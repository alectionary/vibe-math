"""Summarize the fixed paired experiment without selecting favorable examples."""
from collections import Counter
from pathlib import Path
import base64,hashlib,json,zlib
HERE=Path(__file__).resolve().parent
d=json.loads((HERE/'merged-million-results.json').read_text())
N=d['independent_noise_patterns'];NAMES=['previous_best','minimum_4'];CLASSES=['exact','stabilizer','syndrome','logical']


def median(hist):
    hist={int(k):v for k,v in hist.items()};size=sum(hist.values())
    if not size:return None
    targets=[(size-1)//2,size//2];values=[];total=0
    for value,count in sorted(hist.items()):
        while len(values)<2 and total+count>targets[len(values)]:values.append(value)
        total+=count
    return sum(values)/2


analysis={}
for name in NAMES:
    h=d['histograms'][name];source={str(i)+str(j):Counter() for i in range(2) for j in range(2)}
    containment={str(i):Counter() for i in range(2)}
    for key,count in h['strata'].items():
        syndrome,transition,contains=key.split('|');a,z=transition.split('->')
        fa=a in ['syndrome','logical'];fz=z in ['syndrome','logical']
        for group in [source[syndrome],containment[contains]]:
            group['patterns']+=count;group['original_failures']+=fa*count;group['merged_failures']+=fz*count
            group['rescued']+=(fa and not fz)*count;group['harmed']+=(fz and not fa)*count
    categories={}
    for category,hist in h['category'].items():
        total=sum(hist.values());never=hist.get('-1',0);first=hist.get('1',0)
        categories[category]=dict(patterns=total,no_common_hard_divergence=never,
                                  first_at_iteration_one=first,first_later=total-never-first,
                                  median_first_divergence=median({k:v for k,v in hist.items() if int(k)>=1}))
    traces=[t for t in d['traces'] if t['design']==name]
    examples=[]
    for category in ['harmed','rescued']:
        trace=next((t for t in traces if t['category']==category),None)
        if trace is None:continue
        first=trace['summary']['first']
        first_variables=([v for v in range(252) if trace['histories']['original'][first]['estimate'][v]!=trace['histories']['merged'][first]['estimate'][v]] if first>=0 else [])
        examples.append(dict(category=category,index=trace['index'],error_weight=trace['error'].count('1'),
                             first_differing_variables=first_variables,
                             source_syndrome=trace['summary']['source_syndrome'],first=trace['summary']['first'],
                             first_changed=trace['summary']['changed'],first_inside=trace['summary']['inside'],
                             original_iterations=len(trace['histories']['original'])-1,
                             merged_iterations=len(trace['histories']['merged'])-1,
                             terminal_transition=trace['transition'],initial_contains_gained=trace['summary']['contains'],
                             first_gained_in_residual={label:next((r['iteration'] for r in hist if r['residual_contains_gained_support']),None)
                                                      for label,hist in trace['histories'].items()}))
    changed=base64.b64decode(d['trajectory_cohort'][name]['changed_zlib_base64'])
    changed=zlib.decompress(changed)
    inside=zlib.decompress(base64.b64decode(d['trajectory_cohort'][name]['inside_zlib_base64']))
    analysis[name]=dict(categories=categories,initial_source_syndrome={k:dict(v) for k,v in source.items()},
                        initial_gained_support_containment={k:dict(v) for k,v in containment.items()},
                        first_divergence_involves_outside_variables=sum(a>b for a,b in zip(changed,inside)),
                        selected_error_pairs=len(traces),selected_histories=2*len(traces),examples=examples)
out=dict(status='descriptive_summary_of_frozen_million_pair_results',source_results_sha256=hashlib.sha256((HERE/'merged-million-results.json').read_bytes()).hexdigest(),
         report_source_sha256=hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),codes=analysis)
