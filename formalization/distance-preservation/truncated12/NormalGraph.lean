import ActualIncidence
import Mathlib.Combinatorics.SimpleGraph.Extremal.Turan
set_option maxHeartbeats 0
namespace TruncatedDistance
open TannerSix
variable {V C : Type*} [Fintype V] [Fintype C] [DecidableEq V] [DecidableEq C]

noncomputable def normalGraph (E : V → C → Prop) (T : Finset V) :
    SimpleGraph {v // v∈T} where
  Adj v w := v≠w ∧ ∃ c, E v.1 c ∧ E w.1 c
  symm := ⟨by rintro v w ⟨h,c,hv,hw⟩;exact ⟨h.symm,c,hw,hv⟩⟩
  loopless := ⟨by intro v h;exact h.1 rfl⟩

noncomputable instance normal_graph_decidable (E : V → C → Prop) (T : Finset V) :
    DecidableRel (normalGraph E T).Adj := fun _ _ => Classical.propDecidable _

lemma no_three_at_check (E : V → C → Prop) [DecidableRel E] (T : Finset V)
    (ht : ∀ c, (T.filter (fun v => E v c)).card=0 ∨ (T.filter (fun v => E v c)).card=2)
    (v w z : {v // v∈T}) (hvw : v≠w) (hwz : w≠z) (hzv : z≠v)
    (c : C) (hv : E v.1 c) (hw : E w.1 c) (hz : E z.1 c) : False := by
  have hvw' : v.1≠w.1 := fun h => hvw (Subtype.ext h)
  have hwz' : w.1≠z.1 := fun h => hwz (Subtype.ext h)
  have hvz' : v.1≠z.1 := fun h => hzv (Subtype.ext h.symm)
  have hs : ({v.1,w.1,z.1} : Finset V) ⊆ T.filter (fun q => E q c) := by
    intro q hq
    simp only [Finset.mem_insert,Finset.mem_singleton] at hq
    rcases hq with rfl|rfl|rfl
    · exact Finset.mem_filter.mpr ⟨v.2,hv⟩
    · exact Finset.mem_filter.mpr ⟨w.2,hw⟩
    · exact Finset.mem_filter.mpr ⟨z.2,hz⟩
  have hcard := Finset.card_le_card hs
  have h3 : ({v.1,w.1,z.1} : Finset V).card=3 := by simp [hvw',hwz',hvz']
  rw [h3] at hcard
  rcases ht c with h|h <;> omega

theorem normal_no_triangle (E : V → C → Prop) [DecidableRel E]
    (h6 : NoSix E) (T : Finset V)
    (ht : ∀ c, (T.filter (fun v => E v c)).card=0 ∨ (T.filter (fun v => E v c)).card=2)
    (v w z : {v // v∈T})
    (hvw : (normalGraph E T).Adj v w) (hwz : (normalGraph E T).Adj w z)
    (hzv : (normalGraph E T).Adj z v) : False := by
  obtain ⟨hvw,c,hvc,hwc⟩ := hvw
  obtain ⟨hwz,d,hwd,hzd⟩ := hwz
  obtain ⟨hzv,f,hzf,hvf⟩ := hzv
  have hcd : c≠d := by
    intro h
    exact no_three_at_check E T ht v w z hvw hwz hzv c hvc hwc (by simpa only [h] using hzd)
  have hdf : d≠f := by
    intro h
    exact no_three_at_check E T ht v w z hvw hwz hzv d (by simpa only [h] using hvf) hwd hzd
  have hfc : f≠c := by
    intro h
    exact no_three_at_check E T ht v w z hvw hwz hzv f hvf (by simpa only [h] using hwc) hzf
  exact h6 v.1 w.1 z.1 c d f
    (fun h => hvw (Subtype.ext h)) (fun h => hwz (Subtype.ext h))
    (fun h => hzv (Subtype.ext h)) hcd hdf hfc hvc hwc hwd hzd hzf hvf

theorem normal_clique_free (E : V → C → Prop) [DecidableRel E]
    (h6 : NoSix E) (T : Finset V)
    (ht : ∀ c, (T.filter (fun v => E v c)).card=0 ∨ (T.filter (fun v => E v c)).card=2) :
    (normalGraph E T).CliqueFree 3 := by
  classical
  by_contra hn
  let f := SimpleGraph.topEmbeddingOfNotCliqueFree hn
  exact normal_no_triangle E h6 T ht (f 0) (f 1) (f 2)
    (f.map_adj_iff.mpr (by simp)) (f.map_adj_iff.mpr (by simp))
    (f.map_adj_iff.mpr (by simp))

theorem triangle_free_edge_bound {A : Type*} [Fintype A] [DecidableEq A]
    (G : SimpleGraph A) [DecidableRel G.Adj] (h : G.CliqueFree 3) :
    G.edgeFinset.card ≤ (Fintype.card A)^2/4 := by
  have h1 := SimpleGraph.CliqueFree.card_edgeFinset_le (r := 2) h
  have h2 := SimpleGraph.mul_turanNumber_le (n := Fintype.card A) (r := 2)
  norm_num only [Nat.reduceMul,Nat.reduceSub,one_mul] at h2
  omega

#print axioms normal_clique_free
#print axioms triangle_free_edge_bound
end TruncatedDistance
