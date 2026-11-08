#!/usr/bin/env python3
"""Select a permutation submatrix of the logical pairing matrix.

Exactly k selected X rows and k selected Z columns, each with selected degree
one, give a k-pair CSS frame. For k=128 their Gram matrix is a permutation
matrix and hence both sectors are automatically bases. No partner restriction
or symmetry assumption is used. UNKNOWN is not an exclusion certificate.
"""
import argparse
import json
from collections import defaultdict
from itertools import combinations
from pathlib import Path
from ortools.sat.python import cp_model


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--pairs', type=int, default=128)
    ap.add_argument('--seconds', type=float, default=300)
    ap.add_argument('--workers', type=int, default=4)
    ap.add_argument('--seed', type=int, default=0)
    ap.add_argument('--output', type=Path)
    ap.add_argument('--log', action='store_true')
    ap.add_argument('--seed4-cap', type=int, help='Use only after the corresponding exclusion is checked.')
    ap.add_argument('--maximize', action='store_true')
    ap.add_argument('--hint', type=Path, help='JSON with zero-based pool_pairs.')
    args = ap.parse_args()
    root = Path(__file__).parent
    X = [int(s,16) for s in (root/'pools/xcoords.txt').read_text().split()]
    Z = [int(s,16) for s in (root/'pools/zcoords.txt').read_text().split()]
    anti = [[j for j,z in enumerate(Z) if (x&z).bit_count()%2] for x in X]
    trans = [[i for i,row in enumerate(anti) if j in row] for j in range(len(Z))]
    model = cp_model.CpModel()
    xs = [model.new_bool_var(f'x{i}') for i in range(len(X))]
    zs = [model.new_bool_var(f'z{j}') for j in range(len(Z))]
    if args.maximize:
        model.add(sum(xs)==sum(zs))
        model.add(sum(xs)<=128)
        model.maximize(sum(xs))
    else:
        model.add(sum(xs)==args.pairs)
        model.add(sum(zs)==args.pairs)
    if args.seed4_cap is not None:
        ids=[i for i,x in enumerate(X) if x.bit_count()==1 and ((x>>64)&65535)]
        assert len(ids)==16
        # Sector exchange sends pool X_i to Z_i. Its Gram matrix is symmetric.
        assert all((j in anti[i])==(i in anti[j]) for i in range(len(X)) for j in range(len(Z)))
        model.add(sum(xs[i] for i in ids)<=args.seed4_cap)
        model.add(sum(zs[i] for i in ids)<=args.seed4_cap)
    # Every induced matching is independent on either side, even if partial.
    # Explicit small dependency circuits strengthen propagation.
    for values,variables in [(X,xs),(Z,zs)]:
        indices={v:i for i,v in enumerate(values)}
        pair_sums=defaultdict(list)
        circuits=set()
        for i,a in enumerate(values):
            for j in range(i):
                value=a^values[j]
                pair_sums[value].append((i,j))
                if value in indices: circuits.add(tuple(sorted((i,j,indices[value]))))
        for pairs in pair_sums.values():
            for p,q in combinations(pairs,2):
                circuit=tuple(sorted(p+q))
                if len(set(circuit))==4: circuits.add(circuit)
        for circuit in circuits:
            model.add(sum(variables[i] for i in circuit)<=len(circuit)-1)
    for i,js in enumerate(anti):
        degree = sum(zs[j] for j in js)
        model.add(degree==1).only_enforce_if(xs[i])
        if args.pairs==128 and not args.maximize: model.add(degree>=1)
    for j,its in enumerate(trans):
        degree = sum(xs[i] for i in its)
        model.add(degree==1).only_enforce_if(zs[j])
        if args.pairs==128 and not args.maximize: model.add(degree>=1)
    # A basis contains at most dim(V) members in any subspace V. Coordinate
    # block subspaces supply cheap, independently valid redundant rank cuts.
    if args.pairs==128:
        for values,variables in [(X,xs),(Z,zs)]:
            for mask in range(1,255):
                allowed=sum(65535 << (16*b) for b in range(8) if mask>>b&1)
                ids=[i for i,v in enumerate(values) if v&~allowed==0]
                if not ids: continue
                piv={}
                for i in ids:
                    v=values[i]
                    while v:
                        p=v.bit_length()-1
                        if p not in piv: piv[p]=v;break
                        v^=piv[p]
                if len(ids)>len(piv): model.add(sum(variables[i] for i in ids)<=len(piv))
    solver=cp_model.CpSolver()
    if args.hint:
        pairs=json.loads(args.hint.read_text())['pool_pairs']
        selectedX={i for i,j in pairs}; selectedZ={j for i,j in pairs}
        for i,v in enumerate(xs): model.add_hint(v,int(i in selectedX))
        for j,v in enumerate(zs): model.add_hint(v,int(j in selectedZ))
    solver.parameters.max_time_in_seconds=args.seconds
    solver.parameters.num_search_workers=args.workers
    solver.parameters.random_seed=args.seed
    solver.parameters.log_search_progress=args.log
    status=solver.solve(model)
    result={'status':solver.status_name(status),'pairs_requested':args.pairs,
            'wall_seconds':solver.wall_time,'branches':solver.num_branches,
            'conflicts':solver.num_conflicts,'seed':args.seed,'workers':args.workers}
    result['seed4_cap']=args.seed4_cap
    result['maximize']=args.maximize
    if args.maximize:
        result['objective']=solver.objective_value
        result['best_bound']=solver.best_objective_bound
    if status in (cp_model.OPTIMAL,cp_model.FEASIBLE):
        chosenX=[i for i,v in enumerate(xs) if solver.value(v)]
        chosenZ=[j for j,v in enumerate(zs) if solver.value(v)]
        pairs=[]
        for i in chosenX:
            js=[j for j in chosenZ if j in anti[i]]
            assert len(js)==1
            pairs.append([i,js[0]])
        expected=len(chosenX) if args.maximize else args.pairs
        assert len(set(j for _,j in pairs))==expected
        assert all(((X[i]&Z[j]).bit_count()%2)==(a==b)
                   for a,(i,_) in enumerate(pairs) for b,(_,j) in enumerate(pairs))
        result['pool_pairs']=pairs
    print(json.dumps(result,indent=2),flush=True)
    if args.output: args.output.write_text(json.dumps(result,indent=2)+'\n')


if __name__=='__main__': main()