(HERE/'merged-million-analysis.json').write_text(json.dumps(out,indent=2)+'\n')
lines=['# One million fresh paired errors: original versus merged checks','',
'''This fixed experiment compares each original code to its verified merged
representation on **1,000,000 fresh shared errors at p = 4%**. All four arms
receive the same patterns: **4,000,000 decoder executions**, not four million
independent samples. Matrices, physical labels, H_Z, channel and decoder were
frozen before noise generation. Previous experiments are not pooled.

Both representations of each code have the identical labeled CSS code,
exact `[[252,10,10]]` parameters, full logical spectrum, variable degree three,
girth eight, connectedness and 756 edges. The merger changes 126 checks to
125 and creates one degree-twelve check in place of two degree-six checks.
The absorbing counts change 2,646 to 2,764 and 2,520 to 2,640, respectively.

## Paired performance results

Differences below are merged minus original, in percentage points. The
simultaneous intervals use a Bonferroni adjustment for the two predefined
contrasts: each marginal interval has nominal coverage 97.5%. These and the
pointwise intervals use the paired normal approximation.

| Code | Original FER | Merged FER | Difference (points) | Paired 95% interval | Simultaneous 95% interval |
| --- | ---: | ---: | ---: | --- | --- |''']
for c in d['contrasts']:
    name=c['design'];a=next(r for r in d['results'] if r['design']==name and r['representation']=='original')
    z=next(r for r in d['results'] if r['design']==name and r['representation']=='merged')
    lo,hi=c['paired_95_interval'];blo,bhi=c['bonferroni_simultaneous_95_interval']
    lines.append(f"| {name} | {100*a['failure_rate']:.4f}% | {100*z['failure_rate']:.4f}% | {100*c['difference_merged_minus_original']:+.4f} | [{100*lo:+.4f}, {100*hi:+.4f}] | [{100*blo:+.4f}, {100*bhi:+.4f}] |")
    if blo>0:verdict='The adjusted interval favors the original representation.'
    elif bhi<0:verdict='The adjusted interval favors the merged representation.'
    else:verdict='The adjusted interval does not establish a winner.'
    analysis[name]['verdict']=verdict
lines.append('')
for name in NAMES:lines.append(name+': '+analysis[name]['verdict'])
lines.append('''
| Code / representation | Failures | Syndrome failures | Matched logical failures | Successful nonzero stabilizer residuals | Mean iterations |
| --- | ---: | ---: | ---: | ---: | ---: |''')
for r in d['results']:
    lines.append(f"| {r['design']} / {r['representation']} | {r['failure_count']:,} | {r['syndrome']:,} | {r['logical']:,} | {r['stabilizer']:,} | {r['mean_iterations']:.5f} |")
lines.append('')
for name in NAMES:
    a=next(r for r in d['results'] if r['design']==name and r['representation']=='original')
    z=next(r for r in d['results'] if r['design']==name and r['representation']=='merged')
    lines.append(f"{name}: {z['syndrome']-a['syndrome']:+,} syndrome failures and {z['logical']-a['logical']:+,} logical failures, totaling {z['failure_count']-a['failure_count']:+,} extra failures. The net deterioration is in syndrome convergence; measured logical failures decrease slightly.")
lines.append('''
Stabilizer-equivalent recovery is success even if the returned estimate
differs from the true error. Every outcome is checked against the full original
syndrome as well as the unchanged complete H_Z span. Same-code row-span
equality means a match to merged constraints is equivalent to a match to
the original constraints; merging cannot hide an unsatisfied original check.

| Code | Original failed, merged succeeded (rescued) | Original succeeded, merged failed (harmed) | Net extra merged failures |
| --- | ---: | ---: | ---: |''')
for c in d['contrasts']:
    better=c['original_failed_merged_succeeded'];worse=c['original_succeeded_merged_failed']
    lines.append(f"| {c['design']} | {better:,} | {worse:,} | {worse-better:+,} |")
lines.append('''
## Where hard-decision trajectories diverge across the full cohort

Every original/merged pair was traced internally, not just the saved examples.
The table reports the first differing hard-decision vector while both decoders
are still running. It distinguishes those histories from edge-message histories,
which are not archived here. Messages may differ before a hard decision changes.

| Code | Joint outcome | Patterns | First hard divergence at iteration 1 | First hard divergence later | No hard divergence | Median first divergence when present |
| --- | --- | ---: | ---: | ---: | ---: | ---: |''')
for name in NAMES:
    for category in ['both_succeed','rescued','harmed','both_fail']:
        a=analysis[name]['categories'].get(category)
        if not a:continue
        lines.append(f"| {name} | {category} | {a['patterns']:,} | {a['first_at_iteration_one']:,} | {a['first_later']:,} | {a['no_common_hard_divergence']:,} | {a['median_first_divergence']} |")
