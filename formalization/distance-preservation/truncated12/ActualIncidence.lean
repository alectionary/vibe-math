import GeneralLPPhysical
import LowWeightChecks
set_option maxHeartbeats 0
namespace TruncatedDistance
open FamilyWords TannerSix
variable {L : Nat} [NeZero L]

def CEdge (e : Fin 3 → Fin 4 → ZMod L)
    (v : Fin 4 × ZMod L) (c : Fin 3 × ZMod L) : Prop := c.2=v.2+e c.1 v.1
def ZEdge (e : Fin 3 → Fin 4 → ZMod L) (q : Qubit L) (c : SourceModel.ZCheck L) : Prop :=
  match q with
  | .inl ((j,k),s) => c.1.1=j ∧ CEdge e (k,s) (c.1.2,c.2)
  | .inr ((l,i),s) => c.1.2=i ∧ CEdge e (c.1.1,c.2) (l,s)

instance (e : Fin 3 → Fin 4 → ZMod L) : DecidableRel (ZEdge e) := by
  intro q c
  cases q <;> dsimp [ZEdge,CEdge] <;> infer_instance

theorem classical_incidence (e : Fin 3 → Fin 4 → ZMod L)
    (v : Fin 4 × ZMod L) (c : Fin 3 × ZMod L) :
    GeneralLP.C e c v≠0 ↔ CEdge e v c := by
  simp [GeneralLP.C,GeneralLP.P,SourceModel.P,CEdge]

theorem quantum_incidence (e : Fin 3 → Fin 4 → ZMod L)
    (q : Qubit L) (c : SourceModel.ZCheck L) :
    GeneralLP.HZ e c q≠0 ↔ ZEdge e q c := by
  rcases q with ⟨⟨j,k⟩,s⟩ | ⟨⟨l,i⟩,s⟩
  · simp [GeneralLP.HZ,GeneralLP.P,SourceModel.P,ZEdge,CEdge]
  · have he : c.2=s+(-e l c.1.1) ↔ s=c.2+e l c.1.1 := by
      constructor <;> intro h
      · rw [h];abel
      · rw [h];abel
    simp [GeneralLP.HZ,GeneralLP.P,SourceModel.P,ZEdge,CEdge,he]

lemma omit_fst_ne {A B C : Type*} {p q : (A × B) × C}
    (hne : p≠q) (h : p.1.1=q.1.1) : (p.1.2,p.2)≠(q.1.2,q.2) := by
  intro he
  rcases p with ⟨⟨a,b⟩,c⟩
  rcases q with ⟨⟨a',b'⟩,c'⟩
  have hb : b=b' := congrArg (fun x : B × C => x.1) he
  have hc : c=c' := congrArg (fun x : B × C => x.2) he
  exact hne (Prod.ext (Prod.ext h hb) hc)
lemma omit_snd_ne {A B C : Type*} {p q : (A × B) × C}
    (hne : p≠q) (h : p.1.2=q.1.2) : (p.1.1,p.2)≠(q.1.1,q.2) := by
  intro he
  rcases p with ⟨⟨a,b⟩,c⟩
  rcases q with ⟨⟨a',b'⟩,c'⟩
  have ha : a=a' := congrArg (fun x : A × C => x.1) he
  have hc : c=c' := congrArg (fun x : A × C => x.2) he
  exact hne (Prod.ext (Prod.ext ha h) hc)

lemma left_check_unique (e : Fin 3 → Fin 4 → ZMod L) (j k : Fin 4) (s : ZMod L)
    (c d : SourceModel.ZCheck L) (hi : c.1.2=d.1.2)
    (hc : ZEdge e (.inl ((j,k),s)) c) (hd : ZEdge e (.inl ((j,k),s)) d) : c=d := by
  apply Prod.ext (Prod.ext (hc.1.trans hd.1.symm) hi)
  exact hc.2.trans (by simpa only [hi] using hd.2.symm)
