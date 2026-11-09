#!/usr/bin/env python3
"""Independent re-implementation of Chen (2021), Appendices A-B: mediation in a sharp RDD.

Data generation (Appendix A), per replication of a condition (n, a, b, c', h):
  x ~ N(0, 1);  for each cutoff p in {.25, .50, .75}:
    cut = sample quantile of x at p (R type 7, numpy 'linear');  t = 1 if x >= cut else 0;
    r = x - cut;  m = a t + e_m, e_m ~ N(0, sqrt(1 - a^2));
    y = c' t + b m + h t m + e_y, e_y ~ N(0, sqrt(1 - b^2)).
  Fresh residuals are drawn for each cutoff, as in Appendix A.
Estimation (Appendix B): OLS m ~ 1 + t + r and y ~ 1 + t + r + m + tm;
  PNIE = a b, MINT = a h, TNIE = a b + a h, PNDE = c' + h i0M, TNDE = c' + h i0M + a h,
  where i0M is the intercept of the m model. 95% percentile bootstrap CIs from 500 resamples
  of the rows; the same resample indices are used for all three cutoffs, as in Appendix B.
Bootstrap fits use weighted Gram matrices: for resample counts w, Z' diag(w) Z gives the
normal equations exactly, so each resample is solved without copying the data.

Population values under this data-generating model: PNIE = ab, MINT = ah, TNIE = ab + ah,
PNDE = c' (the m-model intercept is 0), TNDE = c' + ah.

  chen_sim.py run --out work/ [--reps 1000] [--boot 500] [--workers 2] [--only N]
  chen_sim.py bench
"""
import argparse, itertools, json, os, sys, time
from pathlib import Path
import numpy as np

N_LEVELS = [500, 1000, 2500, 5000, 10000]
PATH_LEVELS = [0.0, 0.14, 0.39, 0.59]
H_LEVELS = [0.0, 0.05, 0.15, 0.34]
CUTS = [0.25, 0.50, 0.75]
EFFECTS = ['PNIE', 'TNIE', 'PNDE', 'TNDE', 'MINT']
MASTER_SEED = 20211201  # our own seed; R's streams cannot be reproduced here

CONDITIONS = [dict(n=n, a=a, b=b, c=c, h=h) for n, a, b, c, h in
              itertools.product(N_LEVELS, PATH_LEVELS, PATH_LEVELS, PATH_LEVELS, H_LEVELS)]

# column order of the per-cutoff design: 0:1 1:t 2:r 3:m 4:tm 5:y
PAIRS = [(i, j) for i in range(6) for j in range(i, 6)]  # 21 unique Gram entries


def population(a, b, c, h):
    return dict(PNIE=a * b, TNIE=a * b + a * h, PNDE=c, TNDE=c + a * h, MINT=a * h)


def effects_from_gram(G):
    """G: (..., 6, 6) Gram of [1, t, r, m, tm, y]. Returns (..., 5) PNIE, TNIE, PNDE, TNDE, MINT."""
    Xm = G[..., :3, :3]; ym = G[..., :3, 3]
    bm = np.linalg.solve(Xm, ym[..., None])[..., 0]            # i0M, a, r-coef
    idx = [0, 1, 2, 3, 4]
    Xy = G[..., idx, :][..., :, idx]; yy = G[..., idx, 5]
    by = np.linalg.solve(Xy, yy[..., None])[..., 0]            # i0Y, c', r-coef, b, h
    i0m, a = bm[..., 0], bm[..., 1]
    c, b, h = by[..., 1], by[..., 3], by[..., 4]
    return np.stack([a * b, a * b + a * h, c + h * i0m, c + h * i0m + a * h, a * h], axis=-1)


def gram_from_products(P):
    """P: (..., 21) summed products -> (..., 6, 6) symmetric Gram."""
    G = np.empty(P.shape[:-1] + (6, 6))
    for k, (i, j) in enumerate(PAIRS):
        G[..., i, j] = P[..., k]; G[..., j, i] = P[..., k]
    return G