lines.append('''
All first-iteration differences are confined to the twelve source-check
variables. Later divergence can involve variables outside those neighborhoods.
The complete per-pattern first-divergence index, changed-variable counts,
inside-neighborhood counts and number of differing common iterations are
stored in compressed streams and independently reconstructed in the audit.
''')
for name in NAMES:
    lines.append(f"{name}: the first differing hard-decision vector includes variables outside the two source checks on {analysis[name]['first_divergence_involves_outside_variables']:,} patterns.")
lines.append('''

## A precise first-iteration message change

Let s_A and s_B be the original syndrome bits of the two checks. Their merged
syndrome is s_A XOR s_B. Initially all variable-to-check messages have the
same positive prior L = 3,332,431; the normalized check-message magnitude is
M = 2,665,945, in fixed-point units of 2^-20. This initial magnitude is the
same for degree-six and degree-twelve checks because the incoming magnitudes
are all L.

Thus each source-A variable originally receives message sign (-1)^s_A from
that check and instead receives (-1)^(s_A XOR s_B); the analogous statement
holds for B. All other first-iteration messages are unchanged. With variable
degree three and 0 < M < L < 2M, a first-iteration decision is one exactly
when all three incident syndrome bits are one. This proves the local update
rule used to check saved histories.

- 00: all first-iteration messages and decisions agree. Later message magnitudes
  or signs can still diverge because the merged minimum uses eleven other
  incoming edges rather than five.
- 01: messages on A change from positive to negative; B's initial signs agree.
- 10: messages on B change from positive to negative; A's initial signs agree.
- 11: the merged message is positive instead of negative on both source sets.

This is an exact local calculation, not a proof of eventual failure or a
complete explanation of the aggregate FER change. In particular, it makes
the graph intervention's message coupling explicit without attributing the
effect solely to the new absorbing supports.

A separate audit regenerates the same noise stream and checks this local
rule on all 2,000,000 code/error pairs. For a variable on A, a first-iteration
decision differs exactly when s_B = 1 and both other incident check syndromes
are one; the symmetric rule holds on B. The audit predicts the presence,
number and confinement of every first-iteration hard-decision divergence.
It performs no additional decoder executions and is not a Lean formalization.

The following strata are descriptive, conditional on the initial source-check
syndromes. They are not extra confirmatory tests:

| Code | Initial source bits | Patterns | Original failures | Merged failures | Net extra merged failures |
| --- | --- | ---: | ---: | ---: | ---: |''')
for name in NAMES:
    for syndrome,g in analysis[name]['initial_source_syndrome'].items():
        lines.append(f"| {name} | {syndrome} | {g['patterns']:,} | {g['original_failures']:,} | {g['merged_failures']:,} | {g['merged_failures']-g['original_failures']:+,} |")
lines.append('''
## Direct containment of newly gained absorbing supports

We check every initial error for containment of any of the 118 or 120 newly
gained four-variable supports. Containment does not assert that the decoder
is trapped on that support. Conversely, an error that initially contains none
can later develop a residual containing one.

| Code | Initial error contains a gained support | Patterns | Rescued | Harmed | Net extra merged failures |
| --- | --- | ---: | ---: | ---: | ---: |''')
for name in NAMES:
    for flag,g in analysis[name]['initial_gained_support_containment'].items():
        lines.append(f"| {name} | {'Yes' if flag=='1' else 'No'} | {g['patterns']:,} | {g['rescued']:,} | {g['harmed']:,} | {g['harmed']-g['rescued']:+,} |")
lines.append('''
This exact finite decomposition separates initially contained patterns from
the rest. It does not classify all dynamic trapping events. Only the selected
complete histories below have per-iteration residual-support annotations;
do not extrapolate their proportions to the entire million-error cohort.
''')
for name in NAMES:
    a=analysis[name]['initial_gained_support_containment'];outside=a['0'];inside=a['1']
    lines.append(f"{name}: {outside['harmed']-outside['rescued']:+,} net extra failures occur among initially non-containing errors, versus {inside['harmed']-inside['rescued']:+,} among containing errors. Direct initial containment alone does not account for most of the observed net penalty. This does not exclude later dynamic interaction with gained supports.")
