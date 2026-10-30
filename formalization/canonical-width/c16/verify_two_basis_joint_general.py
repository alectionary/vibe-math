#!/usr/bin/env python3
"""Independent symbolic and physical replay of the general five-law model.

No general-model producer or optimizer is imported. All source ranks, affine
dimensions, semantic row descriptors, exact reference coordinates and numeric
packet entries are rebuilt from the saved model and frozen physical source.
"""
import os
assert os.nice(0)==19, 'research replay requires verified nice19 before imports'
from pathlib import Path
from fractions import Fraction as Q
from collections import defaultdict
import argparse, copy, gzip, hashlib, json, time
import numpy as np
from verify_two_sided_full_basis_oracle import physical_source, domains, target
from verify_two_basis_direct_allocation import check_allocation

ROOT=Path(__file__).resolve().parent
LOW=[0,1,2,4,8,3,5,9,6,10,12]
HIGH=[7,11,13,14,15]
LAYOUT='1,P[4],PP[6lex],U[X720,Z720],P_U[4,1440].ravel(C)'
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def read(p):
    p=Path(p);return json.loads(gzip.decompress(p.read_bytes()) if p.suffix=='.gz' else p.read_bytes())
def empty():return ({},{})
def term(k,j,v=1):
    e=empty()
    if v:e[k][j]=Q(v)
    return e
def add(a,b,c=1):
    out=(dict(a[0]),dict(a[1]))
    for k in [0,1]:
        for j,v in b[k].items():
            w=out[k].get(j,Q(0))+c*v
            if w:out[k][j]=w
            else:out[k].pop(j,None)
    return out
def decode(e,nf,nv):
    assert isinstance(e,list) and len(e)==2;out=[]
    for entries,n in zip(e,[nf,nv]):
        assert isinstance(entries,list);d={}
        for j,v in entries:
            assert type(j)is int and 0<=j<n and j not in d and type(v)is str
            q=Q(v);assert q and str(q)==v;d[j]=q
        out.append(d)
    return tuple(out)
def ev(e,f,x):return sum((c*f[j] for j,c in e[0].items()),Q(0))+sum((c*x[j] for j,c in e[1].items()),Q(0))
def flat(e):return {(k,j):v for k in [0,1] for j,v in e[k].items()}
def sparse_span(rows):
    piv={}
    for source in rows:
        d=dict(source)
        while d:
            k=min(d);v=d[k]
            if k not in piv:
                piv[k]={j:c/v for j,c in d.items()};break
            for j,c in piv[k].items():
                w=d.get(j,Q(0))-v*c
                if w:d[j]=w
                else:d.pop(j,None)
    return piv
def in_span(d,piv):
    d=dict(d)
    while d:
        k=min(d)
        if k not in piv:return False
        v=d[k]
        for j,c in piv[k].items():
            w=d.get(j,Q(0))-v*c
            if w:d[j]=w
            else:d.pop(j,None)
    return True
def binary_rank(values):
    B={}
    for v in values:
        while v:
            k=(v&-v).bit_length()-1
            if k in B:v^=B[k]
            else:B[k]=v;break
    return len(B)
def rkkey(r):return r['mask'],tuple(r['forced_zero_indices']),tuple(r['indices']),r['contraction_rank']
def normrank(r):return {k:r[k] for k in ['mask','forced_zero_indices','indices','contraction_rank']}
def rank_geometry(r,U,dd):
    m,F,S,rr=[r[k] for k in ['mask','forced_zero_indices','indices','contraction_rank']]
    assert type(m)is int and 0<=m<16 and type(rr)is int and rr>=0
    assert F==dd[m]['zero_forced'] and S==sorted(set(S))
    assert all(type(j)is int and 0<=j<720 for j in F+S) and set(S)<=set(dd[m]['zero_free'])
    assert binary_rank(U[j] for j in F)==len(F)
    assert binary_rank(U[j] for j in F+S)-len(F)==rr
def literal_row(M,d):
    k=d['kind'];lam=M['lambda_expressions']
    if k=='lambda_nonnegative':return add(empty(),lam[d['mask']],-1)
    s=M['sectors'][d['side']];E=s['allocations']
    if k=='local_consistency':return s['local_consistency'][d['local_index']]
    if k=='box':
        e=E[d['mask']][d['index']]
        return add(empty(),e,-1) if d['bound']=='lower' else add(e,lam[d['mask']],-1)
    if k=='rank':
        r=s['rank_rows'][d['rank_index']];m=r['mask'];A=r['indices'];rr=r['contraction_rank']
    else:
        m=d['mask'];domain=s['domains'][m]
        if k=='zero_bucket':A=domain['zero_forced']+domain['zero_free'];rr=domain['zero_required']
        else:assert k=='owner_bucket';A=domain['bins'][d['owner']];rr=1
    e=add(empty(),lam[m],-rr)
    for j in A:e=add(e,E[m][j])
    return e
