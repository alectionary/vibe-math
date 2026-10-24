module

public import IncidenceCover

@[expose] public section
set_option linter.unusedSimpArgs false
set_option linter.unusedSectionVars false
namespace Incidence
namespace Family
abbrev Check (n : ℕ) := ZMod 7 × ZMod n
abbrev Var (n : ℕ) := Bool × Check n

def col {n : ℕ} (v : Var n) : List (Check n) :=
  if v.1 then [(v.2.1,v.2.2), (v.2.1,v.2.2-1), (v.2.1,v.2.2-6)]
  else [(v.2.1,v.2.2+27), (v.2.1+1,v.2.2), (v.2.1+2,v.2.2+54)]

def row {n : ℕ} (c : Check n) : List (Var n) :=
  [(false,c.1,c.2-27), (false,c.1-1,c.2), (false,c.1-2,c.2-54),
   (true,c.1,c.2), (true,c.1,c.2+1), (true,c.1,c.2+6)]

def E {n : ℕ} (v : Var n) (c : Check n) : Prop := c ∈ col v
instance {n : ℕ} : DecidableRel (@E n) := fun _ _ => inferInstanceAs (Decidable (_ ∈ _))

def projC {n : ℕ} (h : 63 ∣ n) (c : Check n) : Incidence.Check :=
  (c.1,ZMod.castHom h (ZMod 63) c.2)
def projV {n : ℕ} (h : 63 ∣ n) (v : Var n) : Incidence.Var :=
  (v.1,projC h v.2)

lemma project_col {n : ℕ} (h : 63 ∣ n) (v : Var n) :
    (col v).map (projC h) = Incidence.col (projV h v) := by
  rcases v with ⟨b,j,f⟩
  cases b <;> simp only [col,Incidence.col,projC,projV,Bool.false_eq_true,
    ↓reduceIte,List.map_cons,List.map_nil,map_add,map_sub,map_one,map_ofNat]

lemma project_row {n : ℕ} (h : 63 ∣ n) (c : Check n) :
    (row c).map (projV h) = Incidence.row (projC h c) := by
  rcases c with ⟨j,f⟩
  simp only [row,Incidence.row,projC,projV,List.map_cons,List.map_nil,
    map_add,map_sub,map_one,map_ofNat]

lemma row_complete {n : ℕ} (v : Var n) (c : Check n) (h : E v c) : v ∈ row c := by
  rcases v with ⟨b,j,f⟩
  rcases c with ⟨i,g⟩
  cases b <;> simp only [E,col,Bool.false_eq_true,↓reduceIte,List.mem_cons,
    List.not_mem_nil,or_false,Prod.mk.injEq] at h
  · rcases h with h | h | h
    · rcases h with ⟨rfl,rfl⟩; simp [row]
    · rcases h with ⟨rfl,rfl⟩; simp [row]
    · rcases h with ⟨rfl,rfl⟩; simp [row]
  · rcases h with h | h | h
    · rcases h with ⟨rfl,rfl⟩; simp [row]
    · rcases h with ⟨rfl,rfl⟩; simp [row]
    · rcases h with ⟨rfl,rfl⟩; simp [row]

lemma maps {n : ℕ} (h : 63 ∣ n) (v : Var n) (c : Check n) (he : E v c) :
    Incidence.E (projV h v) (projC h c) := by
  have hm : projC h c ∈ (col v).map (projC h) := List.mem_map.mpr ⟨c,he,rfl⟩
  simpa only [project_col,Incidence.E] using hm

lemma lifts {n : ℕ} (h : 63 ∣ n) (v : Var n) (d : Incidence.Check)
    (he : Incidence.E (projV h v) d) : ∃ c, E v c ∧ projC h c = d := by
  change d ∈ Incidence.col (projV h v) at he
  rw [← project_col] at he
  exact List.mem_map.mp he

lemma base_row_nodup : ∀ c : Incidence.Check, (Incidence.row c).Nodup := by decide +kernel

lemma local_inj {n : ℕ} (h : 63 ∣ n) (v w : Var n) (c : Check n)
    (hv : E v c) (hw : E w c) (he : projV h v = projV h w) : v = w := by
  have hn : ((row c).map (projV h)).Nodup := by
    rw [project_row]; exact base_row_nodup _
  exact List.inj_on_of_nodup_map hn (row_complete v c hv) (row_complete w c hw) he

/-- A partner at every selected incidence is equivalent to excluding degree one. -/
lemma stopping_of_partners {V C : Type*} [DecidableEq V] [DecidableEq C]
    (E : V → C → Prop) [DecidableRel E] (S : Finset V) (hne : S.Nonempty)
    (hp : ∀ v ∈ S, ∀ c, E v c → ∃ w ∈ S, w ≠ v ∧ E w c) : Stopping E S := by
  classical
  refine ⟨hne,?_⟩
  intro c hc
  obtain ⟨v,hv⟩ := Finset.card_eq_one.mp hc
  have hvm : v ∈ S.filter (fun w => E w c) := by rw [hv]; simp
  obtain ⟨w,hw,hwv,hwc⟩ := hp v (Finset.mem_filter.mp hvm).1 c (Finset.mem_filter.mp hvm).2
  have hwm : w ∈ S.filter (fun u => E u c) := Finset.mem_filter.mpr ⟨hw,hwc⟩
  have : w = v := by simpa [hv] using hwm
  exact hwv this

