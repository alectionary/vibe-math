from pathlib import Path
import json,itertools
P=Path(__file__).resolve().parent
records=json.loads((P/'normal-form-index.json').read_text())
imports=['import HistogramPolynomials']+['import Connect'+r['module'][2:] for r in records]
s=imports+['set_option maxHeartbeats 0','set_option maxRecDepth 1000000','namespace LabelHistograms',
'open scoped BigOperators','open CycleKernelBridge EventHistogram HistogramPolynomials CycleData',
'instance {p n N : ℕ} [NeZero N] (B : Fin p → Fin 3 → Fin n → ℤ)',
'    (S : Finset (Fin p)) (z : Fin n → ZMod N) : Decidable (Events B S z) :=',
'  inferInstanceAs (Decidable (∀ i∈S, ∀ j : Fin 3, ∑ k, (B i j k : ZMod N)*z k=0))','']
for scope,n in [('Gauge',11),('Raw',30)]:
 rows='triangle'+scope
 literals=['∅' if mask==0 else '{'+','.join(str(i) for i in range(5) if mask>>i&1)+'}' for mask in range(32)]
 s += [f'def events{scope} (N : ℕ) [NeZero N] (z : Fin {n} → ZMod N) (i : Fin 5) : Bool :=',
 f'  decide (∀ j : Fin 3, ∑ k, ({rows} i j k : ZMod N)*z k=0)',
 f'theorem all{scope} (N : ℕ) [NeZero N] (S : Finset (Fin 5)) :',
 f'    Nat.card {{z : Fin {n} → ZMod N // Events {rows} S z}}=N^({n}-rankOf S.card) := by',
 f'  have hlist : (Finset.univ : Finset (Finset (Fin 5)))={{{",".join(literals)}}} := by decide',
 '  have h := Finset.mem_univ S', '  rw [hlist] at h',
 '  simp only [Finset.mem_insert,Finset.mem_singleton] at h',
 '  rcases h with '+' | '.join('h' for _ in range(32)), '  all_goals subst S']
 for mask in range(32):
  s += [f'  · exact ConnectTriangle{scope}{mask}.actual_count N']
 s += [f'theorem intersections{scope} (N : ℕ) [NeZero N] (S : Finset (Fin 5)) :',
 f'    intersectionCount (events{scope} N) S=N^({n}-rankOf S.card) := by',
 f'  have h := all{scope} N S',
 '  rw [Nat.card_eq_fintype_card] at h',
 '  rw [Fintype.card_subtype] at h',
 '  rw [← h]', '  unfold intersectionCount', '  apply congrArg Finset.card',
 '  apply Finset.filter_congr', '  intro z _',
 f'  simp only [events{scope},Events,decide_eq_true_eq]']
s += ['theorem triangle_gauge_histogram (N : ℕ) [NeZero N] (j : Fin 6) :',
 '    (histogram (eventsGauge N) j : ℤ)=polynomial N j :=',
 '  histogram_formula (eventsGauge N) N (intersectionsGauge N) j',
 'theorem power_factor (N : ℤ) (s : ℕ) : N^(30-rankOf s)=N^19*N^(11-rankOf s) := by',
 '  have h : rankOf s≤11 := Nat.min_le_right _ _',
 '  rw [show 30-rankOf s=19+(11-rankOf s) by omega,pow_add]',
 'theorem triangle_raw_histogram (N : ℕ) [NeZero N] (j : Fin 6) :',
 '    (histogram (eventsRaw N) j : ℤ)=(N : ℤ)^19*polynomial N j := by',
 '  rw [inversion]', '  simp_rw [intersectionsRaw N,Nat.cast_pow,power_factor]',
 '  calc',
 '    (∑ S : Finset (Fin 5), coefficient j S*((N : ℤ)^19*(N : ℤ)^(11-rankOf S.card))) =',
 '        (N : ℤ)^19*∑ S : Finset (Fin 5), coefficient j S*(N : ℤ)^(11-rankOf S.card) := by',
 '      rw [Finset.mul_sum]; apply Finset.sum_congr rfl; intro S _; ring',
 '    _=(N : ℤ)^19*polynomial N j := by rw [group_by_card,evaluate]',
 '#print axioms allGauge','#print axioms allRaw','#print axioms triangle_gauge_histogram',
 '#print axioms triangle_raw_histogram','end LabelHistograms']
(P/'LabelHistograms.lean').write_text('\n'.join(s)+'\n')