def packet_row(packet,prefix,i,e,features):
    left,right=map(int,packet[prefix+'_indptr'][i:i+2]);keys=packet[prefix+'_indices'][left:right].tolist()
    assert keys==sorted(e[1])
    assert packet[prefix+'_data'][left:right].tolist()==[float(e[1][j]) for j in keys]
    assert packet[prefix+'_rhs'][i]==float(-sum((v*features[j] for j,v in e[0].items()),Q(0)))

def replay(model_path,prepared_path,point):
    saved=read(model_path);prepared=read(prepared_path);assert prepared['model_sha256']==sha(model_path)
    assert saved['status']=='FROZEN_GENERAL_SHARED_LAW_ALLOCATION_MODEL'
    assert saved['feature_layout']==LAYOUT and saved['feature_count']==7211
    assert saved['structural_only_elimination'] is True and saved['fixed_law_faces_used'] is False
    assert saved['point_sha256']==prepared['point_sha256']==sha(point)
    assert all(sha(ROOT/p)==h for p,h in saved['source_hashes'].items())
    sources=dict(saved['source_hashes']);nv=len(saved['variables']);assert nv==prepared['variables']
    assert saved['high_masks']==HIGH and saved['variables'][:5]==[dict(kind='tau',mask=m) for m in HIGH]
    M=dict(saved);M['lambda_expressions']=[decode(e,7211,nv) for e in saved['lambda_expressions']]
    M['sectors']={}
    for side,s in saved['sectors'].items():
        M['sectors'][side]=dict(s,allocations=[[decode(e,7211,nv) for e in row] for row in s['allocations']],
            local_consistency=[decode(e,7211,nv) for e in s['local_consistency']])
    lam=[]
    for m in range(16):
        e=empty()
        for sup in range(16):
            if sup&m!=m:continue
            sign=(-1)**(sup.bit_count()-m.bit_count())
            e=add(e,term(0,LOW.index(sup),sign) if sup in LOW else term(1,HIGH.index(sup),sign))
        lam.append(e)
    assert M['lambda_expressions']==lam
    X,Z,_=physical_source();xx,zz=M['X_anchors'],M['Z_anchors'];ddall=domains(X,Z,xx,zz)
    features=target(point,xx,zz);eq=[];ub=[dict(kind='lambda_nonnegative',mask=m) for m in range(16)]
    location=defaultdict(list);seen=set()
    for i,v in enumerate(M['variables'][5:],5):
        assert v['kind']=='allocation' and v['side'] in ['X','Z']
        assert type(v['index'])is int and 0<=v['index']<720 and type(v['mask'])is int and 0<=v['mask']<16
        key=(v['side'],v['index'],v['mask']);assert key not in seen;seen.add(key)
        location[key[:2]].append((v['mask'],i))
    parameter_dimensions={};moment_checks=0;structural_checks=0;physical_ranks=0
    for side,U in [('X',X),('Z',Z)]:
        s=M['sectors'][side];dd=[d[side] for d in ddall];assert all(d['feasible'] for d in dd)
        domainkeys=['zero_forced','zero_free','zero_required','bins','forced','absent']
        assert s['domains']==[{k:list(d[k]) if isinstance(d[k],tuple) else d[k] for k in domainkeys} for d in dd]
        assert len(s['allocations'])==16 and all(len(r)==720 for r in s['allocations'])
        expected_dimension=0;residual_index=0;off=720*int(side=='Z')
        for j in range(720):
            free=[]
            for m,d in enumerate(dd):
                allowed=set(d['zero_forced']+d['zero_free']+[q for b in d['bins'] for q in b])
                if j in d['forced']:assert s['allocations'][m][j]==lam[m];structural_checks+=1
                elif j not in allowed:assert s['allocations'][m][j]==empty();structural_checks+=1
                else:free.append(m)
            A=[{m:Q(1 if k==0 else (m>>(k-1))&1) for m in free if k==0 or m>>(k-1)&1} for k in range(5)]
            rankA=len(sparse_span(A));number=len(free)-rankA;expected_dimension+=number
            retained=location[(side,j)];assert len(retained)==number
            for m,i in retained:assert m in free and s['allocations'][m][j]==term(1,i)
            meta=s['local_metadata'][j];assert meta['index']==j and meta['free_pattern_count']==len(free)
            assert meta['local_moment_rank']==rankA and meta['local_variables']==number
            raw=[]
            for k in range(5):
                fidx=11+off+j if k==0 else 1451+1440*(k-1)+off+j;e=term(0,fidx,-1)
                for m in range(16):
                    if k==0 or m>>(k-1)&1:e=add(e,s['allocations'][m][j])
                raw.append(flat(e));moment_checks+=1
            residuals=[]
            for k in range(rankA,5):
                residuals.append(flat(s['local_consistency'][residual_index]))
                eq.append(dict(kind='local_consistency',side=side,local_index=residual_index,index=j,moment=k));residual_index+=1
            p,q=sparse_span(raw),sparse_span(residuals)
            assert all(in_span(r,q) for r in raw) and all(in_span(r,p) for r in residuals)
        assert residual_index==len(s['local_consistency']) and expected_dimension==s['local_variable_count']
        parameter_dimensions[side]=expected_dimension
        inherited={}
        for spec in M['rank_bank_bindings'][side]:
            bp,rp=ROOT/spec['bank'],ROOT/spec['receipt'];b,r=read(bp),read(rp)
            assert sha(bp)==spec['bank_sha256']==r['bank_sha256'] and sha(rp)==spec['receipt_sha256']
            assert [b[k] for k in ['side','X_anchors','Z_anchors']]==[side,xx,zz]
            assert all(sha(ROOT/p)==h for p,h in b['source_hashes'].items())
            if r['status']=='PASS_COMPLETE_CONTRACTED_RANK_LE_3_GEOMETRY':
                assert r['patterns_checked']==16 and r['consumer_sha256']==sha(ROOT/'two_basis_structure_verify_small_geometry.py');rows=b['rows']
            else:
                assert r['status']=='PASS_EXACT_PHYSICAL_CONDITIONAL_CLOSED_RANK_ROWS'
                assert r['consumer_sha256']==sha(ROOT/'two_basis_structure_verify_physical_closed_rank_bank.py');rows=b['cuts']
            for row in rows:inherited[rkkey(row)]=normrank(row)
        assert [inherited[k] for k in sorted(inherited)]==s['rank_rows']
        for r in s['rank_rows']:rank_geometry(r,U,dd);physical_ranks+=1
        for m,d in enumerate(dd):
            eq.append(dict(kind='zero_bucket',side=side,mask=m))
            for k in range(len(d['bins'])):eq.append(dict(kind='owner_bucket',side=side,mask=m,owner=k))
            for j in range(720):
                for bound in ['lower','upper']:ub.append(dict(kind='box',side=side,mask=m,index=j,bound=bound))
        for k in range(len(s['rank_rows'])):ub.append(dict(kind='rank',side=side,rank_index=k))
    assert eq==M['equalities'] and ub==M['inequalities']
    assert nv==5+sum(parameter_dimensions.values())
    Y={};reference_lambda=None
    for side,path in M['reference_assignment_sources'].items():
        cp=ROOT/path;c=read(cp);fp=cp.with_name(cp.name.removesuffix('.json.gz')+'.frozen.json');f=read(fp)
        rp=cp.with_name(cp.name.removesuffix('.json.gz')+'-independent.json');r=read(rp)
        assert r['status']=='PASS_EXACT_DIRECT_COUNT_AND_LISTED_RANK_ROWS' and r['consumer_sha256']==sha(ROOT/'verify_two_basis_rank_closed_allocation.py')
        assert sha(cp)==r['certificate_sha256'] and c['frozen_sha256']==r['frozen_sha256']==sha(fp)
        assert r['point_sha256']==sha(point) and f['side']==side and all(sha(ROOT/p)==h for p,h in f['source_hashes'].items())
        ll=list(map(Q,f['lambda_masses']))
        if reference_lambda is None:reference_lambda=ll
        else:assert reference_lambda==ll
        Y[side]=[list(map(Q,row)) for row in c['exact_allocations']]
    high=[sum(reference_lambda[m] for m in range(16) if m&t==t) for t in HIGH]
    assert high==list(map(Q,M['reference_law_high_moments']))
    x=[high[HIGH.index(v['mask'])] if v['kind']=='tau' else Y[v['side']][v['mask']][v['index']] for v in M['variables']]
    assert [ev(e,features,x) for e in lam]==reference_lambda
    allocation_checks={};reference_coordinates=0
    for side,s in M['sectors'].items():
        off=720*int(side=='Z');b=features[11+off:731+off]+[features[1451+1440*i+off+j] for i in range(4) for j in range(720)]
        allocation_checks[side]=check_allocation(Y[side],reference_lambda,[d[side] for d in ddall],b)
        for m in range(16):
            for j in range(720):assert ev(s['allocations'][m][j],features,x)==Y[side][m][j];reference_coordinates+=1
    packet_path=ROOT/prepared['numeric_packet_path'];assert sha(packet_path)==prepared['numeric_packet_sha256']
    packet=np.load(packet_path,allow_pickle=False);assert packet['nvars'].tolist()==[nv]
    assert packet['reference_x'].tolist()==list(map(float,x));row_counts={};nonzeros=0
    for kind,prefix in [('equalities','eq'),('inequalities','ub')]:
        assert len(packet[prefix+'_rhs'])==len(M[kind]) and len(packet[prefix+'_indptr'])==len(M[kind])+1
        assert int(packet[prefix+'_indptr'][0])==0 and int(packet[prefix+'_indptr'][-1])==len(packet[prefix+'_indices'])==len(packet[prefix+'_data'])
        assert all(np.isfinite(packet[prefix+k]).all() for k in ['_rhs','_data'])
        for i,d in enumerate(M[kind]):
            e=literal_row(M,d);packet_row(packet,prefix,i,e,features);v=ev(e,features,x)
            assert v==0 if kind=='equalities' else v<=0
        row_counts[kind]=len(M[kind]);nonzeros+=len(packet[prefix+'_indices'])
    # Independent signed combination: all32 boxes for one coordinate yield -1.
    total=empty()
    for d in ub:
        if d['kind']=='box' and d['side']=='X' and d['index']==0:total=add(total,literal_row(M,d))
    assert total==term(0,0,-1)
    rejected=[]
    for name,fn in [
        ('duplicate-expression-entry',lambda:decode([[[0,'1'],[0,'1']],[]],7211,nv)),
        ('out-of-range-variable',lambda:decode([[],[[nv,'1']]],7211,nv)),
        ('noncanonical-rational',lambda:decode([[[0,'2/2']],[]],7211,nv)),
        ('false-physical-rank',lambda:rank_geometry(dict(M['sectors']['X']['rank_rows'][0],contraction_rank=M['sectors']['X']['rank_rows'][0]['contraction_rank']+1),X,[d['X'] for d in ddall]))]:
        try:fn()
        except AssertionError:rejected.append(name)
        else:raise AssertionError('corruption accepted')
    assert all(sha(ROOT/p)==h for p,h in sources.items())
    return dict(status='PASS_EXACT_GENERAL_SHARED_LAW_MODEL',model_sha256=sha(model_path),
        prepared_report_sha256=sha(prepared_path),point_sha256=sha(point),consumer_sha256=sha(__file__),
        source_hashes=sources,variables=nv,shared_high_variables=5,local_dimensions=parameter_dimensions,
        exact_mobius_rows=16,symbolic_moment_rowspan_checks=moment_checks,structural_coordinate_checks=structural_checks,
        all_sixteen_patterns_retained=True,fixed_law_faces_used=False,physical_rank_rows=physical_ranks,
        exact_reference_coordinates=reference_coordinates,reference_checks=allocation_checks,
        semantic_rows=row_counts,numeric_packet_nonzeros_checked=nonzeros,corruptions_rejected=rejected,
        probability_box_combination='32 bounds equal -constant1<=0',lp_run=False,source_C16_answered=False,
        all_subset_rank_membership_proved=False,
        scope='Complete independent symbolic/source/sparse-packet replay of the general shared-law finite-rank model and its exact feasible reference. No optimizer or source exclusion.')

def main():
    ap=argparse.ArgumentParser();ap.add_argument('--model',type=Path,required=True);ap.add_argument('--prepared',type=Path,required=True)
    ap.add_argument('--point',type=Path,required=True);ap.add_argument('--output',type=Path,required=True);a=ap.parse_args()
    assert not a.output.exists();start=time.monotonic();out=replay(a.model,a.prepared,a.point)
    out.update(elapsed_seconds=time.monotonic()-start,process_nice=os.nice(0))
    a.output.write_text(json.dumps(out,indent=2)+'\n');print(json.dumps({k:v for k,v in out.items() if k!='source_hashes'}),flush=True)
if __name__=='__main__':main()
