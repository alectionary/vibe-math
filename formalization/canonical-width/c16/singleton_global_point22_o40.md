# Fresh global singleton rank pilot at point22, orbit40

The single authorized pilot is bounded inconclusive. It found neither a
conditional-rank cut nor an exact conditional basis mixture. No second anchor
or extension was run.

The target is `coupling-results/two-basis-integer-witness22-rational.json.gz`,
SHA256 `4945dd10a5ec76c54311466ab0594b0c7b8fc2071eab4ae9a783a87143baad8f`.
For the physical X anchor at index640, its exact selection probability is
`127024536070873/562949953421312`. The fresh conditional Z target is
`q[j]=T[40,j]/p40`, with physical phase folding and no factor16 left over.
The 624 zero-evaluation vectors span rank127 and have target mass127; the
96 unit-evaluation candidates have target mass1. Every probability is in[0,1].
No membership assertion from point12 or point15 is transferred.

`singleton_global_rank_early.py` invokes the unchanged, independently controlled
`exact_matroid_push_relabel_early.py`. It starts from the deterministic
target-weight greedy basis, uses a60-second internal limit and90-second worker
limit, and allows at most5000 active bases. Every process ran at verified
nice19 with one thread. The run took60.067 solver seconds and61.402 seconds
including preparation and serialization, completing65,020 steps.

The saved state contains3,067 positive rational physical zero-basis weights
summing exactly to one. `verify_singleton_global_rank_early.py` independently
reconstructs the physical pools and exact target, verifies every rank127 basis,
the96 unit probabilities, all720 target/achieved coordinates, and five corrupt
certificate rejections. Its status is
`PASS_EXACT_GLOBAL_SINGLETON_PARTIAL_STATE`, not membership. Exact positive
marginal error is

    14716134881880/127024536070873 = approximately0.11585269537.

The exact L1 error is twice that number. Maximum label was4; the solver made
6,486,299 circuit queries and63,108 cached basis updates. No empty level arose
that triggered a rank check. These are diagnostic observations, not a
convergence or runtime guarantee.

The endpoint, full rational target, basis weights, denominator and labels are
preserved at `two-basis-results/singleton-global-point22-o40.json.gz`, with its
frozen declaration, exit record and independent receipt. Endpoint SHA256 is
`6c7278f1247a452b46178fde29483de1f6d949e212f7163428095ba12c92bf00`.
No rank bank was emitted and the existing rank-row compiler was not invoked.
The phase-zero selected-conditioned T law remains open. This says nothing
about absent conditioning, S laws, joint-profile membership or source frames.
