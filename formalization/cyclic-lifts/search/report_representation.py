"""Document feasibility, the fixed pilot and an exact local update mechanism."""
from pathlib import Path
import hashlib,json,subprocess,tempfile
import benchmark_decoding as b
from representation_trajectory import reference_history

HERE=Path(__file__).resolve().parent
f=json.loads((HERE/'representation-results.json').read_text())
t=json.loads((HERE/'representation-trajectory-results.json').read_text())
analytic=[]
with tempfile.TemporaryDirectory(prefix='representation-analytic-') as tmp:
    binary=Path(tmp)/'minsum'
    subprocess.run(['c++','-std=c++17','-O3',str(HERE/'minsum.cpp'),'-o',str(binary)],check=True)
    for name in ['previous_best','minimum_4']:
        original=next(r for r in f['records'] if r['design']==name and r['representation']=='original')
        deletion=next(r for r in f['records'] if r['design']==name and r['representation']=='delete_one')
        rows=original['hx_rows'];removed=deletion['operation']['row'];assert removed==0
        # A replayable linear relation, with coefficients, for the deleted row.
        pivots={}
        for i,row in enumerate(rows):
            if i==removed:continue
            word=b.rowmask(row);coeff=1<<i
            while word:
                p=word.bit_length()-1
                if p in pivots:word^=pivots[p][0];coeff^=pivots[p][1]
                else:pivots[p]=(word,coeff);break
        word=b.rowmask(rows[removed]);coeff=0
        while word:
            p=word.bit_length()-1;word^=pivots[p][0];coeff^=pivots[p][1]
        relation=[i for i in range(len(rows)) if coeff>>i&1]
        reconstructed=0
        for i in relation:reconstructed^=b.rowmask(rows[i])
        assert reconstructed==b.rowmask(rows[removed])
        v=rows[removed][0]
        checks=[i for i,row in enumerate(rows) if v in row and i!=removed]
        assert len(checks)==2
        support=[next(w for w in rows[c] if w!=v) for c in checks]
        error=b.bit_string(b.rowmask(support),252)
        syn=b.syndrome(list(map(b.rowmask,rows)),b.string_mask(error))
        assert syn[removed]==0 and all(syn[c]==1 for c in checks)
        histories=[]
        for rec in [original,deletion]:
            history=reference_history(rec['hx_rows'],252,error)
            outcome=b.engine(binary,rec['hx_rows'],252,[(.04,error)],100,.8)[0]
            assert outcome==(len(history)-1,True,history[-1])
            assert history[-1]==error
            histories.append(history)
        assert [history[1][v] for history in histories]==['0','1']
        assert [len(history)-1 for history in histories]==[1,2]
        analytic.append(dict(design=name,deleted_row=removed,deleted_row_equals_xor_of_original_rows=relation,
                             variable=v,other_incident_checks=checks,error_support=sorted(support),
                             original_syndrome_on_three_checks=[syn[c] for c in [removed]+checks],
                             original_history=histories[0],deletion_history=histories[1]))
(HERE/'representation-analytic.json').write_text(json.dumps(dict(
    status='exact_linear_relations_and_deterministic_two_error_update_witnesses',records=analytic,
    source_sha256=hashlib.sha256(Path(__file__).read_bytes()).hexdigest()),indent=2)+'\n')

lines=['# Same code, different parity-check representations','',
'''**Yes, absorbing-set counts can vary while the exact labeled CSS code,
channel and decoder algorithm stay fixed. But the tested interventions also
change graph degrees or short cycles.** We found no pure count intervention.
In fact, the existing exhaustive census rules out an alternative using 126
distinct weight-six H_X checks for either of the two saved codes.

The first bounded deletion pilot found **lower counts and worse decoding**
in both codes. This is evidence about deleting a redundant generator, not
evidence that absorbing sets are beneficial or that lower count caused the
earlier cross-code improvement.

## What stays exactly the same

H_Z and physical coordinate labels are unchanged. Each modified H_X has
exactly the original binary row span, verified in both directions with two
pivot conventions. Thus the stabilizer group, encoded space, full labeled
logical structure and logical weight spectra are identical. The existing
exact `[[252,10,10]]` parameters transfer without another distance search.
Every modified row commutes with H_Z, and both ranks remain 121.

Deletion removes an individually redundant row. A saved explicit XOR
relation expresses that row through retained rows. Consequently an estimate
matches the remaining perfect syndrome if and only if it matches the full
original syndrome: deletion cannot manufacture a false syndrome acceptance.
It changes the factor graph and its messages, rather than the set of valid
parity constraints. No claim is made for noisy syndrome measurements.

## Feasibility counts, before new decoding

The [feasibility protocol](REPRESENTATION-PROTOCOL.md) deterministically tests
six representations of each code. All counts below are complete four-variable
absorbing-support counts: every selected variable has strictly more even
than odd incident checks. The former regular-graph eight-cycle shortcut is
not used on modified graphs.

| Code | Representation | Absorbing supports | Checks | Edges | Girth |
| --- | --- | ---: | ---: | ---: | ---: |''']
for r in f['records']:
    lines.append(f"| {r['design']} | {r['representation']} | {r['absorbing_count']:,} | {r['checks']} | {r['edges']} | {r['girth']} |")
