import TransposeConstant
set_option maxHeartbeats 0
namespace FamilyTranspose
variable {L : Nat} [NeZero L]

theorem three_even_count : ∀ a b c : ZMod 2, a+b+c=0 →
    (a≠0 ∨ b≠0 ∨ c≠0) →
    (if a=0 then 0 else 1) + (if b=0 then 0 else 1) + (if c=0 then 0 else 1) = (2 : Nat) := by
  decide +kernel

def word (x : Fin 3 → ZMod L → ZMod 2) (v : Fin 3 × ZMod L) := x v.1 v.2

theorem nonzero_weight (x : Fin 3 → ZMod L → ZMod 2) (hx : Kernel x) (hn : x ≠ 0) :
    (CoverWeight.support (word x)).card = 2*L := by
  have heven := (kernel_iff x).mp hx |>.2
  have hne : x 0 0 ≠ 0 ∨ x 1 0 ≠ 0 ∨ x 2 0 ≠ 0 := by
    by_contra h
    push Not at h
    apply hn
    funext i s
    rw [all_constant x hx i s]
    fin_cases i
    · exact h.1
    · exact h.2.1
    · exact h.2.2
  have hr : (Finset.univ.filter (fun i : Fin 3 => x i 0 ≠ 0)).card = 2 := by
    rw [Finset.card_eq_sum_ones,Finset.sum_filter]
    simpa [Fin.sum_univ_succ,Nat.add_assoc] using three_even_count (x 0 0) (x 1 0) (x 2 0) heven hne
  have hs : CoverWeight.support (word x) =
      (Finset.univ.filter (fun i : Fin 3 => x i 0 ≠ 0)) ×ˢ (Finset.univ : Finset (ZMod L)) := by
    ext v
    simp [CoverWeight.support,word,all_constant x hx]
  rw [hs,Finset.card_product,hr]
  simp

def pair (i : Fin 3) (_s : ZMod L) : ZMod 2 := if i=0 ∨ i=1 then 1 else 0

theorem pair_kernel : Kernel (pair (L := L)) := by
  intro j s
  simp only [boundary,Fin.sum_univ_succ,Fin.sum_univ_zero,pair]
  decide +kernel

theorem pair_nonzero : pair (L := L) ≠ 0 := by
  intro h
  have hh := congrFun (congrFun h 0) 0
  norm_num [pair] at hh

/-- Every nonzero transpose codeword has the same weight, and such a word exists. -/
theorem distance_characterization :
    (∀ x : Fin 3 → ZMod L → ZMod 2, Kernel x → x ≠ 0 →
      (CoverWeight.support (word x)).card = 2*L) ∧
    ∃ x : Fin 3 → ZMod L → ZMod 2, Kernel x ∧ x ≠ 0 :=
  ⟨nonzero_weight, pair,pair_kernel,pair_nonzero⟩

#print axioms nonzero_weight
#print axioms distance_characterization
end FamilyTranspose
