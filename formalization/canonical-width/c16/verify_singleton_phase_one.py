#!/usr/bin/env python3
"""Exact independent phase-I LP, primal/dual and physical greedy replay.

A positive restricted distance is not a global obstruction. Only the full
physical greedy support can certify separation from all zero-pool bases.
"""
import os
assert os.getpriority(os.PRIO_PROCESS,0)==19
for key in ('OPENBLAS_NUM_THREADS','OMP_NUM_THREADS','MKL_NUM_THREADS','VECLIB_MAXIMUM_THREADS','NUMEXPR_NUM_THREADS','BLIS_NUM_THREADS'):
    os.environ[key]='1'
from pathlib import Path
from fractions import Fraction as Q
import argparse,copy,gzip,hashlib,json,time
from verify_singleton_archive_cg import context as archive_context
from verify_singleton_exchange_terminal import rank
from read_soplex_exact_output import read_named_rational

ROOT=Path(__file__).resolve().parent
def sha(path):return hashlib.sha256(Path(path).read_bytes()).hexdigest()
def read(path):
    p=Path(path);raw=p.read_bytes();return json.loads(gzip.decompress(raw) if p.suffix=='.gz' else raw)

def context(path):
    d=read(path);assert d['status']=='EXACT_SINGLETON_PHASE_ONE_LP_REQUIRES_REPLAY'
    assert sha(d['parent_manifest'])==d['parent_manifest_sha256']
    r=read(d['parent_receipt']);assert sha(d['parent_receipt'])==d['parent_receipt_sha256']
    assert r['status']=='PASS_EXACT_SINGLETON_ARCHIVE_LP_TEXT_AND_PHYSICAL_COLUMNS'
    assert r['consumer_sha256']==sha(ROOT/'verify_singleton_archive_cg.py')
    assert r['manifest_sha256']==d['parent_manifest_sha256']
    parent,s,E,q,B,Z=archive_context(d['parent_manifest'])
    n=len(B);m=len(E);N=n+2*m
    assert d['basis_count']==n and d['ground_count']==m and d['variable_count']==N
    assert d['row_count']==1+m+N
    assert d['point_sha256']==s['point_sha256'] and d['anchor_orbit']==s['anchor_orbit']
    assert sha(d['lp'])==d['lp_sha256']
    assert all(sha(ROOT/p)==h for p,h in d['source_hashes'].items())
    return d,s,E,q,B,Z

def expected_rows(E,q,B):
    n=len(B);m=len(E)
    yield 'mass',{i:Q(1) for i in range(n)},'=',Q(1)
    supports=[set(b) for b in B]
    for k,j in enumerate(E):
        terms={i:Q(1) for i,b in enumerate(supports) if j in b}
        terms[n+k]=Q(1);terms[n+m+k]=Q(-1)
        yield 'q'+str(j),terms,'=',q[j]
    for i in range(n+2*m):yield 'n'+str(i),{i:Q(-1)},'<=',Q(0)

def parse(tokens,E,q,B):
    n=len(B);N=n+2*len(E);assert tokens[:2]==['Minimize','obj:'];pos=2;objective={}
    def expression(at):
        terms={}
        while tokens[at] in ('+','-'):
            sign=1 if tokens[at]=='+' else -1;v=sign*Q(tokens[at+1]);name=tokens[at+2]
            assert name.startswith('x') and name[1:].isdigit();i=int(name[1:]);assert 0<=i<N and i not in terms
            terms[i]=v;at+=3
        return at,{i:v for i,v in terms.items() if v}
    pos,objective=expression(pos);assert objective=={i:Q(1) for i in range(n,N)}
    assert tokens[pos:pos+2]==['Subject','To'];pos+=2;count=0
    for name,terms,rel,rhs in expected_rows(E,q,B):
        assert tokens[pos]==name+':';pos+=1;pos,actual=expression(pos)
        assert actual==terms and tokens[pos]==rel and Q(tokens[pos+1])==rhs;pos+=2;count+=1
    assert tokens[pos]=='Bounds';pos+=1
    for i in range(N):assert tokens[pos:pos+2]==['x'+str(i),'free'];pos+=2
    assert tokens[pos:]==['End'];return count