lines.append('''
Reversing row order is a relabeling control. Deleting row zero preserves
girth eight and keeps every remaining row at weight six, but changes six
variable degrees from three to two. Retaining an independent basis changes
more degrees, including some to one. Row-XOR replacements retain 126 checks
but introduce a weight-ten or weight-twelve row and four-cycles. All examined
graphs are connected.

The census contains exactly 126 weight-six vectors in each original H_X
span, and these are precisely its original distinct rows. Any representation
with 126 distinct weight-six rows and that same span must therefore use that
same row set. This is a written finite rigidity deduction from the independently
verified exhaustive census, not a new Lean theorem or a search over every
possible generator weight. It does not rule out other interventions after
relaxing these constraints.

Modified graphs are irregular. Their surviving size-four absorbing supports
include syndrome weights three and, for bases, two. Thus lower totals do not
mean an otherwise identical collection with some equally harmful sets removed.
These representations also lie outside the original normalized regular
lifted-product search family; counts below 2,520 do not contradict its minimum.

## Fixed deletion pilot

The [separate pilot protocol](REPRESENTATION-TRAJECTORY-PROTOCOL.md) was frozen
after feasibility and before decoding. It uses 50,000 new shared Bernoulli
Z-error patterns, p = 0.04, seed 20261026, across six representations: original,
row-order control and deletion for each code. There are 300,000 decoder
executions, not 300,000 independent errors. The old million-pair experiment
is not pooled. Alpha 0.8, 100 iterations, integer arithmetic, clipping,
rounding, ties and stopping rule are unchanged. Stabilizer-equivalent recovery
counts as success using the same full H_Z span.

| Code | Original FER | Delete-one FER | Change (percentage points) | Pointwise paired 95% interval |
| --- | ---: | ---: | ---: | --- |''')
for c in t['contrasts']:
    name=c['design'];a=next(r for r in t['results'] if r['design']==name and r['representation']=='original')
    z=next(r for r in t['results'] if r['design']==name and r['representation']=='delete_one')
    lo,hi=c['pointwise_paired_95_interval']
    lines.append(f"| {name} | {a['failure_count']:,}/50,000 = {100*a['failure_rate']:.3f}% | {z['failure_count']:,}/50,000 = {100*z['failure_rate']:.3f}% | {100*c['difference']:+.3f} | [{100*lo:+.3f}, {100*hi:+.3f}] |")
lines.append('''
These are exploratory pointwise intervals for two predefined contrasts,
without a multiple-testing correction. The sample size was fixed, and no
representations were selected or tuned using these outcomes. Row reversal
matches the original estimate, stopping iteration and syndrome status on
all 100,000 within-code comparisons, not merely in aggregate.

| Code | Rescued by deletion | Harmed by deletion | Extra syndrome failures | Extra logical failures |
| --- | ---: | ---: | ---: | ---: |''')
for c in t['contrasts']:
    name=c['design'];a=next(r for r in t['results'] if r['design']==name and r['representation']=='original')
    z=next(r for r in t['results'] if r['design']==name and r['representation']=='delete_one')
    lines.append(f"| {name} | {c['original_failed_deletion_succeeded']} | {c['original_succeeded_deletion_failed']} | {z['syndrome_failure']-a['syndrome_failure']:+} | {z['matched_logical_failure']-a['matched_logical_failure']:+} |")
