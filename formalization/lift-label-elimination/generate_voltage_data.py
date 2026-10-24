from pathlib import Path
import json
P=Path(__file__).resolve().parent
for b in json.loads((P/'results.json').read_text())['bases']:
 p=len(b['base_supports']);nm=b['name'].title()+'VoltageData';H='PaschCubicTrade.base'+('A' if b['name']=='star' else 'B')
 pcs=[[next(iter(set(b['base'][u])&set(b['base'][v]))) for u,v in [(ss[0],ss[1]),(ss[0],ss[2]),(ss[0],ss[3]),(ss[1],ss[2]),(ss[1],ss[3]),(ss[2],ss[3])]]for ss in b['base_supports']]
 s=['import CycleData','import PaschReindex','import SupportVoltageCount','import PaschCubicTrade','import Mathlib.Tactic.NormNum','import Mathlib.Tactic.Ring','set_option maxHeartbeats 0','set_option maxRecDepth 1000000',f'namespace {nm}','open scoped BigOperators',f'abbrev H := {H}',f'def variableAt : Fin {p} → Fin 4 → Fin 10 := fun r i => match r.val,i.val with']
 for r,ss in enumerate(b['base_supports']):
  for i,v in enumerate(ss):s+=[f'  | {r},{i} => {v}']
 s+=['  | _,_ => 0',f'def checks : Fin {p} → Fin 6 → Fin 10 := fun r e => match r.val,e.val with']
 for r,cc in enumerate(pcs):
  for i,c in enumerate(cc):s+=[f'  | {r},{i} => {c}']
 s+=['  | _,_ => 0','def edges : Fin 30 → Fin 10 × Fin 10 := fun i => match i.val with']
 for i,(v,c) in enumerate(b['edges']):s+=[f'  | {i} => ({v},{c})']
 s+=['  | _ => (0,0)', 'theorem edges_unique : Function.Injective edges := by decide',
 'theorem edges_complete : ∀ v c, c∈H v → ∃ i, edges i=(v,c) := by decide']
 for scope,n in [('Raw',30),('Gauge',11)]:
  indices={idx:i for i,idx in enumerate(b['chord_edges'])}
  s += [f'def labels{scope} {{R : Type*}} [CommRing R] (z : Fin {n} → R) (v c : Fin 10) : R :=',
   '  match v.val,c.val with']
  for idx,(v,c) in enumerate(b['edges']):
   if scope=='Raw':s+=[f'  | {v},{c} => z {idx}']
   elif idx in indices:s+=[f'  | {v},{c} => z {indices[idx]}']
  s+=['  | _,_ => 0']
 s += ['def repSet (r) := Finset.univ.image (variableAt r)',
 f'theorem rep_injective : ∀ r : Fin {p}, Function.Injective (variableAt r) := by decide',
 f'theorem repSet_injective : Function.Injective (repSet : Fin {p} → Finset (Fin 10)) := by decide',
 f'theorem rep_card : ∀ r : Fin {p}, (repSet r).card=4 := by decide',
 'theorem complete_supports : (GlobalCounting.fourSupports.filter (PaschKernelCount.elementary40Check H))=',
 f'    (Finset.univ : Finset (Fin {p})).image repSet := by decide',
 f'theorem rep_even : ∀ r : Fin {p}, PaschClassification.EvenChecks (fun i => H (variableAt r i)) := by',
 f'  change ∀ r : Fin {p}, ∀ c : Fin 10,',
 '    (FourColumnClassification.support (fun i => H (variableAt r i)) c).card%2=0', '  decide',
 f'theorem pair_checks : ∀ r : Fin {p},',
 '    H (variableAt r 0) ∩ H (variableAt r 1)={checks r 0} ∧',
 '    H (variableAt r 0) ∩ H (variableAt r 2)={checks r 1} ∧',
 '    H (variableAt r 0) ∩ H (variableAt r 3)={checks r 2} ∧',
 '    H (variableAt r 1) ∩ H (variableAt r 2)={checks r 3} ∧',
 '    H (variableAt r 1) ∩ H (variableAt r 3)={checks r 4} ∧',
 '    H (variableAt r 2) ∩ H (variableAt r 3)={checks r 5} := by decide',
 'variable {R : Type*} [CommRing R]']
 for scope,n in [('Raw',30),('Gauge',11)]:
  rows=b['name']+scope
  s += [f'def d{scope} (z : Fin {n} → R) (r : Fin {p}) :=',
    f'  PaschLiftCriterion.differences (fun i c => labels{scope} z (variableAt r i) c) (checks r)',
    f'def residual{scope} (z : Fin {n} → R) (r : Fin {p}) (j : Fin 3) : R := match j.val with',
    f'  | 0 => d{scope} z r 0+d{scope} z r 3-d{scope} z r 1',
    f'  | 1 => d{scope} z r 0+d{scope} z r 4-d{scope} z r 2',
    f'  | _ => d{scope} z r 1+d{scope} z r 5-d{scope} z r 2',
    f'theorem rows{scope} (z : Fin {n} → R) (r : Fin {p}) (j : Fin 3) :',
    f'    (∑ k, (CycleData.{rows} r j k : R)*z k)=residual{scope} z r j := by',
    '  fin_cases r <;> fin_cases j <;>',
    f'    norm_num [CycleData.{rows},CycleData.get3,Fin.sum_univ_succ,residual{scope},d{scope},',
    f'      PaschLiftCriterion.differences,variableAt,checks,labels{scope}] <;> ring',
    f'theorem balanced{scope} (z : Fin {n} → R) (r : Fin {p}) :',
    f'    PaschVoltage.Balanced (d{scope} z r) ↔',
    f'      ∀ j : Fin 3, ∑ k, (CycleData.{rows} r j k : R)*z k=0 := by',
    f'  simp_rw [rows{scope}]',
    '  constructor',
    f'  · rintro ⟨h0,h1,h2⟩ j; fin_cases j <;> simp only [residual{scope}]',
    '    · exact sub_eq_zero.mpr h0','    · exact sub_eq_zero.mpr h1','    · exact sub_eq_zero.mpr h2',
    '  · intro h',
    f'    exact ⟨sub_eq_zero.mp (h 0),sub_eq_zero.mp (h 1),sub_eq_zero.mp (h 2)⟩',
    f'#print axioms rows{scope}',f'#print axioms balanced{scope}']
 s += ['#print axioms complete_supports',f'end {nm}']
 (P/(nm+'.lean')).write_text('\n'.join(s)+'\n')
