# Same-code parity-check representation feasibility

Scope: first test whether absorbing counts can vary within either of the two
existing exact `[[252,10,10]]` CSS codes, before selecting a decoding experiment.
No matrix may be selected using new decoder outcomes. No channel or decoder
parameter changes are allowed. Physical coordinate labels and H_Z stay fixed.

For each of `previous_best` and `minimum_4`, examine H_X unchanged, reverse
its row order (negative control), delete the first individually redundant
row, retain a greedy independent row basis, and replace row zero by its XOR
with the first other row sharing one variable or sharing no variables.
These are deterministic feasibility probes, not an exhaustive search over
all equivalent parity-check matrices or an optimization over decoder results.

Verify equality of row spaces in both directions by binary elimination;
keep H_Z unchanged, verify CSS orthogonality, and record ranks. Thus the
stabilizer code, labeled logical operators, length, dimension, exact distance
and complete logical spectrum are preserved, rather than merely matching
their minimum parameters. Perfect-syndrome row additions transform measured
syndromes by the same row operation. This does not model noisy syndrome
measurements or the cost of measuring heavier generators.

Count *all* four-variable absorbing supports directly: for every selected
variable the number of incident checks with positive even induced degree
must strictly exceed the number with odd induced degree. Record zero-syndrome
supports separately. The old eight-cycle counting shortcut is inapplicable
when regularity or girth changes. Use exhaustive quadruples and independently
enumerate supports through a co-neighbor graph covering argument.

Record check/variable degrees, number of edges/checks, connectedness, girth,
four-cycle count, absorbing support overlap and full labeled supports. Cross-check
the original counts 2646/2520 and the existing complete weight-six census.
Determine whether that census rules out a distinct representation retaining
126 distinct weight-six checks. Do not call a count-changing representation
a pure count intervention if degrees, short cycles or other features change.

This feasibility stage uses no fresh random decoding errors. Demonstrate
decoder compatibility using zero error, selected single errors, a stabilizer
and a logical operator under the unchanged decoder at p = 0.04, alpha = 0.8
and 100 iterations. Validate against direct Python message equations.
Trajectory/performance experiments, if justified, need a separately frozen
selection and clearly stated intervention, including graph properties changed.
