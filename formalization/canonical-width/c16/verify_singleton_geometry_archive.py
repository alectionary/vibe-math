#!/usr/bin/env python3
"""Independent full-token archive LP and exact physical-mixture endpoint checks."""
import os
assert os.getpriority(os.PRIO_PROCESS,0)==19
for k in ('OPENBLAS_NUM_THREADS','OMP_NUM_THREADS','MKL_NUM_THREADS','VECLIB_MAXIMUM_THREADS','NUMEXPR_NUM_THREADS','BLIS_NUM_THREADS'):os.environ[k]='1'
from pathlib import Path
from fractions import Fraction as Q
import argparse,copy,gzip,hashlib,json,time
from verify_algebraic_model import physical
from verify_full_partner_projection import point_data
from verify_singleton_exchange_terminal import rank
from read_soplex_exact_output import read_named_rational

ROOT=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def read(p):
    p=Path(p);return json.loads(gzip.decompress(p.read_bytes()) if p.suffix=='.gz' else p.read_bytes())
def context(manifest):
    m=read(manifest);assert m['status']=='EXACT_SINGLETON_GEOMETRY_ARCHIVE_LP_REQUIRES_TEXT_REPLAY'
    assert sha(m['semantic'])==m['semantic_sha256'] and sha(m['lp'])==m['lp_sha256']
    s=read(m['semantic']);assert s['status']=='FROZEN_SINGLETON_GEOMETRY_BASIS_ARCHIVE' and s['seed_kind']=='GEOMETRY_SEED'
    assert s['old_weights_used'] is False and s['old_target_claims_used'] is False
    assert all(sha(ROOT/p)==h for p,h in s['source_hashes'].items())
    c=read(s['geometry_seed']);r=read(s['geometry_receipt'])
    assert c['status']=='GEOMETRY_SEED' and c['seed_kind']=='LEGACY_PHYSICAL_COLUMNS_ONLY'
    assert c['old_weights_used'] is False and c['old_target_claims_used'] is False and c['current_point_membership_claimed'] is False
    assert r['status']=='PASS_EXACT_SINGLETON_GEOMETRY_SEED'
    assert sha(s['geometry_seed'])==s['geometry_seed_sha256']==r['seed_sha256'] and sha(s['geometry_receipt'])==s['geometry_receipt_sha256']
    assert r['consumer_sha256']==sha(ROOT/'verify_singleton_geometry_seed.py')
    assert all(sha(ROOT/p)==h for p,h in {**c['source_hashes'],**r['source_hashes']}.items())
    X,Z,_=physical();assert rank(X)==rank(Z)==128
    k=s['anchor_orbit'];assert type(k)is int and k==32==c['anchor_orbit']
    owner,target=point_data(s['point'],k);p=owner[k];q=[v/(16*p) for v in target[55:]]
    assert sha(s['point'])==m['point_sha256']==s['point_sha256']==c['point_sha256']==r['point_sha256']
    assert Q(s['conditional_probability'])==Q(c['conditional_probability'])==p and 0<p<1
    assert list(map(Q,s['conditional_target']))==list(map(Q,c['conditional_target']))==q and all(0<=v<=1 for v in q)
    E=[j for j in range(720) if (X[16*k]&Z[j]).bit_count()%2==0]
    assert E==s['physical_zero_ground_indices']==c['physical_zero_ground_indices']
    assert rank(Z[j] for j in E)==sum(q[j] for j in E)==127
    U=sorted(set(range(720))-set(E));assert sum(q[j] for j in U)==1
    B=s['physical_bases'];assert B==c['physical_bases'] and 1<=len(B)<=5000 and len({tuple(b) for b in B})==len(B)
    for b in B:assert b==sorted(set(b)) and len(b)==127 and all(type(j)is int and j in E for j in b) and rank(Z[j] for j in b)==127
    assert s['unit_probabilities']==c['unit_probabilities']
    units={b['index']:Q(b['probability']) for b in s['unit_probabilities']}
    assert len(units)==len(s['unit_probabilities']) and set(units)<=set(U) and all(0<w<=1 for w in units.values())
    assert all(units.get(j,0)==q[j] for j in U)
    assert m['variable_count']==s['variable_count']==len(B)
    assert m['row_count']==len(B)+len(E)+1 and m['nonzeros']==len(B)*129
    return m,s,E,q,B,Z