def exact_pair(E,q,B,primal,dual):
    n=len(B);m=len(E);N=n+2*m
    assert len(primal)==N and all(v>=0 for v in primal)
    weights=primal[:n];plus=primal[n:n+m];minus=primal[n+m:]
    assert sum(weights)==1
    mixture={j:Q(0) for j in E}
    for basis,w in zip(B,weights):
        if w:
            for j in basis:mixture[j]+=w
    assert all(mixture[j]+plus[k]-minus[k]==q[j] for k,j in enumerate(E))
    objective=sum(plus)+sum(minus);proof=None
    for sign in (1,-1):
        values={key:sign*v for key,v in dual.items()}
        u=values['mass'];c={j:values['q'+str(j)] for j in E}
        if any(values['n'+str(i)]>0 for i in range(N)):continue
        if any(u+sum(c[j] for j in b)-values['n'+str(i)]!=0 for i,b in enumerate(B)):continue
        if any(c[j]-values['n'+str(n+k)]!=1 or -c[j]-values['n'+str(n+m+k)]!=1 for k,j in enumerate(E)):continue
        value=u+sum(c[j]*q[j] for j in E)
        if value!=objective:continue
        assert all(-1<=c[j]<=1 for j in E)
        assert objective==sum(abs(mixture[j]-q[j]) for j in E)
        proof=dict(sign=sign,constant=u,weights=c,objective=objective,mixture=mixture);break
    assert proof is not None,'No exact primal/dual optimality equality'
    return proof

def greedy_support(E,Z,q,c):
    order=sorted(E,key=lambda j:(-c[j],j));basis=[];pivots={};prefix=[];records=[]
    for j in order:
        value=Z[j]
        while value:
            pivot=value&-value
            if pivot in pivots:value^=pivots[pivot]
            else:pivots[pivot]=value;basis.append(j);break
        prefix.append(j);literal=rank(Z[k] for k in prefix)
        assert literal==len(basis)
        records.append(dict(index=j,rank=literal))
    fullrank=rank(Z[j] for j in E);assert len(basis)==fullrank
    support=sum(c[j] for j in basis);weighted=sum(c[j]*q[j] for j in E);gap=weighted-support
    # Signed prefix identity; negative terminal coefficient cancels at equal mass.
    assert sum(q[j] for j in E)==fullrank
    defects=[];partial=Q(0);prefixmass=Q(0);candidate=None
    for k,j in enumerate(order):
        prefixmass+=q[j]
        if k+1==len(order):break
        delta=c[j]-c[order[k+1]];defect=prefixmass-records[k]['rank'];partial+=delta*defect
        if delta and defect>0 and candidate is None:
            S=sorted(order[:k+1]);candidate=dict(indices=S,bound=records[k]['rank'],exact_conditional_violation=str(defect))
        if delta:defects.append(dict(prefix_length=k+1,coefficient=str(delta),rank=records[k]['rank'],defect=str(defect)))
    assert partial==gap
    if gap>0:assert candidate is not None
    return dict(maximizing_physical_basis=sorted(basis),physical_rank=fullrank,maximum_support=str(support),
                weighted_target=str(weighted),exact_global_separation_gap=str(gap),prefix_ranks=records,
                signed_prefix_identity=defects,global_rank_cut_candidate=candidate if gap>0 else None)

def controls():
    E=[0,1];q=[Q(1,2),Q(1,2)];B=[[0]];x=[Q(1),Q(0),Q(1,2),Q(1,2),Q(0)]
    d=dict(mass=Q(1),q0=Q(-1),q1=Q(1),n0=Q(0),n1=Q(-2),n2=Q(0),n3=Q(0),n4=Q(-2))
    assert exact_pair(E,q,B,x,d)['objective']==1
    bad=[]
    y=x.copy();y[0]=-1;bad.append(('negative_weight',y,d))
    y=x.copy();y[2]+=1;bad.append(('wrong_marginal',y,d))
    v=d.copy();v['q1']=2;bad.append(('bad_dual_bound',x,v))
    v=d.copy();v['mass']=2;bad.append(('false_optimality',x,v))
    rejected=[]
    for label,y,v in bad:
        try:exact_pair(E,q,B,y,v)
        except AssertionError:rejected.append(label)
        else:raise AssertionError(label)
    B2=[[0],[1]];x2=[Q(1,2),Q(1,2),Q(0),Q(0),Q(0),Q(0)]
    d2=dict(mass=Q(0),q0=Q(0),q1=Q(0),**{'n'+str(i):Q(0 if i<2 else -1) for i in range(6)})
    assert exact_pair(E,q,B2,x2,d2)['objective']==0
    tiny='Minimize obj: + 1 x1 + 1 x2 + 1 x3 + 1 x4 Subject To mass: + 1 x0 = 1 q0: + 1 x0 + 1 x1 - 1 x3 = 1/2 q1: + 1 x2 - 1 x4 = 1/2 n0: - 1 x0 <= 0 n1: - 1 x1 <= 0 n2: - 1 x2 <= 0 n3: - 1 x3 <= 0 n4: - 1 x4 <= 0 Bounds x0 free x1 free x2 free x3 free x4 free End'
    assert parse(tiny.split(),E,q,B)==8
    for label,text in [('wrong_objective',tiny.replace('obj: + 1 x1','obj: + 2 x1')),
                       ('wrong_slack_sign',tiny.replace('- 1 x3 =','+ 1 x3 =')),
                       ('missing_nonnegative',tiny.replace('n2: - 1 x2 <= 0 ','')),
                       ('default_bound',tiny.replace('x0 free','0 <= x0'))]:
        try:parse(text.split(),E,q,B)
        except (AssertionError,ValueError,IndexError):rejected.append(label)
        else:raise AssertionError(label)
    Z=[1,1,2];E3=[0,1,2];c={0:Q(1),1:Q(1),2:Q(-1)}
    separation=greedy_support(E3,Z,[Q(1),Q(1),Q(0)],c)
    assert Q(separation['exact_global_separation_gap'])==2
    assert separation['global_rank_cut_candidate']['indices']==[0,1]
    membership=greedy_support(E3,Z,[Q(1,2),Q(1,2),Q(1)],c)
    assert Q(membership['exact_global_separation_gap'])==0 and membership['global_rank_cut_candidate'] is None
    return dict(exact_primal_dual_controls=2,signed_greedy_controls=2,corruptions_rejected=rejected)

