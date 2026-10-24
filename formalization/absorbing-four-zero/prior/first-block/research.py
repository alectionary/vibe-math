"""Exact scratch calculations for L-F16-other-absorbing. Standard library only."""
from itertools import combinations, permutations, product
from collections import Counter, defaultdict
import json
from pathlib import Path


def check_graph(cols):
    cols = [frozenset(c) for c in cols]
    assert all(len(c) == 3 for c in cols)
    pair_owner = {}
    rows = defaultdict(set)
    for v, c in enumerate(cols):
        for r in c:
            rows[r].add(v)
        for pair in combinations(sorted(c), 2):
            assert pair not in pair_owner, (pair, v, pair_owner.get(pair))
            pair_owner[pair] = v
    return cols, rows, pair_owner


def direct_counts(cols):
    """Definition-based oracle, no normal-graph classification."""
    counts = Counter()
    witnesses = defaultdict(list)
    for S in combinations(range(len(cols)), 4):
        induced = Counter(r for v in S for r in cols[v])
        if max(induced.values()) > 2:
            continue
        b = sum(x % 2 for x in induced.values())
        if all(sum(induced[r] == 2 for r in cols[v]) >= 2 for v in S):
            counts[b] += 1
            witnesses[b].append(S)
    return dict(sorted(counts.items())), dict(witnesses)


def rooted_counts(cols):
    """Two perfect matchings of remaining checks at each central edge."""
    cols, rows, owner = check_graph(cols)
    counts = Counter()
    witnesses = defaultdict(list)
    attempts = 0
    for c, neighbors in sorted(rows.items()):
        for u, v in combinations(sorted(neighbors), 2):
            a = sorted(cols[u] - {c})
            b = sorted(cols[v] - {c})
            assert not (set(a) & set(b))
            for d, e in [b, b[::-1]]:
                w = owner.get(tuple(sorted((a[0], d))))
                z = owner.get(tuple(sorted((a[1], e))))
                attempts += 1
                if w is None or z is None:
                    continue
                assert len({u, v, w, z}) == 4
                common = cols[w] & cols[z]
                assert len(common) <= 1
                btype = 0 if common else 2
                counts[btype] += 1
                witnesses[btype].append((u, v, w, z))
    assert counts[0] % 6 == 0
    counts[0] //= 6
    return dict(sorted(counts.items())), dict(witnesses), attempts


def projected_counts(cols):
    """Independent projected diamonds and single-check-triangle correction."""
    cols, rows, _ = check_graph(cols)
    adj = [set().union(*(rows[r] for r in c)) - {v}
           for v, c in enumerate(cols)]
    diamond = k4 = bad_diamond = bad_k4 = 0
    for S in combinations(range(len(cols)), 4):
        edges = [(u, v) for u, v in combinations(S, 2) if v in adj[u]]
        if len(edges) not in (5, 6):
            continue
        high = any(sum(r in cols[v] for v in S) >= 3
                   for r in set().union(*(cols[v] for v in S)))
        if len(edges) == 5:
            diamond += 1
            bad_diamond += high
        else:
            k4 += 1
            bad_k4 += high
    return dict(diamond=diamond, bad_diamond=bad_diamond,
                k4=k4, bad_k4=bad_k4,
                N42=diamond-bad_diamond, N40=k4-bad_k4)


def sts13():
    return sorted({tuple(sorted((i, (i+a)%13, (i+b)%13)))
                   for i in range(13) for a, b in [(1, 4), (2, 7)]})


def trade13(blocks):
    old = [(3,4,7), (3,5,10), (4,10,12), (5,7,12)]
    new = [(3,4,10), (3,5,7), (4,7,12), (5,10,12)]
    assert set(old) <= set(blocks)
    assert Counter(p for b in old for p in combinations(b,2)) == Counter(
        p for b in new for p in combinations(b,2))
    return sorted(set(blocks) - set(old) | set(new))


