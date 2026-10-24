import PairFormulaCore
import Mathlib.Data.Fintype.Card
import Mathlib.Data.Fintype.Prod
set_option maxHeartbeats 0
open PairFormula
namespace FourCompletions
variable {V C : Type*} [Fintype V] [Fintype C] [DecidableEq V] [DecidableEq C]

theorem proper_common_le_four (H : V → Finset C)
    (hd : ∀ v, (H v).card = 3)
    (h4 : ∀ u v, u ≠ v → (H u ∩ H v).card ≤ 1)
    (u v : V) (huv : u ≠ v) (hc : (H u ∩ H v).Nonempty) :
    (properCommon H u v).card ≤ 4 := by
  classical
  let W := properCommon H u v
  have hW (w : ↥W) :
      (H u ∩ H w.val).Nonempty ∧ (H v ∩ H w.val).Nonempty ∧
      ¬ (H u ∩ H v ∩ H w.val).Nonempty := by
    have h := (Finset.mem_filter.mp w.property).2
    exact ⟨h.2.2.1,h.2.2.2.1,h.2.2.2.2⟩
  let a (w : ↥W) : C := Classical.choose (hW w).1
  let b (w : ↥W) : C := Classical.choose (hW w).2.1
  have ha (w : ↥W) : a w ∈ H u ∧ a w ∈ H w.val := by
    exact Finset.mem_inter.mp (Classical.choose_spec (hW w).1)
  have hb (w : ↥W) : b w ∈ H v ∧ b w ∈ H w.val := by
    exact Finset.mem_inter.mp (Classical.choose_spec (hW w).2.1)
  have han (w : ↥W) : a w ∉ H v := by
    intro hav
    apply (hW w).2.2
    exact ⟨a w,Finset.mem_inter.mpr ⟨Finset.mem_inter.mpr ⟨(ha w).1,hav⟩,(ha w).2⟩⟩
  have hbn (w : ↥W) : b w ∉ H u := by
    intro hbu
    apply (hW w).2.2
    exact ⟨b w,Finset.mem_inter.mpr ⟨Finset.mem_inter.mpr ⟨hbu,(hb w).1⟩,(hb w).2⟩⟩
  let f : ↥W → ↥(H u \ H v) × ↥(H v \ H u) := fun w =>
    (⟨a w,Finset.mem_sdiff.mpr ⟨(ha w).1,han w⟩⟩,
     ⟨b w,Finset.mem_sdiff.mpr ⟨(hb w).1,hbn w⟩⟩)
  have hf : Function.Injective f := by
    intro w z heq
    apply Subtype.ext
    by_contra hne
    have haa : a w = a z := congrArg (fun x => x.1.val) heq
    have hbb : b w = b z := congrArg (fun x => x.2.val) heq
    have hab : a w ≠ b w := by
      intro hab
      exact han w (by simpa only [hab] using (hb w).1)
    have hsub : ({a w,b w} : Finset C) ⊆ H w.val ∩ H z.val := by
      intro c hc
      simp only [Finset.mem_insert,Finset.mem_singleton] at hc
      rcases hc with rfl | rfl
      · exact Finset.mem_inter.mpr ⟨(ha w).2,by simpa only [haa] using (ha z).2⟩
      · exact Finset.mem_inter.mpr ⟨(hb w).2,by simpa only [hbb] using (hb z).2⟩
    have htwo : ({a w,b w} : Finset C).card = 2 := by simp [hab]
    have hle := Finset.card_le_card hsub
    have hmax := h4 w.val z.val hne
    omega
  have hint : (H u ∩ H v).card = 1 := by
    have hlo := Finset.card_pos.mpr hc
    have hhi := h4 u v huv
    omega
  have hint' : (H v ∩ H u).card = 1 := by simpa [Finset.inter_comm] using hint
  have hdu : (H u \ H v).card = 2 := by
    have h := Finset.card_sdiff_add_card_inter (H u) (H v)
    rw [hint,hd] at h
    omega
  have hdv : (H v \ H u).card = 2 := by
    have h := Finset.card_sdiff_add_card_inter (H v) (H u)
    rw [hint',hd] at h
    omega
  have hcard := Fintype.card_le_of_injective f hf
  rw [Fintype.card_prod, Fintype.card_coe, Fintype.card_coe, Fintype.card_coe] at hcard
  rw [hdu,hdv] at hcard
  exact hcard

#print axioms proper_common_le_four
end FourCompletions
