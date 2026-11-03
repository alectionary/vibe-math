"""Reconstructed ReShape toric design, with two decoder implementations.

The source's exact probability grid, complements and tie conventions are not
archived. These runs preserve the named distances, not an asserted full figure.
"""
import json
from pathlib import Path
import numpy as np
from scipy.stats import norm
from gf2 import HGP, repetition

ROOT=Path(__file__).resolve().parents[1]


def decoded_failures(e):
    """Batched Algorithm 1, a coordinate complement, exact repetition oracles."""
    size=e.shape[2]
    left=e[:,0];right=e[:,1]
    syndrome=left^np.roll(left,-1,axis=1)^right^np.roll(right,1,axis=2)
    # A valid initial solution; both gauge reference coordinates are zero.
    r=np.zeros_like(right)
    parity=syndrome.sum(axis=1)%2
    for j in range(1,size):r[:,0,j]=r[:,0,j-1]^parity[:,j].astype(np.uint8)
    residual_syndrome=syndrome^r^np.roll(r,1,axis=2)
    l=np.zeros_like(left)
    for i in range(size-1):l[:,i+1]=l[:,i]^residual_syndrome[:,i]
    assert np.array_equal(l^np.roll(l,-1,axis=1)^r^np.roll(r,1,axis=2),syndrome)
    # Projection onto the complement supported on coordinate zero.
    ol=(l.sum(axis=2)%2).astype(np.uint8)
    ort=(r.sum(axis=1)%2).astype(np.uint8)
    l[:,:,0]^=(ol.sum(axis=1)>size/2).astype(np.uint8)[:,None]
    r[:,0,:]^=(ort.sum(axis=1)>size/2).astype(np.uint8)[:,None]
    error_l=left^l;error_r=right^r
    assert not (error_l^np.roll(error_l,-1,axis=1)^error_r^np.roll(error_r,1,axis=2)).any()
    fail=((error_l.sum(axis=2)%2).any(axis=1)|(error_r.sum(axis=1)%2).any(axis=1))
    return fail,l,r


def wilson(k,n,z):
    p=k/n;den=1+z*z/n;c=(p+z*z/(2*n))/den
    h=z*np.sqrt(p*(1-p)/n+z*z/(4*n*n))/den
    return [float(c-h),float(c+h)]


def main():
    rng=np.random.default_rng(20261103);validation=[]
    for size in [2,3,4]:
        c=HGP(repetition(size,True),repetition(size,True))
        # With even size tie conventions/gauge can differ, so compare off ties
        # and always verify low-weight correctness and syndrome validity.
        samples=rng.integers(0,2,size=(200,2,size,size),dtype=np.uint8)
        failures,l,r=decoded_failures(samples)
        agreement=0;off_tie=0
        for e,fail in zip(samples,failures):
            v=e.ravel();generic=bool(c.logical(v^c.correct(v)).any())
            tie=(e[0].sum(axis=1)%2).sum()==size/2 or (e[1].sum(axis=0)%2).sum()==size/2
            if not tie:
                off_tie+=1;agreement+=generic==bool(fail);assert generic==bool(fail)
        validation.append(dict(size=size,errors=200,off_tie=off_tie,off_tie_agreement=agreement))
    sizes=[6,8,10,20]
    rates=[.001,.002,.003,.004,.005,.0075,.01,.015,.02,.03,.05,.075,.1,.15]
    n=10000;family=len(sizes)*len(rates);z=norm.ppf(1-.05/(2*family));rows=[]
    for size in sizes:
        for p in rates:
            # Generator one: uniforms. Independent generator two: binomial,
            # split equally; preserve their distinct counts.
            e1=(rng.random((n//2,2,size,size))<p).astype(np.uint8)
            e2=rng.binomial(1,p,size=(n//2,2,size,size)).astype(np.uint8)
            k1=int(decoded_failures(e1)[0].sum());k2=int(decoded_failures(e2)[0].sum());k=k1+k2
            rows.append(dict(size=size,p=p,trials=n,failures=k,generator_failures=[k1,k2],failure_rate=k/n,
                             wilson95=wilson(k,n,norm.ppf(.975)),bonferroni_wilson95=wilson(k,n,z),
                             contrast_failure_minus_physical_rate=k/n-p))
    (ROOT/'results/toric_noise.json').write_text(json.dumps(dict(scope='reconstructed grid; original point grid and source counts not recovered',seed=20261103,
             family_size=family,alpha=.05,correction='Bonferroni Wilson approximate binomial intervals',validation=validation,rows=rows),indent=2)+'\n')
    import matplotlib
    matplotlib.use('Agg')
    import matplotlib.pyplot as plt
    for size in sizes:
        data=[r for r in rows if r['size']==size]
        plt.loglog([r['p'] for r in data],[r['failure_rate'] for r in data],'.-',label=f'd={size}')
    plt.loglog(rates,rates,'k--',label='unencoded p')
    plt.xlabel('Physical phase-flip probability');plt.ylabel('Logical failure probability')
    plt.legend();plt.title('ReShape: reconstructed toric grid, 10,000 trials per point')
    plt.tight_layout();plt.savefig(ROOT/'results/toric_noise.pdf');plt.savefig(ROOT/'results/toric_noise.png',dpi=180)


if __name__=='__main__':main()
