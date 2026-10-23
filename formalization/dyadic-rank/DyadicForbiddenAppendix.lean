module

public import DyadicForbiddenSource
public import Mathlib.Data.Finset.Sort
public import Mathlib.Algebra.BigOperators.Fin

@[expose] public section
open CyclicLift
namespace DyadicForbidden.Appendix

set_option backward.isDefEq.respectTransparency.types false

variable {X C A : Type*} [AddCommGroup A] [Module (ZMod 2) A]

def Proper {k : ℕ} [NeZero k] {D : Type*} (r : Fin k → D) : Prop :=
  ∀ i, r i ≠ r (i+1)

def Supported (E : X → C → Prop) {k : ℕ} [NeZero k]
    (r : Fin k → C) (c : Fin k → X) : Prop :=
  ∀ i, E (c i) (r i) ∧ E (c i) (r (i+1))

def left2 (s : X → C → A) (r : Fin 2 → C) (c : Fin 2 → X) : A :=
  s (c 0) (r 0) + s (c 0) (r 1)
def right2 (s : X → C → A) (r : Fin 2 → C) (c : Fin 2 → X) : A :=
  s (c 1) (r 1) + s (c 1) (r 0)
def left3 (s : X → C → A) (r : Fin 3 → C) (c : Fin 3 → X) : A :=
  s (c 0) (r 0) + s (c 0) (r 1) + s (c 1) (r 1)
def right3 (s : X → C → A) (r : Fin 3 → C) (c : Fin 3 → X) : A :=
  s (c 1) (r 2) + s (c 2) (r 2) + s (c 2) (r 0)
def left4 (s : X → C → A) (r : Fin 4 → C) (c : Fin 4 → X) : A :=
  s (c 0) (r 0) + s (c 0) (r 1) + s (c 1) (r 1) + s (c 1) (r 2)
def right4 (s : X → C → A) (r : Fin 4 → C) (c : Fin 4 → X) : A :=
  s (c 3) (r 0) + s (c 3) (r 3) + s (c 2) (r 3) + s (c 2) (r 2)

def polygon2 (E : X → C → Prop) (r : Fin 2 → C) (c : Fin 2 → X)
    (h : Supported E r c) : (bipartiteBase E).Walk (.inr (r 0)) (.inr (r 0)) :=
  fourWalk (b := .inl (c 0)) (c := .inr (r 1)) (d := .inl (c 1))
    (h 0).1 (h 0).2 (h 1).1 (h 1).2
def polygon3 (E : X → C → Prop) (r : Fin 3 → C) (c : Fin 3 → X)
    (h : Supported E r c) : (bipartiteBase E).Walk (.inr (r 0)) (.inr (r 0)) :=
  sixWalk (b := .inl (c 0)) (c := .inr (r 1)) (d := .inl (c 1))
    (e := .inr (r 2)) (f := .inl (c 2))
    (h 0).1 (h 0).2 (h 1).1 (h 1).2 (h 2).1 (h 2).2
def polygon4 (E : X → C → Prop) (r : Fin 4 → C) (c : Fin 4 → X)
    (h : Supported E r c) : (bipartiteBase E).Walk (.inr (r 0)) (.inr (r 0)) :=
  eightWalk (b := .inl (c 0)) (c := .inr (r 1)) (d := .inl (c 1))
    (e := .inr (r 2)) (f := .inl (c 2)) (g := .inr (r 3)) (h := .inl (c 3))
    (h 0).1 (h 0).2 (h 1).1 (h 1).2 (h 2).1 (h 2).2 (h 3).1 (h 3).2

theorem zero_pair (a b : A) : a+b=0 ↔ a=b := by
  rw [add_eq_zero_iff_eq_neg, ZModModule.neg_eq_self]

theorem polygon2_zero (E : X → C → Prop) (s : X → C → A)
    (r : Fin 2 → C) (c : Fin 2 → X) (h : Supported E r c) :
    (bipartite E s).displacement (polygon2 E r c h) = 0 ↔ left2 s r c = right2 s r c := by
  have he : (bipartite E s).displacement (polygon2 E r c h) = left2 s r c + right2 s r c := by
    simp [polygon2,fourWalk,VoltageGraph.displacement,bipartite,bipartiteVoltage,
      ZModModule.neg_eq_self,left2,right2,add_assoc]
  rw [he,zero_pair]
theorem polygon3_zero (E : X → C → Prop) (s : X → C → A)
    (r : Fin 3 → C) (c : Fin 3 → X) (h : Supported E r c) :
    (bipartite E s).displacement (polygon3 E r c h) = 0 ↔ left3 s r c = right3 s r c := by
  have he : (bipartite E s).displacement (polygon3 E r c h) = left3 s r c + right3 s r c := by
    simp [polygon3,sixWalk,VoltageGraph.displacement,bipartite,bipartiteVoltage,
      ZModModule.neg_eq_self,left3,right3,add_assoc]
  rw [he,zero_pair]
theorem polygon4_zero (E : X → C → Prop) (s : X → C → A)
    (r : Fin 4 → C) (c : Fin 4 → X) (h : Supported E r c) :
    (bipartite E s).displacement (polygon4 E r c h) = 0 ↔ left4 s r c = right4 s r c := by
  have he : (bipartite E s).displacement (polygon4 E r c h) = left4 s r c + right4 s r c := by
    simp only [polygon4,eightWalk,VoltageGraph.displacement,bipartite,bipartiteVoltage,
      ZModModule.neg_eq_self,left4,right4]
    abel
  rw [he,zero_pair]

def Raw2 (E : X → C → Prop) (s : X → C → A) : Prop :=
  ∃ r c, Proper r ∧ Proper c ∧ Supported E r c ∧ left2 s r c = right2 s r c
def Raw3 (E : X → C → Prop) (s : X → C → A) : Prop :=
  ∃ r c, Proper r ∧ Proper c ∧ Supported E r c ∧ left3 s r c = right3 s r c
def Raw4 (E : X → C → Prop) (s : X → C → A) : Prop :=
  ∃ r c, Proper r ∧ Proper c ∧ Supported E r c ∧ left4 s r c = right4 s r c



