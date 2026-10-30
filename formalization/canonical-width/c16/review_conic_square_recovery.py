#!/usr/bin/env python3
"""Source-square lifting controls and a read-only numerical dual diagnostic.

No conic solve, numerical infeasibility acceptance, or exact certificate is
performed. Numerical trigonometry proposes physical squares; their exact
validity is supplied by a pair of already checked integer-binomial rows.
"""
from pathlib import Path
from collections import Counter,defaultdict,deque
from fractions import Fraction
from itertools import product
import ast, hashlib, json, math, time
import numpy as np
from scipy.sparse import load_npz
from verify_dense_integer_forms import compile_row, coordinate, literal_owner, action, sha, read, source_binding

ROOT=Path(__file__).resolve().parent


def square_row(events,weights,c):
    out=Counter()
    for i,(e,w) in enumerate(zip(events,weights)):
        out[e%720//16]-=2*c*w+w*w
        for j in range(i):out[coordinate(events[j],e)]-=2*weights[j]*w
    return {k:v for k,v in sorted(out.items()) if v},c*c


def paired_binomials(events,weights,c):
    A,a=compile_row(dict(events=events,weights=weights,constant=c))
    B,b=compile_row(dict(events=events,weights=[-w for w in weights],constant=-c))
    out=Counter(A);out.update(B)
    return {k:v for k,v in sorted(out.items()) if v},a+b


def svec(M):
    return np.array([M[i,j]*(1 if i==j else math.sqrt(2)) for j in range(len(M)) for i in range(j,len(M))])


def smat(v,n):
    M=np.zeros((n,n));k=0
    for j in range(n):
        for i in range(j,n):M[i,j]=M[j,i]=v[k]/(1 if i==j else math.sqrt(2));k+=1
    assert k==len(v)
    return M


def blocks(owner):
    p=owner[:45];S={h:owner[45+2025*h:45+2025*(h+1)].reshape(45,45) for h in range(9)}
    T={h:owner[18270+2025*h:18270+2025*(h+1)].reshape(45,45) for h in range(9)}
    for B in [S,T]:
        for h in range(9,16):B[h]=B[16-h].T
    G=np.block([[np.ones((1,1)),p[None,:]],[p[:,None],(sum(S.values())+sum(T.values()))/32]])
    out=[G[:45,:45],(sum(S.values())-sum(T.values()))[:44,:44]]
    for k in range(1,9):
        for sign in [1,-1]:
            H=sum(np.exp(2j*np.pi*k*h/16)*(S[h]+sign*T[h]) for h in range(16))
            R,I=H.real,H.imag
            out.append(R if k==8 else np.block([[R,-I],[I,R]]))
    return out


def lift(index,v):
    """Raw physical forms and denominator F with q=E(sum L^2)/F."""
    if index==0:
        w=np.repeat(np.r_[v[1:],0.0],16);return [(np.r_[w,w],32*v[0])],1024
    if index==1:
        w=np.repeat(np.r_[v,0.0],16);return [(np.r_[w,-w],0.0)],32
    k=(index-2)//2+1;sign=1 if index%2==0 else-1;t=np.arange(16)
    if k==8:
        w=(v[:,None]*(-1.0)**t).ravel();return [(np.r_[w,sign*w],0.0)],32
    a,b=v[:45],v[45:];co=np.cos(2*np.pi*k*t/16);si=np.sin(2*np.pi*k*t/16)
    wr=(a[:,None]*co-b[:,None]*si).ravel()
    wi=(-a[:,None]*si-b[:,None]*co).ravel()
    return [(np.r_[wr,sign*wr],0.0),(np.r_[wi,sign*wi],0.0)],32


def exact_zero_frequency_controls(bits,U):
    aa=[(17*i)%7-3 for i in range(44)];c=-2
    physical=np.repeat(aa+[0],16).tolist();events=list(range(1440))
    forms=[(physical+physical,32*c,0),(physical+[-v for v in physical],0,1)]
    for w,d,index in forms:
        total=0
        for swap in [0,1]:
            for shift in range(16):
                L=d+sum(a*int(bits[j])for a,j in zip(w,action(events,swap,shift)));total+=L*L
        q=Fraction(c*c)if index==0 else Fraction(0)
        if index==0:q+=sum(Fraction(2*c*a*int(U[i]),32) for i,a in enumerate(aa))
        for i,a in enumerate(aa):
            for j,b in enumerate(aa):
                numerator=sum(int(U[coordinate(16*i,16*j+h)])+(1 if index==0 else-1)*int(U[coordinate(16*i,720+16*j+h)])for h in range(16))
                q+=Fraction(a*b*numerator,1024 if index==0 else 32)
        assert Fraction(total,32*(1024 if index==0 else 32))==q
    return 2


def main():
    output=ROOT/'two-basis-results/conic-square-recovery-independent-review.json';assert not output.exists();start=time.monotonic()
    paths=['review_conic_square_recovery.py','export_linear_case_model.py','export_conic_case_model.py','probe_case_conic_scaled_v2.py','verify_dense_integer_forms.py','semantic_linear_case_rows.py','verify_semantic_linear_case_dual.py',
           'coupling-results/sourcecase323200-conic22.json','coupling-results/sourcecase323200-conic22-frozen.json','coupling-results/sourcecase323200-conic22.full-A.npz','coupling-results/sourcecase323200-conic22.full-data.npz','coupling-results/sourcecase323200-conic22.linear-A.npz','coupling-results/sourcecase323200-conic22.linear-data.npz',
           'coupling-results/sourcecase323200-linear22.linear-A.npz','coupling-results/sourcecase323200-linear22.linear-data.npz',
           'two-basis-results/sourcecase323200-semantic22-independent.json','two-basis-results/sourcecase323200-dense-integer0-independent.json','two-basis-results/sourcecase323200-conic-binaryscale1.json','two-basis-results/sourcecase323200-conic-binaryscale1.npz','two-basis-results/sourcecase323200-conic-binaryscale1.frozen.json','two-basis-results/sourcecase323200-semantic22.numeric-row-map.npz']
    hashes={p:sha(ROOT/p)for p in paths};binding=source_binding()
    for fp in [paths[8],paths[19]]:
        f=read(ROOT/fp);sources=f.get('input_and_source_hashes',f.get('source_hashes'))
        assert all(sha(ROOT/p)==h for p,h in sources.items())
    # The conic exporter only adds full-packet writes and metadata after the
    # already reviewed linear construction and owner-map export.
    ts=[ast.parse((ROOT/p).read_text())for p in paths[1:3]]
    mains=[next(n for n in t.body if isinstance(n,ast.FunctionDef)and n.name=='main')for t in ts]
    prefixes=[]
    for m in mains:
        k=next(i for i,n in enumerate(m.body)if isinstance(n,ast.Assign)and any(isinstance(t,ast.Name)and t.id=='out'for t in n.targets))
        prefixes.append(m.body[:k+1])
    dump=lambda n:ast.dump(n,include_attributes=False)
    assert list(map(dump,prefixes[0]))==list(map(dump,prefixes[1]))
    report=read(ROOT/paths[7]);cone=report['full_cone_dimensions'];assert cone['s']==[45,44]+[90]*14+[45,45]
    A=load_npz(ROOT/paths[9]).tocsr();data=np.load(ROOT/paths[10]);b=data['b'];owner_map=data['owner_to_canonical'];stop=cone['z']+cone['l']
    old=load_npz(ROOT/paths[13]).tocsr();difference=A[cone['z']:stop]-old[cone['z']:];difference.eliminate_zeros();assert difference.nnz==0
    olddata=np.load(ROOT/paths[14]);assert np.array_equal(b[:stop],olddata['rhs'])and np.array_equal(owner_map,olddata['owner_to_canonical'])
    # Forced-zero equations originate in a set, so their order can vary across
    # fresh processes. Match every equation exactly; never transfer row numbers.
    old.sum_duplicates();old.sort_indices();A.sum_duplicates();A.sort_indices();lookup=defaultdict(deque)
    def key(M,i,rhs):
        l,r=M.indptr[i:i+2];assert all(int(v)==v for v in M.data[l:r])and int(rhs)==rhs
        return (tuple(map(int,M.indices[l:r])),tuple(map(int,M.data[l:r])),int(rhs))
    for i in range(cone['z']):lookup[key(old,i,olddata['rhs'][i])].append(i)
    eqperm=[]
    for i in range(cone['z']):
        k=key(A,i,b[i]);assert lookup[k];eqperm.append(lookup[k].popleft())
    assert not any(lookup.values())
    oldmap=np.load(ROOT/paths[20]);newmap={k:oldmap[k]for k in oldmap.files}
    for k in ['equality_to_semantic','equality_scale_numerator','equality_scale_denominator']:newmap[k]=oldmap[k][eqperm]
    assert read(ROOT/paths[15])['numeric_correspondence']['map_sha256']==hashes[paths[20]]
    dense=read(ROOT/paths[16]);assert dense['status']=='PASS_DENSE_INTEGER_FORM_SOURCE_VALIDITY'and dense['consumer_sha256']==hashes['verify_dense_integer_forms.py']
    assert dense['complete_monomial_mapping']['unordered_monomials_checked']==1037520
    identity_checks=0;assignments=0
    for k in range(1,5):
        e=[0,17,733,1439][:k]
        for w in product([-2,-1,0,1,2],repeat=k):
            for c in range(-2,3):
                assert paired_binomials(e,list(w),c)==square_row(e,list(w),c);identity_checks+=1
                for bits in product([0,1],repeat=k):
                    L=c+sum(x*y for x,y in zip(w,bits));assert L*L==L*(L-1)//2+(-L)*(-L-1)//2;assignments+=1
    for e,w,c in [(list(range(1440)),[(17*i)%11-5 for i in range(1440)],-3),([0,1439],[1<<91,-3],-(1<<80))]:
        assert paired_binomials(e,w,c)==square_row(e,w,c);identity_checks+=1
    rng=np.random.default_rng(202610301823);lift_checks=exact_checks=slack_checks=0;maxerr=0.0
    for probability in [0.0,1.0,.17,.5]:
        bits=(rng.random(1440)<probability).astype(np.int64);U=literal_owner(bits);owner=U/32;Bs=blocks(owner);x=np.zeros(A.shape[1]);x[owner_map]=owner;slack=b-A@x;pos=stop
        exact_checks+=exact_zero_frequency_controls(bits,U)
        for index,B in enumerate(Bs):
            n=len(B);length=n*(n+1)//2;err=float(np.max(abs(smat(slack[pos:pos+length],n)-B)));maxerr=max(maxerr,err);assert err<1e-10;pos+=length;slack_checks+=1
            v=rng.integers(-3,4,size=n).astype(float);forms,F=lift(index,v);total=0.0
            for swap in [0,1]:
                for shift in range(16):
                    moved=bits[action(np.arange(1440),swap,shift)]
                    total+=sum((c+float(w@moved))**2 for w,c in forms)
            q=float(v@B@v);assert abs(total/(32*F)-q)<1e-8*(1+abs(q));lift_checks+=1
            if 2<=index<16:
                totalone=sum(float(forms[0][0]@bits[action(np.arange(1440),sw,sh)])**2 for sw in [0,1]for sh in range(16))
                assert abs(totalone/(32*16)-q)<1e-8*(1+abs(q));lift_checks+=1
        assert pos==A.shape[0]
    # Undo ONLY the explicit input row scaling. SCS returns its public dual
    # in the input problem coordinates, after internal equilibration recovery.
    endpoint=read(ROOT/paths[17]);saved=np.load(ROOT/paths[18]);y=saved['y']*np.exp2(-saved['row_exponents'].astype(float));assert len(y)==A.shape[0]and np.isfinite(y).all()
    residual=A.T@y;right=float(b@y);gap=float(np.minimum(residual,0).sum()-right)
    clean=y.copy();clean[cone['z']:stop]=np.maximum(clean[cone['z']:stop],0);pos=stop;psd=[];eigenvalues=[]
    for n in cone['s']:
        end=pos+n*(n+1)//2;Y=smat(y[pos:end],n);ev,V=np.linalg.eigh(Y);positive=np.maximum(ev,0);clean[pos:end]=svec((V*positive)@V.T)
        psd.append(dict(dimension=n,minimum_eigenvalue=float(ev[0]),positive_rank_1e12=int(sum(ev>1e-12)),positive_trace=float(positive.sum())));eigenvalues.extend(positive.tolist());pos=end
    cleanres=A.T@clean;cleanright=float(b@clean);cleangap=float(np.minimum(cleanres,0).sum()-cleanright)
    assert abs(right+endpoint['solver_info']['dobj'])<1e-8
    ev=sorted(eigenvalues,reverse=True)
    map_path=ROOT/'two-basis-results/sourcecase323200-conic22-semantic-row-map.npz';assert not map_path.exists();np.savez_compressed(map_path,**newmap)
    out=dict(status='PASS_CONIC_SQUARE_RECOVERY_DESIGN_CONTROLS',source_hashes=hashes,physical_source_bindings=binding,
             conic_export_prefix_ast_equal=True,linear_inequality_packet_bit_identical=True,equalities_exactly_permuted=True,equality_rows_permuted=sum(i!=j for i,j in enumerate(eqperm)),conic_semantic_row_map=str(map_path.relative_to(ROOT)),conic_semantic_row_map_sha256=sha(map_path),
             dense_square_identity_controls=identity_checks,exhaustive_integer_evaluations=assignments,
             exact_G_D0_literal_controls=exact_checks,literal_fourier_and_zero_mode_lifts=lift_checks,
             canonical_PSD_slack_blocks_checked=slack_checks,maximum_slack_mapping_error=maxerr,
             cone_dimensions=cone['s'],cone_physical_square_factors=dict(G=1024,D0=32,k1_to7_two_real_forms=32,k1_to7_one_real_form=16,k8=32),
             square_validity='L^2 = binomial(L,2)+binomial(-L,2), exactly; both rows use existing independent full-support integer consumer.',
             endpoint_diagnostic=dict(status='NO_CANDIDATE_CONTRADICTION_FROM_UNMODIFIED_ENDPOINT',b_dot_y=right,box_residual_corrected_gap=gap,after_numeric_PSD_and_nonnegative_projection=dict(b_dot_y=cleanright,box_residual_corrected_gap=cleangap),PSD_blocks=psd,top16_positive_eigenvalue_mass=sum(ev[:16]),all_positive_eigenvalue_mass=sum(ev),proof=False),
             numerical_source='https://www.cvxgrp.org/scs/api/cones.html',
             source_C16_answered=False,selected_source_case_excluded=False,solver_run=False,exact_certificate_generated=False,
             scope='Exact physical-square bridge plus finite factor/orientation controls; the saved endpoint diagnostic is numerical and does not prove feasibility or infeasibility. Small-square recovery remains a gated proposal.',seconds=time.monotonic()-start)
    assert all(sha(ROOT/p)==h for p,h in hashes.items())
    output.write_text(json.dumps(out,indent=2,sort_keys=True)+'\n');print(output.relative_to(ROOT),sha(output),out['seconds'])


if __name__=='__main__':main()
