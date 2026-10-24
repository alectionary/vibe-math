import StructuredKernel
import Mathlib.Tactic.Abel

set_option maxHeartbeats 0
namespace OrientedKernel
open CyclicRecurrence StructuredKernel
open scoped BigOperators

theorem third_eq : ∀ a b c : F, a+b+c=0 ↔ c=a+b := by decide

variable (N : ℕ) [NeZero N]
def reverse (f : ZMod N → F) : ZMod N → F := fun t => f (-t)
def MinusCondition (f : ZMod N → F) : Prop :=
  ∀ t, f t+f (t-1)+f (t-3)=0

theorem minus_iff_reverse (f : ZMod N → F) :
    MinusCondition N f ↔ ScalarCondition N (reverse N f) := by
  constructor
  · intro hf t
    have h := (third_eq _ _ _).mp (hf (-t))
    simpa only [reverse,neg_add,sub_eq_add_neg] using h
  · intro hf t
    apply (third_eq _ _ _).mpr
    have h := hf (-t)
    simpa only [reverse,neg_add,neg_neg,sub_eq_add_neg] using h

def orient (e : Bool) (f : ZMod N → F) : ZMod N → F :=
  if e then f else reverse N f

theorem orient_involutive (e : Bool) (f : ZMod N → F) :
    orient N e (orient N e f)=f := by
  cases e <;> funext t <;> simp [orient,reverse]

def OrientedCondition (e : Bool) (f : ZMod N → F) : Prop :=
  if e then ScalarCondition N f else MinusCondition N f

theorem oriented_iff (e : Bool) (f : ZMod N → F) :
    OrientedCondition N e f ↔ ScalarCondition N (orient N e f) := by
  cases e
  · exact minus_iff_reverse N f
  · rfl

theorem translate_zero (h7 : 7∣N) (f : ZMod N → F) (hf : ScalarCondition N f)
    (z t : ZMod N) (hz : ZMod.castHom h7 (ZMod 7) z=0) : f (t+z)=f t := by
  let a : Fin 3 → F := fun i => f (i.val : ZMod N)
  have he := kernel_unique N h7 f hf
  calc
    f (t+z)=pattern a ((ZMod.castHom h7 (ZMod 7)) (t+z)) := congrFun he _
    _=pattern a ((ZMod.castHom h7 (ZMod 7)) t) := by rw [map_add,hz,add_zero]
    _=f t := (congrFun he t).symm

theorem oriented_translate_zero (h7 : 7∣N) (e : Bool) (f : ZMod N → F)
    (hf : OrientedCondition N e f)
    (z t : ZMod N) (hz : ZMod.castHom h7 (ZMod 7) z=0) : f (t+z)=f t := by
  cases e
  · have hg := (oriented_iff N false f).mp hf
    have hz' : ZMod.castHom h7 (ZMod 7) (-z)=0 := by rw [map_neg,hz,neg_zero]
    have ht := translate_zero N h7 (reverse N f) hg (-z) (-t) hz'
    simpa only [reverse,neg_add,neg_neg] using ht
  · exact translate_zero N h7 f hf z t hz

variable {m n : Type*} [Fintype m] [Fintype n] [DecidableEq m] [DecidableEq n]

def Twisted (B : Matrix m n F) (z : m → n → ZMod N) (e : Bool)
    (f : n → ZMod N → F) : Prop :=
  (∀ v, OrientedCondition N e (f v)) ∧
  ∀ t c, ∑ v, B c v*f v (t+z c v)=0

def orientRows (e : Bool) (f : n → ZMod N → F) : n → ZMod N → F :=
  fun v => orient N e (f v)

theorem twisted_iff (h7 : 7∣N) (B : Matrix m n F) (z : m → n → ZMod N)
    (hz : ∀ c v, ZMod.castHom h7 (ZMod 7) (z c v)=0)
    (e : Bool) (f : n → ZMod N → F) :
    Twisted N B z e f ↔ Condition N B (orientRows N e f) := by
  have hs (hf : ∀ v, OrientedCondition N e (f v)) : ∀ t c,
      (∑ v, B c v*f v (t+z c v))=∑ v, B c v*f v t := by
    intro t c
    apply Finset.sum_congr rfl
    intro v _
    rw [oriented_translate_zero N h7 e (f v) (hf v) _ _ (hz c v)]
  constructor
  · rintro ⟨hf,he⟩
    refine ⟨fun v => (oriented_iff N e (f v)).mp (hf v),?_⟩
    intro t c
    cases e with
    | true => simpa only [orientRows,orient,↓reduceIte] using (hs hf t c) ▸ he t c
    | false => simpa only [orientRows,orient,↓reduceIte,reverse] using
        (hs hf (-t) c) ▸ he (-t) c
  · rintro ⟨hf,he⟩
    have hf' : ∀ v, OrientedCondition N e (f v) :=
      fun v => (oriented_iff N e (f v)).mpr (hf v)
    refine ⟨hf',?_⟩
    intro t c
    rw [hs hf']
    cases e with
    | true => simpa only [orientRows,orient,↓reduceIte] using he t c
    | false => simpa [orientRows,orient,reverse] using he (-t) c

noncomputable def equivalence (h7 : 7∣N) (B : Matrix m n F) (z : m → n → ZMod N)
    (hz : ∀ c v, ZMod.castHom h7 (ZMod 7) (z c v)=0) (e : Bool) :
    {f : n → ZMod N → F // Twisted N B z e f} ≃
      {f : n → ZMod N → F // Condition N B f} where
  toFun f := ⟨orientRows N e f.val,(twisted_iff N h7 B z hz e f.val).mp f.prop⟩
  invFun g := ⟨orientRows N e g.val,by
    apply (twisted_iff N h7 B z hz e _).mpr
    have hi : orientRows N e (orientRows N e g.val)=g.val := by
      funext v; exact orient_involutive N e (g.val v)
    rw [hi]
    exact g.prop⟩
  left_inv f := Subtype.ext (by funext v; exact orient_involutive N e (f.val v))
  right_inv g := Subtype.ext (by funext v; exact orient_involutive N e (g.val v))

theorem kernel_card (h7 : 7∣N) (B : Matrix m n F) (z : m → n → ZMod N)
    (hz : ∀ c v, ZMod.castHom h7 (ZMod 7) (z c v)=0) (e : Bool) :
    Nat.card {f : n → ZMod N → F // Twisted N B z e f}=
      (Nat.card {x : n → F // BaseCondition B x})^3 := by
  rw [Nat.card_congr (equivalence N h7 B z hz e),StructuredKernel.kernel_card N h7 B]

#print axioms minus_iff_reverse
#print axioms oriented_translate_zero
#print axioms equivalence
#print axioms kernel_card
end OrientedKernel