set_option maxRecDepth 10000 in
set_option maxHeartbeats 0 in
theorem polygon2_tbc (E : X → C → Prop) (r : Fin 2 → C) (c : Fin 2 → X)
    (h : Supported E r c) : TBC (polygon2 E r c h) ↔ Proper r ∧ Proper c := by
  simp [TBC, Reduced, polygon2, fourWalk, Proper, Fin.forall_fin_succ,
    SimpleGraph.Walk.edges_cons, List.isChain_cons_cons,
    and_assoc, and_left_comm, and_comm, eq_comm]
  aesop

set_option maxRecDepth 10000 in
set_option maxHeartbeats 0 in
theorem polygon3_tbc (E : X → C → Prop) (r : Fin 3 → C) (c : Fin 3 → X)
    (h : Supported E r c) : TBC (polygon3 E r c h) ↔ Proper r ∧ Proper c := by
  simp [TBC, Reduced, polygon3, sixWalk, Proper, Fin.forall_fin_succ,
    SimpleGraph.Walk.edges_cons, List.isChain_cons_cons,
    and_assoc, and_left_comm, and_comm, eq_comm]
  aesop

set_option maxRecDepth 10000 in
set_option maxHeartbeats 0 in
theorem polygon4_tbc (E : X → C → Prop) (r : Fin 4 → C) (c : Fin 4 → X)
    (h : Supported E r c) : TBC (polygon4 E r c h) ↔ Proper r ∧ Proper c := by
  simp [TBC, Reduced, polygon4, eightWalk, Proper, Fin.forall_fin_succ,
    SimpleGraph.Walk.edges_cons, List.isChain_cons_cons,
    and_assoc, and_left_comm, and_comm, eq_comm]
  aesop



theorem raw2_of_base (E : X → C → Prop) (s : X → C → A) (r0 : C)
    (p : (bipartite E s).base.Walk (.inr r0) (.inr r0))
    (ht : TBC p) (hz : (bipartite E s).displacement p = 0) (hl : p.length = 4) : Raw2 E s := by
  cases p with
  | nil => simp at hl
  | @cons _ v _ h0 p1 =>
    simp only [SimpleGraph.Walk.length_cons] at hl
    cases v with
    | inr v => exact False.elim h0
    | inl x0 =>
      cases p1 with
      | @cons _ v _ h1 p2 =>
        simp only [SimpleGraph.Walk.length_cons] at hl
        cases v with
        | inl v => exact False.elim h1
        | inr r1 =>
          cases p2 with
          | nil => simp at hl
          | @cons _ v _ h2 p3 =>
            simp only [SimpleGraph.Walk.length_cons] at hl
            cases v with
            | inr v => exact False.elim h2
            | inl x1 =>
              cases p3 with
              | @cons _ v _ h3 p4 =>
                simp only [SimpleGraph.Walk.length_cons] at hl
                cases v with
                | inl v => exact False.elim h3
                | inr r2 =>
                  cases p4 with
                  | cons => simp only [SimpleGraph.Walk.length_cons] at hl; omega
                  | nil =>
                    let r : Fin 2 → C := ![r0,r1]
                    let c : Fin 2 → X := ![x0,x1]
                    have hs : Supported E r c := by
                      intro i
                      fin_cases i
                      · exact ⟨h0,h1⟩
                      · exact ⟨h2,h3⟩
                    change TBC (polygon2 E r c hs) at ht
                    change (bipartite E s).displacement (polygon2 E r c hs) = 0 at hz
                    exact ⟨r,c,((polygon2_tbc E r c hs).mp ht).1,
                      ((polygon2_tbc E r c hs).mp ht).2,hs,(polygon2_zero E s r c hs).mp hz⟩

theorem raw3_of_base (E : X → C → Prop) (s : X → C → A) (r0 : C)
    (p : (bipartite E s).base.Walk (.inr r0) (.inr r0))
    (ht : TBC p) (hz : (bipartite E s).displacement p = 0) (hl : p.length = 6) : Raw3 E s := by
  cases p with
  | nil => simp at hl
  | @cons _ v _ h0 p1 =>
    simp only [SimpleGraph.Walk.length_cons] at hl
    cases v with
    | inr v => exact False.elim h0
    | inl x0 =>
      cases p1 with
      | @cons _ v _ h1 p2 =>
        simp only [SimpleGraph.Walk.length_cons] at hl
        cases v with
        | inl v => exact False.elim h1
        | inr r1 =>
          cases p2 with
          | nil => simp at hl
          | @cons _ v _ h2 p3 =>
            simp only [SimpleGraph.Walk.length_cons] at hl
            cases v with
            | inr v => exact False.elim h2
            | inl x1 =>
              cases p3 with
              | @cons _ v _ h3 p4 =>
                simp only [SimpleGraph.Walk.length_cons] at hl
                cases v with
                | inl v => exact False.elim h3
                | inr r2 =>
                  cases p4 with
                  | nil => simp at hl
                  | @cons _ v _ h4 p5 =>
                    simp only [SimpleGraph.Walk.length_cons] at hl
                    cases v with
                    | inr v => exact False.elim h4
                    | inl x2 =>
                      cases p5 with
                      | @cons _ v _ h5 p6 =>
                        simp only [SimpleGraph.Walk.length_cons] at hl
                        cases v with
                        | inl v => exact False.elim h5
                        | inr r3 =>
                          cases p6 with
                          | cons => simp only [SimpleGraph.Walk.length_cons] at hl; omega
                          | nil =>
                            let r : Fin 3 → C := ![r0,r1,r2]
                            let c : Fin 3 → X := ![x0,x1,x2]
                            have hs : Supported E r c := by
                              intro i
                              fin_cases i
                              · exact ⟨h0,h1⟩
                              · exact ⟨h2,h3⟩
                              · exact ⟨h4,h5⟩
                            change TBC (polygon3 E r c hs) at ht
                            change (bipartite E s).displacement (polygon3 E r c hs) = 0 at hz
                            exact ⟨r,c,((polygon3_tbc E r c hs).mp ht).1,
                              ((polygon3_tbc E r c hs).mp ht).2,hs,(polygon3_zero E s r c hs).mp hz⟩

