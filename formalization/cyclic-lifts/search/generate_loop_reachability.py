"""Source-linked prefix certificates for the first retained harmed holdout example.

No new noise or detector fitting. Both complete C++ trajectories are independently
compared with direct Python equations before exporting the mathematical prefix.
"""
from pathlib import Path
import hashlib,json,tempfile,sys
from develop_loop_mechanisms import codes
from generate_loop_lean import tree,nums
from merged_reference_states import graph,states
from merged_probe import compile_probe,probe
HERE=Path(__file__).resolve().parent;LEAN=HERE.parents[1]/'dyadic-rank'

def compact(xs,render=str,start=0):
 xs=list(xs);assert xs
 if all(x==xs[0] for x in xs):return '(.leaf '+render(xs[0])+')'
 mid=len(xs)//2
 return '(.split '+str(start+mid)+' '+compact(xs[:mid],render,start)+' '+compact(xs[mid:],render,start+mid)+')'

def run():
 out=json.loads((HERE/'loop-holdout-results.json').read_text());name='minimum_4' if '--minimum' in sys.argv else 'previous_best';code=codes()[name];suffix='Minimum' if name=='minimum_4' else '';original_iterations=86 if suffix else 65
 example=min((e for e in out['examples'] if e['design']==name and e['transition']=='harmed' and e['details']['merged']['pinned_checks'][0]>=0),key=lambda e:e['index'])
 assert example['index']==(2435 if suffix else 1804)
 error=example['error'];hist={};term={};checks=[]
 with tempfile.TemporaryDirectory(prefix='loop-full-prefix-') as tmp:
  binary=Path(tmp)/'probe';compile_probe(binary)
  for label in ['original','merged']:
   history,terminal=states(code[label],error);actual=probe(binary,code[label],error,list(range(1,len(history)+1)))
   assert tuple(actual['terminal'])==terminal==(example['records'][label]['iterations'],bool(example['records'][label]['matched']),example['records'][label]['estimate'])
   for k,(a,z) in enumerate(zip(actual['states'],history)):
    assert a['iteration']==k+1 and a['q']==z['q'] and a['r']==z['r'] and a['estimate']==z['estimate']
   assert len(actual['states'])==len(history)
   hist[label]=history;term[label]=terminal
   checks.append(dict(representation=label,states=len(history),q_and_r_coordinates=2*756*len(history),cpp_states_sha256=hashlib.sha256(json.dumps(actual['states'],sort_keys=True,separators=(',',':')).encode()).hexdigest()))
 assert term['original'][0]==original_iterations and term['original'][1] and term['original'][2]==error
 assert term['merged'][0]==100 and not term['merged'][1]
 for label in hist:assert set(hist[label][0]['q'])=={3332431}
 (HERE/('loop-reachability-minimum-validation.json' if suffix else 'loop-reachability-validation.json')).write_text(json.dumps(dict(status='all_full_cpp_states_match_independent_python',design=name,index=example['index'],new_noise_patterns=0,records=checks),indent=2)+'\n')
 g=graph(code['original']);edges=g['edge'];target=[sum(error[v]=='1' for v in row)%2 for row in code['original']]
 text=f'''import CyclicDecoderTubeGraph
import CyclicDecoderTubeData.PreviousHoldout
set_option maxRecDepth 100000
set_option maxHeartbeats 20000000
open CyclicDecoderPersistence CyclicDecoderTubeData
namespace CyclicDecoderOriginal
abbrev C := Fin 126
def checkData : Table (List E) := {tree(g['ce'],nums)}
def incidentData : Table (List E) := {tree(g['ve'],nums)}
def checkOf : Table C := {tree(c for c,v in edges)}
def variableOf : Table V := {tree(v for c,v in edges)}
def actualRows := CyclicMergedWitnesses.Previous.originalData
def decoder : Decoder E V C where
  checks c := checkData.get c.val
  incident v := incidentData.get v.val
  edgeCheck e := checkOf.get e.val
  edgeVariable e := variableOf.get e.val
  rows c := (actualRows.getD c.val []).map (Fin.ofNat 252)
def targetData : Table Bool := {tree(target,lambda x:'true' if x else 'false')}
def target (c : C) : Bool := targetData.get c.val

theorem matrix_rows : ∀ c : C,
    (decoder.checks c).map decoder.edgeVariable = decoder.rows c := by apply checked_all; decide +kernel

theorem check_labels : ∀ c : C,
    (decoder.checks c).all (fun e => decide (decoder.edgeCheck e = c)) = true := by apply checked_all; decide +kernel

theorem check_present : ∀ e : E, e ∈ decoder.checks (decoder.edgeCheck e) := by apply checked_all; decide +kernel

theorem incident_unique : ∀ v : V, (decoder.incident v).Nodup := by apply checked_all; decide +kernel

theorem incident_labels : ∀ v : V,
    (decoder.incident v).all (fun e => decide (decoder.edgeVariable e = v)) = true := by apply checked_all; decide +kernel

theorem incident_present : ∀ e : E, e ∈ decoder.incident (decoder.edgeVariable e) := by apply checked_all; decide +kernel

theorem actual_variable_update (q : E → Int) (e : E) :
    next decoder target q e = CyclicMergedMessages.clip
      (posterior decoder target q (decoder.edgeVariable e) - messages decoder target q e) :=
  next_eq_posterior_sub decoder target q e
    (incident_unique (decoder.edgeVariable e)) (incident_present e)

theorem target_matches_error : ∀ c : C,
    target c = CyclicMergedMessages.signs ((decoder.rows c).map
      (fun v => if v.val ∈ CyclicDecoderTubeData.PreviousHoldout.errorSupport then (-1 : Int) else 1)) := by
  apply checked_all
  decide +kernel
end CyclicDecoderOriginal
'''
 if suffix:text=text.replace('CyclicDecoderOriginal','CyclicDecoderOriginalMinimum').replace('PreviousHoldout','MinimumHoldout').replace('Witnesses.Previous.','Witnesses.Minimum.')
 (LEAN/('CyclicDecoderOriginal'+suffix+'.lean')).write_text(text)
 folder=LEAN/'CyclicDecoderReachData';folder.mkdir(exist_ok=True)
 for label,count in [('original',original_iterations),('merged',75)]:
  ns=suffix+label.capitalize();ctype='CyclicDecoderOriginal.C' if label=='original' else 'CyclicDecoderTubeData.C'
  decoder='CyclicDecoderOriginal.decoder' if label=='original' else 'CyclicDecoderTubeData.PreviousHoldout.decoder'
  targetdef='CyclicDecoderOriginal.target' if label=='original' else 'CyclicDecoderTubeData.PreviousHoldout.target'
  chunks=[f'''import CyclicDecoderOriginal
set_option maxRecDepth 100000
set_option maxHeartbeats 20000000
open CyclicDecoderPersistence CyclicDecoderTubeData
namespace CyclicDecoderReachData.{ns}
abbrev C := {ctype}
abbrev decoder := {decoder}
abbrev target := {targetdef}
''']
  for k in range(1,count):chunks.append(f'def q{k} : Table Nat := {compact(x+52428800 for x in hist[label][k]["q"])}\n')
  chunks.append('def state : Nat → E → Int\n  | 0, _ => CyclicMergedMessages.prior\n'+''.join(f'  | {k}, e => (q{k}.get e.val : Int) - 52428800\n' for k in range(1,count))+'  | _, _ => 0\n')
  failing=[]
  for k in range(count-1):
   word=hist[label][k]['estimate'];targetbits=[sum(error[v]=='1' for v in row)%2 for row in code[label]]
   failing.append(next(c for c,row in enumerate(code[label]) if sum(word[v]=='1' for v in row)%2!=targetbits[c]))
  chunks.append(f'def failedChecks : Table C := {tree(failing)}\n')
  first=next(c for c,row in enumerate(code[label]) if sum(error[v]=='1' for v in row)%2)
  chunks.append(f'def nonzeroCheck : C := {first}\nend CyclicDecoderReachData.{ns}\n')
  text=''.join(chunks)
  if suffix:text=text.replace('CyclicDecoderOriginal','CyclicDecoderOriginalMinimum').replace('PreviousHoldout','MinimumHoldout')
  (folder/(ns+'.lean')).write_text(text)
 print(name,'exported original',original_iterations,'and merged 75-state prefixes;',sum(len(x) for x in hist.values()),'full C++ q/R states checked',flush=True)
if __name__=='__main__':run()
