import SmallStopping
set_option maxHeartbeats 0
namespace TannerSix
variable {V C : Type*} [DecidableEq V] [DecidableEq C]

def NoFour (E : V → C → Prop) : Prop := ∀ v w c d,
  v≠w → c≠d → E v c → E w c → E w d → E v d → False

def NoSix (E : V → C → Prop) : Prop := ∀ v w z c d f,
  v≠w → w≠z → z≠v → c≠d → d≠f → f≠c →
  E v c → E w c → E w d → E z d → E z f → E v f → False

def ThreeChecks (E : V → C → Prop) : Prop :=
  ∀ v, ∃ c : Fin 3 → C, Function.Injective c ∧ ∀ i, E v (c i)

lemma partner (E : V → C → Prop) [DecidableRel E] (T : Finset V)
    (hT : SmallStopping.Stopping E T) (v : V) (hv : v∈T) (c : C) (he : E v c) :
    ∃ w, w∈T ∧ w≠v ∧ E w c := by
  by_contra hn
  have hs : T.filter (fun w => E w c) = {v} := by
    ext w
    simp only [Finset.mem_filter,Finset.mem_singleton]
    constructor
    · intro h
      by_contra hne
      exact hn ⟨w,h.1,hne,h.2⟩
    · intro h; subst w; exact ⟨hv,he⟩
  have h := hT.2 c
  rw [hs] at h
  exact h (by simp)

lemma two_more (E : V → C → Prop) (hd : ThreeChecks E) (v : V) (c : C) :
    ∃ a b, a≠b ∧ a≠c ∧ b≠c ∧ E v a ∧ E v b := by
  obtain ⟨d,hi,he⟩ := hd v
  by_cases h0 : d 0=c
  · refine ⟨d 1,d 2,?_,?_,?_,he 1,he 2⟩
    · exact fun h => (by decide : (1:Fin 3)≠2) (hi h)
    · intro h; exact (by decide : (1:Fin 3)≠0) (hi (h.trans h0.symm))
    · intro h; exact (by decide : (2:Fin 3)≠0) (hi (h.trans h0.symm))
  · by_cases h1 : d 1=c
    · refine ⟨d 0,d 2,?_,h0,?_,he 0,he 2⟩
      · exact fun h => (by decide : (0:Fin 3)≠2) (hi h)
      · intro h; exact (by decide : (2:Fin 3)≠1) (hi (h.trans h1.symm))
    · exact ⟨d 0,d 1,(fun h => (by decide : (0:Fin 3)≠1) (hi h)),h0,h1,he 0,he 1⟩

/-- The degree-three, girth-eight stopping bound (a classical Tanner-tree argument). -/
theorem stopping_lower_six (E : V → C → Prop) [DecidableRel E]
    (h4 : NoFour E) (h6 : NoSix E) (hd : ThreeChecks E)
    (T : Finset V) (hT : SmallStopping.Stopping E T) : 6 ≤ T.card := by
  obtain ⟨v,hv⟩ := hT.1
  obtain ⟨c,hci,hce⟩ := hd v
  have hp : ∀ i : Fin 3, ∃ w, w∈T ∧ w≠v ∧ E w (c i) :=
    fun i => partner E T hT v hv (c i) (hce i)
  choose w hwT hwv hwe using hp
  have hwi : Function.Injective w := by
    intro i j hij
    by_contra hne
    exact h4 v (w i) (c i) (c j) (hwv i).symm
      (fun h => hne (hci h)) (hce i) (hwe i) (by simpa [hij] using hwe j) (hce j)
  obtain ⟨a,b,hab,hac,hbc,hea,heb⟩ := two_more E hd (w 0) (c 0)
  have outside (d : C) (hd0 : d≠c 0) (hed : E (w 0) d) : ∀ i, d≠c i := by
    intro i hi
    by_cases hz : i=0
    · exact hd0 (hi.trans (congrArg c hz))
    · exact h4 v (w 0) (c 0) (c i) (hwv 0).symm
        (fun h => hz ((hci h).symm)) (hce 0) (hwe 0) (by simpa [hi] using hed) (hce i)
  have haout := outside a hac hea
  have hbout := outside b hbc heb
  obtain ⟨x,hxT,hxw,hxa⟩ := partner E T hT (w 0) (hwT 0) a hea
  obtain ⟨y,hyT,hyw,hyb⟩ := partner E T hT (w 0) (hwT 0) b heb
  have xv : x≠v := by
    intro h; subst x
    exact h4 v (w 0) (c 0) a (hwv 0).symm hac.symm (hce 0) (hwe 0) hea hxa
  have yv : y≠v := by
    intro h; subst y
    exact h4 v (w 0) (c 0) b (hwv 0).symm hbc.symm (hce 0) (hwe 0) heb hyb
  have xwi (i : Fin 3) (hi : i≠0) : x≠w i := by
    intro h
    exact h6 v (w 0) (w i) (c 0) a (c i)
      (hwv 0).symm (fun e => hi ((hwi e).symm)) (hwv i)
      hac.symm (haout i) (fun e => hi ((hci e)))
      (hce 0) (hwe 0) hea (by simpa [h] using hxa) (hwe i) (hce i)
  have ywi (i : Fin 3) (hi : i≠0) : y≠w i := by
    intro h
    exact h6 v (w 0) (w i) (c 0) b (c i)
      (hwv 0).symm (fun e => hi ((hwi e).symm)) (hwv i)
      hbc.symm (hbout i) (fun e => hi ((hci e)))
      (hce 0) (hwe 0) heb (by simpa [h] using hyb) (hwe i) (hce i)
  have hxy : x≠y := by
    intro h
    exact h4 (w 0) x a b hxw.symm hab hea hxa (by simpa [h] using hyb) heb
  have w01 : w 0≠w 1 := fun h => (by decide : (0:Fin 3)≠1) (hwi h)
  have w02 : w 0≠w 2 := fun h => (by decide : (0:Fin 3)≠2) (hwi h)
  have w12 : w 1≠w 2 := fun h => (by decide : (1:Fin 3)≠2) (hwi h)
  have hx1 := xwi 1 (by decide)
  have hx2 := xwi 2 (by decide)
  have hy1 := ywi 1 (by decide)
  have hy2 := ywi 2 (by decide)
  let S : Finset V := {v,w 0,w 1,w 2,x,y}
  have hS : S⊆T := by
    intro z hz
    simp only [S,Finset.mem_insert,Finset.mem_singleton] at hz
    rcases hz with rfl|rfl|rfl|rfl|rfl|rfl
    · exact hv
    · exact hwT 0
    · exact hwT 1
    · exact hwT 2
    · exact hxT
    · exact hyT
  have hc : S.card=6 := by
    simp [S,hwv 0,hwv 1,hwv 2,(hwv 0).symm,(hwv 1).symm,(hwv 2).symm,
      xv,xv.symm,yv,yv.symm,hxw,hxw.symm,hyw,hyw.symm,hx1,hx1.symm,hx2,hx2.symm,
      hy1,hy1.symm,hy2,hy2.symm,hxy,hxy.symm,w01,w01.symm,w02,w02.symm,w12,w12.symm]
  rw [← hc]
  exact Finset.card_le_card hS

#print axioms stopping_lower_six
end TannerSix
