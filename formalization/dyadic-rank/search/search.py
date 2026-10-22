"""Exact GF(2) counterexample search; computations here are not Lean proofs."""
import collections, hashlib, json, pathlib, random, time

SEED = 20261021

def translate(v, bit, n):
    step = 1 << bit
    low = sum(((1 << step) - 1) << j for j in range(0, n, 2 * step))
    return ((v & low) << step) | ((v >> step) & low)

def rows_for(signature, ell):
    rows = [signature]
    for bit in range(ell):
        rows += [translate(v, bit, 1 << ell) for v in rows]
    return rows

def rank(signature, ell):
    basis = {}
    for row in rows_for(signature, ell):
        while row:
            p = row.bit_length() - 1
            if p in basis:
                row ^= basis[p]
            else:
                basis[p] = row
                break
    return len(basis)

def independent_rank(signature, ell):
    # Construct every entry directly and pivot from the opposite end.
    n = 1 << ell
    rows = [sum(((signature >> (x ^ y)) & 1) << y for y in range(n)) for x in range(n)]
    r = 0
    for col in range(n):
        p = next((i for i in range(r, n) if (rows[i] >> col) & 1), None)
        if p is None:
            continue
        rows[r], rows[p] = rows[p], rows[r]
        for i in range(r + 1, n):
            if (rows[i] >> col) & 1:
                rows[i] ^= rows[r]
        r += 1
    return r

def syndrome(signature):
    parity, moment = 0, 0
    while signature:
        bit = signature & -signature
        moment ^= bit.bit_length() - 1
        parity ^= 1
        signature ^= bit
    return parity, moment

def project(signature, ell):
    # Free coordinates exclude 0 and the ell unit vectors. Solve ell+1 independent equations.
    for pivot in [0] + [1 << i for i in range(ell)]:
        signature &= ~(1 << pivot)
    parity, moment = syndrome(signature)
    for i in range(ell):
        if (moment >> i) & 1:
            signature |= 1 << (1 << i)
            parity ^= 1
    if parity:
        signature |= 1
    assert syndrome(signature) == (0, 0)
    return signature

def conditioned_from_free(bits, ell):
    free = [x for x in range(1 << ell) if x not in [0] + [1 << i for i in range(ell)]]
    return project(sum(((bits >> i) & 1) << x for i, x in enumerate(free)), ell)

def monomial(indices):
    support = [0]
    for i in indices:
        support += [x ^ (1 << i) for x in support]
    return sum(1 << x for x in support)

def run():
    start = time.monotonic()
    rng = random.Random(SEED)
    records = []
    witness = None
    for ell, uniform, planes in [(1,0,0),(2,0,0),(3,0,0),(4,0,0),
                                  (5,20000,4000),(6,10000,2000),(7,3000,1000),
                                  (8,1000,300),(9,200,100),(10,50,30)]:
        n = 1 << ell
        seen = set()
        histogram = collections.Counter()
        attempts = collections.Counter()
        best = None
        digest = hashlib.sha256()
        crosschecks = 0
        before = time.monotonic()
        def test(s, family):
            nonlocal best, witness, crosschecks
            attempts[family] += 1
            assert syndrome(s) == (0, 0)
            if s in seen:
                return
            seen.add(s)
            r = rank(s, ell)
            assert 2 * r <= n
            if crosschecks < 3:
                assert independent_rank(s, ell) == r
                crosschecks += 1
            histogram[r] += 1
            digest.update(s.to_bytes((n+7)//8, 'little'))
            digest.update(r.to_bytes(4, 'little'))
            if best is None or r > best['rank']:
                best = dict(rank=r, signature_hex=hex(s), family=family)
            if 2 * r == n:
                witness = dict(ell=ell, signature_hex=hex(s), rank=r)
        if ell <= 4:
            for bits in range(1 << (n-ell-1)):
                test(conditioned_from_free(bits, ell), 'exhaustive_conditioned_subspace')
        else:
            for _ in range(uniform):
                test(project(rng.getrandbits(n), ell), 'uniform_conditioned')
                if witness: break
            for _ in range(planes):
                s = 0
                for _ in range(rng.choice([1,2,3,4,8,16])):
                    a,b,c = [rng.randrange(n) for _ in range(3)]
                    for x in [a,b,c,a^b^c]: s ^= 1 << x
                test(s, 'affine_plane_sums')
                if witness: break
            # Symplectic quadratics, with higher-degree perturbations in the augmentation basis.
            for m in range(1, ell//2+1):
                q = 0
                for i in range(m): q ^= monomial([2*i,2*i+1])
                test(q, 'disjoint_pair_quadratic')
                for _ in range(100):
                    s = q
                    for _ in range(rng.randrange(1,17)):
                        s ^= monomial(rng.sample(range(ell), rng.randrange(3,ell+1)))
                    test(s, 'quadratic_higher_degree_perturbations')
                    if witness: break
        records.append(dict(ell=ell,matrix_size=n,exhaustive=ell<=4,
            conditioned_space_size=str(1 << (n-ell-1)),attempts_by_family=dict(attempts),
            distinct_tested=len(seen),rank_histogram=dict(sorted(histogram.items())),
            largest_observed=best,independent_rank_crosschecks=crosschecks,
            ordered_signature_rank_digest=digest.hexdigest(),seconds=round(time.monotonic()-before,3)))
        print(json.dumps(records[-1]), flush=True)
        if witness: break
    result=dict(checked_on='2026-10-21',seed=SEED,arithmetic='Exact GF(2) bitwise Gaussian elimination',
        target='even coefficient parity, zero XOR of support indices, rank = 2^(ell-1)',
        status='counterexample_found' if witness else 'no_counterexample_in_recorded_search',
        lean_verified=False,source_sha256=hashlib.sha256(pathlib.Path(__file__).read_bytes()).hexdigest(),
        counterexample=witness,records=records,seconds=round(time.monotonic()-start,3),
        limitations='Exhaustive only for ell <= 4 in the conditioned subspace. Larger dimensions sampled; no general proof or probability of truth follows.')
    pathlib.Path(__file__).with_name('results.json').write_text(json.dumps(result,indent=2)+'\n')

if __name__ == '__main__': run()
