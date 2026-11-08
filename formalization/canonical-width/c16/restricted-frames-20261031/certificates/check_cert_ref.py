#!/usr/bin/env python3
"""Reference checker for la_gen search certificates (see FORMAT.md). Written by the author of
la_gen for testing the format; the independent checker is written separately from FORMAT.md.

  check_cert_ref.py INSTANCE CERT.gz [CERT2.gz ...]   (several files = shards of one search)

Only checks the certificate against the instance file; it does not regenerate the items.
"""
import gzip, sys


def load(path):
    tok = open(path).read().split()
    p = 0
    def nxt():
        nonlocal p; p += 1; return tok[p - 1]
    nx, nz, ni, dim = (int(nxt()) for _ in range(4))
    def vec():
        lo, hi = nxt(), nxt(); return int(lo, 16) | int(hi, 16) << 64
    dmask = vec()
    X = [vec() for _ in range(nx)]; Z = [vec() for _ in range(nz)]
    items = []
    for _ in range(ni):
        k = int(nxt()); items.append([(int(nxt()), int(nxt())) for _ in range(k)])
    return X, Z, items, dim, dmask


def rank(rows):
    piv = {}; r = 0
    for v in rows:
        while v:
            h = v.bit_length() - 1
            if h in piv: v ^= piv[h]
            else: piv[h] = v; r += 1; break
    return r


def check(inst, certs):
    X, Z, items, dim, dmask = load(inst)
    par = lambda a, b: bin(a & b).count('1') & 1
    bitc = lambda v, c: (v >> c) & 1
    def cov(q, c, k):  # entry (c,k) of the sum of x z^T over the pairs of item q
        b = 0
        for i, j in q: b ^= bitc(X[i], c) & bitc(Z[j], k)
        return b
    for q in items:  # each item is a partial frame
        for a, (i, _) in enumerate(q):
            for b, (_, j) in enumerate(q):
                assert par(X[i], Z[j]) == (a == b), 'item not a partial frame'
    shard_children = []
    for cert in certs:
        f = gzip.open(cert, 'rt')
        head = f.readline().split()
        assert head[0] == 'C16CERT' and head[1] == '1'
        h = dict(zip(head[2::2], map(int, head[3::2])))
        assert h['live_sides'] == 1 and h['items'] == len(items) and h['need'] == dim
        lines = iter(f)
        def tok():
            return next(lines).split()
        R0 = [(1 << c) if (dmask >> c) & 1 else 0 for c in range(128)]
        stats = {'B': 0, 'R': 0, 'E': 0, 'C': 0, 'K': 0, 'S': 0}
        mine = {}
        # iterative DFS: each frame of the stack holds the state of one node being expanded
        def node(R, need, live, path):
            t = tok(); kind = t[0]
            if need == 0:
                raise AssertionError(f'frame found at {path}: certificate claims {kind}')
            xs = {i for q in live for i, _ in items[q]}; zs = {j for q in live for _, j in items[q]}
            if kind == 'R':
                stats['R'] += 1
                xl = sorted(xs); zl = sorted(zs)
                rows = [sum(par(X[i], Z[j]) << b for b, j in enumerate(zl)) for i in xl]
                assert rank(rows) < need, f'rank leaf not justified at {path}'
                return
            c, k = int(t[1]), int(t[2])
            assert c >= 0 and (R[c] >> k) & 1, f'entry not 1 at {path}'
            covering = [q for q in live if cov(items[q], c, k)]
            if kind == 'E':
                stats['E'] += 1
                assert not covering, f'E leaf has candidates at {path}'
                return
            assert kind == 'B'; stats['B'] += 1
            m = int(t[3]); assert m == len(covering)
            listed = []; excluded = set(); marks = []
            for _ in range(m):
                ct = tok(); ck, q = ct[0], int(ct[1]); listed.append(q); marks.append((q, ck))
                assert q in live and cov(items[q], c, k)
                if ck == 'S':
                    stats['S'] += 1
                elif ck == 'K':
                    stats['K'] += 1; assert len(items[q]) > need
                else:
                    assert ck == 'C'; stats['C'] += 1
                    R2 = list(R)
                    for i, j in items[q]:
                        for cc in range(128):
                            if bitc(X[i], cc): R2[cc] ^= Z[j]
                    qx = [i for i, _ in items[q]]; qz = [j for _, j in items[q]]
                    ax = {i for i in xs if all(not par(X[i], Z[j]) for j in qz)} - set(qx)
                    az = {j for j in zs if all(not par(X[i], Z[j]) for i in qx)} - set(qz)
                    live2 = [r for r in live if r != q and r not in excluded
                             and all(i in ax and j in az for i, j in items[r])]
                    node(R2, need - len(items[q]), live2, path + [q])
                excluded.add(q)
            assert sorted(listed) == sorted(covering) and len(set(listed)) == len(listed)
            if len(path) == h['shard_depth']: mine[tuple(path)] = marks
        sys.setrecursionlimit(10000)
        node(R0, dim, list(range(len(items))), [])
        assert tok() == ['END', 'COMPLETE'], 'certificate not complete'
        shard_children.append(mine)
        print(cert, stats)
    # shards: same nodes at the shard depth, same children in the same order, and each child
    # handled (C or K) in exactly one file and skipped (S) in all others
    keys = set(shard_children[0])
    for sc in shard_children: assert set(sc) == keys, 'shards disagree on the tree above the shard depth'
    for key in keys:
        lists = [sc[key] for sc in shard_children]
        assert all([q for q, _ in l] == [q for q, _ in lists[0]] for l in lists)
        for t in range(len(lists[0])):
            assert sum(l[t][1] != 'S' for l in lists) == 1, f'child {lists[0][t][0]} of {key} not handled exactly once'
    print('CERTIFICATE OK: no frame')


if __name__ == '__main__':
    check(sys.argv[1], sys.argv[2:])
