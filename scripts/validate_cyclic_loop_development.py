"""Independent development checks before holdout selection is frozen."""
from pathlib import Path
import json,sys,tempfile,subprocess,random,time
ROOT=Path(__file__).resolve().parents[1];HERE=ROOT/'formalization/cyclic-lifts/search';sys.path.insert(0,str(HERE))
import benchmark_decoding as b
from develop_loop_mechanisms import codes
from loop_engine import compile_engine,run_engine
from loop_reference import diagnostics,interval_check

def run():
 begin=time.monotonic();old=json.loads((HERE/'loop-development-full-results.json').read_text());checked=0
 with tempfile.TemporaryDirectory(prefix='loop-independent-') as tmp:
  binary=Path(tmp)/'loop';stock=Path(tmp)/'stock';compile_engine(binary)
  subprocess.run(['c++','-std=c++17','-O3',str(HERE/'minsum.cpp'),'-o',str(stock)],check=True)
  for name,c in codes().items():
   for label in ['original','merged']:
    rec=next(r for r in old['records'] if r['design']==name and r['representation']==label)
    witnesses=rec['witnesses'];trials=[(r['index'],r['error']) for r in witnesses]
    actual=run_engine(binary,c[label],trials,True,profile=0)
    expected=b.engine(stock,c[label],252,[(.04,e) for i,e in trials],100,.8)
    for a,terminal in zip(actual,expected):
     assert (a['iterations'],bool(a['matched']),a['estimate'])==terminal
     d,history=diagnostics(c[label],a['error'])
     assert d['terminal']==terminal
     for field in ['cycle_start','cycle_period','cycle_repeat','box_passes','box_check']:assert a[field]==d[field],(name,label,field)
     assert a['robust_tail_last'][0]==d['robust_last'] and a['pinned_checks'][0]==d['pinned']
     if 'q75' in a:assert a['q75']==history[74]['q']
     checked+=1
    print(name,label,len(actual),'exact and interval witnesses independently checked',flush=True)
 rng=random.Random(920381);samples=0
 from merged_reference_states import check
 for t in range(2000):
  intervals=[]
  for j in range(rng.randrange(1,12)):
   a=rng.randrange(-52428800,52428801);z=rng.randrange(-52428800,52428801);intervals.append((min(a,z),max(a,z)))
  s=rng.randrange(2);lo,hi=interval_check(s,intervals)
  for k in range(10):
   xs=[rng.randint(a,z) for a,z in intervals];value=check(s,xs);assert lo<=value<=hi;samples+=1
 result=dict(status='independent_development_checks_passed',witnesses=checked,sampled_interval_enclosures=samples,elapsed_seconds=time.monotonic()-begin)
 (HERE/'loop-development-validation.json').write_text(json.dumps(result,indent=2)+'\n');print(result,flush=True)
if __name__=='__main__':run()
