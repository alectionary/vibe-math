import ElevenRealization
set_option maxHeartbeats 0
namespace TruncatedDistance
open FamilyWords KernelCatalog
variable {L : ℕ} [NeZero L]

theorem eleven_geometry_encodes (e : Fin 3 → Fin 4 → ZMod L) (d : ElevenGeometry e) :
    ∃ p : Fin 58752,Nonempty (PatternRealization e 11 p.val) := by
  obtain ⟨c,hc⟩ := injective_three_columns_complete d.singleK d.singleK_injective
  obtain ⟨r,hr⟩ := permutation3_complete d.rightH d.rightH_injective
  obtain ⟨labels,hlabels⟩ := center_leaf_labels_complete (d.centerK 0) (d.centerK 1) d.leafK
    (fun i => ⟨d.adjacent_labels 0 i,d.adjacent_labels 1 i⟩)
  have hC (a : Fin 2) : centerLeafValue labels.val a.val=(d.centerK a).val := by
    fin_cases a
    · exact hlabels.1
    · exact hlabels.2.1
  exact ⟨⟨elevenRank c r labels d.orientation,elevenRank_bound c r labels d.orientation⟩,
    ⟨eleven_realization_of_geometry d c r labels hc hr hC hlabels.2.2⟩⟩

#print axioms eleven_geometry_encodes
end TruncatedDistance
