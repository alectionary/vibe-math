import ClassicalTransport
import EntryTestTransport
import GaugeWeight
import SpanCoefficients
import BucketCounts
set_option maxHeartbeats 0
namespace TruncatedDistance
open FamilyWords
variable {L : ℕ} [NeZero L]

def permU (u : Fin 4 → Fin 4 → ZMod L → ZMod 2) (c : Equiv.Perm (Fin 4))
    (j k : Fin 4) (s : ZMod L) := u (c j) (c k) s
def permV (v : Fin 3 → Fin 3 → ZMod L → ZMod 2) (r : Equiv.Perm (Fin 3))
    (l i : Fin 3) (s : ZMod L) := v (r l) (r i) s

theorem perm_left_count (u : Fin 4 → Fin 4 → ZMod L → ZMod 2)
    (c : Equiv.Perm (Fin 4)) (j : Fin 4) : leftCount (permU u c) j=leftCount u (c j) := by
  unfold leftCount
  exact Finset.card_equiv (Equiv.prodCongr c (Equiv.refl _))
    (fun q => by simp [CoverWeight.support,permU])

theorem perm_right_count (v : Fin 3 → Fin 3 → ZMod L → ZMod 2)
    (r : Equiv.Perm (Fin 3)) (i : Fin 3) : rightCount (permV v r) i=rightCount v (r i) := by
  unfold rightCount
  exact Finset.card_equiv (Equiv.prodCongr r (Equiv.refl _))
    (fun q => by simp [CoverWeight.support,permV])

def fiberShift {A : Type*} (f : A → ZMod L) : (A × ZMod L) ≃ (A × ZMod L) where
  toFun q := (q.1,q.2+f q.1)
  invFun q := (q.1,q.2-f q.1)
  left_inv := by rintro ⟨a,s⟩;simp
  right_inv := by rintro ⟨a,s⟩;simp

theorem gauge_left_count (u : Fin 4 → Fin 4 → ZMod L → ZMod 2)
    (c : Fin 4 → ZMod L) (j : Fin 4) : leftCount (gaugeU u c) j=leftCount u j := by
  unfold leftCount
  exact Finset.card_equiv (fiberShift (fun k => c j+c k))
    (fun q => by simp [CoverWeight.support,gaugeU,fiberShift,add_assoc])

theorem gauge_right_count (v : Fin 3 → Fin 3 → ZMod L → ZMod 2)
    (r : Fin 3 → ZMod L) (i : Fin 3) : rightCount (gaugeV v r) i=rightCount v i := by
  unfold rightCount
  exact Finset.card_equiv (fiberShift (fun l => -r l-r i))
    (fun q => by simp [CoverWeight.support,gaugeV,fiberShift,sub_eq_add_neg,add_assoc])

theorem perm_source_join (r : Equiv.Perm (Fin 3)) (c : Equiv.Perm (Fin 4))
    (u : Fin 4 → Fin 4 → ZMod L → ZMod 2)
    (v : Fin 3 → Fin 3 → ZMod L → ZMod 2) :
    GeneralLP.join (permU u c) (permV v r)=fun q => GeneralLP.join u v (permQubit r c q) := by
  funext q
  cases q <;> rfl

theorem perm_source_kernel (e : Fin 3 → Fin 4 → ZMod L)
    (r : Equiv.Perm (Fin 3)) (c : Equiv.Perm (Fin 4))
    (u : Fin 4 → Fin 4 → ZMod L → ZMod 2)
    (v : Fin 3 → Fin 3 → ZMod L → ZMod 2)
    (hk : ∀ a,(∑ q,GeneralLP.HZ e a q*GeneralLP.join u v q)=0) :
    ∀ a,(∑ q,GeneralLP.HZ (permE e r c) a q*GeneralLP.join (permU u c) (permV v r) q)=0 := by
  rw [perm_source_join]
  exact (perm_z_kernel e r c (GeneralLP.join u v)).mpr hk

theorem perm_source_span_iff (e : Fin 3 → Fin 4 → ZMod L)
    (r : Equiv.Perm (Fin 3)) (c : Equiv.Perm (Fin 4))
    (u : Fin 4 → Fin 4 → ZMod L → ZMod 2)
    (v : Fin 3 → Fin 3 → ZMod L → ZMod 2) :
    GeneralLP.InSpanX (permE e r c) (permU u c) (permV v r) ↔ GeneralLP.InSpanX e u v := by
  change fullSpanX (permE e r c) (GeneralLP.join (permU u c) (permV v r)) ↔ fullSpanX e (GeneralLP.join u v)
  rw [perm_source_join]
  exact perm_full_span_x e r c (GeneralLP.join u v)

theorem perm_source_weight (r : Equiv.Perm (Fin 3)) (c : Equiv.Perm (Fin 4))
    (u : Fin 4 → Fin 4 → ZMod L → ZMod 2)
    (v : Fin 3 → Fin 3 → ZMod L → ZMod 2) :
    (CoverWeight.support (GeneralLP.join (permU u c) (permV v r))).card=
      (CoverWeight.support (GeneralLP.join u v)).card := by
  rw [perm_source_join]
  exact perm_weight r c (GeneralLP.join u v)

def normalRowShift (e : Fin 3 → Fin 4 → ZMod L) (i : Fin 3) := -e i 0+e 0 0
def normalColumnShift (e : Fin 3 → Fin 4 → ZMod L) (j : Fin 4) := -e 0 j

theorem normalize_is_gauge (e : Fin 3 → Fin 4 → ZMod L) :
    normalizeAt e 0 0=gaugeE e (normalRowShift e) (normalColumnShift e) := by
  funext i j
  unfold normalizeAt gaugeE normalRowShift normalColumnShift
  ring

theorem gauge_source_kernel (e : Fin 3 → Fin 4 → ZMod L)
    (r : Fin 3 → ZMod L) (c : Fin 4 → ZMod L)
    (u : Fin 4 → Fin 4 → ZMod L → ZMod 2)
    (v : Fin 3 → Fin 3 → ZMod L → ZMod 2)
    (hk : ∀ a,(∑ q,GeneralLP.HZ e a q*GeneralLP.join u v q)=0) :
    ∀ a,(∑ q,GeneralLP.HZ (gaugeE e r c) a q*GeneralLP.join (gaugeU u c) (gaugeV v r) q)=0 := by
  rintro ⟨⟨j,i⟩,t⟩
  rw [GeneralLP.z_action,gauge_syndrome]
  exact (GeneralLP.z_action e u v j i (t-r i+c j)).symm.trans (hk ((j,i),t-r i+c j))

#print axioms perm_source_kernel
#print axioms perm_source_span_iff
#print axioms gauge_left_count
#print axioms gauge_right_count
#print axioms gauge_source_kernel
end TruncatedDistance
