import PaschLiftProjection

set_option maxHeartbeats 0
open FourColumnClassification PaschRootClassification
namespace PaschLiftCriterion
variable {C G : Type*} [DecidableEq C] [DecidableEq G]
  [Fintype C] [Fintype G] [AddCommGroup G]

def differences (z : Fin 4 → C → G) (c : Fin 6 → C) : Fin 6 → G :=
  fun e => match e.val with
  | 0 => z 0 (c 0)-z 1 (c 0)
  | 1 => z 0 (c 1)-z 2 (c 1)
  | 2 => z 0 (c 2)-z 3 (c 2)
  | 3 => z 1 (c 3)-z 2 (c 3)
  | 4 => z 1 (c 4)-z 3 (c 4)
  | _ => z 2 (c 5)-z 3 (c 5)

theorem adjacent_iff (H : Fin 4 → Finset C) (z : Fin 4 → C → G)
    (x : Fin 4 → G) (i j : Fin 4) (c : C) (hc : H i ∩ H j={c}) :
    (PaschLiftProjection.columns H z (i,x i) ∩
      PaschLiftProjection.columns H z (j,x j)).Nonempty ↔
      x j-x i=z i c-z j c := by
  constructor
  · rintro ⟨⟨d,t⟩,hd⟩
    obtain ⟨hi,hj⟩ := Finset.mem_inter.mp hd
    have hi' := (PaschLiftProjection.mem_columns H z (i,x i) d t).mp hi
    have hj' := (PaschLiftProjection.mem_columns H z (j,x j) d t).mp hj
    have hdc : d=c := by
      have hm : d∈H i ∩ H j := Finset.mem_inter.mpr ⟨hi'.1,hj'.1⟩
      rw [hc] at hm
      exact Finset.mem_singleton.mp hm
    subst d
    have h := hi'.2.symm.trans hj'.2
    calc
      x j-x i=(x j+z j c)-(x i+z j c) := by abel
      _=(x i+z i c)-(x i+z j c) := by rw [← h]
      _=z i c-z j c := by abel
  · intro h
    have hm : c∈H i ∩ H j := by rw [hc]; simp
    refine ⟨(c,x i+z i c),Finset.mem_inter.mpr ⟨?_,?_⟩⟩
    · exact (PaschLiftProjection.mem_columns H z (i,x i) c _).mpr
        ⟨(Finset.mem_inter.mp hm).1,rfl⟩
    · apply (PaschLiftProjection.mem_columns H z (j,x j) c _).mpr
      refine ⟨(Finset.mem_inter.mp hm).2,?_⟩
      calc
        x i+z i c=x i+(z i c-z j c)+z j c := by abel
        _=x i+(x j-x i)+z j c := by rw [h]
        _=x j+z j c := by abel

theorem pair_complete_iff_compatible
    (H : Fin 4 → Finset C) (z : Fin 4 → C → G) (c : Fin 6 → C)
    (h01 : H 0 ∩ H 1={c 0}) (h02 : H 0 ∩ H 2={c 1})
    (h03 : H 0 ∩ H 3={c 2}) (h12 : H 1 ∩ H 2={c 3})
    (h13 : H 1 ∩ H 3={c 4}) (h23 : H 2 ∩ H 3={c 5}) (x : Fin 4 → G) :
    PairComplete (fun i => PaschLiftProjection.columns H z (i,x i)) ↔
      PaschVoltage.Compatible (differences z c) x := by
  constructor
  · intro h
    exact ⟨(adjacent_iff H z x 0 1 _ h01).mp (h 0 1 (by decide)),
      (adjacent_iff H z x 0 2 _ h02).mp (h 0 2 (by decide)),
      (adjacent_iff H z x 0 3 _ h03).mp (h 0 3 (by decide)),
      (adjacent_iff H z x 1 2 _ h12).mp (h 1 2 (by decide)),
      (adjacent_iff H z x 1 3 _ h13).mp (h 1 3 (by decide)),
      (adjacent_iff H z x 2 3 _ h23).mp (h 2 3 (by decide))⟩
  · rintro ⟨a,b,d,e,f,g⟩
    have a' := (adjacent_iff H z x 0 1 _ h01).mpr a
    have b' := (adjacent_iff H z x 0 2 _ h02).mpr b
    have d' := (adjacent_iff H z x 0 3 _ h03).mpr d
    have e' := (adjacent_iff H z x 1 2 _ h12).mpr e
    have f' := (adjacent_iff H z x 1 3 _ h13).mpr f
    have g' := (adjacent_iff H z x 2 3 _ h23).mpr g
    have flip {s t : Finset (C × G)} (h : (s ∩ t).Nonempty) : (t ∩ s).Nonempty := by
      rw [Finset.inter_comm]; exact h
    intro i j hij
    fin_cases i <;> fin_cases j <;> first
    | exact False.elim (hij rfl)
    | exact a'
    | exact b'
    | exact d'
    | exact e'
    | exact f'
    | exact g'
    | exact flip a'
    | exact flip b'
    | exact flip d'
    | exact flip e'
    | exact flip f'
    | exact flip g'

