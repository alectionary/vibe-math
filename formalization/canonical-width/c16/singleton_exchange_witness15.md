# Anchor 40 exact exchange repair at integer witness 15

This bounded gate is inconclusive. It produced neither an exact conditional basis mixture for witness 15 nor a violated conditional rank inequality. The exact partial mixture is independently verified and resumable.

The frozen target is `coupling-results/integer-witness15-rational.json.gz`, SHA256 `5f9a622e68a3c1e842ae13a5a5b18cf06b388515b5821d17eda2389375b290ef`. Its existing full check summary reports `PASS_LISTED_RELAXATION`. The initial distribution consists only of the 956 physical rank-127 zero bases and exact weights from the independently accepted point-12 anchor-40 certificate. All target probabilities were recomputed from witness 15. The older point's membership conclusion is not transferred.

`singleton_basis_exchange_transfer40.py` is a new immutable copy of the previously reviewed lazy repair. Its `ExactRepair` class has exactly the same AST as `singleton_basis_exchange_repair_lazy.py`; the new entry point restricts the target hash, seed, anchor 40, and 540-second cap. No old proof source was edited. The frozen declaration and source-control result are saved beside the output.

The run stopped during reachability search after 540.389 seconds (540.697 seconds including preparation and serialization). It completed 2,701 exact augmentations, with paths of length at most two. The positive marginal error decreased from approximately 0.222061409246 to 0.0472435720104591. The endpoint contains 1,445 distinct physical rank-127 zero bases with positive rational weights summing to one, and 96 unit probabilities summing to one.

The endpoint bank is `coupling-results/singleton-exchange-witness15-o40.json`. The unchanged independent consumer `verify_singleton_exchange_state.py` replayed all 1,445 physical ranks, exact mixture mass, the fresh 720-coordinate conditional target, all unit probabilities, and the residual. Its receipt `coupling-results/singleton-exchange-witness15-o40-state-independent.json` reports `PASS_VALID_EXACT_REPAIR_STATE_AND_RESIDUAL`, with exact positive error

```
586526967461424326954347153832288350294049055255645952817173679 /
12414958109678391209356073596040141429724720950821644359543294880
```

The error is nonzero, so this does not establish all conditional rank inequalities at witness 15. No closed reachable set or direct rank violation was found. Strict decrease of the error does not establish global termination. There was one bounded run, no other anchor was queried, and no extension was made. The unchanged source width interval and 405-case cover receive no new resolution from this gate.
