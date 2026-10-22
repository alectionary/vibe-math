"""Independent small-instance checks and validation of the recorded search evidence."""
import hashlib, json, pathlib
from search import conditioned_from_free, independent_rank, project, rank, rows_for, syndrome
P = pathlib.Path(__file__).resolve().parent
r = json.loads((P/'results.json').read_text())
assert hashlib.sha256((P/'search.py').read_bytes()).hexdigest() == r['source_sha256']
assert r['status'] == 'no_counterexample_in_recorded_search' and r['counterexample'] is None
assert r['lean_verified'] is False
assert [x['ell'] for x in r['records']] == list(range(1,11))
checked = 0
for ell in [1,2,3]:
    n = 1 << ell
    for s in range(1 << n):
        assert rank(s,ell) == independent_rank(s,ell)
        rows = rows_for(s,ell)
        for x in range(n):
            assert rows[x] == sum(((s >> (x ^ y)) & 1) << y for y in range(n))
            square_row = 0
            for y in range(n):
                if (rows[x] >> y) & 1: square_row ^= rows[y]
            assert square_row == ((1 << x) if syndrome(s)[0] else 0)
        assert syndrome(project(s,ell)) == (0,0)
        checked += 1
for x in r['records']:
    ell,n=x['ell'],x['matrix_size']
    assert n==1<<ell and sum(x['rank_histogram'].values())==x['distinct_tested']
    assert sum(x['attempts_by_family'].values()) >= x['distinct_tested']
    assert x['independent_rank_crosschecks']==min(3,x['distinct_tested'])
    assert all(2*int(k)<n for k in x['rank_histogram'])
    s=int(x['largest_observed']['signature_hex'],16)
    assert 0 <= s < 1<<n and syndrome(s)==(0,0)
    assert independent_rank(s,ell)==x['largest_observed']['rank']==max(map(int,x['rank_histogram']))
    if x['exhaustive']:
        assert ell<=4 and x['distinct_tested']==1<<(n-ell-1)
        values={conditioned_from_free(i,ell) for i in range(1<<(n-ell-1))}
        assert len(values)==x['distinct_tested'] and all(syndrome(s)==(0,0) for s in values)
assert r['records'][3]['rank_histogram']=={'0':1,'1':1,'2':30,'4':1120,'6':896}
print('Validated',checked,'unrestricted small signatures against independently constructed matrices and elimination; checked all search summaries and largest-rank witnesses. Larger searches remain non-Lean computations.')