lines.append('''
## Checked trajectories and a precise local mechanism

We retain the first three errors in each joint outcome category for each
code: both succeed, rescued, harmed, both fail. This yields 24 error examples
and 48 full hard-decision trajectories. Trace instrumentation only emits
decisions from an otherwise unchanged copy of the C++ decoder. Each complete
history agrees with direct Python message equations, and every final outcome
is replayed with the original uninstrumented C++ decoder. Per iteration we
record full-original-code residual syndrome weight, stabilizer membership
and changed variables. These are hard-decision histories, not archived full
edge-message histories.

The fixed-point prior at p = 0.04 is `L = 3332431` and the initial incoming
check-message magnitude is `M = 2665945`, in units of 2^-20. Hence
`0 < M < L < 2M`. On iteration one all variable-to-check messages have the
positive magnitude L, so a check's message sign is its syndrome sign.

For an affected original degree-three variable, the posterior is
`L + M(s0 + s1 + s2)`, where each s is +1 for syndrome zero and -1 for one.
It is negative exactly when all three syndrome bits are one: with only two
negative signs the posterior is `L-M > 0`. After deleting check zero, the
posterior is `L + M(s1+s2)`, negative exactly when both retained bits are one,
because `L-2M < 0`. Thus a deleted check with syndrome zero can previously
have prevented an incorrect flip. All eight syndrome-bit cases are checked.
This algebra is a written local-update proof with exact arithmetic checks;
it is not Lean formalized and does not predict eventual failure.

Two deterministic two-error witnesses make that mechanism explicit. Indices
are zero-based, with physical coordinate labels unchanged:

| Code | True error support | Affected variable | Incident syndrome bits (deleted, retained, retained) | Original / deletion recovery iteration |
| --- | --- | ---: | --- | --- |''')
for a in analytic:
    lines.append(f"| {a['design']} | {a['error_support']} | {a['variable']} | {a['original_syndrome_on_three_checks']} | 1 / 2 |")
lines.append('''
Variable zero is not in either true error. The original representation keeps
it zero on iteration one; deletion incorrectly flips it. Both representations
eventually recover exactly. These witnesses prove an update/delay mechanism,
not a failure mechanism for all harmed errors.

In the predefined sampled trajectories, hard decisions first diverge between
iterations 1 and 11 when a divergence occurs. For example, Previous best's
first harmed sample (index 6) converges in 36 iterations originally but fails
the syndrome criterion after 100 with deletion; Minimum 4's first harmed
sample (index 155) converges in 27 versus a 100-iteration syndrome failure.
All 24 selected true errors contain none of the absorbing supports lost by
deletion. That observation is restricted to these examples and to direct
containment; it does not exclude later trapping on a support or contributions
from other error patterns. The local update proof and examples do not explain
the full aggregate deterioration.

## What this establishes and what it does not

We have demonstrated a same-code, same-channel, same-decoder generator
intervention that changes absorbing count. Under that specific intervention,
the pilot measures worse performance despite a smaller count. Matching the
entire code removes logical-spectrum differences, but deletion also changes
variable degrees and the message redundancy. The identified first-update
mechanism provides a concrete alternative explanation to count alone.

This does not establish the cause of the earlier cross-code improvement,
prove that fewer absorbing sets are generally harmful, refute the original
regular-family optimization result, or resolve the general prediction program.
The next focused mechanism question is how often the changed messages lead
to the rescued/harmed trajectories, including cases with later hard-decision
divergence. No larger simulation, new code population, new noise level or
decoder modification is needed merely to state this feasibility result.

## Reproduce and audit

From the repository root:

```sh
python3 formalization/cyclic-lifts/search/representation_feasibility.py
python3 scripts/validate_cyclic_representation.py
python3 formalization/cyclic-lifts/search/representation_trajectory.py
python3 scripts/validate_cyclic_representation_trajectory.py
python3 formalization/cyclic-lifts/search/report_representation.py
```

Two complete enumeration algorithms agree on all twelve representations:
all quadruples using syndrome bitsets, and a co-neighbor graph cover using
direct row incidences. Completeness of the second follows because every
variable in an absorbing support has an even incident check and thus a
co-neighbor within the support. A four-vertex graph with no isolated vertex
either has a perfect matching or is a three-leaf star. Enumerating all
disjoint co-neighbor edge pairs and all such stars therefore covers every
possible support. Both methods also agree with exhaustive direct Python on
56 irregular toy graphs. The original weight-six census was independently
rechecked in all eight saved sectors; original decoder compatibility checks
cover 180 deterministic representation/error cases. The pilot validator
regenerates every noise pattern and reconstructs all contrasts, outcome
categories, trace-selection indices and per-iteration annotations.

[Feasibility results, rows and supports](search/representation-results.json) ·
[Pilot outcomes and full hard-decision trajectories](search/representation-trajectory-results.json) ·
[Explicit row relations and two-error witnesses](search/representation-analytic.json) ·
[Feasibility checks](representation-checks.log) ·
[Pilot checks](representation-trajectory-checks.log) ·
[Verification manifest](representation-verification.json).

The million-pair results were published at commit e39a457. This subsequent
feasibility and trajectory study is local. No new Lean declarations or
completed inventory targets are asserted.
''')
(HERE.parent/'REPRESENTATIONS.md').write_text('\n'.join(lines))
print('PASS: explicit row relations, deterministic two-error histories and report generated.')