lemma right_check_unique (e : Fin 3 → Fin 4 → ZMod L) (l i : Fin 3) (s : ZMod L)
    (c d : SourceModel.ZCheck L) (hj : c.1.1=d.1.1)
    (hc : ZEdge e (.inr ((l,i),s)) c) (hd : ZEdge e (.inr ((l,i),s)) d) : c=d := by
  apply Prod.ext (Prod.ext hj (hc.1.trans hd.1.symm))
  apply add_right_cancel (b := e l d.1.1)
  simpa only [CEdge,hj] using hc.2.symm.trans hd.2

theorem quantum_no_four (e : Fin 3 → Fin 4 → ZMod L) (h4 : NoFour (CEdge e)) :
    NoFour (ZEdge e) := by
  intro v w c d hvw hcd hvc hwc hwd hvd
  rcases v with ⟨⟨a,b⟩,s⟩ | ⟨⟨a,b⟩,s⟩ <;>
    rcases w with ⟨⟨a',b'⟩,t⟩ | ⟨⟨a',b'⟩,t⟩
  · exact h4 (b,s) (b',t) (c.1.2,c.2) (d.1.2,d.2)
      (omit_fst_ne (fun h => hvw (congrArg Sum.inl h)) (hvc.1.symm.trans hwc.1))
      (omit_fst_ne hcd (hvc.1.trans hvd.1.symm)) hvc.2 hwc.2 hwd.2 hvd.2
  · exact hcd (left_check_unique e a b s c d (hwc.1.trans hwd.1.symm) hvc hvd)
  · exact hcd (right_check_unique e a b s c d (hwc.1.trans hwd.1.symm) hvc hvd)
  · exact h4 (c.1.1,c.2) (d.1.1,d.2) (a,s) (a',t)
      (omit_snd_ne hcd (hvc.1.trans hvd.1.symm))
      (omit_snd_ne (fun h => hvw (congrArg Sum.inr h)) (hvc.1.symm.trans hwc.1))
      hvc.2 hvd.2 hwd.2 hwc.2

theorem quantum_no_six (e : Fin 3 → Fin 4 → ZMod L) (h6 : NoSix (CEdge e)) :
    NoSix (ZEdge e) := by
  intro v w z c d f hvw hwz hzv hcd hdf hfc hvc hwc hwd hzd hzf hvf
  rcases v with ⟨⟨a,b⟩,s⟩ | ⟨⟨a,b⟩,s⟩ <;>
    rcases w with ⟨⟨a',b'⟩,t⟩ | ⟨⟨a',b'⟩,t⟩ <;>
    rcases z with ⟨⟨a'',b''⟩,u⟩ | ⟨⟨a'',b''⟩,u⟩
  · exact h6 (b,s) (b',t) (b'',u) (c.1.2,c.2) (d.1.2,d.2) (f.1.2,f.2)
      (omit_fst_ne (fun h => hvw (congrArg Sum.inl h)) (hvc.1.symm.trans hwc.1))
      (omit_fst_ne (fun h => hwz (congrArg Sum.inl h)) (hwd.1.symm.trans hzd.1))
      (omit_fst_ne (fun h => hzv (congrArg Sum.inl h)) (hzf.1.symm.trans hvf.1))
      (omit_fst_ne hcd (hwc.1.trans hwd.1.symm))
      (omit_fst_ne hdf (hzd.1.trans hzf.1.symm))
      (omit_fst_ne hfc (hvf.1.trans hvc.1.symm)) hvc.2 hwc.2 hwd.2 hzd.2 hzf.2 hvf.2
  · exact hdf (right_check_unique e a'' b'' u d f
      (hwd.1.trans (hwc.1.symm.trans (hvc.1.trans hvf.1.symm))) hzd hzf)
  · exact hcd (right_check_unique e a' b' t c d
      (hvc.1.trans (hvf.1.symm.trans (hzf.1.trans hzd.1.symm))) hwc hwd)
  · exact hfc (left_check_unique e a b s f c
      (hzf.1.trans (hzd.1.symm.trans (hwd.1.trans hwc.1.symm))) hvf hvc)
  · exact hfc (right_check_unique e a b s f c
      (hzf.1.trans (hzd.1.symm.trans (hwd.1.trans hwc.1.symm))) hvf hvc)
  · exact hcd (left_check_unique e a' b' t c d
      (hvc.1.trans (hvf.1.symm.trans (hzf.1.trans hzd.1.symm))) hwc hwd)
  · exact hdf (left_check_unique e a'' b'' u d f
      (hwd.1.trans (hwc.1.symm.trans (hvc.1.trans hvf.1.symm))) hzd hzf)
  · exact h6 (c.1.1,c.2) (d.1.1,d.2) (f.1.1,f.2) (a',t) (a'',u) (a,s)
      (omit_snd_ne hcd (hwc.1.trans hwd.1.symm))
      (omit_snd_ne hdf (hzd.1.trans hzf.1.symm))
      (omit_snd_ne hfc (hvf.1.trans hvc.1.symm))
      (omit_snd_ne (fun h => hwz (congrArg Sum.inr h)) (hwd.1.symm.trans hzd.1))
      (omit_snd_ne (fun h => hzv (congrArg Sum.inr h)) (hzf.1.symm.trans hvf.1))
      (omit_snd_ne (fun h => hvw (congrArg Sum.inr h)) (hvc.1.symm.trans hwc.1))
      hwc.2 hwd.2 hzd.2 hzf.2 hvf.2 hvc.2

theorem quantum_three_checks (e : Fin 3 → Fin 4 → ZMod L) : ThreeChecks (ZEdge e) := by
  rintro (⟨⟨j,k⟩,s⟩ | ⟨⟨l,i⟩,s⟩)
  · refine ⟨fun i : Fin 3 => ((j,i),s+e i k),?_,?_⟩
    · intro i i' h
      exact congrArg (fun c : SourceModel.ZCheck L => c.1.2) h
    · intro i
      exact ⟨rfl,rfl⟩
  · refine ⟨fun j : Fin 3 => ((j.castSucc,i),s-e l j.castSucc),?_,?_⟩
    · intro j j' h
      exact Fin.castSucc_inj.mp (congrArg (fun c : SourceModel.ZCheck L => c.1.1) h)
    · intro j
      exact ⟨rfl,by simp [CEdge]⟩

/-- The earlier generic theorem is now applied to every actual source base. -/
theorem source_kernel_zero_or_two (e : Fin 3 → Fin 4 → ZMod L)
    (h4 : NoFour (CEdge e)) (h6 : NoSix (CEdge e))
    (x : Qubit L → ZMod 2)
    (hk : ∀ c, (∑ q,GeneralLP.HZ e c q*x q)=0)
    (hw : (CoverWeight.support x).card≤11) (c : SourceModel.ZCheck L) :
    ((CoverWeight.support x).filter (fun q => ZEdge e q c)).card=0 ∨
      ((CoverWeight.support x).filter (fun q => ZEdge e q c)).card=2 := by
  have hv (c : SourceModel.ZCheck L) (q : Qubit L) :
      GeneralLP.HZ e c q = if ZEdge e q c then 1 else 0 := by
    by_cases h : ZEdge e q c
    · simp only [h,if_true]
      exact CoverWeight.nonzero_one _ ((quantum_incidence e q c).mpr h)
    · simp only [h,if_false]
      exact not_ne_iff.mp (fun hn => h ((quantum_incidence e q c).mp hn))
  apply LowWeightChecks.kernel_check_zero_or_two (ZEdge e)
    (quantum_no_four e h4) (quantum_no_six e h6) (quantum_three_checks e) x ?_ hw c
  intro d
  simpa only [hv,ite_mul,one_mul,zero_mul] using hk d

#print axioms quantum_no_four
#print axioms quantum_no_six
#print axioms source_kernel_zero_or_two
end TruncatedDistance
