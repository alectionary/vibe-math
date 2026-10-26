import K23Numbering
set_option maxHeartbeats 0
namespace TruncatedDistance
open FamilyWords TannerSix
variable {L : ℕ} [NeZero L]

def k23Center : Fin 2 → Fin 5 := ![1,3]
def k23Leaf : Fin 3 → Fin 5 := ![0,2,4]
theorem k23_center_injective : Function.Injective k23Center := by decide +kernel
theorem k23_leaf_injective : Function.Injective k23Leaf := by decide +kernel
theorem k23_center_ne_leaf (a : Fin 2) (b : Fin 3) : k23Center a≠k23Leaf b := by
  fin_cases a <;> fin_cases b <;> decide +kernel

def numberedQubit {e : Fin 3 → Fin 4 → ZMod L}
    {u : Fin 4 → Fin 4 → ZMod L → ZMod 2} (n : K23Numbering e u) (x : Fin 5) : Qubit L :=
  .inl ((3,n.K x),n.S x)

theorem numberedQubit_injective {e : Fin 3 → Fin 4 → ZMod L}
    {u : Fin 4 → Fin 4 → ZMod L → ZMod 2} (n : K23Numbering e u) :
    Function.Injective (numberedQubit n) := by
  intro x y he
  apply n.injective
  have hp := Sum.inl.inj he
  apply Prod.ext
  · exact congrArg (fun p : (Fin 4 × Fin 4) × ZMod L => p.1.2) hp
  · exact congrArg (fun p : (Fin 4 × Fin 4) × ZMod L => p.2) hp

theorem source_three_distinct (e : Fin 3 → Fin 4 → ZMod L)
    (h4 : NoFour (CEdge e)) (h6 : NoSix (CEdge e))
    (x : Qubit L → ZMod 2) (hk : ∀ c,(∑ q,GeneralLP.HZ e c q*x q)=0)
    (hw : (CoverWeight.support x).card≤11)
    (q r z : Qubit L) (hqr : q≠r) (hrz : r≠z) (hzq : z≠q)
    (hq : x q≠0) (hr : x r≠0) (hz : x z≠0)
    (c : SourceModel.ZCheck L) (hqc : ZEdge e q c) (hrc : ZEdge e r c) (hzc : ZEdge e z c) : False := by
  classical
  exact no_three_at_check (ZEdge e) (CoverWeight.support x)
    (source_kernel_zero_or_two e h4 h6 x hk hw)
    ⟨q,Finset.mem_filter.mpr ⟨Finset.mem_univ _,hq⟩⟩
    ⟨r,Finset.mem_filter.mpr ⟨Finset.mem_univ _,hr⟩⟩
    ⟨z,Finset.mem_filter.mpr ⟨Finset.mem_univ _,hz⟩⟩
    (fun he => hqr (congrArg Subtype.val he))
    (fun he => hrz (congrArg Subtype.val he))
    (fun he => hzq (congrArg Subtype.val he)) c hqc hrc hzc

theorem source_neighbor_rows_distinct (e : Fin 3 → Fin 4 → ZMod L)
    (h4 : NoFour (CEdge e)) (h6 : NoSix (CEdge e))
    (x : Qubit L → ZMod 2) (hk : ∀ c,(∑ q,GeneralLP.HZ e c q*x q)=0)
    (hw : (CoverWeight.support x).card≤11)
    (q r z : Qubit L) (j k : Fin 4) (s : ZMod L) (heq : q=.inl ((j,k),s))
    (hqr : q≠r) (hrz : r≠z) (hzq : z≠q)
    (hq : x q≠0) (hr : x r≠0) (hz : x z≠0)
    (c d : SourceModel.ZCheck L) (hqc : ZEdge e q c) (hrc : ZEdge e r c)
    (hqd : ZEdge e q d) (hzd : ZEdge e z d) : c.1.2≠d.1.2 := by
  intro hi
  have hc := source_pair_row_colors_distinct e q j k s heq c d hqc hqd hi
  exact source_three_distinct e h4 h6 x hk hw q r z hqr hrz hzq hq hr hz c hqc hrc
    (by simpa only [hc] using hzd)

