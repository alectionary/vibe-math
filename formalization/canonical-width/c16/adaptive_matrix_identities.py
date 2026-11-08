#!/usr/bin/env python3
"""Residual-guided necessary full-matrix equations; no SAT completion claims."""
from pathlib import Path
import argparse
import json
import time
from signature_cover import logical_data, encode

ROOT = Path(__file__).resolve().parent


def parity(x, z):
    return (x & z).bit_count() % 2


def compress(selected, signatures, target):
    piv = {}
    for k in selected:
        value, combination = signatures[k], 1 << k
        while value:
            p = value.bit_length() - 1
            if p not in piv:
                piv[p] = value, combination
                break
            w, c = piv[p]
            value ^= w
            combination ^= c
    combination = 0
    while target:
        p = target.bit_length() - 1
        assert p in piv
        w, c = piv[p]
        target ^= w
        combination ^= c
    return [k for k in selected if combination >> k & 1]


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--output', type=Path, required=True)
    ap.add_argument('--seconds', type=float, default=180)
    ap.add_argument('--call-seconds', type=float, default=3)
    ap.add_argument('--rounds', type=int, default=24)
    a = ap.parse_args()
    import pycryptosat
    start = time.monotonic()
    A, _, _ = logical_data()
    X, Z = [[int(s, 16) for s in (ROOT/f'pools/{side}coords.txt').read_text().split()] for side in ['x', 'z']]
    x0 = z0 = 48
    E = [(i,j,0,0) for i in range(720) if i != x0 and not A[i] >> z0 & 1
         for j in range(720) if j != z0 and not A[x0] >> j & 1 and A[i] >> j & 1]
    clauses, n, _, _ = encode(A, [0], E, with_xor=False)
    solver = pycryptosat.Solver(threads=1, options={'minmatrixrows':'0', 'maxmatrixrows':'1000', 'autodisablegauss':'0'})
    for c in clauses:
        solver.add_clause(c)
    equations, signatures, target = [], [0]*len(E), 0

    def add(u, v, label):
        nonlocal target
        k = len(equations)
        bit = 1 << k
        expected = parity(u,v)
        anchor = parity(X[x0],v)*parity(u,Z[z0])
        xp = [parity(x,v) for x in X]
        zp = [parity(u,z) for z in Z]
        vs = []
        for q,(i,j,_,_) in enumerate(E):
            if xp[i] and zp[j]:
                vs.append(q+1)
                signatures[q] |= bit
        if expected ^ anchor:
            target |= bit
        solver.add_xor_clause(vs, bool(expected ^ anchor))
        equations.append({'u_hex':hex(u),'v_hex':hex(v),'label':label,'full_target':expected,'anchor_value':anchor,'free_edges_with_value_one':len(vs)})

    for t in range(16):
        add(X[608+t], Z[608+t], f'old-source-{608+t}')
    stages = ['old16', 'source32', 'zero33']
    records = []
    for iteration in range(a.rounds):
        if time.monotonic()-start >= a.seconds:
            break
        if iteration == 1:
            for t in range(16):
                q = 704 + (1+t)%16
                add(X[q], Z[q], f'new-source-{q}')
        elif iteration == 2:
            add(1<<2, 1, 'zero-entry-0-2')
        call_start = time.monotonic()
        sat, model = solver.solve(time_limit=min(a.call_seconds, max(.01,a.seconds-(time.monotonic()-start))))
        record = {'iteration':iteration,'stage':stages[iteration] if iteration<3 else 'adaptive', 'equation_count':len(equations),'answer':sat,'call_seconds':time.monotonic()-call_start,'elapsed_seconds':time.monotonic()-start}
        if sat:
            chosen = compress([k for k in range(len(E)) if model[k+1]], signatures, target)
            pairs = [(x0,z0)] + [E[k][:2] for k in chosen]
            R = [1<<i for i in range(128)]
            for q,(i,j) in enumerate(pairs):
                assert A[i]>>j&1
                for ii,jj in pairs[:q]:
                    assert i!=ii and j!=jj and not A[i]>>jj&1 and not A[ii]>>j&1
                for b in range(128):
                    if X[i]>>b&1:
                        R[b] ^= Z[j]
            for eq in equations:
                u,v = int(eq['u_hex'],16),int(eq['v_hex'],16)
                assert sum(parity(X[i],v)*parity(u,Z[j]) for i,j in pairs)%2 == eq['full_target']
            record['partial_matching'] = pairs
            record['partial_size'] = len(pairs)
            record['residual_rows_hex'] = [hex(r) for r in R]
            if len(pairs)==128:
                assert not any(R)
                records.append(record)
                break
            # A violated matrix entry supplies an independent necessary equation.
            # The initially prescribed32/33 comparisons are kept separate.
            if iteration >= 2:
                row = next(i for i,r in enumerate(R) if r)
                col = (R[row]&-R[row]).bit_length()-1
                record['selected_next_equation'] = [row,col]
                add(1<<col,1<<row,f'adaptive-entry-{row}-{col}')
        records.append(record)
        print(record['stage'],len(equations),'equations',sat,'partial size',record.get('partial_size'),'seconds',time.monotonic()-start,flush=True)
        a.output.write_text(json.dumps({'status':'DISCOVERY_ONLY','anchor':[x0,z0],'edge_count':len(E),'equations':equations,'records':records,'source_C16_answered':False,'elapsed_seconds':time.monotonic()-start},indent=2)+'\n')
        if sat is False or (sat is None and iteration>=2):
            break


if __name__ == '__main__':
    main()
