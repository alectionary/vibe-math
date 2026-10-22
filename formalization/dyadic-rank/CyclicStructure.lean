module

public import CyclicLift

@[expose] public section

open CyclicLift

namespace CyclicStructure

variable {V C : Type*} [DecidableEq V] [DecidableEq C] [Fintype C]
variable (E : V → C → Prop)

noncomputable def neighbors (v : V) : Finset C := by
  classical
  exact Finset.univ.filter (E v)

noncomputable def selected (S : Finset V) (c : C) : Finset V := by
  classical
  exact S.filter (fun v => E v c)

@[simp] theorem mem_neighbors (v : V) (c : C) : c ∈ neighbors E v ↔ E v c := by
  classical
  simp [neighbors]

@[simp] theorem mem_selected (S : Finset V) (v : V) (c : C) :
    v ∈ selected E S c ↔ v ∈ S ∧ E v c := by
  classical
  simp [selected]

theorem selected_subset (S : Finset V) (c : C) : selected E S c ⊆ S := by
  classical
  exact Finset.filter_subset _ _

def Stopping (S : Finset V) : Prop :=
  S.Nonempty ∧ ∀ c, (selected E S c).Nonempty → 2 ≤ (selected E S c).card

theorem check_unique (h4 : ¬HasFourCycle (bipartiteBase E))
    {v w : V} {c d : C} (hvw : v ≠ w)
    (hvc : E v c) (hwc : E w c) (hvd : E v d) (hwd : E w d) : c = d := by
  by_contra hcd
  exact h4 ⟨Sum.inl v, Sum.inr c, Sum.inl w, Sum.inr d,
    hvc, hwc, hwd, hvd, fun h => hvw (Sum.inl.inj h),
    fun h => hcd (Sum.inr.inj h)⟩

theorem variable_unique (h4 : ¬HasFourCycle (bipartiteBase E))
    {v w : V} {c d : C} (hcd : c ≠ d)
    (hvc : E v c) (hwc : E w c) (hvd : E v d) (hwd : E w d) : v = w := by
  by_contra hvw
  exact hcd (check_unique E h4 hvw hvc hwc hvd hwd)

theorem six_contradiction (h6 : ¬HasSixCycle (bipartiteBase E))
    {v w u : V} {c d e : C}
    (hvw : v ≠ w) (hwu : w ≠ u) (hvu : v ≠ u)
    (hcd : c ≠ d) (hde : d ≠ e) (hce : c ≠ e)
    (hvc : E v c) (hwc : E w c) (hwd : E w d)
    (hud : E u d) (hue : E u e) (hve : E v e) : False := by
  apply h6
  refine ⟨Sum.inl v, Sum.inr c, Sum.inl w, Sum.inr d, Sum.inl u, Sum.inr e,
    hvc, hwc, hwd, hud, hue, hve, ?_⟩
  simp [hvw, hwu, hvu, hcd, hde, hce]

theorem stopping_other (S : Finset V) (hs : Stopping E S)
    {v : V} {c : C} (hv : v ∈ S) (he : E v c) :
    ∃ w ∈ S, w ≠ v ∧ E w c := by
  classical
  have hvm : v ∈ selected E S c := (mem_selected E S v c).mpr ⟨hv, he⟩
  have hc := hs.2 c ⟨v, hvm⟩
  obtain ⟨a, ha, b, hb, hab⟩ := Finset.one_lt_card.mp (by omega : 1 < (selected E S c).card)
  by_cases hav : a = v
  · refine ⟨b, (mem_selected E S b c).mp hb |>.1, ?_, (mem_selected E S b c).mp hb |>.2⟩
    intro h; exact hab (hav.trans h.symm)
  · exact ⟨a, (mem_selected E S a c).mp ha |>.1, hav, (mem_selected E S a c).mp ha |>.2⟩

