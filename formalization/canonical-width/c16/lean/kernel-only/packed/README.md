# Direct Nat certificate prototype

This directory is an experiment, outside the C16 Lake library roots. It does not
replace `swap_pools_ok` / `swap_check_ok` and does not prove certificate acceptance.

From the C16 `lean/` directory, after `lake build`:

```sh
python3 kernel-only/packed/generate.py
lake env python3 kernel-only/packed/check.py
```

The generator authenticates `swap.inst` and `swap.cert.gz` against the manifest,
checks the pool coordinate files against the instance, and records all input hashes
(including `PoolData.lean`) in the generated headers. Balanced Nat chunks contain
all 720+720 vectors, 7,936 item keys, and 346,146 certificate tokens. Item keys
regenerate exactly the original ordered swap orbits; the generator checks that.

`PackedCore` uses structural tree lookup and a fuelled list reader.
`PackedData` proves both decoded pool arrays equal `PoolData`, using only
`propext`. Both modules compiled with exit 0. `validation.json` records actual
exit codes and whole-module wall times; these are not isolated kernel timings.

`RootProbe` asks the kernel to check the real root's branch-coverage predicate,
including all 45 original root child keys, with the full instance/live set. It
uses the existing `concreteRules`. It does not check item validation or the full
tree. With one Lean thread and a 2,048 MB Lean memory limit, the experiment timed
out after 90 seconds (90.427 seconds observed wall time); no Lean exit status
was obtained. The collector exits 1 in this case and preserves the two successful
module results. Do not treat this as a passing certificate check or extrapolate
it to a uniform per-node time: data construction is included.

Further work should integrate one shared direct-data backend into the certificate
facts and `no_swap_frame`'s proof, then address the original checker's array-heavy
kernel reductions. The original theorem statements must remain unchanged.
