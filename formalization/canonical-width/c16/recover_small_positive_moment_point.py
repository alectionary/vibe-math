#!/usr/bin/env python3
"""Exact recovery using positive pivot variables, followed by independent consumers."""
from pathlib import Path
from fractions import Fraction
import argparse,gzip,hashlib,json,time
import numpy as np
from scipy.linalg import qr
from flint import fmpq,fmpq_mat
from certify_profile_moment_point import layout,equalities,verify
ROOT=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def main():
    ap=argparse.ArgumentParser();ap.add_argument('--numeric',type=Path,required=True);ap.add_argument('--certificate',type=Path,required=True);ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();start=time.monotonic()
    hp=ROOT/'algebraic-results/hulls-16-rank.json.gz';cp=ROOT/'algebraic-results/orbit-rank-profiles-independent.json';kp=ROOT/'algebraic-results/conditional-capacity/independent.json';xp=ROOT/'algebraic-results/conditional-cross-capacity/independent.json'
    wp=[ROOT/'algebraic-results/conditional-facets-round1-independent.json',ROOT/'moment-resumption-results/all-pair-moment-faces.json'];bp=[ROOT/'relevant-results/seed-cuts.json',ROOT/'moment-resumption-results/all-pair-word-cuts.json']
    hulls=json.loads(gzip.decompress(hp.read_bytes()));caps=json.loads(cp.read_text());cond=json.loads(kp.read_text());cross=json.loads(xp.read_text());weighted=[json.loads(p.read_text()) for p in wp];zeros=set()
    for report in weighted:
        assert report['status']=='PASS'
        for cut in report['cuts']:
            if cut['bound']==0 and all(c>=0 for c in cut['coefficients']):
                for h,c in enumerate(cut['coefficients']):
                    if c:
                        i,j=cut['anchor_orbit'],cut['orbit']
                        if h>8:h=16-h;i,j=j,i
                        zeros.add(('S' if cut['sector']=='X' else 'T',h,i,j))
    names,index,m=layout(hulls);A,b=equalities(hulls,index,m,sorted(zeros));z=np.load(a.numeric)
    x=np.array([float(z['p'][k[1]]) if k[0]=='p' else float(z[f'{k[0]}{k[1]}'][k[2],k[3]]) if k[0] in ('S','T') else float(z[f'w{k[1]}'][k[2]]) for k in names])
    # Clipping is only candidate construction. Every exact inequality is checked
    # below; no clipped floating result is treated as a certificate.
    x=np.maximum(x,0)
    for row in zeros:x[m(*row)]=0
    G=(A@A.T).toarray().astype(float);_,rr,perm=qr(G,pivoting=True);rank=int(np.sum(abs(np.diag(rr))>1e-7));rr=perm[:rank];Ar=A[rr,:]
    eligible=np.flatnonzero(x>1e-10);rng=np.random.default_rng(20261030);candidates=list(range(45))+[m(*r) for r in zeros]+list(rng.choice(eligible,min(9000,len(eligible)),replace=False))
    for o in range(45):
        ids=[k for k,key in enumerate(names) if key[0]=='w' and key[1]==o and x[k]>1e-10];candidates.extend(sorted(ids,key=lambda k:x[k],reverse=True)[:60])
    cols=np.unique(candidates);_,rr2,perm=qr(Ar[:,cols].toarray().astype(float),pivoting=True,mode='economic');assert abs(rr2[rank-1,rank-1])>1e-8;cols=cols[perm[:rank]]
    D=1<<50;n=np.rint(x*D).astype(np.int64);res=b*D-A@n;B=Ar[:,cols].toarray();print('SMALL_POSITIVE_PIVOT_RECOVERY',A.shape,rank,'minimum_variable',float(min(x[c] for c in cols if x[c]>0)),flush=True)
    delta=fmpq_mat(B.tolist()).solve(fmpq_mat([[int(t)] for t in res[rr]]));values=[fmpq(int(t),D) for t in n]
    for k,c in enumerate(cols):values[c]+=delta[k,0]/D
    data={'status':'CANDIDATE_REQUIRES_INDEPENDENT_REPLAY','source_C16_answered':False,'values':list(map(str,values)),'inputs':{p.name:sha(p) for p in [hp,cp,kp]},'row_rank_search':rank,'forced_zero_coordinates':sorted(zeros),'recovery':'Exact correction restricted to positive numeric variables and explicitly forced-zero entries; no new source assumptions.'}
    a.certificate.write_bytes(gzip.compress((json.dumps(data)+'\n').encode(),mtime=0))
    result=verify(data,hulls,caps,cond,cross,weighted)
    # Independent direct source-pattern formula, not the sparse matrix compiler.
    v=list(map(Fraction,data['values']));checked=0;minimum=None
    for path in bp:
        for cut in json.loads(path.read_text())['cuts']:
            assert cut['kind'] in ('universal_sparse_quotient','universal_sparse_quotient_four');J=cut['indices']
            for anchor in J:
                slack=(len(J)-2)*v[index['p',anchor//16]]-sum(v[m('S',(other-anchor)%16,anchor//16,other//16)] for other in J if other!=anchor)
                assert slack>=0,('forbidden_pattern',str(path),J,anchor,str(slack));minimum=slack if minimum is None else min(minimum,slack);checked+=1
    result.update(status='PASS',certificate_sha256=sha(a.certificate),numeric_sha256=sha(a.numeric),numeric_c16_path=str(a.numeric.resolve().relative_to(ROOT)),source_pattern_conditioned_rows_including_duplicates=checked,minimum_exact_pattern_slack=str(minimum),all_four_word_pair_faces=True,additional_source_hashes={str(p.relative_to(ROOT)):sha(p) for p in [*wp,*bp]},elapsed_seconds=time.monotonic()-start)
    result['scope']='Exact feasible point of the degree-two profile/capacity/weighted relaxation with all four checked forbidden pairs and all stated conditioned forbidden-pattern inequalities. Not a physical frame or common probability distribution; original width remains undecided.'
    a.output.write_text(json.dumps(result,indent=2)+'\n');print(result,flush=True)
if __name__=='__main__':main()