def lift_sockets(sockets, ell):
    """sockets[p] lists (check type, offset), N(p,t)={(r,t+offset)}."""
    nrows = 1 + max(r for col in sockets for r, e in col)
    return [frozenset(r*ell+(t+e)%ell for r, e in col)
            for col in sockets for t in range(ell)]


def qc_ghp(base, ell=7, bsupport=(0,1,3)):
    """Hx = [base tensor I | I tensor B^T] with signed sockets."""
    nr = 1 + max(r for c in base for r in c)
    sockets = [[(r,0) for r in sorted(c)] for c in base]
    sockets += [[(r,-e%ell) for e in bsupport] for r in range(nr)]
    return sockets, lift_sockets(sockets, ell)


def orbit_count42(sockets, ell):
    """Construction-data formula; never expands the ell-fold graph."""
    sockets = [tuple((r,e%ell) for r,e in c) for c in sockets]
    assert all(len(set(c)) == len(c) == 3 for c in sockets)

    def nb(p,t):
        return {(r,(t+e)%ell) for r,e in sockets[p]}

    def completion(x,y):
        found=set()
        for s, sc in enumerate(sockets):
            for k,l in permutations(range(3),2):
                rk,ek=sc[k];rl,el=sc[l]
                if rk != x[0] or rl != y[0]:
                    continue
                t=(x[1]-ek)%ell
                if (t+el)%ell == y[1]:
                    found.add((s,t))
        assert len(found) <= 1, (x,y,found)
        return next(iter(found)) if found else None

    rooted=0
    accepted=[]
    for p,q in product(range(len(sockets)),repeat=2):
        for i,j in product(range(3),repeat=2):
            ri,ei=sockets[p][i];rj,ej=sockets[q][j]
            if ri != rj:
                continue
            delta=(ei-ej)%ell
            if p==q and delta==0:
                continue
            A=sorted(nb(p,0)-{(ri,ei)})
            B=sorted(nb(q,delta)-{(ri,ei)})
            assert len(A)==len(B)==2 and not set(A)&set(B)
            for D,E in [B,B[::-1]]:
                w=completion(A[0],D)
                z=completion(A[1],E)
                if w is None or z is None:
                    continue
                assert len({(p,0),(q,delta),w,z})==4
                if not (nb(*w)&nb(*z)):
                    rooted+=1
                    accepted.append((p,q,i,j,delta,w,z))
    assert (ell*rooted)%2==0
    return ell*rooted//2,rooted,accepted


def main():
    A=sts13();B=trade13(A)
    output={"sts":{},"qc_ghp":{}}
    for label,base in [('cyclic',A),('traded',B)]:
        cols,rows,owner=check_graph(base)
        assert len(owner)==78 and all(len(n)==6 for n in rows.values())
        direct,w=direct_counts(cols)
        rooted,_,attempts=rooted_counts(cols)
        projected=projected_counts(cols)
        assert {b:direct.get(b,0) for b in (0,2)}=={b:rooted.get(b,0) for b in (0,2)}
        assert direct.get(2,0)==projected['N42']
        assert direct.get(0,0)==projected['N40']
        output['sts'][label]=dict(blocks=base,counts=direct,projected=projected,
                                 attempts=attempts,witnesses=w)
        sockets,full=qc_ghp(base)
        check_graph(full)
        rooted,_,attempts=rooted_counts(full)
        formula,raw,w=orbit_count42(sockets,7)
        assert formula==rooted.get(2,0)
        output['qc_ghp'][label]=dict(ell=7,bsupport=[0,1,3],
            n=len(full),m=91,column_degree=3,row_degree=9,
            counts=rooted,formula42=formula,rooted_coefficient=raw,
            attempts=attempts,formula_witnesses=w)
    Path('work/absorbing42/results.json').write_text(json.dumps(output,indent=2))
    print(json.dumps({k:{l:{a:b for a,b in v.items() if a not in
        ['blocks','witnesses','formula_witnesses']} for l,v in d.items()}
        for k,d in output.items()},indent=2))

if __name__=='__main__':main()
