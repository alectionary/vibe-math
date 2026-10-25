import TannerSix
import CoverWeight
set_option maxHeartbeats 0
namespace LowWeightChecks
open TannerSix
variable {V C : Type*} [DecidableEq V] [DecidableEq C]

/-- A check with four selected neighbors forces twelve selected variables.
This is a check-rooted classical Tanner-tree counting argument. -/
theorem four_neighbors_force_twelve (E : V → C → Prop) [DecidableRel E]
    (h4 : NoFour E) (h6 : NoSix E) (hd : ThreeChecks E)
    (T : Finset V) (hT : SmallStopping.Stopping E T)
    (c : C) (v : Fin 4 → V) (hvi : Function.Injective v)
    (hvT : ∀ i, v i∈T) (hvc : ∀ i, E (v i) c) : 12≤T.card := by
  have hh : ∀ i : Fin 4, ∃ a b, a≠b ∧ a≠c ∧ b≠c ∧ E (v i) a ∧ E (v i) b :=
    fun i => two_more E hd (v i) c
  choose a b hab hac hbc hea heb using hh
  let d : Fin 4 → Fin 2 → C := fun i k => if k=0 then a i else b i
  have hdc : ∀ i k, d i k≠c := by
    intro i k; fin_cases k <;> simp [d,hac,hbc]
  have hde : ∀ i k, E (v i) (d i k) := by
    intro i k; fin_cases k <;> simp [d,hea,heb]
  have hdi : ∀ i, Function.Injective (d i) := by
    intro i k l h
    fin_cases k <;> fin_cases l
    · rfl
    · exact False.elim (hab i (by simpa [d] using h))
    · exact False.elim (hab i (by simpa [d] using h.symm))
    · rfl
  have hp : ∀ p : Fin 4 × Fin 2, ∃ w, w∈T ∧ w≠v p.1 ∧ E w (d p.1 p.2) :=
    fun p => partner E T hT (v p.1) (hvT p.1) (d p.1 p.2) (hde p.1 p.2)
  choose w hwT hwv hwe using hp
  have hsep (p : Fin 4 × Fin 2) (j : Fin 4) : w p≠v j := by
    intro h
    by_cases hij : p.1=j
    · exact hwv p (h.trans (congrArg v hij.symm))
    · exact h4 (v p.1) (v j) c (d p.1 p.2)
        (fun e => hij (hvi e)) (hdc _ _).symm (hvc _) (hvc _)
        (by simpa [h] using hwe p) (hde _ _)
  have hds (p q : Fin 4 × Fin 2) (hij : p.1≠q.1) : d p.1 p.2≠d q.1 q.2 := by
    intro he
    exact h4 (v p.1) (v q.1) c (d p.1 p.2)
      (fun e => hij (hvi e)) (hdc _ _).symm (hvc _) (hvc _)
      (by simpa [he] using hde q.1 q.2) (hde _ _)
  have hwi : Function.Injective w := by
    intro p q he
    by_cases hij : p.1=q.1
    · have hkl : p.2=q.2 := by
        apply hdi p.1
        by_contra hne
        exact h4 (v p.1) (w p) (d p.1 p.2) (d p.1 q.2)
          (hwv p).symm hne (hde _ _) (hwe p)
          (by simpa [hij,he] using hwe q) (hde _ _)
      exact Prod.ext hij hkl
    · exact False.elim (h6 (v p.1) (w p) (v q.1)
        (d p.1 p.2) (d q.1 q.2) c
        (hwv p).symm (hsep p q.1) (fun e => hij (hvi e.symm))
        (hds p q hij) (hdc _ _) (hdc _ _).symm
        (hde _ _) (hwe p) (by simpa [he] using hwe q) (hde _ _) (hvc _) (hvc _))
  let f : (Fin 4 ⊕ (Fin 4 × Fin 2)) → V := Sum.elim v w
  have hfi : Function.Injective f := by
    intro x y h
    cases x with
    | inl i =>
      cases y with
      | inl j => exact congrArg Sum.inl (hvi h)
      | inr q => exact False.elim (hsep q i h.symm)
    | inr p =>
      cases y with
      | inl j => exact False.elim (hsep p j h)
      | inr q => exact congrArg Sum.inr (hwi h)
  have hsub : Finset.univ.image f⊆T := by
    intro z hz
    obtain ⟨i,_,rfl⟩ := Finset.mem_image.mp hz
    cases i with
    | inl i => exact hvT i
    | inr p => exact hwT p
  have hc := Finset.card_le_card hsub
  rw [Finset.card_image_of_injective _ hfi] at hc
  simpa using hc