def rows(E,q,B):
    n=len(B);yield 'mass',{i:Q(1) for i in range(n)},'=',Q(1)
    supports=[set(b) for b in B]
    for j in E:yield 'q'+str(j),{i:Q(1) for i,b in enumerate(supports) if j in b},'=',q[j]
    for i in range(n):yield 'n'+str(i),{i:Q(-1)},'<=',Q(0)

def parse(tokens,expected,n):
    assert tokens[:7]==['Minimize','obj:','+','0','x0','Subject','To'];i=7;count=0
    for name,wanted,rel,rhs in expected:
        assert tokens[i]==name+':';i+=1;terms={}
        while tokens[i] in ('+','-'):
            sign=1 if tokens[i]=='+' else -1;v=sign*Q(tokens[i+1]);namex=tokens[i+2]
            assert namex.startswith('x') and namex[1:].isdigit();j=int(namex[1:]);assert 0<=j<n
            assert j not in terms;terms[j]=v;i+=3
        assert {j:v for j,v in terms.items() if v}==wanted
        assert tokens[i]==rel and Q(tokens[i+1])==rhs;i+=2;count+=1
    assert tokens[i]=='Bounds';i+=1
    for j in range(n):assert tokens[i:i+2]==['x'+str(j),'free'];i+=2
    assert tokens[i:]==['End'];return count

def mixture(weights,q,B):
    assert len(weights)==len(B) and all(w>=0 for w in weights) and sum(weights)==1
    x=[Q(0)]*720
    for b,w in zip(B,weights):
        for j in b:x[j]+=w
    E=set(j for b in B for j in b)
    assert all(x[j]==q[j] for j in E)
    return x

