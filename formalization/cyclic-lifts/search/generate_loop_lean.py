"""Export exact interval tubes and source-linked finite graph data to Lean."""
from pathlib import Path
import json,sys
from develop_loop_mechanisms import codes
from loop_reference import interval_tail
from merged_reference_states import graph
HERE=Path(__file__).resolve().parent;LEAN=HERE.parents[1]/'dyadic-rank'

def arr(xs):return '#['+', '.join(xs)+']'
def tree(xs,render=str,start=0):
 xs=list(xs);assert xs
 if len(xs)==1:return '(.leaf '+render(xs[0])+')'
 mid=len(xs)//2
 return '(.split '+str(start+mid)+' '+tree(xs[:mid],render,start)+' '+tree(xs[mid:],render,start+mid)+')'
def pairs(xs):return tree(xs,lambda pair:'('+str(pair[0]+52428800)+', '+str(pair[1]+52428800)+')')
def nums(xs):return '['+', '.join(map(str,xs))+']'
def ints(xs):return arr(map(str,xs))
def bools(xs):return arr('true' if x else 'false' for x in xs)
def intervals(xs):return ints(value+52428800 for pair in xs for value in pair)

def run():
 old=json.loads((HERE/'loop-development-full-results.json').read_text());data=codes();selected=[]
 for name in data:
  record=next(r for r in old['records'] if r['design']==name and r['representation']=='merged');index=record['example_indices']['discordant_pinned'];w=next(w for w in record['witnesses'] if w['index']==index)
  selected.append((name,'Development',w))
 fresh=HERE/'loop-holdout-results.json'
 if fresh.exists() and '--old-only' not in sys.argv:
  d=json.loads(fresh.read_text())
  for name in data:
   eligible=[e for e in d['examples'] if e['design']==name and e['transition']=='harmed' and e['details']['merged']['pinned_checks'][0]>=0]
   if eligible:selected.append((name,'Holdout',min(eligible,key=lambda e:e['index'])['details']['merged']))
 head='''import CyclicDecoderPersistence
import CyclicMergedWitnesses

/-! Generated full-coordinate interval-tube data. The incoming iteration-75 state
is supplied by independent C++/Python replay; remaining updates are certified.
Regenerate with generate_loop_lean.py. -/
set_option maxRecDepth 100000
set_option maxHeartbeats 20000000
namespace CyclicDecoderTubeData
open CyclicDecoderPersistence
abbrev E := Fin 756
abbrev V := Fin 252
abbrev C := Fin 125
/-- Balanced lookup keeps trusted-kernel reduction logarithmic in the index. -/
inductive Table (α : Type) where
  | leaf : α → Table α
  | split : Nat → Table α → Table α → Table α

def Table.get {α : Type} : Table α → Nat → α
  | .leaf value, _ => value
  | .split cut left right, i => if i < cut then left.get i else right.get i

/-- Nonnegative offsets keep the certificate serialization compact. -/
def fromOffsets (data : Table (Nat × Nat)) (e : E) : Interval :=
  let value := data.get e.val
  ⟨(value.1 : Int) - 52428800, (value.2 : Int) - 52428800⟩
'''
 chunks=[head]
 for name,code in data.items():
  ns='Previous' if name=='previous_best' else 'Minimum';g=graph(code['merged']);ce=g['ce'];ve=g['ve'];edge=g['edge']
  chunks.append(f'''namespace {ns}
def checkData : Table (List E) := {tree(ce,nums)}
def incidentData : Table (List E) := {tree(ve,nums)}
def checkOf : Table C := {tree(c for c,v in edge)}
def variableOf : Table V := {tree(v for c,v in edge)}
def actualRows : List (List Nat) := CyclicMergedWitnesses.{ns}.mergedData

def decoder : Decoder E V C where
  checks c := checkData.get c.val
  incident v := incidentData.get v.val
  edgeCheck e := checkOf.get e.val
  edgeVariable e := variableOf.get e.val
  rows c := (actualRows.getD c.val []).map (Fin.ofNat 252)
end {ns}
''')
 (LEAN/'CyclicDecoderTubeData.lean').write_text(''.join(chunks)+'end CyclicDecoderTubeData\n')
 folder=LEAN/'CyclicDecoderTubeData';folder.mkdir(exist_ok=True)
 records=[]
 for name,label,w in selected:
  chunks=['import CyclicDecoderTubeData\nset_option maxRecDepth 100000\nset_option maxHeartbeats 20000000\nnamespace CyclicDecoderTubeData\nopen CyclicDecoderPersistence\n']
  base='Previous' if name=='previous_best' else 'Minimum';ns=base+label;rows=data[name]['merged'];tube=interval_tail(rows,w['error'],w['q75']);assert tube['last']==100 and tube['pinned']>=0
  q0=w['q75'];trace=tube['trace'];pinned=tube['pinned'];target=[sum(w['error'][v]=='1' for v in row)%2 for row in rows]
  supports=[{v for v in rows[pinned] if word[v]=='1'} for word in w['tail_decisions']]
  pair=sorted(set.union(*supports));phase=0 if supports[0] else 1
  alternating=len(pair)==2 and all(support==(set(pair) if k%2==phase else set()) for k,support in enumerate(supports))
  chunks.append(f'''namespace {ns}
abbrev decoder := {base}.decoder
def errorIndex : Nat := {w['index']}
def errorSupport : List Nat := {nums(i for i,c in enumerate(w['error']) if c=='1')}
def targetData : Array Bool := {bools(target)}
def target (c : C) : Bool := targetData[c.val]!
def qData : Table Nat := {tree(x+52428800 for x in q0)}
def entry (e : E) : Int := (qData.get e.val : Int) - 52428800
def pinnedCheck : C := {pinned}
''')
  if alternating:
   chunks.append(f'def changingPair : List Nat := {nums(pair)}\ndef activeParity : Nat := {phase}\ndef localPattern (k : Nat) (v : V) : Bool := decide (k%2 = activeParity ∧ v.val ∈ changingPair)\n')
  for k,state in enumerate(trace):chunks.append(f'def b{k} : Table (Nat × Nat) := {pairs(state["box"])}\n')
  chunks.append('def boxes : Nat → E → Interval\n'+''.join(f'  | {k}, e => fromOffsets b{k} e\n' for k in range(26))+'  | _, _ => ⟨0, 0⟩\n')
  chunks.append(f'end {ns}\nend CyclicDecoderTubeData\n')
  (folder/(ns+'.lean')).write_text(''.join(chunks))
  records.append(dict(namespace=ns,design=name,source=label,index=w['index'],pinned_check=pinned,target=target[pinned],alternating_pair=pair if alternating else None,active_parity=phase if alternating else None))
 (HERE/'loop-lean-witnesses.json').write_text(json.dumps(dict(status='deterministic_first_pinned_harmed_merged_tubes',records=records),indent=2)+'\n')
 # A small first-step probe provides a resource estimate before all certificates.
 ns=records[0]['namespace']
 probe=f'''import CyclicDecoderTubeData.{ns}
open CyclicDecoderPersistence CyclicDecoderTubeData
set_option maxRecDepth 100000
set_option maxHeartbeats 20000000
namespace CyclicDecoderTubeProbe
open {ns}
theorem first_step : ∀ e : E,
    (boxes 1 e).lo ≤ (boxNext decoder target (boxes 0) e).lo ∧
    (boxNext decoder target (boxes 0) e).hi ≤ (boxes 1 e).hi := by apply checked_all; decide +kernel
#print axioms first_step
end CyclicDecoderTubeProbe
'''
 (LEAN/'CyclicDecoderTubeProbe.lean').write_text(probe)
 print('Exported',len(records),'tubes; data bytes',(LEAN/'CyclicDecoderTubeData.lean').stat().st_size,flush=True)
if __name__=='__main__':run()
