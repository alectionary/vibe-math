module
public import ClassificationSearch
public import IncidenceSource
public import Incidence
@[expose] public section
set_option linter.unusedSimpArgs false
namespace Incidence.Classification
open Incidence

def rowList (c : Check) : List Var :=
  [(false,c.1,c.2), (false,c.1,c.2-1), (false,c.1,c.2-6),
   (true,c.1,c.2+27), (true,c.1+1,c.2), (true,c.1+2,c.2+54)]
def rowSupport (c : Check) : Finset Var := (rowList c).toFinset

lemma rowSupport_image (c : Check) : rowSupport c = six.image (shiftV c) := by
  simp [rowSupport,rowList,six,shiftV,add_comm,sub_eq_add_neg]

lemma rowSupport_card (c : Check) : (rowSupport c).card = 6 := by
  rw [rowSupport_image,Finset.card_image_of_injective _ (shiftV c).injective,six_card]

lemma rowSupport_stopping (c : Check) : Stopping E (rowSupport c) := by
  rw [rowSupport_image]
  exact stopping_image E (shiftV c) (shiftC c) (shift_incidence c) six six_stopping

/-- The six possible companion centers at the two normalized root variables. -/
def centers : List Check := [(0,0),(0,1),(0,6),(0,-27),(-1,0),(-2,-54)]
def good (S : List Var) : Bool :=
  (S.length == 6) && centers.any (fun c => S.all (fun v => decide (v ∈ rowList c)))

lemma good_sound (S : List Var) (hnd : S.Nodup) (h : good S = true) :
    ∃ c : Check, S.toFinset = rowSupport c := by
  simp only [good,Bool.and_eq_true,beq_iff_eq,List.any_eq_true] at h
  obtain ⟨hlen,c,hc,hs⟩ := h
  refine ⟨c,Finset.eq_of_subset_of_card_le ?_ ?_⟩
  · intro v hv
    have hmem := (List.all_eq_true.mp hs) v (List.mem_toFinset.mp hv)
    simpa [rowSupport] using hmem
  · rw [rowSupport_card,List.toFinset_card_of_nodup hnd,hlen]


end Incidence.Classification