def sixList {n : ℕ} : List (Var n) :=
  [(false,0,0),(false,0,-1),(false,0,-6),
   (true,0,27),(true,1,0),(true,2,54)]
def six {n : ℕ} : Finset (Var n) := sixList.toFinset

lemma project_sixList {n : ℕ} (h : 63 ∣ n) :
    (@sixList n).map (projV h) = @sixList 63 := by
  simp only [sixList,projV,projC,List.map_cons,List.map_nil,
    map_zero,map_one,map_ofNat,map_neg]

theorem six_card {n : ℕ} (h : 63 ∣ n) : (@six n).card = 6 := by
  have hm : ((@sixList n).map (projV h)).Nodup := by
    rw [project_sixList]; decide +kernel
  have hn := List.Nodup.of_map (projV h) hm
  simpa [six,sixList] using List.toFinset_card_of_nodup hn

theorem six_stopping {n : ℕ} : Stopping E (@six n) := by
  apply stopping_of_partners E six
  · exact ⟨(false,0,0),by simp [six,sixList]⟩
  intro v hv c hc
  simp only [six,sixList,List.toFinset_cons,List.toFinset_nil,
    Finset.mem_insert,Finset.mem_singleton,Finset.notMem_empty,or_false] at hv
  rcases hv with hv | hv | hv | hv | hv | hv <;> subst v
  · simp only [E,col,Bool.false_eq_true,↓reduceIte,List.mem_cons,List.not_mem_nil,or_false] at hc
    rcases hc with hc | hc | hc <;> subst c
    · refine ⟨(true,0,27),by simp [six,sixList],by simp,?_⟩
      norm_num [E,col]
    · refine ⟨(true,1,0),by simp [six,sixList],by simp,?_⟩
      norm_num [E,col]
    · refine ⟨(true,2,54),by simp [six,sixList],by simp,?_⟩
      norm_num [E,col]
  · simp only [E,col,Bool.false_eq_true,↓reduceIte,List.mem_cons,List.not_mem_nil,or_false] at hc
    rcases hc with hc | hc | hc <;> subst c
    · refine ⟨(true,0,27),by simp [six,sixList],by simp,?_⟩
      norm_num [E,col]
    · refine ⟨(true,1,0),by simp [six,sixList],by simp,?_⟩
      norm_num [E,col]
    · refine ⟨(true,2,54),by simp [six,sixList],by simp,?_⟩
      norm_num [E,col]
  · simp only [E,col,Bool.false_eq_true,↓reduceIte,List.mem_cons,List.not_mem_nil,or_false] at hc
    rcases hc with hc | hc | hc <;> subst c
    · refine ⟨(true,0,27),by simp [six,sixList],by simp,?_⟩
      norm_num [E,col]
    · refine ⟨(true,1,0),by simp [six,sixList],by simp,?_⟩
      norm_num [E,col]
    · refine ⟨(true,2,54),by simp [six,sixList],by simp,?_⟩
      norm_num [E,col]
  · simp only [E,col,Bool.false_eq_true,↓reduceIte,List.mem_cons,List.not_mem_nil,or_false] at hc
    rcases hc with hc | hc | hc <;> subst c
    · refine ⟨(false,0,0),by simp [six,sixList],by simp,?_⟩
      norm_num [E,col]
    · refine ⟨(false,0,-1),by simp [six,sixList],by simp,?_⟩
      norm_num [E,col]
    · refine ⟨(false,0,-6),by simp [six,sixList],by simp,?_⟩
      norm_num [E,col]
  · simp only [E,col,Bool.false_eq_true,↓reduceIte,List.mem_cons,List.not_mem_nil,or_false] at hc
    rcases hc with hc | hc | hc <;> subst c
    · refine ⟨(false,0,0),by simp [six,sixList],by simp,?_⟩
      norm_num [E,col]
    · refine ⟨(false,0,-1),by simp [six,sixList],by simp,?_⟩
      norm_num [E,col]
    · refine ⟨(false,0,-6),by simp [six,sixList],by simp,?_⟩
      norm_num [E,col]
  · simp only [E,col,Bool.false_eq_true,↓reduceIte,List.mem_cons,List.not_mem_nil,or_false] at hc
    rcases hc with hc | hc | hc <;> subst c
    · refine ⟨(false,0,0),by simp [six,sixList],by simp,?_⟩
      norm_num [E,col]
    · refine ⟨(false,0,-1),by simp [six,sixList],by simp,?_⟩
      norm_num [E,col]
    · refine ⟨(false,0,-6),by simp [six,sixList],by simp,?_⟩
      norm_num [E,col]

end Family
end Incidence
