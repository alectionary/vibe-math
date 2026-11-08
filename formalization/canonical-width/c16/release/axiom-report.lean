import C16Frames
import Pools
import Code
import Mixed
import Aut
import CertGPTNoSwap
import CertGPTVertex
/-! Axiom report for the Lean declarations cited by paper/symmetric-frames.tex.
Run from ../lean:  lake env lean ../release/axiom-report.lean > ../release/axiom-report.tsv
Columns: declaration, status (standard / compiled-evaluation / FAIL), axioms. -/
open Lean Elab Command

def wanted : List String := ["G_eq_mul","G_rot","G_symm","IsFrame","IsFrame.map","IsFrame.swap","X_rot","Z_rot","adj_spec","aut_classification","aut_of_certificate","canon_gram","canon_length","canon_logical","canon_width","card_supp_pure_le","checks_commute","checks_weight_le_9","class_v0","coords_match","coords_nonzero","dM_id","exists_pair_of_residual_entry","finrank_inf_perp_add","first_member_unique","fixed_half_iff","fixed_sT8_iff","fixed_swapHalf_iff","fixed_swap_iff","frame_of_perm_block","frame_rot","frame_swap","gmap_aut","gmap_distinct","gram_one_iff_sum_outer","hx_length","hz_length","induced_matching_le_dim","induced_matching_le_rank","kinds_differ_of_anticommute","perfect_inf_perp","perpOf","physical_pairing_eq_G","pool_matching_le_128","pools_distinct","pools_length","pools_logical","pools_weight_16","pure_frame","remaining_card_le_finrank","tau8", "no_swap_frame", "no_swap_vertex_frame_of_no_pair"]

#eval show CommandElabM Unit from do
  let env ← getEnv
  let mut rows : Array String := #[]
  for (n, _) in env.constants.toList do
    if !(n.toString.startsWith "C16Frames") then continue
    if !(wanted.any (fun w => n.toString.endsWith ("." ++ w))) then continue
    let axs ← liftCoreM <| collectAxioms n
    let std := #[`propext, `Classical.choice, `Quot.sound]
    let extra := axs.filter (fun a => !(std.contains a))
    let status := if axs.any (· == `sorryAx) then "FAIL" else if extra.isEmpty then "standard" else "compiled-evaluation"
    rows := rows.push s!"{n}\t{status}\t{axs.toList}"
  for r in rows.qsort (· < ·) do IO.println r