lines.append('''

## Full, predefined trajectory examples

For each code we retain the union of the first three errors in every joint
success/failure category and the first error in every ordered transition
between exact success, stabilizer success, syndrome failure and logical
failure. Indices are zero-based in the fixed noise stream. The selection
is deterministic and was frozen before outcomes; it is not a random sample
of trajectories. Each complete hard-decision history matches independent
Python message equations and the original uninstrumented C++ terminal output.

The first harmed and rescued examples per code are:

| Code | Example | Error index | First hard divergence | Differing variable indices | Original / merged iterations | Terminal transition | Initial gained-support containment |
| --- | --- | ---: | ---: | --- | --- | --- | --- |''')
for name in NAMES:
    for e in analysis[name]['examples']:
        lines.append(f"| {name} | {e['category']} | {e['index']} | {e['first']} | {e['first_differing_variables']} | {e['original_iterations']} / {e['merged_iterations']} | {e['terminal_transition']} | {e['initial_contains_gained']} |")
lines.append('')
for name in NAMES:
    a=analysis[name];lines.append(f"{name}: {a['selected_error_pairs']} saved error pairs, {a['selected_histories']} complete histories.")
lines.append('')
for name in NAMES:
    for e in analysis[name]['examples']:
        if e['category']=='harmed':
            lines.append(f"In {name}'s first harmed example, first hard divergence is at iteration {e['first']} on variables {e['first_differing_variables']}. The original recovers at iteration {e['original_iterations']}; merged decoding still fails at its limit. The merged residual first contains a gained support at iteration {e['first_gained_in_residual']['merged']}. This is an observed intermediate event, not proof of a permanent trap.")
lines.append('''
Full decisions, iteration-to-iteration changed variables, full-original residual
syndrome weights, residual stabilizer membership and gained-support containment
are linked below. The first-divergence summaries cover all million pairs per
code; the detailed residual annotations cover only the selected histories.

## Interpretation and scope

This estimates the total effect of the specified redundant-check merger on
each fixed code under the fixed decoder and channel. Code, full logical
spectrum, every variable degree, girth and edge count are controlled. Check
degree, check count, cycle multiplicity and message routing change together.
Therefore the results do not isolate absorbing count as the causal variable
or establish a universal design objective. The local XOR-sign mechanism and
the finite trajectory decompositions are more specific than an aggregate
correlation, but are not a complete structural explanation of all failures.

The [earlier feasibility result](DEGREE-PRESERVING.md) also shows that retaining
126 nonzero checks alongside these code/degree/girth constraints would force
the original row set in these codes. No new candidate population, noise
level, decoder change, Lean declaration or completed inventory target is
asserted by this experiment.

## Reproduction and audit

[Frozen protocol](MERGED-MILLION-PROTOCOL.md) ·
[Frozen source/input hashes](search/merged-million-selection.json) ·
[Full outcomes, cohort streams and selected histories](search/merged-million-results.json) ·
[Descriptive summaries](search/merged-million-analysis.json) ·
[Run log](merged-million-run.log) ·
[Independent audit](merged-million-checks.log) ·
[All-pair first-step audit](merged-first-step-checks.log) ·
[First-step validation data](search/merged-first-step-validation.json) ·
[Verification manifest](merged-million-verification.json).

```sh
# From repository root
python3 formalization/cyclic-lifts/search/merged_million.py
python3 scripts/validate_cyclic_merged_million.py
python3 scripts/validate_cyclic_merged_first_step.py
python3 formalization/cyclic-lifts/search/report_merged_million.py
```

The unchanged stock decoder passes 128 direct reference cases and 1,148
total controls on the four arms. Before the fresh run, 128 wrapper terminal
outcomes agree with stock, and 64 paired cases verify batch independence.
The independent audit regenerates every noise pattern and batch/full hash,
checks all gained-support containment and source-syndrome annotations,
reconstructs all outcome/divergence histograms and both adjusted contrasts,
and replays the predefined full histories with C++ and direct Python.

The degree-preserving constructions were published at commit 7d58083.
This new million-error experiment and report remain local.
''')
# Preserve generated verdicts in the descriptive artifact too.
(HERE/'merged-million-analysis.json').write_text(json.dumps(out,indent=2)+'\n')
(HERE.parent/'MERGED-MILLION.md').write_text('\n'.join(lines))
print('Merged-million report and descriptive analysis generated.')