structure K23InternalChecks (e : Fin 3 → Fin 4 → ZMod L)
    (u : Fin 4 → Fin 4 → ZMod L → ZMod 2) (n : K23Numbering e u) where
  check : Fin 2 → Fin 3 → SourceModel.ZCheck L
  center_edge : ∀ a b,ZEdge e (numberedQubit n (k23Center a)) (check a b)
  leaf_edge : ∀ a b,ZEdge e (numberedQubit n (k23Leaf b)) (check a b)
  center_colors : ∀ a,Function.Injective (fun b => (check a b).1.2)
  leaf_colors : ∀ b,(check 0 b).1.2≠(check 1 b).1.2

/-- Actual source checks give a proper three-row coloring of the K2,3 edges. -/
theorem actual_k23_internal_checks (e : Fin 3 → Fin 4 → ZMod L)
    (h4 : NoFour (CEdge e)) (h6 : NoSix (CEdge e))
    (u : Fin 4 → Fin 4 → ZMod L → ZMod 2)
    (v : Fin 3 → Fin 3 → ZMod L → ZMod 2)
    (hk : ∀ c,(∑ q,GeneralLP.HZ e c q*GeneralLP.join u v q)=0)
    (hw : (CoverWeight.support (GeneralLP.join u v)).card≤11)
    (n : K23Numbering e u) : Nonempty (K23InternalChecks e u n) := by
  classical
  have hex (a : Fin 2) (b : Fin 3) : ∃ c,
      ZEdge e (numberedQubit n (k23Center a)) c ∧ ZEdge e (numberedQubit n (k23Leaf b)) c := by
    exact ((n.adjacency (k23Center a) (k23Leaf b)).mpr
      (by fin_cases a <;> fin_cases b <;> decide +kernel)).2
  choose C hC using hex
  have hne (a b : Fin 5) (hab : a≠b) : numberedQubit n a≠numberedQubit n b :=
    fun he => hab (numberedQubit_injective n he)
  refine ⟨{
    check := C
    center_edge := fun a b => (hC a b).1
    leaf_edge := fun a b => (hC a b).2
    center_colors := ?_
    leaf_colors := ?_
  }⟩
  · intro a b b' he
    by_contra hbb
    have hc := source_neighbor_rows_distinct e h4 h6 (GeneralLP.join u v) hk hw
      (numberedQubit n (k23Center a)) (numberedQubit n (k23Leaf b)) (numberedQubit n (k23Leaf b'))
      3 (n.K (k23Center a)) (n.S (k23Center a)) rfl
      (hne _ _ (k23_center_ne_leaf a b))
      (hne _ _ (fun h => hbb (k23_leaf_injective h)))
      (hne _ _ (k23_center_ne_leaf a b').symm)
      (n.nonzero _) (n.nonzero _) (n.nonzero _)
      (C a b) (C a b') (hC a b).1 (hC a b).2 (hC a b').1 (hC a b').2
    exact hc he
  · intro b
    exact source_neighbor_rows_distinct e h4 h6 (GeneralLP.join u v) hk hw
      (numberedQubit n (k23Leaf b)) (numberedQubit n (k23Center 0)) (numberedQubit n (k23Center 1))
      3 (n.K (k23Leaf b)) (n.S (k23Leaf b)) rfl
      (hne _ _ (k23_center_ne_leaf 0 b).symm)
      (hne _ _ (by decide +kernel))
      (hne _ _ (k23_center_ne_leaf 1 b))
      (n.nonzero _) (n.nonzero _) (n.nonzero _)
      (C 0 b) (C 1 b) (hC 0 b).2 (hC 0 b).1 (hC 1 b).2 (hC 1 b).1

#print axioms actual_k23_internal_checks
end TruncatedDistance