theorem actual_even_iff_compatible
    (H : Fin 4 → Finset C) (z : Fin 4 → C → G) (c : Fin 6 → C)
    (hd : ∀ i, (H i).card=3)
    (h4 : ∀ i j, i≠j → (H i ∩ H j).card≤1)
    (he : ∀ q, (support H q).card≤2)
    (h01 : H 0 ∩ H 1={c 0}) (h02 : H 0 ∩ H 2={c 1})
    (h03 : H 0 ∩ H 3={c 2}) (h12 : H 1 ∩ H 2={c 3})
    (h13 : H 1 ∩ H 3={c 4}) (h23 : H 2 ∩ H 3={c 5}) (x : Fin 4 → G) :
    PaschClassification.EvenChecks (fun i => PaschLiftProjection.columns H z (i,x i)) ↔
      PaschVoltage.Compatible (differences z c) x := by
  have hd' := fun i => PaschLiftProjection.cubic H z hd (i,x i)
  have h4' : ∀ i j : Fin 4, i≠j →
      (PaschLiftProjection.columns H z (i,x i) ∩
        PaschLiftProjection.columns H z (j,x j)).card≤1 := by
    intro i j hij
    apply PaschLiftProjection.linear H z h4
    exact fun h => hij (congrArg Prod.fst h)
  have he' : ∀ q, (support (fun i => PaschLiftProjection.columns H z (i,x i)) q).card≤2 := by
    rintro ⟨q,t⟩
    apply le_trans (Finset.card_le_card (t := support H q) ?_) (he q)
    intro i hi
    apply (mem_support H q i).mpr
    exact ((PaschLiftProjection.mem_columns H z (i,x i) q t).mp
      ((mem_support _ _ i).mp hi)).1
  exact (elementary_pair_complete_iff _ hd' h4' he').symm.trans
    (pair_complete_iff_compatible H z c h01 h02 h03 h12 h13 h23 x)

/-- Counts actual zero-syndrome offset assignments above one specified base
Pasch. The global partition over unordered base supports is a separate step. -/
theorem actual_even_offset_count
    (H : Fin 4 → Finset C) (z : Fin 4 → C → G) (c : Fin 6 → C)
    (hd : ∀ i, (H i).card=3)
    (h4 : ∀ i j, i≠j → (H i ∩ H j).card≤1)
    (he : ∀ q, (support H q).card≤2)
    (h01 : H 0 ∩ H 1={c 0}) (h02 : H 0 ∩ H 2={c 1})
    (h03 : H 0 ∩ H 3={c 2}) (h12 : H 1 ∩ H 2={c 3})
    (h13 : H 1 ∩ H 3={c 4}) (h23 : H 2 ∩ H 3={c 5}) :
    Nat.card {x : Fin 4 → G // PaschClassification.EvenChecks
      (fun i => PaschLiftProjection.columns H z (i,x i))} =
      if PaschVoltage.Balanced (differences z c) then Nat.card G else 0 := by
  let e := Equiv.subtypeEquivRight
    (actual_even_iff_compatible H z c hd h4 he h01 h02 h03 h12 h13 h23)
  exact (Nat.card_congr e).trans (PaschVoltage.solution_count (differences z c))

#print axioms adjacent_iff
#print axioms pair_complete_iff_compatible
#print axioms actual_even_iff_compatible
#print axioms actual_even_offset_count
end PaschLiftCriterion