theorem raw4_of_base (E : X → C → Prop) (s : X → C → A) (r0 : C)
    (p : (bipartite E s).base.Walk (.inr r0) (.inr r0))
    (ht : TBC p) (hz : (bipartite E s).displacement p = 0) (hl : p.length = 8) : Raw4 E s := by
  cases p with
  | nil => simp at hl
  | @cons _ v _ h0 p1 =>
    simp only [SimpleGraph.Walk.length_cons] at hl
    cases v with
    | inr v => exact False.elim h0
    | inl x0 =>
      cases p1 with
      | @cons _ v _ h1 p2 =>
        simp only [SimpleGraph.Walk.length_cons] at hl
        cases v with
        | inl v => exact False.elim h1
        | inr r1 =>
          cases p2 with
          | nil => simp at hl
          | @cons _ v _ h2 p3 =>
            simp only [SimpleGraph.Walk.length_cons] at hl
            cases v with
            | inr v => exact False.elim h2
            | inl x1 =>
              cases p3 with
              | @cons _ v _ h3 p4 =>
                simp only [SimpleGraph.Walk.length_cons] at hl
                cases v with
                | inl v => exact False.elim h3
                | inr r2 =>
                  cases p4 with
                  | nil => simp at hl
                  | @cons _ v _ h4 p5 =>
                    simp only [SimpleGraph.Walk.length_cons] at hl
                    cases v with
                    | inr v => exact False.elim h4
                    | inl x2 =>
                      cases p5 with
                      | @cons _ v _ h5 p6 =>
                        simp only [SimpleGraph.Walk.length_cons] at hl
                        cases v with
                        | inl v => exact False.elim h5
                        | inr r3 =>
                          cases p6 with
                          | nil => simp at hl
                          | @cons _ v _ h6 p7 =>
                            simp only [SimpleGraph.Walk.length_cons] at hl
                            cases v with
                            | inr v => exact False.elim h6
                            | inl x3 =>
                              cases p7 with
                              | @cons _ v _ h7 p8 =>
                                simp only [SimpleGraph.Walk.length_cons] at hl
                                cases v with
                                | inl v => exact False.elim h7
                                | inr r4 =>
                                  cases p8 with
                                  | cons => simp only [SimpleGraph.Walk.length_cons] at hl; omega
                                  | nil =>
                                    let r : Fin 4 → C := ![r0,r1,r2,r3]
                                    let c : Fin 4 → X := ![x0,x1,x2,x3]
                                    have hs : Supported E r c := by
                                      intro i
                                      fin_cases i
                                      · exact ⟨h0,h1⟩
                                      · exact ⟨h2,h3⟩
                                      · exact ⟨h4,h5⟩
                                      · exact ⟨h6,h7⟩
                                    change TBC (polygon4 E r c hs) at ht
                                    change (bipartite E s).displacement (polygon4 E r c hs) = 0 at hz
                                    exact ⟨r,c,((polygon4_tbc E r c hs).mp ht).1,
                                      ((polygon4_tbc E r c hs).mp ht).2,hs,(polygon4_zero E s r c hs).mp hz⟩

section WordSymmetries
variable {k : ℕ} [NeZero k]

def total (s : X → C → A) (r : Fin k → C) (c : Fin k → X) : A :=
  ∑ i, (s (c i) (r i) + s (c i) (r (i+1)))

def rowAt (shift : Fin k) (rev : Bool) (i : Fin k) : Fin k :=
  if rev then shift-i else shift+i
def colAt (shift : Fin k) (rev : Bool) (i : Fin k) : Fin k :=
  if rev then shift-i-1 else shift+i

def colEquiv (shift : Fin k) (rev : Bool) : Fin k ≃ Fin k where
  toFun := colAt shift rev
  invFun := fun i => if rev then shift-i-1 else i-shift
  left_inv := by intro i; cases rev <;> dsimp [colAt] <;> abel
  right_inv := by intro i; cases rev <;> dsimp [colAt] <;> abel

theorem rowAt_step (shift : Fin k) (rev : Bool) (i : Fin k) :
    (rowAt shift rev i, rowAt shift rev (i+1)) =
      if rev then (colAt shift rev i+1, colAt shift rev i)
      else (colAt shift rev i, colAt shift rev i+1) := by
  cases rev <;> simp only [rowAt,colAt,Bool.false_eq_true,ite_false,ite_true]
  · congr 1; abel
  · congr 1 <;> abel

theorem proper_reindex {D : Type*} (r : Fin k → D) (hr : Proper r)
    (shift : Fin k) (rev : Bool) : Proper (r ∘ rowAt shift rev) := by
  intro i
  have h := rowAt_step shift rev i
  cases rev with
  | false =>
    simpa [Function.comp_def,rowAt,add_assoc] using hr (shift+i)
  | true =>
    have h0 := congrArg Prod.fst h
    have h1 := congrArg Prod.snd h
    simp only [ite_true] at h0 h1
    simpa only [Function.comp_apply,h0,h1] using (hr (colAt shift true i)).symm

theorem proper_col_reindex {D : Type*} (c : Fin k → D) (hc : Proper c)
    (shift : Fin k) (rev : Bool) : Proper (c ∘ colAt shift rev) := by
  cases rev with
  | false => exact proper_reindex c hc shift false
  | true =>
    have he : colAt shift true = rowAt (shift-1) true := by
      funext i; dsimp [colAt,rowAt]; abel
    rw [he]
    exact proper_reindex c hc (shift-1) true

theorem supported_reindex (E : X → C → Prop) (r : Fin k → C) (c : Fin k → X)
    (hs : Supported E r c) (shift : Fin k) (rev : Bool) :
    Supported E (r ∘ rowAt shift rev) (c ∘ colAt shift rev) := by
  intro i
  have h := rowAt_step shift rev i
  cases rev <;> simp only [Bool.false_eq_true,ite_false,ite_true] at h
  · have h0 := congrArg Prod.fst h
    have h1 := congrArg Prod.snd h
    dsimp only at h0 h1
    simpa only [Function.comp_apply,h0,h1] using hs (colAt shift false i)
  · have h0 := congrArg Prod.fst h
    have h1 := congrArg Prod.snd h
    dsimp only at h0 h1
    simpa only [Function.comp_apply,h0,h1] using (hs (colAt shift true i)).symm

