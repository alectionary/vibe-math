#!/usr/bin/env python3
"""Target-independent contracted binary-matroid rank-at-most-three bank.

Nontrivial parallel classes, complete three-point lines and closures of
four-circuits suffice, together with boxes/nonnegativity, for all rank<=3
inequalities. A finite simple rank-three decomposition control is included.
"""
from pathlib import Path
from collections import defaultdict, Counter
from itertools import combinations
import argparse, hashlib, json, time
from verify_two_sided_full_basis_oracle import physical_source, domains

ROOT=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def basis(values):
    piv={}
    for value in values:
        while value:
            k=value.bit_length()-1
            if k in piv:value^=piv[k]
            else:piv[k]=value;break
    return piv
def reduce(value,piv):
    for k in sorted(piv,reverse=True):
        if value>>k&1:value^=piv[k]
    return value
def rank_three_control():
    counts=Counter()
    for mask in range(128):
        E=[i+1 for i in range(7) if mask>>i&1];r=len(basis(E))
        four=[q for q in combinations(E,4) if q[0]^q[1]^q[2]^q[3]==0]
        if r<3:counts['lower_rank']+=1;continue
        if four:
            q=four[0];assert len(basis(q))==3;counts['contains_four_circuit']+=1
        else:
            triangles=[q for q in combinations(E,3) if q[0]^q[1]^q[2]==0]
            assert len(triangles)<=1
            if triangles:
                remaining=set(E)-set(triangles[0]);assert len(remaining)==1
                assert len(basis(triangles[0]))+len(basis(remaining))==r
                counts['triangle_plus_coloop']+=1
            else:
                assert len(E)==r;counts['independent_singletons']+=1
    assert sum(counts.values())==128
    return dict(subsets_checked=128,cases=dict(counts),claim='Every simple binary rank-three restriction contains a four-circuit, or is a direct sum of a triangle and a coloop, or is independent.')
def geometry(U,d,m):
    F=list(d['zero_forced']);P=basis(U[j] for j in F);assert len(P)==len(F)
    groups=defaultdict(list)
    for j in d['zero_free']:groups[reduce(U[j],P)].append(j)
    loops=groups.get(0,[]);values=sorted(v for v in groups if v);records={}
    def add(vs,r,gens):
        A=sorted(loops+[j for v in vs for j in groups.get(v,[])])
        assert len(basis([U[j] for j in F+A]))==len(F)+r
        generators=[groups[v][0] for v in gens]
        assert len(basis([U[j] for j in F+generators]))==len(F)+r
        records[(r,tuple(A))]=dict(mask=m,forced_zero_indices=F,indices=A,contraction_rank=r,
            physical_span_rank=len(F)+r,quotient_generator_indices=generators)
    if loops:add([],0,[])
    for v in values:
        if len(groups[v])>1:add([v],1,[v])
    sums=defaultdict(list)
    for i,v in enumerate(values):
        for w in values[i+1:]:
            s=v^w;sums[s].append((v,w))
            if w<s and s in groups:add([v,w,s],2,[v,w])
    for pairs in sums.values():
        for (v,w),(u,t) in combinations(pairs,2):
            assert len({v,w,u,t})==4 and v^w^u^t==0
            span={v,w,u,v^w,v^u,w^u,v^w^u};assert len(span)==7
            add(sorted(span & groups.keys()),3,[v,w,u])
    rows=[records[k] for k in sorted(records)]
    return dict(mask=m,forced_zero_indices=F,zero_free_indices=d['zero_free'],
        contracted_rank=d['zero_required']-len(F),quotient_nonzero_classes=len(values),
        quotient_loop_count=len(loops),rows_by_rank=dict(sorted(Counter(row['contraction_rank'] for row in rows).items())),
        rows=rows)
def main():
    ap=argparse.ArgumentParser();ap.add_argument('--X-anchors',type=int,nargs=2,required=True);ap.add_argument('--Z-anchors',type=int,nargs=2,required=True)
    ap.add_argument('--side',choices=['X','Z'],required=True);ap.add_argument('--output',type=Path,required=True)
    a=ap.parse_args();assert not a.output.exists();start=time.monotonic()
    sources={p:sha(ROOT/p) for p in [Path(__file__).name,'verify_two_sided_full_basis_oracle.py','verify_algebraic_model.py','physical-pool-source.json','pools/xcoords.txt','pools/zcoords.txt']}
    frozen=dict(status='FROZEN_TARGET_INDEPENDENT_SMALL_FLAT_GEOMETRY',X_anchors=a.X_anchors,Z_anchors=a.Z_anchors,side=a.side,
        source_hashes=sources,patterns=list(range(16)),rank_limit=3,allocation_or_point_used=False)
    fp=a.output.with_suffix('.frozen.json');assert not fp.exists();fp.write_text(json.dumps(frozen,indent=2)+'\n')
    X,Z,_=physical_source();U=X if a.side=='X' else Z;dd=domains(X,Z,a.X_anchors,a.Z_anchors)
    assert len(dd)==16 and all(d['feasible'] for d in dd)
    patterns=[geometry(U,d[a.side],m) for m,d in enumerate(dd)]
    out=dict(frozen);out.update(status='EXACT_CONTRACTED_RANK3_GEOMETRY_REQUIRES_REPLAY',frozen_sha256=sha(fp),
        rank_three_decomposition_control=rank_three_control(),patterns=patterns,
        rows=[row for pattern in patterns for row in pattern['rows']],
        coverage_claim='Together with coordinate boxes and nonnegativity, these rows imply every zero-matroid rank inequality of contracted rank at most three. No claim for rank four or higher.',
        all_subset_rank_membership_proved=False,global_target_nonmembership_proved=False,source_C16_answered=False,
        elapsed_seconds=time.monotonic()-start)
    assert all(sha(ROOT/p)==h for p,h in sources.items())
    a.output.write_text(json.dumps(out,indent=2)+'\n')
    print(json.dumps(dict(status=out['status'],patterns=len(patterns),rows=len(out['rows']),rows_by_rank=dict(Counter(r['contraction_rank'] for r in out['rows'])),seconds=out['elapsed_seconds'])),flush=True)
if __name__=='__main__':main()
