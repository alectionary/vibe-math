/- Recheck the stored proof terms with the kernel, separately from elaboration.
   Run the SAME file against the old and new builds:
     lake env lean kernel-only/KernelTimings.lean
   A successful recheck alone does not imply kernel-only axioms; inspect `axioms`.
   The kernel environment's addDeclCore always checks (no skip-check parameter).
   Each fresh declaration is checked against the same imported environment.
   Times exclude imports and tactics. Include generated auxiliary proofs of each
   target, and the two new private helper lemmas; other imported dependencies
   remain trusted as already checked by the build. -/
import CertGPTPool
import CertGPTRun
import Aut
import Pools
import Code
import Lean

open Lean Elab Command in
run_cmd do
  let env ← getEnv
  let names : Array Name := #[
    `C16Frames.CertGPT.swap_pools_ok, `C16Frames.CertGPT.swap_check_ok,
    `C16Frames.Aut.adj_spec, `C16Frames.Aut.rot1_aut, `C16Frames.Aut.swp_aut,
    `C16Frames.Aut.gmap_ginv, `C16Frames.Aut.ginv_gmap, `C16Frames.Aut.gmap_eq,
    `C16Frames.Aut.gmap_distinct, `C16Frames.Aut.class_v0, `C16Frames.Aut.dM_id,
    `C16Frames.PoolBridge.xArr_size, `C16Frames.PoolBridge.zArr_size,
    `C16Frames.PoolBridge.X_rot, `C16Frames.PoolBridge.Z_rot,
    `C16Frames.PoolBridge.G_symm, `C16Frames.PoolBridge.G_rot,
    `C16Frames.PoolBridge.tau8, `C16Frames.PoolBridge.tau8_invol,
    `C16Frames.PoolBridge.rotEquiv,
    `C16Frames.Code.hx_length, `C16Frames.Code.hz_length,
    `C16Frames.Code.checks_weight_le_9, `C16Frames.Code.checks_commute,
    `C16Frames.Code.canon_length, `C16Frames.Code.canon_logical,
    `C16Frames.Code.canon_gram, `C16Frames.Code.canon_width,
    `C16Frames.Code.pools_length, `C16Frames.Code.pools_weight_16,
    `C16Frames.Code.pools_logical, `C16Frames.Code.pools_distinct,
    `C16Frames.Code.coords_match, `C16Frames.Code.coords_nonzero,
    `C16Frames.Code.physical_pairing_eq_G]
  let owners : Array Name := #[`Aut, `Pools, `Code, `CertGPTPool, `CertGPTRun]
  let localConstants := env.constants.toList.filter fun (name, _) =>
    match env.getModuleIdxFor? name with
    | some idx => owners.contains env.header.moduleNames[idx]!
    | none => false
  let mut work : Array (Name × Name) := #[]
  for target in names do
    work := work.push (target, target)
    for (name, info) in localConstants do
      let nested := (name.toString.splitOn (target.toString ++ ".")).length > 1
      let helper :=
        (target == `C16Frames.Aut.gmap_eq && name.toString.endsWith ".iterate_rot1_val") ||
        ((target == `C16Frames.Code.hx_length || target == `C16Frames.Code.hz_length) &&
          name.toString.endsWith ".expandRow_length")
      if nested || helper then
        match info with
        | .thmInfo _ | .defnInfo _ => work := work.push (target, name)
        | _ => pure ()
  for (target, name) in work do
    let freshName := `C16KernelTiming ++ name
    let decl ← match env.checked.get.find? name with
      | some (.thmInfo info) => pure <| Declaration.thmDecl {info with name := freshName, all := [freshName]}
      | some (.defnInfo info) => pure <| Declaration.defnDecl {info with name := freshName, all := [freshName]}
      | _ => throwError "missing theorem/definition: {name}"
    let start ← IO.monoNanosNow
    match env.checked.get.addDeclCore 0 100000 decl none with
    | .error _ => throwError "kernel recheck failed: {name}"
    | .ok _ => pure ()
    let stop ← IO.monoNanosNow
    let axs ← collectAxioms name
    let record := Json.mkObj [("name", toJson name.toString), ("target", toJson target.toString),
      ("kernel_ns", toJson (stop - start)), ("axioms", toJson (axs.map Name.toString))]
    liftIO <| IO.println ("C16_KERNEL_TIMING " ++ record.compress)