omit [Module (ZMod 2) A] in
theorem total_reindex (s : X → C → A) (r : Fin k → C) (c : Fin k → X)
    (shift : Fin k) (rev : Bool) :
    total s (r ∘ rowAt shift rev) (c ∘ colAt shift rev) = total s r c := by
  unfold total
  calc
    _ = ∑ i, (s (c (colEquiv shift rev i)) (r (colEquiv shift rev i)) +
        s (c (colEquiv shift rev i)) (r (colEquiv shift rev i+1))) := by
      apply Finset.sum_congr rfl
      intro i _
      have h := rowAt_step shift rev i
      cases rev <;> simp only [Bool.false_eq_true,ite_false,ite_true] at h
      · have h0 := congrArg Prod.fst h
        have h1 := congrArg Prod.snd h
        dsimp only at h0 h1
        change s (c (colAt shift false i)) (r (rowAt shift false i)) +
          s (c (colAt shift false i)) (r (rowAt shift false (i+1))) = s (c (colAt shift false i)) (r (colAt shift false i)) +
          s (c (colAt shift false i)) (r (colAt shift false i+1))
        rw [h0,h1]
      · have h0 := congrArg Prod.fst h
        have h1 := congrArg Prod.snd h
        dsimp only at h0 h1
        change s (c (colAt shift true i)) (r (rowAt shift true i)) +
          s (c (colAt shift true i)) (r (rowAt shift true (i+1))) = s (c (colAt shift true i)) (r (colAt shift true i)) +
          s (c (colAt shift true i)) (r (colAt shift true i+1))
        rw [h0,h1]
        exact add_comm _ _
    _ = _ := Equiv.sum_comp (colEquiv shift rev) (fun i : Fin k => s (c i) (r i) + s (c i) (r (i+1)))

end WordSymmetries

section OrderedRows
variable {k : ℕ} [NeZero k] [LinearOrder C]

def Used (r : Fin k → Fin k) (i : Fin k) : Prop := ∃ j, r j = i
def PrefixCode (r : Fin k → Fin k) : Prop := ∀ i j, i ≤ r j → Used r i
def StrictUsed (r : Fin k → Fin k) (f : Fin k → C) : Prop :=
  ∀ i j, Used r i → Used r j → i < j → f i < f j

/-- Sort the distinct visited rows, encode by their rank, and extend the
ordered embedding arbitrarily on unused names. No bound on the array size. -/
theorem ordered_factor (r : Fin k → C) :
    ∃ code : Fin k → Fin k, ∃ f : Fin k → C,
      (∀ i, f (code i) = r i) ∧ PrefixCode code ∧ StrictUsed code f := by
  classical
  let S := Finset.univ.image r
  have hk : S.card ≤ k := by
    simpa [S] using Finset.card_image_le (s := (Finset.univ : Finset (Fin k))) (f := r)
  let e := S.orderIsoOfFin rfl
  have hm (i : Fin k) : r i ∈ S := Finset.mem_image.mpr ⟨i,Finset.mem_univ _,rfl⟩
  let code : Fin k → Fin k := fun i => Fin.castLE hk (e.symm ⟨r i,hm i⟩)
  let f : Fin k → C := fun j => if h : j.val < S.card then (e ⟨j.val,h⟩).val else r 0
  have hd (i : Fin k) : f (code i) = r i := by
    dsimp [f,code]
    split_ifs with hi
    · exact congrArg Subtype.val (e.apply_symm_apply ⟨r i,hm i⟩)
    · exact (hi (e.symm ⟨r i,hm i⟩).isLt).elim
  refine ⟨code,f,hd,?_,?_⟩
  · intro i j hij
    have hi : i.val < S.card := lt_of_le_of_lt hij (e.symm ⟨r j,hm j⟩).isLt
    obtain ⟨a,_,ha⟩ := Finset.mem_image.mp (e ⟨i.val,hi⟩).property
    refine ⟨a,Fin.ext ?_⟩
    have he : (⟨r a,hm a⟩ : S) = e ⟨i.val,hi⟩ := Subtype.ext ha
    change (e.symm ⟨r a,hm a⟩).val = i.val
    rw [he,e.symm_apply_apply]
  · rintro i j ⟨a,rfl⟩ ⟨b,rfl⟩ hab
    rw [hd,hd]
    exact e.symm.lt_iff_lt.mp hab

end OrderedRows

section CanonicalPatterns
variable {k : ℕ} [NeZero k]

def rowEquiv (shift : Fin k) (rev : Bool) : Fin k ≃ Fin k where
  toFun := rowAt shift rev
  invFun := fun i => if rev then shift-i else i-shift
  left_inv := by intro i; cases rev <;> dsimp [rowAt] <;> abel
  right_inv := by intro i; cases rev <;> dsimp [rowAt] <;> abel

theorem used_reindex (code : Fin k → Fin k) (shift : Fin k) (rev : Bool) (i : Fin k) :
    Used (code ∘ rowAt shift rev) i ↔ Used code i := by
  constructor
  · rintro ⟨j,hj⟩; exact ⟨rowAt shift rev j,hj⟩
  · rintro ⟨j,hj⟩
    refine ⟨(rowEquiv shift rev).symm j,?_⟩
    change code (rowEquiv shift rev ((rowEquiv shift rev).symm j)) = i
    rw [Equiv.apply_symm_apply,hj]

theorem prefix_reindex (code : Fin k → Fin k) (hp : PrefixCode code)
    (shift : Fin k) (rev : Bool) : PrefixCode (code ∘ rowAt shift rev) := by
  intro i j hij
  exact (used_reindex code shift rev i).mpr (hp i (rowAt shift rev j) hij)

def PrintedIndex (m : Fin 21) : Fin 21 :=
  ![0,1,2,3,4,5,6,7,8,9,10,14,11,12,13,15,16,17,18,19,20] m
