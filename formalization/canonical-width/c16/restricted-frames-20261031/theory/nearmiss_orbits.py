"""Part (c): do the near-miss partial frames contain whole pool orbits, or local frames of orbit pairs?"""
import json, sys
from collections import Counter
sys.path.insert(0, __file__.rsplit('/', 1)[0])
from common import X, Z, dot
p = json.load(open('../la/inst/partials.json'))
mono = {(a, b) for a, b, h in json.load(open('mono_pairs.json'))}
out = {}
for name, pairs in p.items():
    assert all(dot(X[i], Z[j]) == (k == l) for k, (i, _) in enumerate(pairs) for l, (_, j) in enumerate(pairs))
    cx = Counter(i // 16 for i, j in pairs); cz = Counter(j // 16 for i, j in pairs)
    wholeX = [a for a, c in cx.items() if c == 16]; wholeZ = [b for b, c in cz.items() if c == 16]
    # orbit pair local frames: all 16 of X orbit a paired into Z orbit b
    po = Counter((i // 16, j // 16) for i, j in pairs)
    local = [ab for ab, c in po.items() if c == 16]
    out[name] = {'pairs': len(pairs), 'X orbit counts': sorted(cx.values(), reverse=True)[:8], 'Z orbit counts': sorted(cz.values(), reverse=True)[:8],
                 'whole X orbits': wholeX, 'whole Z orbits': wholeZ, 'whole orbit-pair blocks': local,
                 'orbit-pair counts top': po.most_common(6)}
    print(name, out[name])
json.dump(out, open('nearmiss_orbits.json', 'w'), indent=1)
