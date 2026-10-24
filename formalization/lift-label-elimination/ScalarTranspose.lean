import ScalarIncidence

set_option maxHeartbeats 0
namespace ScalarTranspose
open CyclicRecurrence
variable (N : ℕ) [NeZero N]

def columns (t : ZMod N) : Finset (ZMod N) :=
  (ScalarIncidence.columns N (-t)).image Neg.neg

theorem columns_three (t : ZMod N) : columns N t={t,t+1,t+3} := by
  simp [columns,ScalarIncidence.columns_three,neg_sub,add_comm]

theorem cubic (hN : 7≤N) (t : ZMod N) : (columns N t).card=3 := by
  rw [columns,Finset.card_image_of_injective _ neg_injective]
  exact ScalarIncidence.cubic N hN (-t)

theorem linear (hN : 7≤N) (t s : ZMod N) (hts : t≠s) :
    (columns N t ∩ columns N s).card≤1 := by
  change ((ScalarIncidence.columns N (-t)).image Neg.neg ∩
    (ScalarIncidence.columns N (-s)).image Neg.neg).card≤1
  rw [← Finset.image_inter _ _ neg_injective,Finset.card_image_of_injective _ neg_injective]
  exact ScalarIncidence.linear N hN (-t) (-s) (fun h => hts (neg_injective h))

theorem membership (t c : ZMod N) :
    c∈ScalarIncidence.columns N (-t) ↔ -c∈columns N t := by
  simp only [columns,Finset.mem_image]
  constructor
  · intro h; exact ⟨c,h,rfl⟩
  · rintro ⟨u,hu,huc⟩
    have he : u=c := neg_injective huc
    simpa only [he] using hu

theorem no_four_dependency (q : ℕ) (hq : 2≤q) (g : Fin 4 → ZMod (7*q))
    (hg : Function.Injective g) :
    ¬ PaschClassification.EvenChecks (fun i => columns (7*q) (g i)) := by
  letI : NeZero q := ⟨by omega⟩
  intro he
  apply ScalarIncidence.no_four_dependency q hq (fun i => -g i)
    (fun i j h => hg (neg_injective h))
  intro c
  have hc := he (-c)
  simpa only [FourColumnClassification.support,← membership] using hc

theorem entry (hN : 7≤N) (s t : ZMod N) :
    PaschKernelCount.checkMatrix (columns N) s t=
      (if s=t then 1 else 0)+(if s=t+1 then 1 else 0)+(if s=t+3 then 1 else 0) := by
  have hm : -s∈ScalarIncidence.columns N (-t) ↔ s∈columns N t := by
    simpa only [neg_neg] using membership N t (-s)
  have he (k : ZMod N) : -s=-t-k ↔ s=t+k := by
    constructor <;> intro h
    · have hh := congrArg Neg.neg h
      simpa [neg_sub,add_comm] using hh
    · rw [h]; abel
  have h := ScalarIncidence.entry N hN (-s) (-t)
  simpa only [PaschKernelCount.checkMatrix,hm,neg_inj,he] using h

/-- The ordinary seven-coordinate scalar has exactly seven Pasch supports. -/
theorem fano_count : PaschKernelCount.count40 (ScalarIncidence.columns 7)=7 := by decide

theorem fano_transpose_count : PaschKernelCount.count40 (columns 7)=7 := by decide

#print axioms cubic
#print axioms linear
#print axioms no_four_dependency
#print axioms fano_count
#print axioms fano_transpose_count
end ScalarTranspose
