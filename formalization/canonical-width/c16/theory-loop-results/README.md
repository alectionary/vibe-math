# C16 theory loop certificates and replay

The [mathematical report](../THEORY-LOOP.md) proves a 428-case sufficient
starting cover versus 497, net 69 fewer. All 428 full completion cases remain
unresolved; the original width remains 16 or 18.

## Exact evidence

- [Aggregate scope and checks](verification.json).
- [Final cover list and independent proof replay](final-independent.json).
- [Complete exchange discovery and proof chain](exchange/chain.json).
- [Projected matrix ranks and 480 inclusion-minimality witnesses](theory-independent.json).
- [Encoding and affine soundness controls](additional-controls.json).
- [Conditional affine contradiction](affine-control-independent.json) and [hard-domain fixed point](affine-hard-independent.json).
- [Alternative witness 687-case comparison](witness36-final-independent.json).
- [Primary-paper question screen and software pins](paper-screening.json).
- [Bounded rounds and early stop](experiment-summary.json).

## Frozen inputs and clean replay

The [scientific manifest](manifest.json) binds 630 files at immutable commit
`bfc58d42ce21d83529f5e36d86a63d1be79448fa`. Its old 497 base dependencies
and all local Python consumer modules are included. The
[historical manifest receipt](historical-manifests-check.json) checks 331 hash
entries at their own publication revisions. Later shared lessons incorporate
unrelated master work; the scientific manifest continues to refer to its
immutable revision.

The [clean-checkout receipt](clean-replay/clean-checkout.json) and its adjacent
JSON outputs record all seven independent consumers with discovery and numeric
libraries blocked. Python 3.12 and a separately built pinned DRAT-trim checker
are used; the [environment record](environment.json) gives revisions. The
[replay driver](clean-replay-driver.py) records exact commands and environment.
Its temporary paths can be changed for a local checkout; the mathematical
consumer scripts are in the parent directory. No discovery solver is needed
to replay the successful certificates.

[Integration check](integration-check.json) and later publication/release
receipts are separate from the scientific manifest. They do not add a proof
of the original width question.
