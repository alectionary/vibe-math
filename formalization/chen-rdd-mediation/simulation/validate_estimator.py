#!/usr/bin/env python3
"""Independent validation of chen_sim.py's estimator (engine-fallback record).

1. Point estimates from the Gram-matrix solver equal scikit-learn LinearRegression fits of
   m ~ t + r and y ~ t + r + m + tm (a separate code path: scipy lstsq on centred data).
2. Bootstrap effects from resample counts equal explicit row resampling refitted with
   numpy.linalg.lstsq, for the same resample indices.
3. Population-value check: with n = 200,000 the estimates are within 0.03 (a few standard errors) of the
   population values used for bias and coverage.
"""
import numpy as np
from sklearn.linear_model import LinearRegression
import chen_sim as cs

rng = np.random.default_rng(7)
worst = 0.0
for trial in range(20):
    n = int(rng.choice([500, 2500])); a, b, c = rng.choice(cs.PATH_LEVELS, 3); h = rng.choice(cs.H_LEVELS)
    x = rng.standard_normal(n); p = rng.choice(cs.CUTS); cut = np.quantile(x, p)
    t = (x >= cut).astype(float); r = x - cut
    m = a * t + rng.normal(0, np.sqrt(1 - a * a), n); y = c * t + b * m + h * t * m + rng.normal(0, np.sqrt(1 - b * b), n)
    fm = LinearRegression().fit(np.column_stack([t, r]), m); fy = LinearRegression().fit(np.column_stack([t, r, m, t * m]), y)
    ah, i0 = fm.coef_[0], fm.intercept_; ch, bh, hh = fy.coef_[0], fy.coef_[2], fy.coef_[3]
    ref = np.array([ah * bh, ah * bh + ah * hh, ch + hh * i0, ch + hh * i0 + ah * hh, ah * hh])
    Z = np.column_stack([np.ones(n), t, r, m, t * m, y])
    ours = cs.effects_from_gram(Z.T @ Z)
    worst = max(worst, np.abs(ours - ref).max())
    # bootstrap: counts versus explicit resampling
    idx = rng.integers(0, n, size=(5, n))
    for row in idx:
        w = np.bincount(row, minlength=n).astype(float)
        gb = cs.effects_from_gram((Z * w[:, None]).T @ Z)
        Zr = Z[row]
        bm = np.linalg.lstsq(Zr[:, :3], Zr[:, 3], rcond=None)[0]; by = np.linalg.lstsq(Zr[:, :5], Zr[:, 5], rcond=None)[0]
        refb = np.array([bm[1] * by[3], bm[1] * (by[3] + by[4]), by[1] + by[4] * bm[0], by[1] + by[4] * bm[0] + bm[1] * by[4], bm[1] * by[4]])
        worst = max(worst, np.abs(gb - refb).max())
print('max |difference| over 20 scikit-learn fits and 100 bootstrap refits:', f'{worst:.2e}')
assert worst < 1e-8
# 3. large-sample population check
rng = np.random.default_rng(11)
cond = dict(n=200000, a=.59, b=.39, c=.39, h=.34)
est, lo, hi = cs.one_replication(rng, cond, 20)
pop = np.array([cs.population(.59, .39, .39, .34)[e] for e in cs.EFFECTS])
print('n=200000 estimates by cutoff:\n', np.round(est, 4), '\npopulation:', np.round(pop, 4))
assert np.abs(est - pop).max() < 0.03  # one replication; sampling SE is about 0.006-0.01
print('PASS_ESTIMATOR_VALIDATION')
