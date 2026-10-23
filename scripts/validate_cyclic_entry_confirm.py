"""Reconstruct the fresh paired interaction and regenerate its independent noise."""
from pathlib import Path
from collections import Counter
from statistics import NormalDist
import base64,hashlib,json,math,random,struct,subprocess,sys,tempfile,time,zlib
ROOT=Path(__file__).resolve().parents[1];HERE=ROOT/'formalization/cyclic-lifts/search';sys.path.insert(0,str(HERE))
import benchmark_decoding as b
from develop_loop_mechanisms import codes
from merged_reference_states import states

def unpack(s):
 raw=zlib.decompress(base64.b64decode(s));return struct.unpack('<'+str(len(raw)//2)+'H',raw)

def run():
 start=time.monotonic();packet=json.loads((HERE/'entry-confirm-results.json').read_text());selection=HERE/'entry-confirm-selection.json';frozen=json.loads(selection.read_text())
 assert hashlib.sha256(selection.read_bytes()).hexdigest()==packet['selection_sha256']
 for rel,h in frozen['sha256'].items():assert hashlib.sha256((ROOT/rel).read_bytes()).hexdigest()==h,rel
 assert packet['new_independent_noise_patterns']==2000000 and packet['primary_decoder_executions']==4000000
 patterns=0;outcomes=0;replays=0
 with tempfile.TemporaryDirectory(prefix='entry-confirm-check-') as tmp:
  stock=Path(tmp)/'stock';subprocess.run(['c++','-std=c++17','-O3',str(HERE/'minsum.cpp'),'-o',str(stock)],check=True)
  for rec in packet['records']:
   name=rec['design'];code=codes()[name];source=[code['original'][i] for i in code['pair']]
   arms={l:{f.replace('_uint16_le_zlib_base64',''):unpack(v) for f,v in a.items()} for l,a in rec['arms'].items()};strata=unpack(rec['strata_uint16_le_zlib_base64']);assert len(strata)==1000000
   groups={};rng=random.Random(rec['seed']);stream=hashlib.sha256();batch=[];saved={e['index']:e for e in packet['examples'] if e['design']==name};batch_sha={x['offset']:x['error_sha256'] for x in packet['batches'] if x['design']==name}
   for i in range(1000000):
    error=''.join('1' if rng.random()<.04 else '0' for v in range(252));patterns+=1
    if i:stream.update(b'\n')
    stream.update(error.encode());batch.append(error)
    a,z=[sum(error[v]=='1' for v in row)%2 for row in source];assert strata[i]==2*a+z;key=str(a)+str(z)
    g=groups.setdefault(key,Counter());g['trials']+=1
    kinds={l:arm['kinds'][i] for l,arm in arms.items()}
    for l,kind in kinds.items():
     assert kind in range(4) and 0<=arms[l]['iterations'][i]<=100 and 0<=arms[l]['first'][i]<=126
     g[l+'_syndrome']+=kind==2;g[l+'_quantum']+=kind>=2;g[l+'_logical']+=kind==3;outcomes+=1
    g['lost']+=kinds['original']!=2 and kinds['merged']==2;g['gained']+=kinds['original']==2 and kinds['merged']!=2
    delta=arms['merged']['first'][i]-arms['original']['first'][i];g['first_gap_sum']+=delta;g['first_gap_square_sum']+=delta**2
    if key=='00':assert delta==0
    if i in saved:assert error==saved[i]['error']
    if len(batch)==10000:
     assert hashlib.sha256('\n'.join(batch).encode()).hexdigest()==batch_sha[i-9999];batch=[]
   assert stream.hexdigest()==rec['error_stream_sha256']
   assert {k:dict(v) for k,v in groups.items()}==rec['groups']
   active=Counter()
   for key in ['01','10','11']:active.update(groups[key])
   calc=[]
   for g in [active,groups['00']]:
    n=g['trials'];d=(g['lost']-g['gained'])/n;se=math.sqrt((g['lost']+g['gained']-n*d*d)/(n*(n-1)));calc.append((d,se))
   d=calc[0][0]-calc[1][0];se=math.hypot(calc[0][1],calc[1][1]);z=NormalDist().inv_cdf(.9875)
   expected=rec['interaction'];assert math.isclose(d,expected['difference'],abs_tol=1e-15) and math.isclose(se,expected['standard_error'],abs_tol=1e-15)
   assert all(math.isclose(a,b,abs_tol=1e-15) for a,b in zip([d-z*se,d+z*se],expected['bonferroni_simultaneous_95_interval']))
   for example in saved.values():
    for l in arms:
     index,it,matched,estimate,first=example['records'][l]
     ref,term=states(code[l],example['error']);assert term==(it,matched,estimate)
     assert b.engine(stock,code[l],252,[(.04,example['error'])],100,.8)[0]==term
     target=b.syndrome(list(map(b.rowmask,code['original'])),b.string_mask(example['error']))
     observed=0 if not ref else sum(a!=b for a,b in zip(b.syndrome(list(map(b.rowmask,code['original'])),b.string_mask(ref[0]['estimate'])),target))
     assert observed==first
     residual=b.string_mask(example['error'])^b.string_mask(estimate);ok=b.in_span(residual,b.basis(code['hz']))
     kind=0 if residual==0 else 1 if ok else 2 if not matched else 3
     assert kind==arms[l]['kinds'][index];replays+=1
   print(name,'all million noise patterns, outcomes, first weights and interaction summaries PASS',flush=True)
 out=dict(status='fresh_entry_confirmation_independently_verified',independent_patterns_regenerated=patterns,terminal_outcomes_reconstructed=outcomes,independent_full_trajectory_controls=replays,elapsed_seconds=time.monotonic()-start)
 (HERE/'entry-confirm-validation.json').write_text(json.dumps(out,indent=2)+'\n');print(out,flush=True)
if __name__=='__main__':run()
