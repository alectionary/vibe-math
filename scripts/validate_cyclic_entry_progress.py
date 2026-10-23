"""Check complete baseline tables, source gates and generated graph tables."""
from pathlib import Path
from collections import Counter
from fractions import Fraction
import base64,json,math,re,struct,sys,time,zlib
ROOT=Path(__file__).resolve().parents[1];HERE=ROOT/'formalization/cyclic-lifts/search';LEAN=ROOT/'formalization/dyadic-rank';sys.path.insert(0,str(HERE));sys.path.insert(0,str(ROOT/'scripts'))
import benchmark_decoding as b
from develop_loop_mechanisms import codes
from merged_mechanism import unpack_bits
from merged_reference_states import graph,states
from validate_cyclic_loop_lean_data import parse,get

def u16(s):
 raw=zlib.decompress(base64.b64decode(s));return struct.unpack('<'+str(len(raw)//2)+'H',raw)
def table_scope(path,ns):
 text=path.read_text().split('namespace '+ns+'\n',1)[1].split('end '+ns,1)[0]
 return {key:parse(value) for key,value in re.findall(r'^def (\w+) : Table [^\n]*? := (.*)$',text,re.M)}

def run():
 start=time.monotonic();packet=json.loads((HERE/'entry-progress-results.json').read_text());soft=json.loads((HERE/'entry-soft-controls.json').read_text());checked=0;controls=0;table_values=0
 for rec in packet['records']:
  main=json.loads((HERE/('merged-million-results.json' if rec['mode']=='development' else 'entry-confirm-results.json')).read_text());name=rec['design'];code=codes()[name]
  if rec['mode']=='development':
   arms={r['representation']:r for r in main['results'] if r['design']==name};flags={l:unpack_bits(r['syndrome_flags_zlib_base64'],1000000) for l,r in arms.items()}
  else:
   arms=next(x for x in main['records'] if x['design']==name)['arms'];flags={l:[k==2 for k in u16(v['kinds_uint16_le_zlib_base64'])] for l,v in arms.items()}
  raw=zlib.decompress(base64.b64decode(rec['packed_predecode_features_uint16_le_zlib_base64']));assert len(raw)==1000000*10
  groups={};hardgroups={};wcells={};jointcells={};softcells={}
  for index,(w,initial,offset,stratum,changed) in enumerate(struct.iter_unpack('<5H',raw)):
   assert 0<=w<=252 and 0<=initial<=126 and stratum<4 and changed<=12
   delta=offset-126;active=stratum!=0;assert abs(delta)<=3*changed
   if not active:assert changed==delta==0
   direction=int(flags['merged'][index])-int(flags['original'][index])
   key='worse_first' if delta>0 else 'better_first' if delta<0 else 'same_first_active' if active else 'same_first_inactive'
   hk='inactive' if not active else 'soft_only' if not changed else 'hard_worse_weight' if delta>0 else 'hard_better_weight' if delta<0 else 'hard_same_weight'
   for target,k in [(groups,key),(hardgroups,hk)]:
    g=target.setdefault(k,Counter());g['trials']+=1;g['net']+=direction;g['lost']+=direction==1;g['gained']+=direction==-1
   for collection,k in [(wcells,str(w)),(jointcells,str(w)+'/'+str(initial))]:
    cell=collection.setdefault(k,{'0':Counter(),'1':Counter()})[str(int(active))];cell['trials']+=1;cell['sum']+=direction;cell['square_sum']+=direction**2
   if hk in ['inactive','soft_only']:
    cell=softcells.setdefault(str(w)+'/'+str(initial),{'inactive':Counter(n=0,sum=0,squares=0),'soft_only':Counter(n=0,sum=0,squares=0)})[hk]
    cell['n']+=1;cell['sum']+=direction;cell['squares']+=direction**2
   checked+=1
  assert {k:dict(v) for k,v in groups.items()}==rec['groups']
  assert {k:dict(v) for k,v in hardgroups.items()}==rec['hard_groups']
  assert {k:{a:dict(v) for a,v in g.items()} for k,g in wcells.items()}==rec['all_weight_cells']
  assert {k:{a:dict(v) for a,v in g.items()} for k,g in jointcells.items()}==rec['all_joint_baseline_cells']
  # Recompute the secondary standardized contrasts from independently joined
  # cell totals. Use a separately organized formula and stable summation.
  for table, field in [(wcells,'error_weight_standardization'),
                       (jointcells,'error_and_initial_syndrome_weight_standardization')]:
   in_range=[g for k,g in table.items() if 5<=int(k.split('/')[0])<=16]
   selected=[g for g in in_range if min(g['0']['trials'],g['1']['trials'])>=100]
   masses=[g['0']['trials']+g['1']['trials'] for g in selected];mass=sum(masses)
   means=[g['1']['sum']/g['1']['trials']-g['0']['sum']/g['0']['trials'] for g in selected]
   estimate=math.fsum(n*d for n,d in zip(masses,means))/mass
   pieces=[]
   for n,g in zip(masses,selected):
    for arm in g.values():
     count=arm['trials']
     pieces.append((n/mass)**2*(arm['square_sum']-arm['sum']**2/count)/(count*(count-1)))
   se=math.sqrt(math.fsum(pieces));result=rec[field]
   assert len(selected)==result['cell_count'] and mass==result['retained_pairs']
   assert math.isclose(estimate,result['standardized_active_minus_inactive'],abs_tol=1e-15)
   assert math.isclose(se,result['conditional_plugin_standard_error'],abs_tol=1e-15)
   assert all(math.isclose(a,z,abs_tol=1e-15) for a,z in zip([estimate-1.96*se,estimate+1.96*se],result['nominal_95_interval']))
  # Post hoc soft-only controls are checked separately, with exact rational
  # arithmetic for the conditional means and variances before final square root.
  sc=next(x for x in soft['records'] if x['mode']==rec['mode'] and x['design']==name)
  assert {k:{a:dict(v) for a,v in g.items()} for k,g in softcells.items()}==sc['joint_cells']
  selected=[g for k,g in softcells.items() if 5<=int(k.split('/')[0])<=16 and min(v['n'] for v in g.values())>=100]
  mass=sum(sum(v['n'] for v in g.values()) for g in selected);estimate=Fraction(0);variance=Fraction(0)
  for g in selected:
   weight=Fraction(sum(v['n'] for v in g.values()),mass)
   estimate+=weight*(Fraction(g['soft_only']['sum'],g['soft_only']['n'])-Fraction(g['inactive']['sum'],g['inactive']['n']))
   for v in g.values():
    variance+=weight**2*(Fraction(v['squares'],v['n'])-Fraction(v['sum'],v['n'])**2)/(v['n']-1)
  result=sc['standardization'];se=math.sqrt(float(variance));estimate=float(estimate)
  assert mass==result['retained_pairs'] and len(selected)==result['cells']
  assert math.isclose(estimate,result['contrast_soft_minus_inactive'],abs_tol=1e-15)
  assert all(math.isclose(a,z,abs_tol=1e-15) for a,z in zip([estimate-1.96*se,estimate+1.96*se],result['nominal_conditional_95_interval']))
  # Independently reproduce retained predecode quantities and numerical first updates.
  for example in rec['retained']:
   error=example['error'];target=b.syndrome(list(map(b.rowmask,code['original'])),b.string_mask(error))
   hist={l:states(code[l],error)[0] for l in ['original','merged']}
   estimates={l:'0'*252 if not h else h[0]['estimate'] for l,h in hist.items()}
   weights={l:sum(a!=z for a,z in zip(b.syndrome(list(map(b.rowmask,code['original'])),b.string_mask(x)),target)) for l,x in estimates.items()}
   sa,sb=[target[i] for i in code['pair']];changed=sum(a!=z for a,z in zip(estimates['original'],estimates['merged']))
   assert example['features']==[error.count('1'),sum(target),weights['original'],weights['merged'],sa,sb,changed]
   controls+=1
  print(rec['mode'],name,'all million feature/endpoint joins and baseline cells PASS',flush=True)
 cones=json.loads((HERE/'entry-dependency-cones.json').read_text());witnesses=json.loads((HERE/'entry-propagation-witnesses.json').read_text())
 for rec in cones:
  code=codes()[rec['design']];g=graph(code['original']);a,z=code['pair'];src={e for e,(c,v) in enumerate(g['edge']) if c in [a,z]}
  direct={e for e,(c,v) in enumerate(g['edge']) if any(f in src for f in g['ve'][v] if f!=e)}
  deps=[sorted({f for h in g['ve'][v] if h!=e for f in g['ce'][g['edge'][h][0]] if f!=h}) for e,(c,v) in enumerate(g['edge'])]
  assert sorted(src)==rec['source_edges'] and sorted(direct)==rec['direct_extrinsic_edges'] and deps==rec['dependencies']
  ns='Previous' if rec['design']=='previous_best' else 'Minimum';tables=table_scope(LEAN/'CyclicDecoderEntryCone.lean',ns);cone=set();counts=[]
  for k in range(1,9):
   cone=direct|{e for e,ds in enumerate(deps) if cone.intersection(ds)};counts.append(len(cone))
   if k<=3:
    for e in range(756):assert get(tables['data'+str(k)],e)==(e in cone);table_values+=1
  assert counts==rec['cone_sizes_1_to_8']
  mapped=table_scope(LEAN/'CyclicDecoderEntryWitnesses.lean',ns)['mapData'];mg=graph(code['merged']);mapping=[mg['lookup'][a if c==z else c-1 if c>z else c,v] for c,v in g['edge']]
  assert len(set(mapping))==756
  for e,value in enumerate(mapping):assert get(mapped,e)==value;table_values+=1
  assert mapping==next(w['edge_map'] for w in witnesses if w['design']==rec['design'])
 result=dict(status='entry_progress_and_graph_tables_independently_verified',paired_feature_rows_checked=checked,independent_first_round_controls=controls,balanced_lean_graph_entries_checked=table_values,elapsed_seconds=time.monotonic()-start)
 (HERE/'entry-progress-validation.json').write_text(json.dumps(result,indent=2)+'\n');print(result,flush=True)
if __name__=='__main__':run()
