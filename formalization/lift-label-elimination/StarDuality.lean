import StarElimination

set_option maxHeartbeats 0
namespace StarDuality
open PaschCubicTrade

def p (v : Fin 10) : Fin 10 := ⟨(v.val+6)%10,Nat.mod_lt _ (by decide)⟩
def q (c : Fin 10) : Fin 10 := ⟨(c.val+4)%10,Nat.mod_lt _ (by decide)⟩

def variablePerm : Fin 10 ≃ Fin 10 where
  toFun := p
  invFun := q
  left_inv := by decide
  right_inv := by decide

def checkPerm : Fin 10 ≃ Fin 10 := variablePerm.symm

def dualBase (c : Fin 10) : Finset (Fin 10) :=
  Finset.univ.filter (fun v => c∈baseA v)

theorem base_reindex : ∀ u,
    dualBase (variablePerm u)=(baseA u).image checkPerm := by decide

variable {G : Type*} [AddCommGroup G] [DecidableEq G] [Fintype G]
def dualLabels (a : G) (c v : Fin 10) := -StarElimination.labels a v c

theorem label_reindex (a : G) (u c : Fin 10) :
    dualLabels a (variablePerm u) (checkPerm c)=StarElimination.labels (-a) u c := by
  have hcond : ∀ u c,
      ((checkPerm c=0 ∧ variablePerm u=0) ∨ (checkPerm c=4 ∧ variablePerm u=6)) ↔
        ((u=0 ∧ c=0) ∨ (u=4 ∧ c=6)) := by decide
  unfold dualLabels StarElimination.labels
  simp only [hcond]
  split_ifs <;> simp

def checkFiberPerm : Fin 10 × G ≃ Fin 10 × G := Equiv.prodCongr checkPerm (Equiv.refl G)

/-- The actual dual cover is the original star cover with negated labels,
up to explicit variable/check permutations; the fiber coordinate is preserved. -/
theorem cover_reindex (a : G) (u : Fin 10) (t : G) :
    PaschLiftProjection.columns dualBase (dualLabels a) (variablePerm u,t)=
      (PaschLiftProjection.columns baseA (StarElimination.labels (-a)) (u,t)).image checkFiberPerm := by
  unfold PaschLiftProjection.columns
  rw [base_reindex]
  simp only [Finset.image_image]
  apply Finset.image_congr
  intro c hc
  change (checkPerm c,t+dualLabels a (variablePerm u) (checkPerm c))=
    (checkPerm c,t+StarElimination.labels (-a) u c)
  rw [label_reindex]

/-- Both actual cover sectors are Pasch-free for any nonzero changed label. -/
theorem dual_nonzero_eliminates (a : G) (ha : a≠0) (f : Fin 4 → Fin 10 × G)
    (hf : Function.Injective f) :
    ¬ PaschClassification.EvenChecks
      (fun i => PaschLiftProjection.columns dualBase (dualLabels a) (f i)) := by
  intro he
  let g : Fin 4 → Fin 10 × G := fun i => (variablePerm.symm (f i).1,(f i).2)
  have heq (i : Fin 4) : (variablePerm (g i).1,(g i).2)=f i := by simp [g]
  have hi : Function.Injective g := by
    intro i j hij
    apply hf
    rw [← heq i,← heq j]
    exact congrArg (fun w : Fin 10 × G => (variablePerm w.1,w.2)) hij
  have hcols (i : Fin 4) :
      PaschLiftProjection.columns dualBase (dualLabels a) (f i)=
      (PaschLiftProjection.columns baseA (StarElimination.labels (-a)) (g i)).image checkFiberPerm := by
    rw [← heq i]
    exact cover_reindex a (g i).1 (g i).2
  have hstar : PaschClassification.EvenChecks
      (fun i => PaschLiftProjection.columns baseA (StarElimination.labels (-a)) (g i)) := by
    intro c
    have hs : FourColumnClassification.support
        (fun i => PaschLiftProjection.columns dualBase (dualLabels a) (f i)) (checkFiberPerm c)=
        FourColumnClassification.support
        (fun i => PaschLiftProjection.columns baseA (StarElimination.labels (-a)) (g i)) c := by
      ext i
      simp only [FourColumnClassification.mem_support,hcols,Finset.mem_image]
      constructor
      · rintro ⟨d,hd,he⟩
        have hdc : d=c := checkFiberPerm.injective he
        subst d
        exact hd
      · intro hc
        exact ⟨c,hc,rfl⟩
    have h := he (checkFiberPerm c)
    rw [hs] at h
    exact h
  exact StarElimination.nonzero_eliminates (-a) (neg_ne_zero.mpr ha) g hi hstar

#print axioms variablePerm
#print axioms base_reindex
#print axioms label_reindex
#print axioms cover_reindex
#print axioms dual_nonzero_eliminates
end StarDuality