/-- Girth at least eight forces every stopping set to have at least twice
the minimum variable degree. Both the graph and stopping-set semantics
are explicit; this is not an assumed tree-bound certificate. -/
theorem stopping_card_ge_twice_degree (S : Finset V) (hs : Stopping E S)
    (h4 : ¬HasFourCycle (bipartiteBase E))
    (h6 : ¬HasSixCycle (bipartiteBase E))
    (d : ℕ) (hd : 2 ≤ d) (hdegree : ∀ v ∈ S, d ≤ (neighbors E v).card) :
    2*d ≤ S.card := by
  classical
  obtain ⟨v, hv⟩ := hs.1
  have hn := hdegree v hv
  have hnpos : (neighbors E v).Nonempty := Finset.card_pos.mp (by omega)
  obtain ⟨c0, hc0⟩ := hnpos
  have hw : ∀ c : {c // c ∈ neighbors E v}, ∃ w ∈ S, w ≠ v ∧ E w c.val := by
    intro c
    exact stopping_other E S hs hv ((mem_neighbors E v c.val).mp c.property)
  choose w hwS hwne hwE using hw
  let c0' : {c // c ∈ neighbors E v} := ⟨c0,hc0⟩
  let a := w c0'
  have haS : a ∈ S := hwS c0'
  have hav : a ≠ v := hwne c0'
  have hac0 : E a c0 := hwE c0'
  have hvc0 : E v c0 := (mem_neighbors E v c0).mp hc0
  have hz : ∀ c : {c // c ∈ (neighbors E a).erase c0}, ∃ z ∈ S, z ≠ a ∧ E z c.val := by
    intro c
    exact stopping_other E S hs haS ((mem_neighbors E a c.val).mp (Finset.mem_erase.mp c.property).2)
  choose z hzS hzne hzE using hz
  have winj : Function.Injective w := by
    intro c e h
    apply Subtype.ext
    exact check_unique E h4 (hwne c) (hwE c) ((mem_neighbors E v c.val).mp c.property)
      (h ▸ hwE e) ((mem_neighbors E v e.val).mp e.property)
  have zinj : Function.Injective z := by
    intro c e h
    apply Subtype.ext
    exact check_unique E h4 (hzne c) (hzE c)
      ((mem_neighbors E a c.val).mp (Finset.mem_erase.mp c.property).2)
      (h ▸ hzE e) ((mem_neighbors E a e.val).mp (Finset.mem_erase.mp e.property).2)
  have znv : ∀ c, z c ≠ v := by
    intro c h
    have hcne := (Finset.mem_erase.mp c.property).1
    have hvc := h ▸ hzE c
    exact hcne (check_unique E h4 hav
      ((mem_neighbors E a c.val).mp (Finset.mem_erase.mp c.property).2) hvc hac0 hvc0)
  have znw : ∀ c e, z c ≠ w e := by
    intro c e h
    have hca := (mem_neighbors E a c.val).mp (Finset.mem_erase.mp c.property).2
    have hc0ne := (Finset.mem_erase.mp c.property).1
    have hwe := (mem_neighbors E v e.val).mp e.property
    have he0 : e.val ≠ c0 := by
      intro he
      have heq : e = c0' := Subtype.ext he
      exact hzne c (h.trans (congrArg w heq))
    have hce : c.val ≠ e.val := by
      intro he
      exact hc0ne (check_unique E h4 hav hca (he ▸ hwe) hac0 hvc0)
    have hawe : a ≠ w e := by
      intro he
      exact he0 (check_unique E h4 hav (he ▸ hwE e) hwe hac0 hvc0)
    exact six_contradiction E h6 hav.symm hawe (hwne e).symm
      (Ne.symm hc0ne) hce he0.symm hvc0 hac0 hca (h ▸ hzE c) (hwE e) hwe
  let first : Finset V := (neighbors E v).attach.image w
  let second : Finset V := ((neighbors E a).erase c0).attach.image z
  have hf : first.card = (neighbors E v).card := by
    simp [first, Finset.card_image_of_injective _ winj]
  have hsnd : second.card = ((neighbors E a).erase c0).card := by
    simp [second, Finset.card_image_of_injective _ zinj]
  have hdis : Disjoint first second := by
    apply Finset.disjoint_left.mpr
    intro x hx hy
    obtain ⟨c, _, rfl⟩ := Finset.mem_image.mp hx
    obtain ⟨e, _, he⟩ := Finset.mem_image.mp hy
    exact znw e c he
  have hsub : first ∪ second ⊆ S.erase v := by
    intro x hx
    rcases Finset.mem_union.mp hx with hx | hx
    · obtain ⟨c, _, rfl⟩ := Finset.mem_image.mp hx
      exact Finset.mem_erase.mpr ⟨hwne c, hwS c⟩
    · obtain ⟨c, _, rfl⟩ := Finset.mem_image.mp hx
      exact Finset.mem_erase.mpr ⟨znv c, hzS c⟩
  have hcard := Finset.card_le_card hsub
  rw [Finset.card_union_of_disjoint hdis, hf, hsnd,
    Finset.card_erase_of_mem ((mem_neighbors E a c0).mpr hac0),
    Finset.card_erase_of_mem hv] at hcard
  have hda := hdegree a haS
  omega


noncomputable def evenNeighbors (S : Finset V) (v : V) : Finset C := by
  classical
  exact (neighbors E v).filter (fun c => (selected E S c).card % 2 = 0)

noncomputable def oddNeighbors (S : Finset V) (v : V) : Finset C :=
  neighbors E v \ evenNeighbors E S v

def Absorbing (S : Finset V) : Prop :=
  S.Nonempty ∧ ∀ v ∈ S, (oddNeighbors E S v).card < (evenNeighbors E S v).card

@[simp] theorem mem_even (S : Finset V) (v : V) (c : C) :
    c ∈ evenNeighbors E S v ↔ E v c ∧ (selected E S c).card % 2 = 0 := by
  classical
  simp [evenNeighbors]

theorem even_subset (S : Finset V) (v : V) : evenNeighbors E S v ⊆ neighbors E v := by
  classical
  exact Finset.filter_subset _ _

theorem absorbing_even_two (S : Finset V) (hs : Absorbing E S)
    (deg : ∀ v ∈ S, (neighbors E v).card = 3) {v : V} (hv : v ∈ S) :
    2 ≤ (evenNeighbors E S v).card := by
  have h := Finset.card_sdiff_add_card_eq_card (even_subset E S v)
  have hlt := hs.2 v hv
  change (neighbors E v \ evenNeighbors E S v).card < _ at hlt
  rw [deg v hv] at h
  omega

theorem even_two_distinct (S : Finset V) (hs : Absorbing E S)
    (deg : ∀ v ∈ S, (neighbors E v).card = 3) {v : V} (hv : v ∈ S) :
    ∃ c ∈ evenNeighbors E S v, ∃ d ∈ evenNeighbors E S v, c ≠ d := by
  exact Finset.one_lt_card.mp (by have := absorbing_even_two E S hs deg hv; omega)

/-- An even check in an absorbing support of size at most four has exactly two
selected neighbors: multiplicity four would prevent a second even check. -/
theorem even_check_two (S : Finset V) (hs : Absorbing E S) (hcard : S.card ≤ 4)
    (deg : ∀ v ∈ S, (neighbors E v).card = 3)
    (h4 : ¬HasFourCycle (bipartiteBase E))
    {v : V} (hv : v ∈ S) {c : C} (hc : c ∈ evenNeighbors E S v) :
    (selected E S c).card = 2 := by
  classical
  have hvc := (mem_even E S v c).mp hc
  have hpos := Finset.card_pos.mpr (show (selected E S c).Nonempty from ⟨v, by simp [hv, hvc.1]⟩)
  have hle := (Finset.card_le_card (selected_subset E S c)).trans hcard
  have cases24 : (selected E S c).card = 2 ∨ (selected E S c).card = 4 := by omega
  rcases cases24 with h | h
  · exact h
  have heq : selected E S c = S := Finset.eq_of_subset_of_card_le
    (selected_subset E S c) (by omega)
  obtain ⟨d, hd, e, he, hde⟩ := even_two_distinct E S hs deg hv
  have hex : ∃ d ∈ evenNeighbors E S v, d ≠ c := by
    by_cases hdc : d = c
    · exact ⟨e, he, fun h => hde (hdc.trans h.symm)⟩
    · exact ⟨d, hd, hdc⟩
  obtain ⟨d, hd, hdc⟩ := hex
  have hvd := (mem_even E S v d).mp hd
  have hdm : v ∈ selected E S d := by simp [hv, hvd.1]
  have hdp : 0 < (selected E S d).card := Finset.card_pos.mpr ⟨v, hdm⟩
  have hdtwo : 1 < (selected E S d).card := by omega
  obtain ⟨w, hw, hwv⟩ := Finset.exists_mem_ne hdtwo v
  have hw' := (mem_selected E S w d).mp hw
  have hwc : E w c := (mem_selected E S w c).mp (heq.symm ▸ hw'.1) |>.2
  exact False.elim (hdc (check_unique E h4 hwv hw'.2 hvd.1 hwc hvc.1))

/-- A second selected variable at an even check. -/
theorem even_other (S : Finset V) {v : V} (hv : v ∈ S) {c : C}
    (hvc : E v c) (hc : (selected E S c).card = 2) :
    ∃ w ∈ S, w ≠ v ∧ E w c := by
  classical
  obtain ⟨w, hw, hne⟩ := Finset.exists_mem_ne (show 1 < (selected E S c).card by omega) v
  exact ⟨w, (mem_selected E S w c).mp hw |>.1, hne,
    (mem_selected E S w c).mp hw |>.2⟩

/-- A selected pair at a check of multiplicity two exhausts that check. -/
theorem pair_exhausts (S : Finset V) {v w u : V} {c : C}
    (hc : (selected E S c).card = 2) (hvw : v ≠ w)
    (hv : v ∈ S) (hw : w ∈ S) (hvc : E v c) (hwc : E w c)
    (hu : u ∈ S) (huc : E u c) : u = v ∨ u = w := by
  classical
  have heq : ({v,w} : Finset V) = selected E S c := by
    apply Finset.eq_of_subset_of_card_le
    · intro x hx
      simp only [Finset.mem_insert, Finset.mem_singleton] at hx
      rcases hx with rfl | rfl <;> simp [hv, hw, hvc, hwc]
    · simpa [hvw] using hc.le
  have : u ∈ ({v,w} : Finset V) := heq.symm ▸ ((mem_selected E S u c).mpr ⟨hu,huc⟩)
  simpa using this

/-- Two consecutive shared checks cannot have an additional check between
its endpoints in a Tanner graph without four- and six-cycles. -/
theorem no_triangle (h4 : ¬HasFourCycle (bipartiteBase E))
    (h6 : ¬HasSixCycle (bipartiteBase E))
    {v w u : V} {c d e : C} (hvw : v ≠ w) (hwu : w ≠ u) (hvu : v ≠ u)
    (hcd : c ≠ d) (hvc : E v c) (hwc : E w c) (hwd : E w d)
    (hud : E u d) (hue : E u e) (hve : E v e) : False := by
  have hce : c ≠ e := by
    intro h
    exact hcd (check_unique E h4 hwu hwc (h ▸ hue) hwd hud)
  have hde : d ≠ e := by
    intro h
    exact hcd (check_unique E h4 hvw hvc hwc (h ▸ hve) hwd)
  exact six_contradiction E h6 hvw hwu hvu hcd hde hce hvc hwc hwd hud hue hve

/-- An unoriented eight-cycle is recorded by its variable and check supports,
with an explicit simple cyclic ordering as a certificate. -/
def EightCycleOn (S : Finset V) (T : Finset C) : Prop :=
  ∃ v w u z : V, ∃ c d e f : C,
    [v,w,u,z].Nodup ∧ [c,d,e,f].Nodup ∧
    S = {v,w,u,z} ∧ T = {c,d,e,f} ∧
    E v c ∧ E w c ∧ E w d ∧ E u d ∧ E u e ∧ E z e ∧ E z f ∧ E v f

/-- Every nonempty absorbing support of size at most four in a cubic
Tanner graph of girth at least eight is an eight-cycle support. -/
theorem absorbing_small_cycle (S : Finset V) (hs : Absorbing E S)
    (hcard : S.card ≤ 4) (deg : ∀ v ∈ S, (neighbors E v).card = 3)
    (h4 : ¬HasFourCycle (bipartiteBase E))
    (h6 : ¬HasSixCycle (bipartiteBase E)) :
    ∃ T, EightCycleOn E S T := by
  classical
  obtain ⟨v,hv⟩ := hs.1
  obtain ⟨c,hc,f,hf,hcf⟩ := even_two_distinct E S hs deg hv
  have hvc := ((mem_even E S v c).mp hc).1
  have hvf := ((mem_even E S v f).mp hf).1
  have hc2 := even_check_two E S hs hcard deg h4 hv hc
  have hf2 := even_check_two E S hs hcard deg h4 hv hf
  obtain ⟨w,hw,hwv,hwc⟩ := even_other E S hv hvc hc2
  obtain ⟨z,hz,hzv,hzf⟩ := even_other E S hv hvf hf2
  have hwz : w ≠ z := by
    intro h
    exact hcf (check_unique E h4 hwv hwc hvc (h ▸ hzf) hvf)
  obtain ⟨d,hd,hdc⟩ : ∃ d ∈ evenNeighbors E S w, d ≠ c := by
    obtain ⟨a,ha,b,hb,hab⟩ := even_two_distinct E S hs deg hw
    by_cases h : a = c
    · exact ⟨b,hb, fun h' => hab (h.trans h'.symm)⟩
    · exact ⟨a,ha,h⟩
  have hwd := ((mem_even E S w d).mp hd).1
  have hd2 := even_check_two E S hs hcard deg h4 hw hd
  obtain ⟨u,hu,huw,hud⟩ := even_other E S hw hwd hd2
  have huv : u ≠ v := by
    intro h
    exact hdc (check_unique E h4 hwv hwd (h ▸ hud) hwc hvc)
  have huz : u ≠ z := by
    intro h
    exact no_triangle E h4 h6 hwv.symm (huw.symm) huv.symm hdc.symm
      hvc hwc hwd hud (h ▸ hzf) hvf
  have hvars : [v,w,u,z].Nodup := by
    simp [hwv, hwv.symm, hzv, hzv.symm, hwz, huw, huw.symm, huv, huv.symm, huz, huz.symm]
  have hsub : ({v,w,u,z} : Finset V) ⊆ S := by
    intro x hx; simp only [Finset.mem_insert,Finset.mem_singleton] at hx
    rcases hx with rfl | rfl | rfl | rfl <;> assumption
  have hS : S = {v,w,u,z} := by
    apply (Finset.eq_of_subset_of_card_le hsub _).symm
    simpa [hwv,hwv.symm,hzv,hzv.symm,hwz,huw,huw.symm,huv,huv.symm,huz,huz.symm] using hcard
  obtain ⟨e,he,hef⟩ : ∃ e ∈ evenNeighbors E S z, e ≠ f := by
    obtain ⟨a,ha,b,hb,hab⟩ := even_two_distinct E S hs deg hz
    by_cases h : a = f
    · exact ⟨b,hb, fun h' => hab (h.trans h'.symm)⟩
    · exact ⟨a,ha,h⟩
  have hze := ((mem_even E S z e).mp he).1
  have he2 := even_check_two E S hs hcard deg h4 hz he
  obtain ⟨t,ht,htz,hte⟩ := even_other E S hz hze he2
  have htv : t ≠ v := by
    intro h
    exact hef (check_unique E h4 hzv hze (h ▸ hte) hzf hvf)
  have htw : t ≠ w := by
    intro h
    exact no_triangle E h4 h6 hwv hzv.symm hwz hcf hwc hvc hvf hzf hze (h ▸ hte)
  have htu : t = u := by
    rw [hS] at ht
    simp only [Finset.mem_insert,Finset.mem_singleton] at ht
    rcases ht with ht | ht | ht | ht
    · exact False.elim (htv ht)
    · exact False.elim (htw ht)
    · exact ht
    · exact False.elim (htz ht)
  have hue : E u e := htu ▸ hte
  have hdf : d ≠ f := by
    intro h
    have := pair_exhausts E S hf2 hzv.symm hv hz hvf hzf hw (h ▸ hwd)
    exact this.elim hwv hwz
  have hce : c ≠ e := by
    intro h
    have := pair_exhausts E S hc2 hwv.symm hv hw hvc hwc hz (h.symm ▸ hze)
    exact this.elim hzv hwz.symm
  have hde : d ≠ e := by
    intro h
    have := pair_exhausts E S hd2 huw.symm hw hu hwd hud hz (h.symm ▸ hze)
    exact this.elim hwz.symm huz.symm
  refine ⟨{c,d,e,f}, v,w,u,z,c,d,e,f,hvars,?_,hS,rfl,
    hvc,hwc,hwd,hud,hue,hze,hzf,hvf⟩
  simp [hdc,hdc.symm,hcf,hdf,hce,hde,hef,hef.symm]

/-- A cycle check has exactly its two cycle variables as selected neighbors. -/
theorem cycle_check_two (h4 : ¬HasFourCycle (bipartiteBase E))
    {v w u z : V} {c d f : C} (hvars : [v,w,u,z].Nodup)
    (hcd : c ≠ d) (hcf : c ≠ f)
    (hvc : E v c) (hwc : E w c) (hwd : E w d)
    (hud : E u d) (hzf : E z f) (hvf : E v f) :
    selected E {v,w,u,z} c = {v,w} := by
  classical
  have hn : v ≠ w ∧ v ≠ u ∧ v ≠ z ∧ w ≠ u ∧ w ≠ z ∧ u ≠ z := by
    simpa [and_assoc] using hvars
  ext x
  simp only [mem_selected, Finset.mem_insert, Finset.mem_singleton]
  constructor
  · rintro ⟨hx,hxc⟩
    rcases hx with rfl | rfl | rfl | rfl
    · exact Or.inl rfl
    · exact Or.inr rfl
    · exact False.elim (hcd (check_unique E h4 hn.2.2.2.1 hwc hxc hwd hud))
    · exact False.elim (hcf (check_unique E h4 hn.2.2.1 hvc hxc hvf hzf))
  · rintro (rfl | rfl)
    · exact ⟨Or.inl rfl,hvc⟩
    · exact ⟨Or.inr (Or.inl rfl),hwc⟩

theorem cycle_absorbing {S : Finset V} {T : Finset C} (hcycle : EightCycleOn E S T)
    (deg : ∀ v ∈ S, (neighbors E v).card = 3)
    (h4 : ¬HasFourCycle (bipartiteBase E)) : Absorbing E S := by
  classical
  obtain ⟨v,w,u,z,c,d,e,f,hvars,hchecks,rfl,rfl,hvc,hwc,hwd,hud,hue,hze,hzf,hvf⟩ := hcycle
  have hn : v ≠ w ∧ v ≠ u ∧ v ≠ z ∧ w ≠ u ∧ w ≠ z ∧ u ≠ z := by
    simpa [and_assoc] using hvars
  have hcne : c ≠ d ∧ c ≠ e ∧ c ≠ f ∧ d ≠ e ∧ d ≠ f ∧ e ≠ f := by
    simpa [and_assoc] using hchecks
  have hc2 := cycle_check_two E h4 hvars hcne.1 hcne.2.2.1 hvc hwc hwd hud hzf hvf
  have hd2 : selected E {v,w,u,z} d = {w,u} := by
    have := cycle_check_two E h4 (v:=w) (w:=u) (u:=z) (z:=v) (c:=d) (d:=e) (f:=c)
      (by simp_all [ne_comm]) hcne.2.2.2.1 hcne.1.symm hwd hud hue hze hvc hwc
    have hrot : ({w,u,z,v} : Finset V) = {v,w,u,z} := by
      ext x; simp only [Finset.mem_insert, Finset.mem_singleton]; tauto
    rw [hrot] at this
    exact this
  have he2 : selected E {v,w,u,z} e = {u,z} := by
    have := cycle_check_two E h4 (v:=u) (w:=z) (u:=v) (z:=w) (c:=e) (d:=f) (f:=d)
      (by simp_all [ne_comm]) hcne.2.2.2.2.2 hcne.2.2.2.1.symm hue hze hzf hvf hwd hud
    have hrot : ({u,z,v,w} : Finset V) = {v,w,u,z} := by
      ext x; simp only [Finset.mem_insert, Finset.mem_singleton]; tauto
    rw [hrot] at this
    exact this
  have hf2 : selected E {v,w,u,z} f = {z,v} := by
    have := cycle_check_two E h4 (v:=z) (w:=v) (u:=w) (z:=u) (c:=f) (d:=c) (f:=e)
      (by simp_all [ne_comm]) hcne.2.2.1.symm hcne.2.2.2.2.2.symm hzf hvf hvc hwc hue hze
    have hrot : ({z,v,w,u} : Finset V) = {v,w,u,z} := by
      ext x; simp only [Finset.mem_insert, Finset.mem_singleton]; tauto
    rw [hrot] at this
    exact this
  have htwo : ∀ x ∈ ({v,w,u,z} : Finset V), 2 ≤ (evenNeighbors E {v,w,u,z} x).card := by
    intro x hx
    have hc : (selected E {v,w,u,z} c).card % 2 = 0 := by simp [hc2, hn.1]
    have hd : (selected E {v,w,u,z} d).card % 2 = 0 := by simp [hd2, hn.2.2.2.1]
    have he : (selected E {v,w,u,z} e).card % 2 = 0 := by simp [he2, hn.2.2.2.2.2]
    have hf : (selected E {v,w,u,z} f).card % 2 = 0 := by simp [hf2, hn.2.2.1.symm]
    simp only [Finset.mem_insert, Finset.mem_singleton] at hx
    have helper {x : V} {a b : C} (hab : a ≠ b) (hxa : E x a) (hxb : E x b)
        (ha : (selected E {v,w,u,z} a).card % 2 = 0)
        (hb : (selected E {v,w,u,z} b).card % 2 = 0) :
        2 ≤ (evenNeighbors E {v,w,u,z} x).card := by
      have hsub : ({a,b} : Finset C) ⊆ evenNeighbors E {v,w,u,z} x := by
        intro t ht
        simp only [Finset.mem_insert,Finset.mem_singleton] at ht
        rcases ht with ht | ht
        · subst t; exact (mem_even E _ _ _).mpr ⟨hxa,ha⟩
        · subst t; exact (mem_even E _ _ _).mpr ⟨hxb,hb⟩
      simpa [hab] using Finset.card_le_card hsub
    rcases hx with hx | hx | hx | hx <;> subst x
    · exact helper hcne.2.2.1 hvc hvf hc hf
    · exact helper hcne.1 hwc hwd hc hd
    · exact helper hcne.2.2.2.1 hud hue hd he
    · exact helper hcne.2.2.2.2.2 hze hzf he hf
  refine ⟨⟨v, by simp⟩, ?_⟩
  intro x hx
  have hcard := Finset.card_sdiff_add_card_eq_card (even_subset E {v,w,u,z} x)
  have hd := deg x hx
  have he := htwo x hx
  change (neighbors E x \ evenNeighbors E {v,w,u,z} x).card < _
  omega

/-- In girth at least eight, a check joining two variables of an eight-cycle
must already be one of its cycle checks. Opposite pairs would close a six-cycle. -/
theorem cycle_shared_check {S : Finset V} {T : Finset C} (hc : EightCycleOn E S T)
    (h4 : ¬HasFourCycle (bipartiteBase E))
    (h6 : ¬HasSixCycle (bipartiteBase E))
    {x y : V} {a : C} (hx : x ∈ S) (hy : y ∈ S) (hxy : x ≠ y)
    (hxa : E x a) (hya : E y a) : a ∈ T := by
  classical
  obtain ⟨v,w,u,z,c,d,e,f,hvars,hchecks,rfl,rfl,hvc,hwc,hwd,hud,hue,hze,hzf,hvf⟩ := hc
  have hn : v ≠ w ∧ v ≠ u ∧ v ≠ z ∧ w ≠ u ∧ w ≠ z ∧ u ≠ z := by
    simpa [and_assoc] using hvars
  have hcne : c ≠ d ∧ c ≠ e ∧ c ≠ f ∧ d ≠ e ∧ d ≠ f ∧ e ≠ f := by
    simpa [and_assoc] using hchecks
  have hvu : ∀ a, ¬(E v a ∧ E u a) := by
    intro a ha
    exact no_triangle E h4 h6 hn.1 hn.2.2.2.1 hn.2.1 hcne.1
      hvc hwc hwd hud ha.2 ha.1
  have hwz : ∀ a, ¬(E w a ∧ E z a) := by
    intro a ha
    exact no_triangle E h4 h6 hn.2.2.2.1 hn.2.2.2.2.2 hn.2.2.2.2.1 hcne.2.2.2.1
      hwd hud hue hze ha.2 ha.1
  simp only [Finset.mem_insert,Finset.mem_singleton] at hx hy
  rcases hx with hx | hx | hx | hx <;> subst x
  · rcases hy with hy | hy | hy | hy <;> subst y
    · exact False.elim (hxy rfl)
    · have ha := check_unique E h4 hxy hxa hya hvc hwc
      simp [ha]
    · exact False.elim (hvu a ⟨hxa,hya⟩)
    · have ha := check_unique E h4 hxy hxa hya hvf hzf
      simp [ha]
  · rcases hy with hy | hy | hy | hy <;> subst y
    · have ha := check_unique E h4 hxy hxa hya hwc hvc
      simp [ha]
    · exact False.elim (hxy rfl)
    · have ha := check_unique E h4 hxy hxa hya hwd hud
      simp [ha]
    · exact False.elim (hwz a ⟨hxa,hya⟩)
  · rcases hy with hy | hy | hy | hy <;> subst y
    · exact False.elim (hvu a ⟨hya,hxa⟩)
    · have ha := check_unique E h4 hxy hxa hya hud hwd
      simp [ha]
    · exact False.elim (hxy rfl)
    · have ha := check_unique E h4 hxy hxa hya hue hze
      simp [ha]
  · rcases hy with hy | hy | hy | hy <;> subst y
    · have ha := check_unique E h4 hxy hxa hya hzf hvf
      simp [ha]
    · exact False.elim (hwz a ⟨hya,hxa⟩)
    · have ha := check_unique E h4 hxy hxa hya hze hue
      simp [ha]
    · exact False.elim (hxy rfl)

theorem cycle_checks_exact {S : Finset V} {T : Finset C} (hc : EightCycleOn E S T)
    (h4 : ¬HasFourCycle (bipartiteBase E))
    (h6 : ¬HasSixCycle (bipartiteBase E)) (a : C) :
    a ∈ T ↔ 2 ≤ (selected E S a).card := by
  classical
  constructor
  · intro ha
    obtain ⟨v,w,u,z,c,d,e,f,hvars,hchecks,rfl,rfl,hvc,hwc,hwd,hud,hue,hze,hzf,hvf⟩ := hc
    have hn : v ≠ w ∧ v ≠ u ∧ v ≠ z ∧ w ≠ u ∧ w ≠ z ∧ u ≠ z := by
      simpa [and_assoc] using hvars
    have helper {x y : V} (hxy : x ≠ y) (hx : x ∈ ({v,w,u,z} : Finset V))
        (hy : y ∈ ({v,w,u,z} : Finset V)) (hxa : E x a) (hya : E y a) :
        2 ≤ (selected E {v,w,u,z} a).card := by
      have hsub : ({x,y} : Finset V) ⊆ selected E {v,w,u,z} a := by
        intro t ht
        simp only [Finset.mem_insert,Finset.mem_singleton] at ht
        rcases ht with ht | ht <;> subst t <;> simp [hx,hy,hxa,hya]
      simpa [hxy] using Finset.card_le_card hsub
    simp only [Finset.mem_insert,Finset.mem_singleton] at ha
    rcases ha with ha | ha | ha | ha <;> subst a
    · exact helper hn.1 (by simp) (by simp) hvc hwc
    · exact helper hn.2.2.2.1 (by simp) (by simp) hwd hud
    · exact helper hn.2.2.2.2.2 (by simp) (by simp) hue hze
    · exact helper hn.2.2.1 (by simp) (by simp) hvf hzf
  · intro ha
    obtain ⟨x,hx,y,hy,hxy⟩ := Finset.one_lt_card.mp (by omega : 1 < (selected E S a).card)
    exact cycle_shared_check E hc h4 h6 ((mem_selected E S x a).mp hx).1
      ((mem_selected E S y a).mp hy).1 hxy
      ((mem_selected E S x a).mp hx).2 ((mem_selected E S y a).mp hy).2

/-- A cycle's variable support uniquely determines its check support. -/
theorem cycle_checks_unique {S : Finset V} {T U : Finset C}
    (ht : EightCycleOn E S T) (hu : EightCycleOn E S U)
    (h4 : ¬HasFourCycle (bipartiteBase E))
    (h6 : ¬HasSixCycle (bipartiteBase E)) : T = U := by
  ext a
  rw [cycle_checks_exact E ht h4 h6, cycle_checks_exact E hu h4 h6]

/-- The cycle certificate constructs an actual Mathlib simple closed walk
of length eight, rather than a separate unconnected cycle predicate. -/
theorem cycle_native {S : Finset V} {T : Finset C} (hc : EightCycleOn E S T) :
    ∃ a : V ⊕ C, ∃ p : (bipartiteBase E).Walk a a, p.IsCycle ∧ p.length = 8 := by
  obtain ⟨v,w,u,z,c,d,e,f,hvars,hchecks,_,_,hvc,hwc,hwd,hud,hue,hze,hzf,hvf⟩ := hc
  have hn : v ≠ w ∧ v ≠ u ∧ v ≠ z ∧ w ≠ u ∧ w ≠ z ∧ u ≠ z := by
    simpa [and_assoc] using hvars
  have hcne : c ≠ d ∧ c ≠ e ∧ c ≠ f ∧ d ≠ e ∧ d ≠ f ∧ e ≠ f := by
    simpa [and_assoc] using hchecks
  let p : (bipartiteBase E).Walk (.inl v) (.inl v) :=
    eightWalk (b:=.inr c) (c:=.inl w) (d:=.inr d) (e:=.inl u)
      (f:=.inr e) (g:=.inl z) (h:=.inr f) hvc hwc hwd hud hue hze hzf hvf
  refine ⟨.inl v,p,?_,rfl⟩
  rw [SimpleGraph.Walk.isCycle_iff_isPath_tail_and_le_length]
  constructor
  · simp only [SimpleGraph.Walk.isPath_def]
    change [Sum.inr c, Sum.inl w, Sum.inr d, Sum.inl u, Sum.inr e, Sum.inl z, Sum.inr f, Sum.inl v].Nodup
    simp_all [ne_comm]
  · change 3 ≤ 8; omega

/-- Exact support-level characterization, including the small-set exclusion. -/
theorem absorbing_iff_cycle (S : Finset V) (hcard : S.card ≤ 4)
    (deg : ∀ v ∈ S, (neighbors E v).card = 3)
    (h4 : ¬HasFourCycle (bipartiteBase E))
    (h6 : ¬HasSixCycle (bipartiteBase E)) :
    Absorbing E S ↔ ∃ T, EightCycleOn E S T := by
  exact ⟨fun hs => absorbing_small_cycle E S hs hcard deg h4 h6,
    fun ⟨_,ht⟩ => cycle_absorbing E ht deg h4⟩

theorem cycle_card_four {S : Finset V} {T : Finset C} (hc : EightCycleOn E S T) : S.card = 4 := by
  classical
  obtain ⟨v,w,u,z,c,d,e,f,hvars,_,rfl,_⟩ := hc
  have hn : v ≠ w ∧ v ≠ u ∧ v ≠ z ∧ w ≠ u ∧ w ≠ z ∧ u ≠ z := by
    simpa [and_assoc] using hvars
  simp [hn]

theorem absorbing_minimum_four (S : Finset V) (hs : Absorbing E S)
    (deg : ∀ v ∈ S, (neighbors E v).card = 3)
    (h4 : ¬HasFourCycle (bipartiteBase E))
    (h6 : ¬HasSixCycle (bipartiteBase E)) : 4 ≤ S.card := by
  by_contra h
  obtain ⟨T,hT⟩ := absorbing_small_cycle E S hs (by omega) deg h4 h6
  have := cycle_card_four E hT
  omega

/-- Unoriented simple eight-cycles are identified by their two supports.
The cyclic ordering is a proposition, so rotation and reversal do not
create additional elements of this type. -/
def UnorientedEightCycles := {p : Finset V × Finset C // EightCycleOn E p.1 p.2}

def FourAbsorbingSupports := {S : Finset V // S.card = 4 ∧ Absorbing E S}

/-- The support map is a genuine bijection. Degree three is required only
on the variable side, with no restriction on check degrees. -/
noncomputable def absorbing_cycle_equiv
    (deg : ∀ v, (neighbors E v).card = 3)
    (h4 : ¬HasFourCycle (bipartiteBase E))
    (h6 : ¬HasSixCycle (bipartiteBase E)) :
    UnorientedEightCycles E ≃ FourAbsorbingSupports E := by
  let f : UnorientedEightCycles E → FourAbsorbingSupports E := fun p =>
    ⟨p.val.1, cycle_card_four E p.property,
      cycle_absorbing E p.property (fun v _ => deg v) h4⟩
  apply Equiv.ofBijective f
  constructor
  · intro p q hpq
    have hS : p.val.1 = q.val.1 := congrArg Subtype.val hpq
    have hT : p.val.2 = q.val.2 := cycle_checks_unique E p.property
      (hS.symm ▸ q.property) h4 h6
    exact Subtype.ext (Prod.ext hS hT)
  · intro S
    obtain ⟨T,hT⟩ := absorbing_small_cycle E S.val S.property.2
      S.property.1.le (fun v _ => deg v) h4 h6
    exact ⟨⟨(S.val,T),hT⟩, Subtype.ext rfl⟩


theorem stopping_minimum_six (S : Finset V) (hs : Stopping E S)
    (h4 : ¬HasFourCycle (bipartiteBase E))
    (h6 : ¬HasSixCycle (bipartiteBase E))
    (deg : ∀ v ∈ S, (neighbors E v).card = 3) : 6 ≤ S.card := by
  exact stopping_card_ge_twice_degree E S hs h4 h6 3 (by omega)
    (fun v hv => (deg v hv).ge)

/-- Equality of cycle and support counts, with cycles counted once per
unoriented support pair rather than once per walk origin and direction. -/
theorem absorbing_cycle_count
    (deg : ∀ v, (neighbors E v).card = 3)
    (h4 : ¬HasFourCycle (bipartiteBase E))
    (h6 : ¬HasSixCycle (bipartiteBase E)) :
    Nat.card (UnorientedEightCycles E) = Nat.card (FourAbsorbingSupports E) :=
  Nat.card_congr (absorbing_cycle_equiv E deg h4 h6)

#print axioms mem_neighbors
#print axioms mem_selected
#print axioms selected_subset
#print axioms check_unique
#print axioms variable_unique
#print axioms six_contradiction
#print axioms stopping_other
#print axioms stopping_card_ge_twice_degree
#print axioms mem_even
#print axioms even_subset
#print axioms absorbing_even_two
#print axioms even_two_distinct
#print axioms even_check_two
#print axioms even_other
#print axioms pair_exhausts
#print axioms no_triangle
#print axioms absorbing_small_cycle
#print axioms cycle_check_two
#print axioms cycle_absorbing
#print axioms cycle_shared_check
#print axioms cycle_checks_exact
#print axioms cycle_checks_unique
#print axioms cycle_native
#print axioms absorbing_iff_cycle
#print axioms cycle_card_four
#print axioms absorbing_minimum_four
#print axioms stopping_minimum_six
#print axioms absorbing_cycle_count
#print axioms absorbing_cycle_equiv

end CyclicStructure
