# Replay guide

The original C16 question remains open. The new exact result excludes only the
joint thin-support034/034 case. Read `../OVERNIGHT-RESEARCH.md` for the argument.

From the repository root, with Python3.12 and python-flint0.9.0:

```sh
python formalization/canonical-width/c16/replay_overnight.py \
  --output /tmp/c16-overnight-replay.json
```

This replays all exact results, the source bridge, six adversarial controls,
the independent physical88 check and the version-specific question accounting.
It runs no solver. The independent cover check also reconstructs the physical
pairing graph and verifies all255 cover costs and the1,082-case manifest.
Every listed completion remains unresolved. Individual mathematical consumers
can also be run directly:

```sh
python formalization/canonical-width/c16/verify_pool_inverse_structure.py \
  formalization/canonical-width/c16/inversion-results/normal-form.json \
  --output /tmp/c16-normal-form.json
python formalization/canonical-width/c16/verify_exchange_dual.py \
  formalization/canonical-width/c16/overnight-results/joint034-dual-no-cap.json.gz \
  --psd formalization/canonical-width/c16/overnight-results/joint034-dual.json.PSD.json.gz \
  --output /tmp/c16-joint034.json
python formalization/canonical-width/c16/verify_exchange_dual_controls.py \
  --output /tmp/c16-joint034-controls.json
python formalization/canonical-width/c16/verify_asymptotic_barrier.py \
  --output /tmp/c16-asymptotic-barrier.json
```

The source bridge checks every pool point, all518,400 cross-pairings, the
coordinate adjunction and physical sector exchange. The dual consumer uses
integer arithmetic and python-flint exact integer matrix products; it does not
load the numerical model, solver, exported canonical matrices or recovery code.
It regenerates all used source inequalities and verifies the rational PSD
preconditioners. The dual omits the critical-monomial cap. Its contradiction
gap remains strictly negative after exact box correction.

`joint034-dual.json.gz` is the earlier candidate with one such cap, retained
for discovery provenance. **Use `joint034-dual-no-cap.json.gz` for the result.**
The same PSD preconditioner applies because removing the linear cap term does
not change the dual matrix. `joint034-checked.json` is the independent final
result. `joint034-checked-final.json` additionally includes the complete source
coordinate bridge inside the dual consumer. `joint034-controls-final.json`
records six rejected corruptions, including an indefinite matrix whose hash
and residual bookkeeping were deliberately updated and a zero preconditioner.

`exchange-controls.json` additionally checks averaged actual physical88 and
retained80 frames in the producer's split coordinates; that numerical-control
replay uses NumPy/SciPy/CVXPY. No eigenvalue tolerance is used in the exact dual
consumer. `three-thin-fresh.json` replays the prior family theorem used in the
asymptotic-method comparison. No Lean completion is claimed.

Each solver launch has a separate `.exit.json` receipt. `MODEL_BUILT`,
`optimal_inaccurate`, wall termination and a small numerical residual are not
exact feasibility or exclusion certificates. Initial checker syntax/encoding
failures and launch failures are retained; the final successful check is
`verify-joint034-final.exit.json`. The third-moment pilot ended at07:40 UTC.

Numerical canonical matrices and vectors remain ignored local producer data.
The exact replay needs only the published source inputs, compressed dual and
PSD preconditioners. Paper source bytes likewise remain in the shared local
`collected-c16-papers` directory; `paper-screening.json` records hashes, primary
URLs, version-specific question locators and source-status limits.

`pair-case-cover.json` is the complete selected-pair completion manifest,
not a batch of solved cases. The12-anchor cover and the1,082-case cover use
different cost objectives and therefore choose different hitting sets.
`partial88-maximality.json` proves only direct-extension maximality. The
24 local-replacement attempts in `local-exchange.json` are a bounded
construction experiment, with no global exclusion or new frame.