def main():
    ap=argparse.ArgumentParser();ap.add_argument('--manifest',type=Path,required=True);ap.add_argument('--output',type=Path,required=True)
    mode=ap.add_mutually_exclusive_group();mode.add_argument('--primal',type=Path);mode.add_argument('--farkas',type=Path)
    ap.add_argument('--solver-frozen',type=Path);a=ap.parse_args();assert not a.output.exists();start=time.monotonic()
    m,s,E,q,B,Z=context(a.manifest);n=len(B);rejected=[]
    if not a.primal and not a.farkas:
        count=parse(Path(m['lp']).read_text().split(),rows(E,q,B),n)
        tiny='Minimize obj: + 0 x0 Subject To mass: + 1 x0 + 1 x1 = 1 q: + 1 x0 = 1/3 n0: - 1 x0 <= 0 n1: - 1 x1 <= 0 Bounds x0 free x1 free End'
        expected=[('mass',{0:Q(1),1:Q(1)},'=',Q(1)),('q',{0:Q(1)},'=',Q(1,3)),('n0',{0:Q(-1)},'<=',Q(0)),('n1',{1:Q(-1)},'<=',Q(0))]
        assert parse(tiny.split(),expected,2)==4
        for label,bad in [('rhs',tiny.replace('1/3','1/2')),('missing_nonnegative',tiny.replace('n0: - 1 x0 <= 0 ','')),('wrong_column',tiny.replace('q: + 1 x0','q: + 1 x1')),('positive_default_bound',tiny.replace('x0 free','0 <= x0'))]:
            try:parse(bad.split(),expected,2)
            except (AssertionError,IndexError,ValueError):rejected.append(label)
            else:raise AssertionError(label)
        out=dict(status='PASS_EXACT_SINGLETON_GEOMETRY_ARCHIVE_LP_TEXT_AND_PHYSICAL_COLUMNS',rows_checked=count,physical_bases_checked=n,nonzeros=m['nonzeros'],negative_controls_rejected=rejected)
    elif a.primal:
        f=read(a.solver_frozen);assert f['input_manifest_sha256']==sha(a.manifest) and f['input_lp_sha256']==m['lp_sha256']
        assert any(v=='-X='+str(a.primal.resolve()) for v in f['command'])
        named=read_named_rational(a.primal,['x'+str(i) for i in range(n)]);w=[named['x'+str(i)] for i in range(n)]
        x=mixture(w,q,B);assert all(x[j]==q[j] for j in E)
        U=set(range(720))-set(E)
        for j in U:x[j]=q[j]
        assert x==q
        for label,bad in [('negative',[-Q(1),*w[1:]]),('mass',[w[0]+1,*w[1:]])]:
            try:mixture(bad,q,B)
            except AssertionError:rejected.append(label)
            else:raise AssertionError(label)
        out=dict(status='PASS_EXACT_GLOBAL_SINGLETON_ARCHIVE_BASIS_MEMBERSHIP',physical_bases_checked=n,
                 positive_basis_count=sum(v>0 for v in w),zero_bases=[dict(indices=b,weight=str(v)) for b,v in zip(B,w) if v],
                 unit_probabilities=s['unit_probabilities'],conditional_target=s['conditional_target'],
                 exact_coordinates_checked=720,exact_L1_residual='0',all_conditional_T_rank_inequalities_proved=True,
                 primal=str(a.primal),primal_sha256=sha(a.primal),solver_frozen=str(a.solver_frozen),solver_frozen_sha256=sha(a.solver_frozen),
                 negative_controls_rejected=rejected)
    else:
        f=read(a.solver_frozen);assert f['input_manifest_sha256']==sha(a.manifest) and f['input_lp_sha256']==m['lp_sha256']
        assert any(v=='-Y='+str(a.farkas.resolve()) for v in f['command'])
        names=['mass',*['q'+str(j) for j in E],*['n'+str(i) for i in range(n)]]
        raw=read_named_rational(a.farkas,names,'farkas');proof=None
        for sign in (1,-1):
            w={name:sign*v for name,v in raw.items()}
            if any(w['n'+str(i)]<0 for i in range(n)):continue
            residual=[w['mass']+sum((w['q'+str(j)] for j in b),Q(0))-w['n'+str(i)] for i,b in enumerate(B)]
            gap=-w['mass']-sum((w['q'+str(j)]*q[j] for j in E),Q(0))
            if not any(residual) and gap>0:
                proof=dict(sign=sign,exact_gap=str(gap),multipliers={k:str(v) for k,v in w.items() if v})
                break
        assert proof is not None,'No exact restricted-archive Farkas proof'
        out=dict(status='PASS_EXACT_RESTRICTED_SINGLETON_ARCHIVE_INFEASIBILITY',proof=proof,
                 physical_bases_checked=n,all_columns_cancelled=True,source_rank_cut_proved=False,
                 farkas=str(a.farkas),farkas_sha256=sha(a.farkas),solver_frozen=str(a.solver_frozen),solver_frozen_sha256=sha(a.solver_frozen))
    out.update(manifest=str(a.manifest),manifest_sha256=sha(a.manifest),semantic_sha256=m['semantic_sha256'],lp_sha256=m['lp_sha256'],
               point_sha256=s['point_sha256'],anchor_orbit=s['anchor_orbit'],consumer_sha256=sha(__file__),
               source_hashes=s['source_hashes'],source_C16_answered=False,physical_full_frame=False,
               scope='Selected-conditioned global T law. Restricted archive infeasibility is never a source rank cut.',elapsed_seconds=time.monotonic()-start)
    a.output.write_text(json.dumps(out,indent=2)+'\n');print(json.dumps({k:v for k,v in out.items() if k not in ['source_hashes','zero_bases','conditional_target','unit_probabilities']}),flush=True)
if __name__=='__main__':main()
