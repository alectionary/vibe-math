"""Frozen finite validation domain, including composite and even lifts."""
import json,sys,time,subprocess
from itertools import combinations, product
from collections import Counter
from pathlib import Path
ROOT=Path(__file__).resolve().parent
from research import direct_counts, rooted_counts, projected_counts, check_graph
from formula import cyclic_formula


def local_patterns():
    multi=[frozenset(s) for k in (2,3,4) for s in combinations(range(4),k)]
    graphs=0;types=Counter()
    for bits in range(1<<len(multi)):
        rows=[s for i,s in enumerate(multi) if bits>>i&1]
        if any(sum({a,b}<=s for s in rows)>1 for a,b in combinations(range(4),2)):
            continue
        degrees=[sum(v in s for s in rows) for v in range(4)]
        if max(degrees,default=0)>3:continue
        rows += [frozenset([v]) for v in range(4) for _ in range(3-degrees[v])]
        cols=[frozenset(i for i,s in enumerate(rows) if v in s) for v in range(4)]
        d,_=direct_counts(cols);r,_,_=rooted_counts(cols);p=projected_counts(cols)
        for b in (0,2):assert d.get(b,0)==r.get(b,0)
        assert d.get(2,0)==p['N42'] and d.get(0,0)==p['N40']
        graphs+=1;types[str(d)]+=1
    return dict(candidate_multi_check_families=1<<len(multi),valid_local_patterns=graphs,
                count_types=dict(types))


def matrix_masks(M,ell):
    """Separate row/column polynomial expansion, not the socket lift helper."""
    n=6*ell
    masks=[0]*n
    for r in range(3):
        for c in range(3):
            e=M[r][c]
            for a in range(ell):
                masks[c*ell+a] |= 1<<(r*ell+(a+e)%ell)
        for a in range(ell):
            for e in (0,1,3):masks[(3+r)*ell+a] |= 1<<(r*ell+(a-e)%ell)
    return masks


def main():
    start=time.monotonic();local=local_patterns();print('local',json.dumps(local),flush=True)
    totals={};out=(ROOT/'exhaustive-cases.txt').open('w')
    for ell in (7,8,9,10):
        tried=valid=nonzero=0;hist=Counter()
        for a,b,c,d in product(range(ell),repeat=4):
            tried+=1
            M=[[0,0,0],[0,a,b],[0,c,d]]
            if any(len({(M[r][u]-M[r][v])%ell for r in range(3)})!=3
                   for u,v in combinations(range(3),2)):continue
            sockets=[[(r,M[r][p]) for r in range(3)] for p in range(3)]
            sockets += [[(r,-e%ell) for e in (0,1,3)] for r in range(3)]
            f=cyclic_formula(sockets,ell)
            n42=f['N42'];valid+=1;nonzero+=bool(n42);hist[n42]+=1
            masks=matrix_masks(M,ell)
            assert all(x.bit_count()==3 for x in masks)
            assert all((x&y).bit_count()<=1 for x,y in combinations(masks,2))
            out.write(f'{len(masks)} {n42}\n')
            out.write('\n'.join(f'{x&((1<<64)-1)} {x>>64}' for x in masks)+'\n')
        totals[ell]=dict(normalized_matrices=tried,no_four_cycle_cases=valid,
                         positive_count_cases=nonzero,count_histogram=dict(sorted(hist.items())))
        print('ell',ell,json.dumps(totals[ell]),'seconds',time.monotonic()-start,flush=True)
    out.close()
    result=dict(local=local,cyclic=totals,seconds=time.monotonic()-start,
                domain='All normalized 3x3 monomial exponent arrays, ell=7,8,9,10; b=1+x+x^3; only no-four-cycle graphs')
    (ROOT/'validation-results.json').write_text(json.dumps(result,indent=2))


if __name__=='__main__':main()
