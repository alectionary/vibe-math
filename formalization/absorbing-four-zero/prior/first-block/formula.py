"""Incidence-corrected pair formula and its Fourier form for cyclic lifts."""
from itertools import product, permutations, combinations
from collections import Counter
import cmath, json
from pathlib import Path


def cyclic_formula(sockets,ell,fourier=False):
    """Return exact integer count and optional independently evaluated Fourier sum.

    The input contains exactly the three occupied (row type, exponent) sockets
    per variable type. Assumes the expanded binary Tanner graph has no 4-cycle.
    Rooted completions are solved using modular arithmetic, never ell-fold rows.
    """
    sockets=[tuple((r,e%ell) for r,e in col) for col in sockets]
    nr=1+max(r for col in sockets for r,e in col)
    nc=len(sockets)
    assert all(len(set(col))==3 for col in sockets)
    def nb(p,t):return {(r,(t+e)%ell) for r,e in sockets[p]}
    def completion(x,y):
        found=set()
        for p,col in enumerate(sockets):
            for k,l in permutations(range(3),2):
                rk,ek=col[k];rl,el=col[l]
                t=(x[1]-ek)%ell
                if rk==x[0] and rl==y[0] and (t+el)%ell==y[1]:
                    found.add((p,t))
        assert len(found)<=1
        return found
    raw=0; roots=[];distribution=Counter();max_fourier_error=0.
    for p,q in product(range(nc),repeat=2):
        for i,j in product(range(3),repeat=2):
            ri,ei=sockets[p][i];rj,ej=sockets[q][j]
            delta=(ei-ej)%ell
            if ri!=rj or (p==q and delta==0):continue
            shared=(ri,ei)
            assert nb(p,0)&nb(q,delta)=={shared}
            W=set()
            for a,b in product(nb(p,0)-{shared},nb(q,delta)-{shared}):
                W |= completion(a,b)
            assert len(W)<=4
            assert (p,0) not in W and (q,delta) not in W
            assert all(shared not in nb(*w) for w in W)
            t=len(W)
            edge_pairs=[(w,z) for w,z in combinations(sorted(W),2) if nb(*w)&nb(*z)]
            e=len(edge_pairs)
            term=t*t-t-2*e
            assert term>=0 and term%2==0
            raw+=term;distribution[(t,e)]+=1
            root=dict(p=p,q=q,i=i,j=j,delta=delta,W=sorted(W),t=t,
                      induced_W_edges=e,term=term)
            if fourier:
                spectral_energy=0.
                for f in range(ell):
                    phase=lambda k:cmath.exp(-2j*cmath.pi*f*k/ell)
                    bhat=[sum(phase(a) for r,a in W if r==v) for v in range(nc)]
                    y=[sum(phase(e)*bhat[v] for v,col in enumerate(sockets)
                           for s,e in col if s==r) for r in range(nr)]
                    spectral_energy+=sum(abs(x)**2 for x in y)/ell
                # ||H b||^2 = b^T (A_VN + 3I) b = 2 e(W) + 3 t.
                err=abs(spectral_energy-(2*e+3*t))
                max_fourier_error=max(max_fourier_error,err)
                assert err<1e-7
                assert abs((t*t+2*t-spectral_energy)-term)<1e-7
                root['spectral_energy']=spectral_energy
            roots.append(root)
    assert ell*raw%4==0
    return dict(N42=ell*raw//4,ell=ell,variable_types=nc,check_types=nr,
                raw_sum=raw,number_of_roots=len(roots),
                root_distribution={f't={t},edges={e}':c for (t,e),c in sorted(distribution.items())},
                max_fourier_error=max_fourier_error if fourier else None,roots=roots)


def main():
    from research import qc_ghp
    w=json.loads(Path('work/absorbing42/cubic-matched-witness.json').read_text())
    results={}
    for name in ['A','B']:
        sockets,_=qc_ghp(w[name])
        results['matched_'+name]=cyclic_formula(sockets,7,True)
    sockets=json.loads(Path('work/absorbing42/source882-sockets.json').read_text())
    results['source882']=cyclic_formula(sockets,63,True)
    Path('work/absorbing42/formula-results.json').write_text(json.dumps(results,indent=2))
    print(json.dumps({k:{a:b for a,b in v.items() if a!='roots'} for k,v in results.items()},indent=2))


if __name__=='__main__':main()
