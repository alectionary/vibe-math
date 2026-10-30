"""Preserved solver sensitivity and channel normalization checks."""
import json
from replicate import ROOT, ALPHAS, coherent_channel, solve_recovery
import numpy as np

rows = []
for alpha in ALPHAS:
    h, _ = coherent_channel('extended', alpha)
    for tolerance in [1e-4, 1e-5, 1e-7, 1e-9]:
        row = dict(case='extended', alpha=float(alpha), tolerance=tolerance,
                   **solve_recovery(h, 'SCS', tolerance))
        rows.append(row)
        print(json.dumps(row), flush=True)
        (ROOT/'outputs/solver_sensitivity.json').write_text(json.dumps(rows, indent=2)+'\n')

checks = []
for case in ['equal', 'imaginary', 'extended']:
    h, _ = coherent_channel(case, ALPHAS[-1], loss=0)
    r = solve_recovery(h)
    checks.append(dict(test='no loss', case=case, expected=1., **r))
# Replacement channel and flagged one-photon dual rail erasure at 1% loss.
for loss in [1., .01]:
    e = np.array([[0,0],[1,0],[0,1]], complex)
    v=e.T.reshape(-1)
    h=(1-loss)*np.outer(v,v.conj())/4
    for i in range(2):
        w=np.zeros(6);w[i*3]=1
        h += loss*np.outer(w,w)/4
    r=solve_recovery(h)
    checks.append(dict(test='flagged erasure', loss=loss, expected=1-.75*loss, **r))
for r in checks:
    assert abs(r['fidelity']-r['expected']) < 1e-7, r
(ROOT/'outputs/normalization.json').write_text(json.dumps(checks, indent=2)+'\n')