def one_replication(rng, cond, nboot):
    n, a, b, c, h = cond['n'], cond['a'], cond['b'], cond['c'], cond['h']
    x = rng.standard_normal(n)
    prods = []
    for p in CUTS:
        cut = np.quantile(x, p)
        t = (x >= cut).astype(float)
        r = x - cut
        m = a * t + rng.normal(0.0, np.sqrt(1 - a * a), n)
        y = c * t + b * m + h * t * m + rng.normal(0.0, np.sqrt(1 - b * b), n)
        Z = np.column_stack([np.ones(n), t, r, m, t * m, y])
        prods.append(np.stack([Z[:, i] * Z[:, j] for i, j in PAIRS], axis=1))
    P = np.concatenate(prods, axis=1)                          # n x 63
    est = effects_from_gram(gram_from_products(P.sum(0).reshape(3, 21)))  # 3 x 5
    idx = rng.integers(0, n, size=(nboot, n))
    W = np.bincount((idx + (np.arange(nboot) * n)[:, None]).ravel(),
                    minlength=nboot * n).reshape(nboot, n).astype(float)
    Pb = (W @ P).reshape(nboot, 3, 21)
    boot = effects_from_gram(gram_from_products(Pb))           # nboot x 3 x 5
    lo = np.quantile(boot, 0.025, axis=0)                      # R quantile type 7
    hi = np.quantile(boot, 0.975, axis=0)
    return est, lo, hi


def run_condition(k, reps, nboot, out):
    cond = CONDITIONS[k]
    path = out / f'cond_{k:04d}.json'
    if path.exists():
        return
    rng = np.random.default_rng(np.random.SeedSequence(MASTER_SEED, spawn_key=(k,)))
    pop = np.array([population(cond['a'], cond['b'], cond['c'], cond['h'])[e] for e in EFFECTS])
    est = np.empty((reps, 3, 5)); lo = np.empty_like(est); hi = np.empty_like(est)
    t0 = time.time()
    for i in range(reps):
        est[i], lo[i], hi[i] = one_replication(rng, cond, nboot)
    rec = dict(index=k, **cond, reps=reps, boot=nboot, seconds=round(time.time() - t0, 1), cutoffs=[])
    for j, p in enumerate(CUTS):
        e, l, u = est[:, j], lo[:, j], hi[:, j]
        cell = {}
        for q, name in enumerate(EFFECTS):
            cell[name] = dict(
                population=pop[q], mean=float(e[:, q].mean()), sd=float(e[:, q].std(ddof=1)),
                bias=float(e[:, q].mean() - pop[q]),
                reject=float(((l[:, q] > 0) | (u[:, q] < 0)).mean()),
                cover=float(((l[:, q] <= pop[q]) & (pop[q] <= u[:, q])).mean()),
                ci_below_truth=float((u[:, q] < pop[q]).mean()),   # truth above the CI
                ci_above_truth=float((l[:, q] > pop[q]).mean()))   # truth below the CI
        rec['cutoffs'].append(dict(p=p, treated_share=1 - p, **cell))
    tmp = path.with_suffix('.tmp')
    tmp.write_text(json.dumps(rec) + '\n'); tmp.rename(path)


def worker(args):
    ks, reps, nboot, out = args
    os.environ.setdefault('OPENBLAS_NUM_THREADS', '1')
    for k in ks:
        run_condition(k, reps, nboot, Path(out))


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('mode', choices=['run', 'bench'])
    ap.add_argument('--out', default='work')
    ap.add_argument('--reps', type=int, default=1000)
    ap.add_argument('--boot', type=int, default=500)
    ap.add_argument('--workers', type=int, default=2)
    ap.add_argument('--only', type=int, nargs='*')
    ap.add_argument('--shard', default='0/1', help='i/k: run conditions with index %% k == i')
    args = ap.parse_args()
    if args.mode == 'bench':
        rng = np.random.default_rng(1)
        for n in N_LEVELS:
            t0 = time.time()
            for _ in range(5):
                one_replication(rng, dict(n=n, a=.39, b=.39, c=.39, h=.15), 500)
            print(n, round((time.time() - t0) / 5, 4), 's per replication', flush=True)
        return
    out = Path(args.out); out.mkdir(parents=True, exist_ok=True)
    si, sk = map(int, args.shard.split('/'))
    ks = args.only if args.only else [k for k in range(len(CONDITIONS)) if k % sk == si]
    # largest n first, interleaved across workers, so the slow conditions finish early
    ks = sorted(ks, key=lambda k: -CONDITIONS[k]['n'])
    if args.workers == 1:
        worker((ks, args.reps, args.boot, str(out)))
    else:
        from multiprocessing import Pool
        with Pool(args.workers) as pool:
            pool.map(worker, [(ks[w::args.workers], args.reps, args.boot, str(out))
                              for w in range(args.workers)])


if __name__ == '__main__':
    main()
