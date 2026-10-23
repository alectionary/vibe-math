"""Reconstruct all holdout summaries; independently replay retained certificates."""
from pathlib import Path
from collections import Counter
from statistics import NormalDist
import base64,hashlib,json,math,random,struct,subprocess,sys,tempfile,time,zlib
ROOT=Path(__file__).resolve().parents[1];HERE=ROOT/'formalization/cyclic-lifts/search';sys.path.insert(0,str(HERE))
import benchmark_decoding as b
from develop_loop_mechanisms import codes
from loop_reference import diagnostics


def bits(s,n):
 raw=zlib.decompress(base64.b64decode(s));return [bool(raw[i//8]&(1<<(i%8))) for i in range(n)]
def u16(s):
 raw=zlib.decompress(base64.b64decode(s));return struct.unpack('<'+'H'*(len(raw)//2),raw)
def flag(col,k):
 cycle=col['cycle_period'][k]>0;box=col['box_check_plus_one'][k]>0;pinned=col['pinned_check_plus_one'][k]>0
 return dict(cycle=cycle,box=box,pinned=pinned,primary=cycle or box or pinned,robust=col['robust_last_plus_one'][k]==101)
def contrast(a,z):
 gained=sum(x and not y for x,y in zip(a,z));lost=sum(y and not x for x,y in zip(a,z));n=len(a);delta=(lost-gained)/n;se=math.sqrt((lost+gained-n*delta*delta)/(n*(n-1)))
 return dict(original_failed_merged_succeeded=gained,original_succeeded_merged_failed=lost,difference_merged_minus_original=delta,standard_error=se,paired_95_interval=[delta-NormalDist().inv_cdf(.975)*se,delta+NormalDist().inv_cdf(.975)*se],bonferroni_simultaneous_95_interval=[delta-NormalDist().inv_cdf(.9875)*se,delta+NormalDist().inv_cdf(.9875)*se])

def run():
 started=time.monotonic();out=json.loads((HERE/'loop-holdout-results.json').read_text());frozen=json.loads((HERE/'loop-holdout-selection.json').read_text());n=out['trials_per_code'];assert n==1000000
 for rel,h in frozen['sha256'].items():assert hashlib.sha256((ROOT/rel).read_bytes()).hexdigest()==h,rel
 assert hashlib.sha256((HERE/'loop-holdout-selection.json').read_bytes()).hexdigest()==out['selection_sha256']
 total_examples=0;checks=0;example_errors={}
 for name,code in codes().items():
  arms={r['representation']:r for r in out['results'] if r['design']==name};data={};groups={};cohort=next(r for r in out['cohorts'] if r['design']==name)
  for label,r in arms.items():
   col={f:u16(s) for f,s in r['fields_uint16_le_zlib_base64'].items()};assert all(len(xs)==n for xs in col.values())
   kinds=u16(r['outcome_classes_uint16_le_zlib_base64']);fail=bits(r['failure_flags_zlib_base64'],n);syn=bits(r['syndrome_flags_zlib_base64'],n)
   assert len(kinds)==n
   counts=Counter();columns=col
   for k,kind in enumerate(kinds):
    assert kind in range(4) and fail[k]==(kind>=2) and syn[k]==(kind==2)
    counts[['exact','stabilizer','syndrome','logical'][kind]]+=1;counts['iteration_sum']+=col['iterations'][k]
    fs=flag(col,k);assert not any(fs.values()) or syn[k]
    for f,v in fs.items():counts[f]+=v
    counts['fixed']+=col['cycle_period'][k]==1;counts['periodic']+=col['cycle_period'][k]>1;counts['eligible_75']+=col['iterations'][k]>=75
   for f,v in r['counts'].items():assert counts[f]==v,(name,label,f)
   assert sum(fail)==r['failure_count'] and sum(syn)==r['syndrome_count']
   assert r['failure_rate']==sum(fail)/n
   for f in ['cycle','box','pinned','primary','robust']:assert r['certificate_coverage_wilson_95'][f]==list(b.wilson(counts[f],sum(syn)))
   data[label]=dict(columns=col,kinds=kinds,fail=fail,syn=syn)
   checks+=n
  for k in range(n):
   a,z=data['original']['syn'][k],data['merged']['syn'][k]
   direction='lost_syndrome_match' if not a and z else 'gained_syndrome_match' if a and not z else 'both_syndrome_fail' if a and z else 'both_syndrome_match'
   g=groups.setdefault(direction,Counter());g['cases']+=1
   for label in arms:
    for f,v in flag(data[label]['columns'],k).items():g[label+'_'+f]+=v
  assert {k:dict(v) for k,v in groups.items()}==cohort['groups']
  expected_contrast=next(r for r in out['contrasts'] if r['design']==name)
  for metric,field in [('quantum','fail'),('syndrome','syn')]:
   got=contrast(data['original'][field],data['merged'][field]);expected=expected_contrast[metric]
   for key,value in got.items():
    if isinstance(value,list):assert all(math.isclose(a,z,rel_tol=1e-12,abs_tol=1e-15) for a,z in zip(value,expected[key]))
    elif isinstance(value,float):assert math.isclose(value,expected[key],rel_tol=1e-12,abs_tol=1e-15)
    else:assert value==expected[key]
  needed={e['index']:e for e in out['examples'] if e['design']==name};rng=random.Random(out['seeds'][name]);stream=hashlib.sha256();batch=[];batch_rec={x['offset']:x for x in out['batches'] if x['design']==name}
  for index in range(n):
   error=''.join('1' if rng.random()<.04 else '0' for v in range(252))
   if index:stream.update(b'\n')
   stream.update(error.encode());batch.append(error)
   if index in needed:
    assert needed[index]['error']==error;example_errors[name,index]=error
   if len(batch)==10000:
    offset=index+1-len(batch);assert hashlib.sha256('\n'.join(batch).encode()).hexdigest()==batch_rec[offset]['error_sha256'];batch=[]
  assert stream.hexdigest()==cohort['error_stream_sha256']
  print(name,'all million outcomes, detector fields, contrasts, cohort groups and fresh noise hashes verified',flush=True)
 with tempfile.TemporaryDirectory(prefix='loop-holdout-independent-') as tmp:
  stock=Path(tmp)/'stock';subprocess.run(['c++','-std=c++17','-O3',str(HERE/'minsum.cpp'),'-o',str(stock)],check=True)
  for name,code in codes().items():
   examples=[e for e in out['examples'] if e['design']==name]
   for label in ['original','merged']:
    stock_records=b.engine(stock,code[label],252,[(.04,e['error']) for e in examples],100,.8)
    for example,terminal in zip(examples,stock_records):
     actual=example['details'][label];expected,history=diagnostics(code[label],example['error'])
     assert expected['terminal']==terminal==(actual['iterations'],bool(actual['matched']),actual['estimate'])
     for f in ['cycle_start','cycle_period','cycle_repeat','box_passes','box_check']:assert expected[f]==actual[f]
     assert expected['robust_last']==actual['robust_tail_last'][0] and expected['pinned']==actual['pinned_checks'][0]
     if 'q75' in actual:assert actual['q75']==history[74]['q'] and actual['tail_decisions']==[s['estimate'] for s in history[74:]]
     total_examples+=1
    print(name,label,len(examples),'retained trajectories independently match exact and interval equations',flush=True)
 result=dict(status='holdout_outcomes_noise_and_independent_trajectory_certificates_passed',primary_outcome_rows_reconstructed=checks,independent_error_patterns_regenerated=2*n,independent_full_trajectory_replays=total_examples,elapsed_seconds=time.monotonic()-started)
 (HERE/'loop-holdout-validation.json').write_text(json.dumps(result,indent=2)+'\n');print(result,flush=True)
if __name__=='__main__':run()
