"""Independent exact equations and reconstruction of the early diagnostic."""
from pathlib import Path
from collections import Counter
import base64,hashlib,json,math,struct,sys,tempfile,subprocess,time,zlib
ROOT=Path(__file__).resolve().parents[1];HERE=ROOT/'formalization/cyclic-lifts/search';sys.path.insert(0,str(HERE))
import benchmark_decoding as b
from develop_loop_mechanisms import codes
from merged_reference_states import graph,states,check,PRIOR
from merged_mechanism import unpack_bits

def decode(packet):
 raw=zlib.decompress(base64.b64decode(packet['packed_int64_le_zlib_base64']))
 values=struct.unpack('<'+str(len(raw)//8)+'q',raw);stride=packet['stride'];assert stride==55
 assert len(values)==stride*packet['pairs'];out=[]
 for off in range(0,len(values),stride):
  x=values[off:off+stride]
  out.append(dict(index=x[0],lost=bool(x[1]),iterations=x[2:4],features={str(t):x[4+j*17:4+(j+1)*17] for j,t in enumerate([5,10,25])}))
 return out

def reference(code,error):
 og,mg=graph(code['original']),graph(code['merged']);a,z=code['pair'];o,ot=states(code['original'],error);m,mt=states(code['merged'],error)
 mapping=[mg['lookup'][a if c==z else c-1 if c>z else c,v] for c,v in og['edge']]
 target=b.syndrome(list(map(b.rowmask,code['original'])),b.string_mask(error));rows=list(map(b.rowmask,code['original']))
 synd=lambda x:b.syndrome(rows,b.string_mask(x))
 weight=lambda x:sum(v!=w for v,w in zip(synd(x),target))
 result=[];cumulative=[0,0,0]
 for k in range(min(25,len(o),len(m))):
  os,ms=o[k],m[k];qm=[ms['q'][f] for f in mapping]
  splitr=[check(target[c],[qm[f] for f in og['ce'][c] if f!=e]) for e,(c,v) in enumerate(og['edge'])]
  splitpost=[PRIOR+sum(splitr[e] for e in es) for es in og['ve']]
  split=''.join('1' if x<0 else '0' for x in splitpost)
  weights=[weight(os['estimate']),weight(ms['estimate']),weight(split)]
  cumulative=[a+b for a,b in zip(cumulative,weights)]
  hamming=lambda x,y:sum(a!=b for a,b in zip(x,y))
  pin=lambda hist:sum(all(synd(hist[j]['estimate'])[c]!=target[c] for j in range(max(0,k-4),k+1)) for c in range(126))
  result.append(weights+cumulative+[hamming(split,ms['estimate']),hamming(os['estimate'],ms['estimate']),hamming(os['estimate'],split),hamming(os['estimate'],o[k-1]['estimate']) if k else 0,hamming(ms['estimate'],m[k-1]['estimate']) if k else 0,pin(o),pin(m),sum(abs(v)<PRIOR//4 for v in os['posterior']),sum(abs(v)<PRIOR//4 for v in ms['posterior']),sum(abs(ms['r'][mapping[e]]-splitr[e]) for e in range(756)),sum(abs(splitr[e]-os['r'][e]) for e in range(756))])
 return result,ot,mt

def run():
 start=time.monotonic();frozen=json.loads((HERE/'entry-dynamics-selection.json').read_text());checks=0;coordinates=0
 for rel,h in frozen['sha256'].items():assert hashlib.sha256((ROOT/rel).read_bytes()).hexdigest()==h
 assert hashlib.sha256((HERE/'entry-dynamics-development.json').read_bytes()).hexdigest()==frozen['development_sha256']
 with tempfile.TemporaryDirectory(prefix='entry-independent-') as tmp:
  stock=Path(tmp)/'stock';subprocess.run(['c++','-O3','-std=c++17',str(HERE/'minsum.cpp'),'-o',str(stock)],check=True)
  for mode in ['development','holdout']:
   packet=json.loads((HERE/f'entry-dynamics-{mode}.json').read_text());main=json.loads((HERE/('merged-million-results.json' if mode=='development' else 'loop-holdout-results.json')).read_text())
   for rec in packet['records']:
    name=rec['design'];rows=decode(rec);arm={r['representation']:r for r in main['results'] if r['design']==name};flags={l:unpack_bits(r['syndrome_flags_zlib_base64'],1000000) for l,r in arm.items()}
    expected=[i for i in range(1000000) if flags['original'][i]!=flags['merged'][i]]
    assert [r['index'] for r in rows]==expected
    assert all(r['lost']==(not flags['original'][r['index']]) for r in rows)
    for t in [5,10,25]:
     profile={typ:Counter() for typ in ['lost','gained']}
     for r in rows:
      if min(r['iterations'])<=t:continue
      typ='lost' if r['lost'] else 'gained';d=profile[typ];d['cases']+=1
      for key,val in zip(packet['fields'],r['features'][str(t)]):d[key]+=val
     for typ,d in profile.items():assert dict(d)==rec['profiles'][typ+'/'+str(t)]
    code=codes()[name]
    for example in [x for x in packet['retained'] if x['design']==name]:
     ref,ot,mt=reference(code,example['error'])
     assert ref==example['steps']
     assert ot==tuple(example['original']) and mt==tuple(example['merged'])
     for l,term in [('original',ot),('merged',mt)]:assert b.engine(stock,code[l],252,[(.04,example['error'])],100,.8)[0]==term
     coordinates+=sum(len(x) for x in ref);checks+=2
    print(mode,name,'packed cohort and independent reference controls PASS',flush=True)
 out=dict(status='entry_diagnostics_independently_verified',full_decoder_controls=checks,scalar_feature_controls=coordinates,elapsed_seconds=time.monotonic()-start)
 (HERE/'entry-dynamics-validation.json').write_text(json.dumps(out,indent=2)+'\n');print(out,flush=True)
if __name__=='__main__':run()
