import GaugeTransport
import ActualIncidence
set_option maxHeartbeats 0
namespace TruncatedDistance
open FamilyWords TannerSix
variable {L : ℕ} [NeZero L]

def normalizeAt (e : Fin 3 → Fin 4 → ZMod L) (r : Fin 3) (h : Fin 4)
    (i : Fin 3) (j : Fin 4) : ZMod L := e i j-e i h-e r j+e r h

def columnForm (e : Fin 3 → Fin 4 → ZMod L) (i : Fin 3) (a b c d : Fin 4) :=
  e i a+e i b-e i c-e i d
def rowForm (e : Fin 3 → Fin 4 → ZMod L) (i j k : Fin 3) (c : Fin 4) :=
  e i c+e j c-2*e k c

@[simp] theorem normalizeAt_row (e : Fin 3 → Fin 4 → ZMod L) (r : Fin 3) (h : Fin 4) (j : Fin 4) :
    normalizeAt e r h r j=0 := by unfold normalizeAt;ring
@[simp] theorem normalizeAt_column (e : Fin 3 → Fin 4 → ZMod L) (r : Fin 3) (h : Fin 4) (i : Fin 3) :
    normalizeAt e r h i h=0 := by unfold normalizeAt;ring

theorem normalized_column_form (e : Fin 3 → Fin 4 → ZMod L) (r : Fin 3) (h : Fin 4)
    (i : Fin 3) (a b c d : Fin 4) :
    columnForm (normalizeAt e r h) i a b c d=columnForm e i a b c d-columnForm e r a b c d := by
  unfold columnForm normalizeAt
  ring

theorem normalized_row_form (e : Fin 3 → Fin 4 → ZMod L) (r : Fin 3) (h : Fin 4)
    (i j k : Fin 3) (c : Fin 4) :
    rowForm (normalizeAt e r h) i j k c=rowForm e i j k c-rowForm e i j k h := by
  unfold rowForm normalizeAt
  ring

theorem normalized_partial_row_equality (e : Fin 3 → Fin 4 → ZMod L)
    (r : Fin 3) (h : Fin 4) (i j k : Fin 3) (a b : Fin 4) :
    rowForm (normalizeAt e r h) i j k a=rowForm (normalizeAt e r h) i j k b ↔
      rowForm e i j k a=rowForm e i j k b := by
  rw [normalized_row_form,normalized_row_form]
  constructor <;> intro he <;> linear_combination he

theorem normalized_full_column_test (e : Fin 3 → Fin 4 → ZMod L)
    (h0 : ∀ c,e 0 c=0) (r : Fin 3) (h : Fin 4) (a b c d : Fin 4) :
    (∀ i,columnForm (normalizeAt e r h) i a b c d=0) ↔
      (∀ i,columnForm e i a b c d=0) := by
  have hzero : columnForm e 0 a b c d=0 := by simp [columnForm,h0]
  simp_rw [normalized_column_form]
  constructor
  · intro hn i
    have hr := hn 0
    have hi := hn i
    rw [hzero] at hr
    linear_combination hi-hr
  · intro ho i
    rw [ho i,ho r,sub_self]

theorem normalized_full_row_test (e : Fin 3 → Fin 4 → ZMod L)
    (h0 : ∀ i,e i 0=0) (r : Fin 3) (h : Fin 4) (i j k : Fin 3) :
    (∀ c,rowForm (normalizeAt e r h) i j k c=0) ↔
      (∀ c,rowForm e i j k c=0) := by
  have hzero : rowForm e i j k 0=0 := by simp [rowForm,h0]
  simp_rw [normalized_row_form]
  constructor
  · intro hn c
    have hh := hn 0
    have hc := hn c
    rw [hzero] at hh
    linear_combination hc-hh
  · intro ho c
    rw [ho c,ho h,sub_self]

def normalizationVariable (e : Fin 3 → Fin 4 → ZMod L) (r : Fin 3) :
    (Fin 4 × ZMod L) ≃ (Fin 4 × ZMod L) where
  toFun p := (p.1,p.2-e r p.1)
  invFun p := (p.1,p.2+e r p.1)
  left_inv := by rintro ⟨j,s⟩;simp
  right_inv := by rintro ⟨j,s⟩;simp

def normalizationCheck (e : Fin 3 → Fin 4 → ZMod L) (r : Fin 3) (h : Fin 4) :
    (Fin 3 × ZMod L) ≃ (Fin 3 × ZMod L) where
  toFun p := (p.1,p.2+e p.1 h-e r h)
  invFun p := (p.1,p.2-e p.1 h+e r h)
  left_inv := by rintro ⟨i,t⟩;dsimp;congr 1;ring
  right_inv := by rintro ⟨i,t⟩;dsimp;congr 1;ring

theorem normalization_incidence (e : Fin 3 → Fin 4 → ZMod L) (r : Fin 3) (h : Fin 4)
    (v : Fin 4 × ZMod L) (c : Fin 3 × ZMod L) :
    CEdge (normalizeAt e r h) v c ↔ CEdge e (normalizationVariable e r v) (normalizationCheck e r h c) := by
  change c.2=v.2+(e c.1 v.1-e c.1 h-e r v.1+e r h) ↔
    c.2+e c.1 h-e r h=v.2-e r v.1+e c.1 v.1
  constructor <;> intro he <;> linear_combination he

theorem normalization_no_four (e : Fin 3 → Fin 4 → ZMod L) (r : Fin 3) (h : Fin 4)
    (h4 : NoFour (CEdge e)) : NoFour (CEdge (normalizeAt e r h)) := by
  intro v w c d hvw hcd hvc hwc hwd hvd
  exact h4 _ _ _ _ (fun he => hvw ((normalizationVariable e r).injective he))
    (fun he => hcd ((normalizationCheck e r h).injective he))
    ((normalization_incidence e r h v c).mp hvc) ((normalization_incidence e r h w c).mp hwc)
    ((normalization_incidence e r h w d).mp hwd) ((normalization_incidence e r h v d).mp hvd)

theorem normalization_no_six (e : Fin 3 → Fin 4 → ZMod L) (r : Fin 3) (h : Fin 4)
    (h6 : NoSix (CEdge e)) : NoSix (CEdge (normalizeAt e r h)) := by
  intro v w z c d f hvw hwz hzv hcd hdf hfc hvc hwc hwd hzd hzf hvf
  exact h6 _ _ _ _ _ _
    (fun he => hvw ((normalizationVariable e r).injective he))
    (fun he => hwz ((normalizationVariable e r).injective he))
    (fun he => hzv ((normalizationVariable e r).injective he))
    (fun he => hcd ((normalizationCheck e r h).injective he))
    (fun he => hdf ((normalizationCheck e r h).injective he))
    (fun he => hfc ((normalizationCheck e r h).injective he))
    ((normalization_incidence e r h v c).mp hvc) ((normalization_incidence e r h w c).mp hwc)
    ((normalization_incidence e r h w d).mp hwd) ((normalization_incidence e r h z d).mp hzd)
    ((normalization_incidence e r h z f).mp hzf) ((normalization_incidence e r h v f).mp hvf)

#print axioms normalized_partial_row_equality
#print axioms normalized_full_column_test
#print axioms normalized_full_row_test
#print axioms normalization_no_six
end TruncatedDistance
