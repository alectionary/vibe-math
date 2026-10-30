Independent read-only review of `export_joint_general_exact_lp.py` and
`run_soplex_general_bounded.py` found no change to the reviewed model semantics.
The exporter evaluates only exact target coefficients, writes each original
variable expression with right side minus its target constant, preserves `=`
and `<=`, and round-trips every rational text token and all free bounds.
The objective is zero; no discovery margin variable is introduced. Optional
five tau equations explicitly select the zero-high law and prevent a general
law exclusion claim.

Additional rank rows are reconstructed from physical pools, joint forced-zero
contraction and the allowed zero pool for their pattern. Thus their validity
does not depend on the discovery target or receipt alone. Receipt consumer
hash checking would strengthen provenance, but its absence does not invalidate
these directly checked rank rows. Star rows pass the independently reviewed
adapter and existing consumer bindings.

The runner checks setup/tiny controls and exact input byte hashes, uses the
exact read/solve modes, zero tolerances, 120-second internal and 150-second
external caps, and a 2GB sampled RSS stop. It labels every solver result as a
candidate requiring independent semantic replay. Both runner and child check
nice19. The exporter must itself be launched by a nice19-guarded supervisor,
because its imports precede its local priority assertion. This review involved
no LP solve and conveys no feasibility or infeasibility result.