def PrintedRows (m : Fin 21) : Fin 4 → Fin 4 := sourceRows (PrintedIndex m)

theorem printedIndex_bijective : Function.Bijective PrintedIndex := by decide

def LeftTriple (m : Fin 21) : Fin 3 → Fin 4 :=
  ![![0,1,0],![0,1,0],![0,1,0],![0,2,0],![0,2,0],![0,3,0],
    ![0,2,1],![0,2,1],![0,3,1],![0,1,2],![0,1,2],![0,3,2],
    ![0,1,3],![0,1,3],![0,2,3],![1,2,1],![1,2,1],![1,3,1],
    ![1,3,2],![1,2,3],![2,3,2]] m
def RightTriple (m : Fin 21) : Fin 3 → Fin 4 :=
  ![![0,1,0],![0,2,0],![0,3,0],![0,2,0],![0,3,0],![0,3,0],
    ![0,2,1],![0,3,1],![0,3,1],![0,1,2],![0,3,2],![0,3,2],
    ![0,1,3],![0,2,3],![0,2,3],![1,2,1],![1,3,1],![1,3,1],
    ![1,3,2],![1,2,3],![2,3,2]] m

theorem literal_triples_match : ∀ m : Fin 21,
    LeftTriple m = ![PrintedRows m 0,PrintedRows m 1,PrintedRows m 2] ∧
    RightTriple m = ![PrintedRows m 0,PrintedRows m 3,PrintedRows m 2] := by decide

def halfPath (s : X → C → A) (f : Fin 4 → C) (t : Fin 3 → Fin 4) (u v : X) : A :=
  s u (f (t 0)) + s u (f (t 1)) + s v (f (t 1)) + s v (f (t 2))

omit [Module (ZMod 2) A] in
theorem literal_halves_match (s : X → C → A) (f : Fin 4 → C)
    (m : Fin 21) (c : Fin 4 → X) :
    halfPath s f (LeftTriple m) (c 0) (c 1) = left4 s (f ∘ PrintedRows m) c ∧
    halfPath s f (RightTriple m) (c 3) (c 2) = right4 s (f ∘ PrintedRows m) c := by
  obtain ⟨hl,hr⟩ := literal_triples_match m
  rw [hl,hr]
  exact ⟨rfl,rfl⟩

theorem classify2 : ∀ code : Fin 2 → Fin 2, Proper code → PrefixCode code →
    ∃ shift : Fin 2, ∃ rev : Bool, ∀ i, code (rowAt shift rev i) = i := by
  unfold Proper PrefixCode Used
  decide
theorem classify3 : ∀ code : Fin 3 → Fin 3, Proper code → PrefixCode code →
    ∃ shift : Fin 3, ∃ rev : Bool, ∀ i, code (rowAt shift rev i) = i := by
  unfold Proper PrefixCode Used
  decide

