"""Read-only replay of negative four-anchor pilot archives and last pricing.

This validates discovery provenance, not projected membership or infeasibility.
Also recovers an exact four-Bernoulli distribution for the ten P/PP moments.
"""
from pathlib import Path
from fractions import Fraction
import argparse,json,time
import numpy as np
from scipy.optimize import linprog
from verify_four_anchor_full_partner import read,sha,features,target
from verify_full_partner_basis_oracle import rebuild_domain,dimension,extend
from verify_algebraic_model import physical

def exact_solve(A,b):
    rows=[[Fraction(int(v)) for v in row]+[rhs] for row,rhs in zip(A,b)];n=len(A[0]);pivots=[];cursor=0
    for j in range(n):
        hit=next((i for i in range(cursor,len(rows)) if rows[i][j]),None)
        if hit is None:continue
        rows[cursor],rows[hit]=rows[hit],rows[cursor];d=rows[cursor][j];rows[cursor]=[v/d for v in rows[cursor]]
        for i in range(len(rows)):
            if i!=cursor and rows[i][j]:d=rows[i][j];rows[i]=[a-d*b for a,b in zip(rows[i],rows[cursor])]
        pivots.append(j);cursor+=1
    assert all(any(row[:n]) or row[-1]==0 for row in rows) and len(pivots)==n
    x=[Fraction(0)]*n
    for i,j in enumerate(pivots):x[j]=rows[i][-1]
    assert all(sum(Fraction(int(v))*a for v,a in zip(row,x))==bb for row,bb in zip(A,b))
    return x
def main():
    ap=argparse.ArgumentParser();ap.add_argument('--report',type=Path,required=True);ap.add_argument('--point',type=Path,required=True);ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();assert not a.output.exists();start=time.monotonic();report=read(a.report);assert report['status']=='NO_EXACT_SEPARATOR_FOUND' and report['point_sha256']==sha(a.point)
    assert all(sha(Path(__file__).parent/p)==h for p,h in report['source_hashes'].items());archive=Path(report['columns_artifact']);assert sha(archive)==report['columns_sha256'];data=np.load(archive);anchors=report['anchors'];X,Z,_=physical();tar=target(a.point,anchors);b=np.array(list(map(float,tar)));physical_checks=0
    for mask,basis,f in zip(data['masks'],data['selected_Z_indices'],data['features']):
        m=int(mask);B=list(map(int,basis));assert len(B)==len(set(B))==128 and all(0<=j<720 for j in B) and dimension(Z[j] for j in B)==128
        selected=[anchors[i] for i in range(4) if m>>i&1];sig=[sum(((X[x]&Z[j]).bit_count()%2)<<k for k,x in enumerate(selected)) for j in B]
        assert all(s.bit_count()<=1 for s in sig) and all(sig.count(1<<k)==1 for k in range(len(selected)))
        assert np.array_equal(f,features(m,B));physical_checks+=1
    weights=data['master_mixture_weights'];assert min(weights)>=0 and abs(sum(weights)-1)<1e-10;x=weights@data['features'].astype(float);residual=float(max(abs(x-b)));assert abs(residual-report['numeric_mixture_max_feature_residual'])<1e-12
    raw=b-x;raw[0]=0;c=[int(np.rint(v/max(abs(raw))*report['pricing_scale'])) for v in raw];last=next(r for r in reversed(report['rounds']) if 'exact_upper' in r);exact=sum(v*t for v,t in zip(c,tar));assert str(exact)==last['exact_target'];upper=[];prefixes=0
    for m in range(16):
        selected=sorted(anchors[i] for i in range(4) if m>>i&1);d=rebuild_domain(X,Z,selected,128)
        if d['status']!='FULL_PARTNER_BASIS_DOMAIN':continue
        w=[c[11+j]+sum(c[731+720*i+j] for i in range(4) if m>>i&1) for j in range(720)];order=sorted(d['zero'],key=lambda j:(-w[j],j));rows={};z=0
        for j in order:
            old=len(rows);extend(rows,Z[j]);z+=(len(rows)-old)*w[j];prefixes+=1
        local=sum(v*f for v,f in zip(c[:11],features(m,[])[:11]));upper.append(local+z+sum(max(w[j] for j in A) for A in d['bins']))
    assert max(upper)==last['exact_upper'] and str(exact-max(upper))==last['exact_gap']
    A=np.array([features(m,[])[:11] for m in range(16)],dtype=int).T;lp=linprog(np.zeros(16),A_eq=A,b_eq=b[:11],bounds=(0,None),method='highs');assert lp.success;ids=np.flatnonzero(lp.x>1e-9);rational=exact_solve(A[:,ids],tar[:11]);assert min(rational)>=0 and sum(rational)==1
    out={'status':'PASS_NEGATIVE_PILOT_REPLAY','source_C16_answered':False,'projected_membership_proved':False,'report_sha256':sha(a.report),'archive_sha256':sha(archive),'consumer_sha256':sha(Path(__file__)),'point_sha256':sha(a.point),'anchors':anchors,'physical_columns_checked':physical_checks,'last_support_all_patterns_checked':16,'last_support_prefix_rank_checks':prefixes,'last_exact_support':max(upper),'last_exact_target':str(exact),'last_exact_gap':str(exact-max(upper)),'numeric_mixture_mass':float(sum(weights)),'numeric_mixture_minimum_weight':float(min(weights)),'numeric_mixture_max_residual':residual,'four_Bernoulli_local_polytope_exact':{'status':'PASS','masks':list(map(int,ids)),'weights':list(map(str,rational)),'equations_checked':11},'elapsed_seconds':time.monotonic()-start,'scope':'All saved physical columns, target mapping and final exact support independently replayed. Exact P/PP marginal membership alone is proved; full P/Q moment mixture is numerical and incomplete.'};a.output.write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(out),flush=True)
if __name__=='__main__':main()
