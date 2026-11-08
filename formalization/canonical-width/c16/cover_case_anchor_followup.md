The strengthened case-floor followup for cover tuple(5,11,10), physical
anchor(80,186), is exactly feasible for the listed moment relaxation. No source
anchor is excluded, and this does not construct a physical completion.

The new model is a separate copy of `unified_anchor_coupling_model.py`, with
the previously verified condition

    T_10[5,11] = T_6[11,5] ≥ 1/32.

It includes31 accepted partner rows,296 conditional rank rows,3 projected
rows,129 selected Boolean rows, and the old profile/capacity/physical families.
The omitted triangle from the earlier case pilot was already included in the
parent model. Root's source/helper files and the earlier zero-margin pilot,
failed direct recovery, mixed candidate, and receipts were preserved.

One model call was used. Its PSD search margin was1e-5, and its selected
Boolean/projected margins were1e-6. This was explicitly a sufficient interior
search; an unsuccessful numerical result would not have excluded a source
case. The solver cap was120 seconds. SCS returned optimal after22.28 seconds
of solver time, with71.59 seconds for the complete wrapped model call.

The direct rational recovery passed without blending. Independent replay then
passed exact PSD/profile constraints, all old ownership/circuit/legacy rows,
all296 rank rows, all3 projected rows, all31 partner rows, all129 selected
Boolean rows, the global conditioned screen, all Boolean triangles/unions,
and the independent direct triple-distribution checks. The case-floor checker
also binds the independent physical symmetry/stabilizer bridge.

The exact value is

    T_6[11,5] = 4775404919177 / 140737488355328,
    T_6[11,5] - 1/32 = 377358408073 / 140737488355328 > 0.

The accepted point is
`coupling-results/cover-case051110-anchor-witness0-rational.json.gz`, SHA256
`dba2b32d731892d4292be8e3ba5e8878cfebc876cec81ae331134310b48ea503`.
The acceptance summary is
`coupling-results/cover-case051110-anchor-witness0-checks.json`, with status
`PASS_CASE_RELAXATION_AND_ALL_SCREENS`.

This supplies a rational feasible point for the current strengthened
relaxation with the selected-pair floor. Accordingly, this particular model
cannot exclude this case by that floor. The actual source completion remains
unresolved. The authorized second model call was unnecessary and was not run.
The original source interval16/18, cover405, and zero completed full source
anchor exclusions are unchanged.
