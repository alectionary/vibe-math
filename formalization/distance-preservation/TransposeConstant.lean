import FamilyTranspose
set_option maxHeartbeats 0
namespace FamilyTranspose
variable {L : Nat} [NeZero L]
open scoped CharTwo

theorem constant_of_period (f : ZMod L → ZMod 2) (hf : ∀ s, f (s+1)=f s) (s : ZMod L) :
    f s = f 0 := by
  have h : ∀ n : Nat, f (n : ZMod L) = f 0 := by
    intro n
    induction n with
    | zero => simp
    | succ n ih => simpa only [Nat.cast_succ] using (hf (n : ZMod L)).trans ih
  simpa only [ZMod.natCast_zmod_val] using h s.val

theorem third_constant (x : Fin 3 → ZMod L → ZMod 2) (hx : Kernel x) (s : ZMod L) :
    x 2 s = x 2 0 := by
  apply constant_of_period (x 2) _ s
  intro t
  have h := (CharTwo.add_eq_zero.mp (third_period x hx (t-1))).symm
  have ha : t-1+1=t := by ring
  have hb : t-1+2=t+1 := by ring
  simpa only [ha,hb] using h

theorem second_period (x : Fin 3 → ZMod L → ZMod 2) (hx : Kernel x) (s : ZMod L) :
    x 1 (s+1)=x 1 s := by
  have h0 := hx 0 s
  have h1 := hx 1 s
  norm_num [boundary,FamilyWords.exponent,Fin.sum_univ_succ] at h0 h1
  rw [third_constant x hx s] at h0
  rw [third_constant x hx (s+2)] at h1
  have h := congrArg (fun z => z + (x 0 s + x 2 0)) h0
  have k := congrArg (fun z => z + (x 0 s + x 2 0)) h1
  simp only [zero_add] at h k
  have he : x 1 s = x 0 s + x 2 0 := by
    simpa [add_assoc,add_left_comm,add_comm] using h
  have he' : x 1 (s+1) = x 0 s + x 2 0 := by
    simpa [add_assoc,add_left_comm,add_comm] using k
  exact he'.trans he.symm

theorem second_constant (x : Fin 3 → ZMod L → ZMod 2) (hx : Kernel x) (s : ZMod L) :
    x 1 s = x 1 0 := constant_of_period (x 1) (second_period x hx) s

theorem first_constant (x : Fin 3 → ZMod L → ZMod 2) (hx : Kernel x) (s : ZMod L) :
    x 0 s = x 0 0 := by
  have h0 := hx 0 0
  have hs := hx 0 s
  norm_num [boundary,FamilyWords.exponent,Fin.sum_univ_succ] at h0 hs
  rw [second_constant x hx s,third_constant x hx s] at hs
  exact add_right_cancel (hs.trans h0.symm)

theorem all_constant (x : Fin 3 → ZMod L → ZMod 2) (hx : Kernel x) (i : Fin 3) (s : ZMod L) :
    x i s = x i 0 := by
  fin_cases i
  · exact first_constant x hx s
  · exact second_constant x hx s
  · exact third_constant x hx s

theorem kernel_iff (x : Fin 3 → ZMod L → ZMod 2) : Kernel x ↔
    (∀ i s, x i s = x i 0) ∧ x 0 0 + x 1 0 + x 2 0 = 0 := by
  constructor
  · intro hx
    refine ⟨all_constant x hx,?_⟩
    have h:=hx 0 0
    simpa [boundary,FamilyWords.exponent,Fin.sum_univ_succ,add_assoc] using h
  · rintro ⟨hc,hs⟩ j t
    unfold boundary
    simp_rw [hc]
    simpa [Fin.sum_univ_succ,add_assoc] using hs

#print axioms all_constant
#print axioms kernel_iff
end FamilyTranspose
