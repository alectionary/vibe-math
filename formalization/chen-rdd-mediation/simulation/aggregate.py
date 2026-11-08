#!/usr/bin/env python3
"""Aggregate chen_sim.py condition files into cell-level results and the dissertation's summaries.

  aggregate.py WORK_DIR OUT_DIR

Writes, in OUT_DIR:
  cells.csv          one row per condition x cutoff x effect (1,280 x 3 x 5 = 19,200 rows)
  table48_ours.csv   % of conditions with |bias| <= .10 and <= .05, by effect and cutoff index
  table49_ours.csv   mean coverage and imbalance, by effect and cutoff index
  type1.csv          Type I error (population effect 0): mean rate, % within Bradley [.025,.075], by effect, cutoff, n
  power.csv          power (population effect != 0): mean rate, % of cells >= .80, by effect, cutoff, n
  summary.json       counts, extremes, and the numbers quoted in the write-up

Cutoff index follows Appendix A's code: index 1 = 25th percentile (75% treated),
index 2 = median, index 3 = 75th percentile (25% treated).
Imbalance is named as in Table 4.9: "truth above CI" means the whole CI lies below the
population value (chen_sim field ci_below_truth); "truth below CI" is the reverse.
"""
import csv, json, sys
from pathlib import Path
from collections import defaultdict

EFFECTS = ['PNIE', 'TNIE', 'PNDE', 'TNDE', 'MINT']
N_LEVELS = [500, 1000, 2500, 5000, 10000]
ZERO = 1e-12


def load(work):
    recs = [json.loads(p.read_text()) for p in sorted(Path(work).glob('cond_*.json'))]
    idx = sorted(r['index'] for r in recs)
    if idx != list(range(1280)):
        missing = sorted(set(range(1280)) - set(idx))
        sys.exit(f'expected conditions 0..1279, have {len(idx)}; missing e.g. {missing[:10]}')
    bad = [r['index'] for r in recs if r['reps'] != 1000 or r['boot'] != 500]
    if bad:
        sys.exit(f'conditions not at 1000 reps / 500 boot: {bad[:10]}')
    return recs


def main():
    work, out = Path(sys.argv[1]), Path(sys.argv[2])
    out.mkdir(parents=True, exist_ok=True)
    recs = load(work)
    rows = []
    for r in recs:
        for ci, cut in enumerate(r['cutoffs'], start=1):
            for e in EFFECTS:
                c = cut[e]
                rows.append(dict(index=r['index'], n=r['n'], a=r['a'], b=r['b'], c=r['c'], h=r['h'],
                                 cut_index=ci, quantile=cut['p'], treated_share=cut['treated_share'],
                                 effect=e, population=round(c['population'], 6),
                                 mean=c['mean'], sd=c['sd'], bias=c['bias'], reject=c['reject'],
                                 cover=c['cover'], truth_above_ci=c['ci_below_truth'],
                                 truth_below_ci=c['ci_above_truth']))
    with open(out / 'cells.csv', 'w', newline='') as f:
        w = csv.DictWriter(f, fieldnames=list(rows[0])); w.writeheader()
        for row in rows:
            w.writerow({k: (f'{v:.6g}' if isinstance(v, float) else v) for k, v in row.items()})

    g = defaultdict(list)
    for row in rows:
        g[(row['effect'], row['cut_index'])].append(row)

    t48, t49 = [], []
    for e in EFFECTS:
        for ci in (1, 2, 3):
            rs = g[(e, ci)]
            k = len(rs)
            t48.append(dict(effect=e, cut_index=ci, conditions=k,
                            within_10=100 * sum(abs(x['bias']) <= .10 for x in rs) / k,
                            within_05=100 * sum(abs(x['bias']) <= .05 for x in rs) / k,
                            max_abs_bias=max(abs(x['bias']) for x in rs)))
            t49.append(dict(effect=e, cut_index=ci, conditions=k,
                            truth_below_ci=100 * sum(x['truth_below_ci'] for x in rs) / k,
                            coverage=100 * sum(x['cover'] for x in rs) / k,
                            truth_above_ci=100 * sum(x['truth_above_ci'] for x in rs) / k,
                            pct_cells_in_bradley=100 * sum(.925 <= x['cover'] <= .975 for x in rs) / k,
                            min_coverage=min(x['cover'] for x in rs)))

    t1, pw = [], []
    for e in EFFECTS:
        for ci in (1, 2, 3):
            for n in N_LEVELS:
                rs = [x for x in g[(e, ci)] if x['n'] == n]
                z = [x for x in rs if abs(x['population']) < ZERO]
                nz = [x for x in rs if abs(x['population']) >= ZERO]
                if z:
                    t1.append(dict(effect=e, cut_index=ci, n=n, cells=len(z),
                                   mean_type1=sum(x['reject'] for x in z) / len(z),
                                   pct_in_bradley=100 * sum(.025 <= x['reject'] <= .075 for x in z) / len(z),
                                   max_type1=max(x['reject'] for x in z)))
                if nz:
                    pw.append(dict(effect=e, cut_index=ci, n=n, cells=len(nz),
                                   mean_power=sum(x['reject'] for x in nz) / len(nz),
                                   pct_ge_80=100 * sum(x['reject'] >= .80 for x in nz) / len(nz)))

    for name, tab in [('table48_ours', t48), ('table49_ours', t49), ('type1', t1), ('power', pw)]:
        with open(out / f'{name}.csv', 'w', newline='') as f:
            w = csv.DictWriter(f, fieldnames=list(tab[0])); w.writeheader()
            for row in tab:
                w.writerow({k: (f'{v:.4f}' if isinstance(v, float) else v) for k, v in row.items()})

    # MINT power by the size of the population MINT (a*h), pooled over cutoffs
    mint = defaultdict(list)
    for x in rows:
        if x['effect'] == 'MINT' and x['population'] >= ZERO:
            mint[(x['n'], x['population'])].append(x['reject'])
    summary = dict(
        conditions=len(recs), cells=len(rows) // 5, rows=len(rows),
        overall_max_abs_bias=max(abs(x['bias']) for x in rows),
        overall_mean_coverage=sum(x['cover'] for x in rows) / len(rows),
        overall_min_coverage=min(x['cover'] for x in rows),
        pct_cells_coverage_in_bradley=100 * sum(.925 <= x['cover'] <= .975 for x in rows) / len(rows),
        type1_overall_mean=(lambda z: sum(z) / len(z))([x['reject'] for x in rows if abs(x['population']) < ZERO]),
        type1_cells=sum(abs(x['population']) < ZERO for x in rows),
        type1_pct_in_bradley=(lambda z: 100 * sum(.025 <= v <= .075 for v in z) / len(z))(
            [x['reject'] for x in rows if abs(x['population']) < ZERO]),
        mint_power_by_n_and_ah={f'n={n} ah={p:.4f}': round(sum(v) / len(v), 4)
                                for (n, p), v in sorted(mint.items())},
    )
    (out / 'summary.json').write_text(json.dumps(summary, indent=1) + '\n')
    print(json.dumps({k: v for k, v in summary.items() if k != 'mint_power_by_n_and_ah'}, indent=1))


if __name__ == '__main__':
    main()