def main():
    ap=argparse.ArgumentParser();ap.add_argument('--manifest',type=Path,required=True);ap.add_argument('--output',type=Path,required=True)
    ap.add_argument('--primal',type=Path);ap.add_argument('--dual',type=Path);ap.add_argument('--solver-frozen',type=Path);a=ap.parse_args()
    start=time.monotonic();assert not a.output.exists();d,s,E,q,B,Z=context(a.manifest);n=len(B);N=n+2*len(E)
    count=parse(Path(d['lp']).read_text().split(),E,q,B);tiny=controls()
    out=dict(status='PASS_EXACT_SINGLETON_PHASE_ONE_LP_AND_PHYSICAL_COLUMNS',rows_checked=count,
             physical_bases_checked=n,variables=N,tiny_controls=tiny)
    assert bool(a.primal)==bool(a.dual)==bool(a.solver_frozen)
    if a.primal:
        frozen=read(a.solver_frozen)
        assert frozen['input_manifest_sha256']==sha(a.manifest) and frozen['input_lp_sha256']==d['lp_sha256']
        assert '-X='+str(a.primal.resolve()) in frozen['command'] and '-Y='+str(a.dual.resolve()) in frozen['command']
        weights=read_named_rational(a.primal,['x'+str(i) for i in range(N)])
        dual=read_named_rational(a.dual,['mass',*['q'+str(j) for j in E],*['n'+str(i) for i in range(N)]],'dual')
        values=[weights['x'+str(i)] for i in range(N)];proof=exact_pair(E,q,B,values,dual)
        pricing=greedy_support(E,Z,q,proof['weights']);objective=proof['objective']
        out.update(status='PASS_EXACT_SINGLETON_PHASE_ONE_OPTIMUM_AND_FULL_GREEDY_PRICING',
                   exact_restricted_L1_distance=str(objective),dual_sign=proof['sign'],
                   dual_constant=str(proof['constant']),dual_weights=[[j,str(proof['weights'][j])] for j in E if proof['weights'][j]],
                   positive_basis_count=sum(w>0 for w in values[:n]),pricing=pricing,
                   restricted_infeasibility_is_not_global_cut=True,full_singleton_membership=objective==0,
                   zero_bases=[dict(indices=b,weight=str(w)) for b,w in zip(B,values[:n]) if w] if objective==0 else None,
                   unit_probabilities=s['unit_probabilities'] if objective==0 else None,
                   conditional_target=s['conditional_target'] if objective==0 else None,
                   primal=str(a.primal),primal_sha256=sha(a.primal),dual=str(a.dual),dual_sha256=sha(a.dual),
                   solver_frozen=str(a.solver_frozen),solver_frozen_sha256=sha(a.solver_frozen))
        if objective==0:
            assert all(proof['mixture'][j]==q[j] for j in E)
            # Parent context already checked exact unit marginals on the complement.
            out['exact_coordinates_checked']=720
    out.update(manifest=str(a.manifest),manifest_sha256=sha(a.manifest),lp_sha256=d['lp_sha256'],
               consumer_sha256=sha(__file__),point_sha256=s['point_sha256'],anchor_orbit=s['anchor_orbit'],
               source_C16_answered=False,physical_full_frame=False,source_hashes=d['source_hashes'],
               elapsed_seconds=time.monotonic()-start,nice=19,threads=1)
    a.output.write_text(json.dumps(out,indent=2)+'\n')
    print(json.dumps({k:v for k,v in out.items() if k not in ('source_hashes','zero_bases','conditional_target','unit_probabilities','pricing','dual_weights')}),flush=True)
if __name__=='__main__':main()