/-- Below twelve, every neighboring check of a stopping support has degree
at most three. Binary parity will then exclude degrees one and three. -/
theorem degree_le_three (E : V → C → Prop) [DecidableRel E]
    (h4 : NoFour E) (h6 : NoSix E) (hd : ThreeChecks E)
    (T : Finset V) (hT : SmallStopping.Stopping E T) (hsize : T.card≤11) (c : C) :
    (T.filter (fun v => E v c)).card≤3 := by
  by_contra hn
  have hcard : 4≤(T.filter (fun v => E v c)).card := by omega
  obtain ⟨f⟩ := Function.Embedding.nonempty_of_card_le (show Fintype.card (Fin 4)≤
      Fintype.card {v // v∈T.filter (fun v => E v c)} by simpa using hcard)
  let v : Fin 4 → V := fun i => (f i).val
  have hvi : Function.Injective v := fun i j h => f.injective (Subtype.ext h)
  have hvT : ∀ i, v i∈T := fun i => (Finset.mem_filter.mp (f i).property).1
  have hvc : ∀ i, E (v i) c := fun i => (Finset.mem_filter.mp (f i).property).2
  have ht := four_neighbors_force_twelve E h4 h6 hd T hT c v hvi hvT hvc
  omega

variable [Fintype V]

def BinaryKernel (E : V → C → Prop) [DecidableRel E] (x : V → ZMod 2) : Prop :=
  ∀ c, (∑ v, if E v c then x v else 0)=0

theorem parity_card (E : V → C → Prop) [DecidableRel E]
    (x : V → ZMod 2) (hk : BinaryKernel E x) (c : C) :
    (((CoverWeight.support x).filter (fun v => E v c)).card : ZMod 2)=0 := by
  have he := CoverWeight.sum_eq_card_support (Finset.univ.filter (fun v => E v c)) x
  have hs : ((Finset.univ.filter (fun v => E v c)).filter (fun v => x v≠0))=
      (CoverWeight.support x).filter (fun v => E v c) := by
    ext v
    simp [CoverWeight.support,and_comm]
  rw [hs] at he
  have hz : (∑ v∈Finset.univ.filter (fun v => E v c), x v)=0 := by
    simpa only [Finset.sum_filter] using hk c
  exact he.symm.trans hz

theorem kernel_stopping (E : V → C → Prop) [DecidableRel E]
    (x : V → ZMod 2) (hk : BinaryKernel E x) (hn : x≠0) :
    SmallStopping.Stopping E (CoverWeight.support x) := by
  constructor
  · by_contra h
    apply hn
    funext v
    by_contra hv
    exact h ⟨v,Finset.mem_filter.mpr ⟨Finset.mem_univ _,hv⟩⟩
  · intro c hc
    have hp := parity_card E x hk c
    rw [hc] at hp
    norm_num at hp

/-- Every binary kernel word of weight at most eleven meets each check in
zero or two selected coordinates. The degree/girth premises are explicit. -/
theorem kernel_check_zero_or_two (E : V → C → Prop) [DecidableRel E]
    (h4 : NoFour E) (h6 : NoSix E) (hd : ThreeChecks E)
    (x : V → ZMod 2) (hk : BinaryKernel E x)
    (hsize : (CoverWeight.support x).card≤11) (c : C) :
    ((CoverWeight.support x).filter (fun v => E v c)).card=0 ∨
      ((CoverWeight.support x).filter (fun v => E v c)).card=2 := by
  by_cases hn : x=0
  · simp [hn,CoverWeight.support]
  have hdg := degree_le_three E h4 h6 hd _ (kernel_stopping E x hk hn) hsize c
  have hp := parity_card E x hk c
  have hc : ((CoverWeight.support x).filter (fun v => E v c)).card=0 ∨
      ((CoverWeight.support x).filter (fun v => E v c)).card=1 ∨
      ((CoverWeight.support x).filter (fun v => E v c)).card=2 ∨
      ((CoverWeight.support x).filter (fun v => E v c)).card=3 := by omega
  rcases hc with h|h|h|h
  · exact Or.inl h
  · rw [h] at hp; norm_num at hp
  · exact Or.inr h
  · rw [h] at hp
    exact False.elim ((by decide +kernel : (3 : ZMod 2)≠0) hp)

#print axioms four_neighbors_force_twelve
#print axioms degree_le_three
#print axioms kernel_check_zero_or_two
end LowWeightChecks