theorem classify4 (code : Fin 4 → Fin 4) (hp : Proper code) :
    ∃ m : Fin 21, ∃ shift : Fin 4, ∃ rev : Bool,
      ∀ i, code (rowAt shift rev i) = PrintedRows m i := by
  obtain ⟨m,s,v,h⟩ := (source_row_patterns_complete code).mp hp
  obtain ⟨m',hm⟩ := printedIndex_bijective.surjective m
  refine ⟨m',if v then s else -s,v,fun i => ?_⟩
  rw [h]
  change sourceRows m (rowAt s v (rowAt (if v then s else -s) v i)) = sourceRows (PrintedIndex m') i
  rw [hm]
  congr 1
  cases v <;> dsimp [rowAt] <;> abel

end CanonicalPatterns



section TotalWords
variable {k : ℕ} [NeZero k]
def WordZero (E : X → C → Prop) (s : X → C → A) (k : ℕ) [NeZero k] : Prop :=
  ∃ r : Fin k → C, ∃ c : Fin k → X,
    Proper r ∧ Proper c ∧ Supported E r c ∧ total s r c = 0
end TotalWords

omit [Module (ZMod 2) A] in
theorem total2_halves (s : X → C → A) (r : Fin 2 → C) (c : Fin 2 → X) :
    total s r c = left2 s r c + right2 s r c := by
  simp [total,Fin.sum_univ_succ,left2,right2]

theorem raw2_iff_word (E : X → C → Prop) (s : X → C → A) :
    Raw2 E s ↔ WordZero E s 2 := by
  simp only [Raw2, WordZero,total2_halves,zero_pair]

theorem raw2_sound (E : X → C → Prop) (s : X → C → A) (h : Raw2 E s) :
    BoundedCycle (tannerLift E s) 4 := by
  rcases h with ⟨r,c,hr,hc,hs,hz⟩
  apply (source_tbc_complete (bipartite E s) 4).mp
  exact ⟨.inr (r 0),polygon2 E r c hs,(polygon2_tbc E r c hs).mpr ⟨hr,hc⟩,
    (polygon2_zero E s r c hs).mpr hz,by rfl⟩

omit [Module (ZMod 2) A] in
theorem total3_halves (s : X → C → A) (r : Fin 3 → C) (c : Fin 3 → X) :
    total s r c = left3 s r c + right3 s r c := by
  simp [total,Fin.sum_univ_succ,left3,right3]
  abel

theorem raw3_iff_word (E : X → C → Prop) (s : X → C → A) :
    Raw3 E s ↔ WordZero E s 3 := by
  simp only [Raw3, WordZero,total3_halves,zero_pair]

theorem raw3_sound (E : X → C → Prop) (s : X → C → A) (h : Raw3 E s) :
    BoundedCycle (tannerLift E s) 6 := by
  rcases h with ⟨r,c,hr,hc,hs,hz⟩
  apply (source_tbc_complete (bipartite E s) 6).mp
  exact ⟨.inr (r 0),polygon3 E r c hs,(polygon3_tbc E r c hs).mpr ⟨hr,hc⟩,
    (polygon3_zero E s r c hs).mpr hz,by rfl⟩

omit [Module (ZMod 2) A] in
theorem total4_halves (s : X → C → A) (r : Fin 4 → C) (c : Fin 4 → X) :
    total s r c = left4 s r c + right4 s r c := by
  simp [total,Fin.sum_univ_succ,left4,right4]
  abel

theorem raw4_iff_word (E : X → C → Prop) (s : X → C → A) :
    Raw4 E s ↔ WordZero E s 4 := by
  simp only [Raw4, WordZero,total4_halves,zero_pair]

theorem raw4_sound (E : X → C → Prop) (s : X → C → A) (h : Raw4 E s) :
    BoundedCycle (tannerLift E s) 8 := by
  rcases h with ⟨r,c,hr,hc,hs,hz⟩
  apply (source_tbc_complete (bipartite E s) 8).mp
  exact ⟨.inr (r 0),polygon4 E r c hs,(polygon4_tbc E r c hs).mpr ⟨hr,hc⟩,
    (polygon4_zero E s r c hs).mpr hz,by rfl⟩

omit [Module (ZMod 2) A] in
theorem check_root_cycle (E : X → C → Prop) (s : X → C → A) {n : ℕ}
    (h : ∃ x, ∃ q : (tannerLift E s).Walk x x, q.IsCycle ∧ q.length = n) :
    ∃ c a, ∃ q : (tannerLift E s).Walk (.inr c,a) (.inr c,a), q.IsCycle ∧ q.length = n := by
  classical
  rcases h with ⟨⟨x,a⟩,q,hq,hl⟩
  cases x with
  | inr c => exact ⟨c,a,q,hq,hl⟩
  | inl v =>
    cases q with
    | nil => exact (hq.not_nil (by simp)).elim
    | @cons _ y _ h p =>
      rcases y with ⟨y,b⟩
      cases y with
      | inl w => exact False.elim h.1
      | inr c =>
        let q := p.cons h
        have hm : (Sum.inr c,b) ∈ q.support := by simp [q]
        refine ⟨c,b,q.rotate (.inr c,b) hm,hq.rotate hm,?_⟩
        simpa [q] using hl

theorem raw2_complete (E : X → C → Prop) (s : X → C → A)
    (h : ∃ x, ∃ q : (tannerLift E s).Walk x x, q.IsCycle ∧ q.length = 4) : Raw2 E s := by
  obtain ⟨c,a,q,hq,hl⟩ := check_root_cycle E s h
  apply raw2_of_base E s c (q.map (bipartite E s).projection)
  · exact (tbc_project_iff _ q).mpr (cycle_tbc q hq)
  · exact ((bipartite E s).closed_lift_projects_iff _ a).mp ⟨q,rfl⟩
  · exact (SimpleGraph.Walk.length_map _ q).trans hl

theorem raw3_complete (E : X → C → Prop) (s : X → C → A)
    (h : ∃ x, ∃ q : (tannerLift E s).Walk x x, q.IsCycle ∧ q.length = 6) : Raw3 E s := by
  obtain ⟨c,a,q,hq,hl⟩ := check_root_cycle E s h
  apply raw3_of_base E s c (q.map (bipartite E s).projection)
  · exact (tbc_project_iff _ q).mpr (cycle_tbc q hq)
  · exact ((bipartite E s).closed_lift_projects_iff _ a).mp ⟨q,rfl⟩
  · exact (SimpleGraph.Walk.length_map _ q).trans hl

theorem raw4_complete (E : X → C → Prop) (s : X → C → A)
    (h : ∃ x, ∃ q : (tannerLift E s).Walk x x, q.IsCycle ∧ q.length = 8) : Raw4 E s := by
  obtain ⟨c,a,q,hq,hl⟩ := check_root_cycle E s h
  apply raw4_of_base E s c (q.map (bipartite E s).projection)
  · exact (tbc_project_iff _ q).mpr (cycle_tbc q hq)
  · exact ((bipartite E s).closed_lift_projects_iff _ a).mp ⟨q,rfl⟩
  · exact (SimpleGraph.Walk.length_map _ q).trans hl

theorem raw_cumulative_complete (E : X → C → Prop) (s : X → C → A) (g : ℕ)
    (hg : g = 4 ∨ g = 6 ∨ g = 8) :
    ((4 ≤ g ∧ Raw2 E s) ∨ (6 ≤ g ∧ Raw3 E s) ∨ (8 ≤ g ∧ Raw4 E s)) ↔
      BoundedCycle (tannerLift E s) g := by
  constructor
  · rintro (⟨hl,h⟩ | ⟨hl,h⟩ | ⟨hl,h⟩)
    · obtain ⟨x,q,hq,hg⟩ := raw2_sound E s h
      exact ⟨x,q,hq,hg.trans hl⟩
    · obtain ⟨x,q,hq,hg⟩ := raw3_sound E s h
      exact ⟨x,q,hq,hg.trans hl⟩
    · obtain ⟨x,q,hq,hg⟩ := raw4_sound E s h
      exact ⟨x,q,hq,hg.trans hl⟩
  · rintro ⟨x,q,hq,hl⟩
    have he : Even q.length := ((tannerColoring E s).even_length_iff_congr q).mpr Iff.rfl
    have hmin := hq.three_le_length
    have hlen : q.length = 4 ∨ q.length = 6 ∨ q.length = 8 := by
      rcases he with ⟨k,hk⟩
      rcases hg with rfl | rfl | rfl <;> omega
    rcases hlen with h4 | h6 | h8
    · exact Or.inl ⟨by omega,raw2_complete E s ⟨x,q,hq,h4⟩⟩
    · exact Or.inr (Or.inl ⟨by omega,raw3_complete E s ⟨x,q,hq,h6⟩⟩)
    · exact Or.inr (Or.inr ⟨by omega,raw4_complete E s ⟨x,q,hq,h8⟩⟩)



section OptimizedEnumeration
variable {k n : ℕ} [NeZero k] [LinearOrder C]

def Optimized (E : X → C → Prop) (s : X → C → A) (t : Fin n → Fin k → Fin k) : Prop :=
  ∃ m : Fin n, ∃ f : Fin k → C, ∃ c : Fin k → X,
    PrefixCode (t m) ∧ StrictUsed (t m) f ∧ Proper (f ∘ t m) ∧ Proper c ∧
    Supported E (f ∘ t m) c ∧ total s (f ∘ t m) c = 0

omit [Module (ZMod 2) A] in
theorem optimized_complete (E : X → C → Prop) (s : X → C → A)
    (t : Fin n → Fin k → Fin k)
    (hclass : ∀ code : Fin k → Fin k, Proper code → PrefixCode code →
      ∃ m shift rev, ∀ i, code (rowAt shift rev i) = t m i) :
    Optimized E s t ↔ WordZero E s k := by
  constructor
  · rintro ⟨m,f,c,_,_,hr,hc,hs,hz⟩
    exact ⟨f ∘ t m,c,hr,hc,hs,hz⟩
  · rintro ⟨r,c,hr,hc,hs,hz⟩
    obtain ⟨code,f,hd,hpre,hstrict⟩ := ordered_factor r
    have hpc : Proper code := by
      intro i he
      apply hr i
      rw [← hd i, ← hd (i+1),he]
    obtain ⟨m,shift,rev,hm⟩ := hclass code hpc hpre
    have hcode : code ∘ rowAt shift rev = t m := funext hm
    have hrow : f ∘ t m = r ∘ rowAt shift rev := by
      funext i
      dsimp only [Function.comp_apply]
      rw [← hm i,hd]
    refine ⟨m,f,c ∘ colAt shift rev,?_,?_,?_,proper_col_reindex c hc shift rev,?_,?_⟩
    · rw [← hcode]
      exact prefix_reindex code hpre shift rev
    · rw [← hcode]
      intro i j hi hj hij
      exact hstrict i j ((used_reindex code shift rev i).mp hi)
        ((used_reindex code shift rev j).mp hj) hij
    · rw [hrow]
      exact proper_reindex r hr shift rev
    · rw [hrow]
      exact supported_reindex E r c hs shift rev
    · rw [hrow,total_reindex,hz]

def HalfEnumeration (E : X → C → Prop) (t : Fin n → Fin k → Fin k)
    (collision : Fin n → (Fin k → C) → (Fin k → X) → Prop) : Prop :=
  ∃ m : Fin n, ∃ f : Fin k → C, ∃ c : Fin k → X,
    PrefixCode (t m) ∧ StrictUsed (t m) f ∧ Proper (f ∘ t m) ∧ Proper c ∧
    Supported E (f ∘ t m) c ∧ collision m f c

omit [Module (ZMod 2) A] in
theorem halfEnumeration_iff (E : X → C → Prop) (s : X → C → A)
    (t : Fin n → Fin k → Fin k)
    (collision : Fin n → (Fin k → C) → (Fin k → X) → Prop)
    (he : ∀ m f c, collision m f c ↔ total s (f ∘ t m) c = 0) :
    HalfEnumeration E t collision ↔ Optimized E s t := by
  simp only [HalfEnumeration,Optimized,he]

def Enum2 (E : X → C → Prop) (s : X → C → A) : Prop :=
  HalfEnumeration E (fun _ : Fin 1 => id) (fun _ f c => left2 s f c = right2 s f c)
def Enum3 (E : X → C → Prop) (s : X → C → A) : Prop :=
  HalfEnumeration E (fun _ : Fin 1 => (id : Fin 3 → Fin 3)) (fun _ f c =>
    s (c 0) (f 0) + s (c 0) (f 1) + s (c 1) (f 1) =
    s (c 2) (f 0) + s (c 2) (f 2) + s (c 1) (f 2))
def Enum4 (E : X → C → Prop) (s : X → C → A) : Prop :=
  HalfEnumeration E PrintedRows (fun m f c =>
    halfPath s f (LeftTriple m) (c 0) (c 1) = halfPath s f (RightTriple m) (c 3) (c 2))

theorem enum2_complete (E : X → C → Prop) (s : X → C → A) : Enum2 E s ↔ Raw2 E s := by
  rw [raw2_iff_word]
  unfold Enum2
  rw [halfEnumeration_iff E s _ _ (by
    intro m f c
    simp only [total2_halves,zero_pair,Function.comp_id])]
  apply optimized_complete
  intro code hp hpre
  obtain ⟨shift,rev,h⟩ := classify2 code hp hpre
  exact ⟨0,shift,rev,h⟩

theorem enum3_complete (E : X → C → Prop) (s : X → C → A) : Enum3 E s ↔ Raw3 E s := by
  rw [raw3_iff_word]
  unfold Enum3
  rw [halfEnumeration_iff E s _ _ (by
    intro m f c
    rw [total3_halves,zero_pair]
    dsimp only [Function.comp_id,left3,right3]
    have he : s (c 2) (f 0) + s (c 2) (f 2) + s (c 1) (f 2) =
        s (c 1) (f 2) + s (c 2) (f 2) + s (c 2) (f 0) := by abel
    rw [he])]
  apply optimized_complete
  intro code hp hpre
  obtain ⟨shift,rev,h⟩ := classify3 code hp hpre
  exact ⟨0,shift,rev,h⟩

theorem enum4_complete (E : X → C → Prop) (s : X → C → A) : Enum4 E s ↔ Raw4 E s := by
  rw [raw4_iff_word]
  unfold Enum4
  rw [halfEnumeration_iff E s _ _ (by
    intro m f c
    obtain ⟨hl,hr⟩ := literal_halves_match s f m c
    rw [hl,hr,total4_halves,zero_pair])]
  apply optimized_complete
  intro code hp _
  exact classify4 code hp

end OptimizedEnumeration

section AppendixChecker
variable [LinearOrder C]

theorem paper_columns4_iff (c : Fin 4 → X) :
    (c 0 ≠ c 1 ∧ c 3 ≠ c 2 ∧ c 0 ≠ c 3 ∧ c 1 ≠ c 2) ↔ Proper c := by
  simp [Proper,Fin.forall_fin_succ,eq_comm,and_assoc,and_comm]
  aesop

def AppendixCondition (E : X → C → Prop) (s : X → C → A) (g : ℕ) : Prop :=
  (4 ≤ g ∧ Enum2 E s) ∨ (6 ≤ g ∧ Enum3 E s) ∨ (8 ≤ g ∧ Enum4 E s)

theorem appendix_complete (E : X → C → Prop) (s : X → C → A) (g : ℕ)
    (hg : g = 4 ∨ g = 6 ∨ g = 8) :
    AppendixCondition E s g ↔ BoundedCycle (tannerLift E s) g := by
  unfold AppendixCondition
  rw [enum2_complete,enum3_complete,enum4_complete]
  exact raw_cumulative_complete E s g hg

variable [Fintype X] [Fintype C] [DecidableEq X] [DecidableEq A]

instance halfEnumerationDecidable {k n : ℕ} [NeZero k]
    (E : X → C → Prop) [DecidableRel E] (t : Fin n → Fin k → Fin k)
    (collision : Fin n → (Fin k → C) → (Fin k → X) → Prop)
    [∀ m f c, Decidable (collision m f c)] : Decidable (HalfEnumeration E t collision) := by
  unfold HalfEnumeration
  refine @Fintype.decidableExistsFintype (Fin n) _ (fun m => ?_) inferInstance
  refine @Fintype.decidableExistsFintype (Fin k → C) _ (fun f => ?_) inferInstance
  refine @Fintype.decidableExistsFintype (Fin k → X) _ (fun c => ?_) inferInstance
  unfold PrefixCode StrictUsed Used Proper Supported
  infer_instance

instance appendixConditionDecidable (E : X → C → Prop) [DecidableRel E]
    (s : X → C → A) (g : ℕ) : Decidable (AppendixCondition E s g) := by
  unfold AppendixCondition Enum2 Enum3 Enum4
  infer_instance

/-- Literal finite appendix enumeration: one rectangle class, one hexagon
class, and the 21 printed eight-step classes with their 42 half-path sums.
Only ordered embeddings of used row names and occupied blocks are accepted.
There is no base-walk enumeration or simple-cycle oracle in this checker. -/
def appendixCheck (E : X → C → Prop) [DecidableRel E] (s : X → C → A) (g : ℕ) : Bool :=
  decide (AppendixCondition E s g)

theorem appendixCheck_spec (E : X → C → Prop) [DecidableRel E] (s : X → C → A) (g : ℕ)
    (hg : g = 4 ∨ g = 6 ∨ g = 8) :
    appendixCheck E s g = true ↔ BoundedCycle (tannerLift E s) g := by
  rw [appendixCheck,decide_eq_true_eq]
  exact appendix_complete E s g hg

def appendixForbiddenCheck (B : X × C → Option A) (slot : X × C) (g : ℕ) (a : A) : Bool := by
  letI : DecidableRel (active (filled B slot a)) := fun v c => by
    unfold active
    infer_instance
  exact appendixCheck (active (filled B slot a)) (label (filled B slot a)) g

theorem appendixForbiddenCheck_spec (B : X × C → Option A) (slot : X × C) (g : ℕ) (a : A)
    (hg : g = 4 ∨ g = 6 ∨ g = 8) :
    appendixForbiddenCheck B slot g a = true ↔
    BoundedCycle (matrixTanner (binaryExpansion (active (filled B slot a))
      (label (filled B slot a)))) g := by
  unfold appendixForbiddenCheck
  let : DecidableRel (active (filled B slot a)) := fun v c => by
    unfold active
    infer_instance
  rw [appendixCheck_spec _ _ _ hg,lift_eq_binaryTanner]

/-- Full source-specific enumeration correspondence, at arbitrary finite
array dimensions and fiber dimensions, including missing/preexisting blocks. -/
theorem appendixForbiddenCheck_eq (B : X × C → Option A) (slot : X × C) (g : ℕ) (a : A)
    (hg : g = 4 ∨ g = 6 ∨ g = 8) :
    appendixForbiddenCheck B slot g a = forbiddenCheck B slot g a := by
  apply Bool.eq_iff_iff.mpr
  rw [appendixForbiddenCheck_spec _ _ _ _ hg,forbiddenCheck_spec]

theorem appendix_dyadic_six_eight (ell : ℕ)
    (B : X × C → Option (Fin ell → ZMod 2)) (slot : X × C) (a : Fin ell → ZMod 2) :
    appendixForbiddenCheck B slot 6 a = forbiddenCheck B slot 6 a ∧
    appendixForbiddenCheck B slot 8 a = forbiddenCheck B slot 8 a := by
  exact ⟨appendixForbiddenCheck_eq B slot 6 a (by omega),
    appendixForbiddenCheck_eq B slot 8 a (by omega)⟩

end AppendixChecker

#print axioms zero_pair
#print axioms polygon2_zero
#print axioms polygon3_zero
#print axioms polygon4_zero
#print axioms polygon2_tbc
#print axioms polygon3_tbc
#print axioms polygon4_tbc
#print axioms raw2_of_base
#print axioms raw3_of_base
#print axioms raw4_of_base
#print axioms rowAt_step
#print axioms proper_reindex
#print axioms proper_col_reindex
#print axioms supported_reindex
#print axioms total_reindex
#print axioms ordered_factor
#print axioms used_reindex
#print axioms prefix_reindex
#print axioms printedIndex_bijective
#print axioms literal_triples_match
#print axioms literal_halves_match
#print axioms classify2
#print axioms classify3
#print axioms classify4
#print axioms total2_halves
#print axioms raw2_iff_word
#print axioms raw2_sound
#print axioms total3_halves
#print axioms raw3_iff_word
#print axioms raw3_sound
#print axioms total4_halves
#print axioms raw4_iff_word
#print axioms raw4_sound
#print axioms check_root_cycle
#print axioms raw2_complete
#print axioms raw3_complete
#print axioms raw4_complete
#print axioms raw_cumulative_complete
#print axioms optimized_complete
#print axioms halfEnumeration_iff
#print axioms enum2_complete
#print axioms enum3_complete
#print axioms enum4_complete
#print axioms paper_columns4_iff
#print axioms appendix_complete
#print axioms appendixCheck_spec
#print axioms appendixForbiddenCheck_spec
#print axioms appendixForbiddenCheck_eq
#print axioms appendix_dyadic_six_eight

end DyadicForbidden.Appendix
