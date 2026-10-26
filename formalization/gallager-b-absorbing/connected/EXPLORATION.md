# Search route and retained failure

The first tested CNOT A1->B1 on the14-qubit predecessor gives a connected actual X graph and correct hard-decision recovery on all128 A-supported Z-errors. It does **not** satisfy the alternate extrinsic-edge stopping test:16 inputs with syndrome-column label1 fail the first edge-parity match. This candidate is retained in candidate.json and is not presented as solving the stronger two-convention contract.

A repeated B check would suppress the unwanted target message, but introduces an exact duplicate check. Instead the accepted candidate adds one X-stabilized qubit C and couples it by CNOT C->B1. The15 actual X checks are now distinct. At B1 there are nine incoming checks, at most four of which initially send1; even after excluding a zero, four versus four ties to0. Hence B1 sends0 on every outgoing edge. Both stopping conventions pass for every input.

The independent verifier reconstructs the binary matrices from the earlier simplex rows and two gate maps, rather than importing this search module. It checks all128 inputs and all32766 nontrivial physical cuts. The overlap spanning tree is rediscovered independently; it need not use the development tree's order.

No sampled Monte Carlo or negative exhaustive-search claim is used. Only two single-CNOT orientations and the explicit15-qubit repair were examined; this is not a classification of all couplings. High-girth, degree-three and both-sector decoder requirements were not added.
