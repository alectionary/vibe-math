import SparseTranspose
import OrientedKernel
import RankFromKernel

set_option maxHeartbeats 0
namespace SparseCSS
open Matrix CyclicRecurrence StructuredKernel OrientedKernel
open scoped BigOperators
variable {V C : Type*} [Fintype V] [Fintype C] [DecidableEq V] [DecidableEq C]
variable (N : ℕ) [NeZero N]

def shift (e : Bool) (t : ZMod N) (k : ℕ) : ZMod N :=
  if e then t+k else t-k

def adjoint (H : V → Finset C) (z : V → C → ZMod N) (e : Bool) :
    Matrix (Sum (V × ZMod N) (C × ZMod N)) (C × ZMod N) F
  | .inl (v,t),(c,s) => if c∈H v ∧ s=t+z v c then 1 else 0
  | .inr (c,t),(d,s) =>
      (if d=c ∧ s=t then 1 else 0)+
      (if d=c ∧ s=shift N e t 1 then 1 else 0)+
      (if d=c ∧ s=shift N e t 3 then 1 else 0)

def base (H : V → Finset C) : Matrix V C F :=
  fun v c => if c∈H v then 1 else 0

theorem left_apply (H : V → Finset C) (z : V → C → ZMod N) (e : Bool)
    (f : C × ZMod N → F) (v : V) (t : ZMod N) :
    (adjoint N H z e *ᵥf) (.inl (v,t))=∑ c∈H v, f (c,t+z v c) := by
  have h := SparseTranspose.transpose_apply H z f v t
  have hm (a : C × ZMod N) : a∈PaschLiftProjection.columns H z (v,t) ↔
      a.1∈H v ∧ a.2=t+z v a.1 := by
    rcases a with ⟨c,s⟩
    exact PaschLiftProjection.mem_columns H z (v,t) c s
  simp only [Matrix.mulVec,dotProduct,Matrix.transpose_apply,SparseTranspose.incidence] at h
  simp_rw [hm] at h
  exact h

theorem right_apply (H : V → Finset C) (z : V → C → ZMod N) (e : Bool)
    (f : C × ZMod N → F) (c : C) (t : ZMod N) :
    (adjoint N H z e *ᵥf) (.inr (c,t))=
      f (c,t)+f (c,shift N e t 1)+f (c,shift N e t 3) := by
  simp [Matrix.mulVec,dotProduct,adjoint,Fintype.sum_prod_type,
    add_mul,Finset.sum_add_distrib,ite_and,Finset.sum_ite_irrel,
    Finset.sum_ite_eq',Finset.sum_ite_eq]

theorem kernel_iff (H : V → Finset C) (z : V → C → ZMod N) (e : Bool)
    (f : C × ZMod N → F) :
    adjoint N H z e *ᵥf=0 ↔
      Twisted N (base H) z e (fun c t => f (c,t)) := by
  have hb (t : ZMod N) (v : V) :
      (∑ c, base H v c*f (c,t+z v c))=∑ c∈H v, f (c,t+z v c) := by
    simp [base,ite_mul,← Finset.sum_filter]
  have hs (c : C) :
      (∀ t, f (c,t)+f (c,shift N e t 1)+f (c,shift N e t 3)=0) ↔
      OrientedCondition N e (fun t => f (c,t)) := by
    cases e
    · simp only [shift,Bool.false_eq_true,↓reduceIte,OrientedCondition,MinusCondition,Nat.cast_ofNat,Nat.cast_one]
    · simp only [shift,↓reduceIte,OrientedCondition,ScalarCondition,Nat.cast_ofNat,Nat.cast_one]
      exact forall_congr' (fun t => third_eq _ _ _)
  constructor
  · intro hf
    refine ⟨fun c => (hs c).mp (fun t => ?_),fun t v => ?_⟩
    · have h := congrFun hf (.inr (c,t))
      rwa [right_apply] at h
    · rw [hb]
      have h := congrFun hf (.inl (v,t))
      rwa [left_apply] at h
  · rintro ⟨hf,hl⟩
    funext w
    cases w with
    | inl v => rw [left_apply,← hb]; exact hl v.2 v.1
    | inr c => rw [right_apply]; exact (hs c.1).mpr (hf c.1) c.2

noncomputable def kernelEquiv (H : V → Finset C) (z : V → C → ZMod N) (e : Bool) :
    {f : C × ZMod N → F // adjoint N H z e *ᵥf=0} ≃
      {f : C → ZMod N → F // Twisted N (base H) z e f} where
  toFun f := ⟨fun c t => f.val (c,t),(kernel_iff N H z e f.val).mp f.prop⟩
  invFun g := ⟨fun c => g.val c.1 c.2,(kernel_iff N H z e _).mpr g.prop⟩
  left_inv _ := rfl
  right_inv _ := rfl

theorem kernel_card (h7 : 7∣N) (H : V → Finset C) (z : V → C → ZMod N)
    (hz : ∀ v c, ZMod.castHom h7 (ZMod 7) (z v c)=0) (e : Bool) :
    Nat.card {f : C × ZMod N → F // adjoint N H z e *ᵥf=0}=
      (Nat.card {x : C → F // BaseCondition (base H) x})^3 := by
  rw [Nat.card_congr (kernelEquiv N H z e),OrientedKernel.kernel_card N h7 (base H) z hz e]

theorem rank_defect_nine (h7 : 7∣N) (H : V → Finset C) (z : V → C → ZMod N)
    (hz : ∀ v c, ZMod.castHom h7 (ZMod 7) (z v c)=0) (e : Bool)
    (hb : Nat.card {x : C → F // BaseCondition (base H) x}=8) :
    (adjoint N H z e).rank+9=Fintype.card C*N := by
  have hc : Nat.card {f : C × ZMod N → F // adjoint N H z e *ᵥf=0}=512 := by
    rw [kernel_card N h7 H z hz e,hb]; decide
  simpa only [Fintype.card_prod,ZMod.card] using RankFromKernel.rank_of_kernel _ hc

#print axioms kernel_iff
#print axioms kernel_card
#print axioms rank_defect_nine
end SparseCSS
