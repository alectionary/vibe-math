import FamilyTheorem
set_option maxHeartbeats 0
namespace ClassicalUpper20
variable {L : Nat} [NeZero L]
open FamilyWords
open scoped Matrix CharTwo

def word (v : Fin 4 × ZMod L) : ZMod 2 :=
  ![delta 4 v.2+delta 5 v.2+delta 7 v.2+delta 8 v.2+delta 9 v.2+delta 11 v.2,
    delta 2 v.2+delta 3 v.2+delta 6 v.2+delta 7 v.2+delta 8 v.2+delta 11 v.2,
    delta 0 v.2+delta 2 v.2+delta 3 v.2+delta 6 v.2,
    delta 0 v.2+delta 4 v.2+delta 5 v.2+delta 9 v.2] v.1

theorem kernel : CyclicCover.Kernel DistanceFamily.liftE (word (L := L)) := by
  rintro ⟨i,t⟩
  fin_cases i <;>
    norm_num [CyclicCover.boundary,DistanceFamily.liftE,FamilyWords.exponent,word,
      Fin.sum_univ_succ,delta_sub,add_comm,add_left_comm,add_assoc]

theorem nonzero (hL : 11 ∣ L) : word (L := L)≠0 := by
  let p : ZMod L →+* ZMod 11 := ZMod.castHom hL (ZMod 11)
  have h2 : (2 : ZMod L)≠0 := by
    intro h
    have hh : (2 : ZMod 11)=0 := by simpa only [map_ofNat,map_zero] using congrArg p h
    exact (by decide : (2 : ZMod 11)≠0) hh
  have h3 : (3 : ZMod L)≠0 := by
    intro h
    have hh : (3 : ZMod 11)=0 := by simpa only [map_ofNat,map_zero] using congrArg p h
    exact (by decide : (3 : ZMod 11)≠0) hh
  have h6 : (6 : ZMod L)≠0 := by
    intro h
    have hh : (6 : ZMod 11)=0 := by simpa only [map_ofNat,map_zero] using congrArg p h
    exact (by decide : (6 : ZMod 11)≠0) hh
  have he : word ((2 : Fin 4),(0 : ZMod L))=1 := by
    simp [word,delta,h2,h3,h6,h2.symm,h3.symm,h6.symm]
  intro h
  have hh:=congrFun h ((2 : Fin 4),(0 : ZMod L))
  rw [he] at hh
  exact one_ne_zero hh

def supportList : List (Fin 4 × ZMod L) :=
  [(0,4),(0,5),(0,7),(0,8),(0,9),(0,11),
   (1,2),(1,3),(1,6),(1,7),(1,8),(1,11),
   (2,0),(2,2),(2,3),(2,6),(3,0),(3,4),(3,5),(3,9)]

theorem zero_outside (v : Fin 4 × ZMod L) (hv : v∉supportList (L := L)) : word v=0 := by
  rcases v with ⟨i,s⟩
  fin_cases i <;> simp_all [word,supportList,delta]

theorem weight_le : (CoverWeight.support (word (L := L))).card≤20 := by
  have hs : CoverWeight.support (word (L := L)) ⊆ (supportList (L := L)).toFinset := by
    intro v hv
    have hn : word v≠0 := (Finset.mem_filter.mp hv).2
    by_contra h
    have hh : v∉supportList (L := L) := by simpa using h
    exact hn (zero_outside v hh)
  have h:=Finset.card_le_card hs
  have hl:=List.toFinset_card_le (l := supportList (L := L))
  have he : (supportList (L := L)).length=20 := rfl
  omega

theorem classical_distance_upper (hL : 11 ∣ L) : DistanceFamily.classicalDistance L≤20 := by
  have h : DistanceFamily.ClassicalHasWeight L (CoverWeight.support (word (L := L))).card :=
    ⟨word,kernel,nonzero hL,rfl⟩
  exact (Nat.find_min' _ h).trans weight_le

#print axioms kernel
#print axioms nonzero
#print axioms classical_distance_upper
end ClassicalUpper20
