#!/usr/bin/env python3
"""Independent exact eight-event marginal law or global moment separation.

Every full dual frame restricts to one of the enumerated allowed masks.
An allowed mask need not extend to a full frame; feasibility is only local.
"""
import os
assert os.getpriority(os.PRIO_PROCESS,0)==19
for key in ('OPENBLAS_NUM_THREADS','OMP_NUM_THREADS','MKL_NUM_THREADS','VECLIB_MAXIMUM_THREADS','NUMEXPR_NUM_THREADS','BLIS_NUM_THREADS'):
    os.environ[key]='1'
from pathlib import Path
from fractions import Fraction as Q
from itertools import combinations
from collections import Counter
import argparse,copy,gzip,hashlib,json,math,time
from verify_algebraic_model import physical
from verify_singleton_archive_cg import parse
from verify_singleton_exchange_terminal import rank
from read_soplex_exact_output_v2 import read_named_rational

ROOT=Path(__file__).resolve().parent
EVENTS=[['X',80],['X',512],['Z',186],['Z',433],['X',614],['X',281],['Z',51],['Z',83]]
POINT_SHA='4945dd10a5ec76c54311466ab0594b0c7b8fc2071eab4ae9a783a87143baad8f'
PAIRS=list(combinations(range(8),2))
def sha(path):return hashlib.sha256(Path(path).read_bytes()).hexdigest()
def read(path):
    p=Path(path);raw=p.read_bytes();return json.loads(gzip.decompress(raw) if p.suffix=='.gz' else raw)

def owner_index(side,a,b):
    i,j=a//16,b//16;h=(b-a)%16
    if h>8:h,i,j=16-h,j,i
    if h in (0,8) and i>j:i,j=j,i
    if side=='S' and h==0 and i==j:return i
    return 45+(0 if side=='S' else 9*2025)+h*2025+45*i+j

def target(path,events):
    values=list(map(Q,read(path)['values']));compact={};cursor=45
    for side in 'ST':
        for h in range(9):
            for i in range(45):
                for j in range(i if h in (0,8) else 0,45):
                    compact[side,h,i,j]=values[cursor];cursor+=1
    assert cursor==32535 and len(values)>=cursor
    full=values[:45]
    for side in 'ST':
        for h in range(9):
            for i in range(45):
                for j in range(45):
                    ii,jj=(j,i) if h in (0,8) and i>j else (i,j)
                    full.append(compact[side,h,ii,jj])
    assert len(full)==36495
    coordinates=[a//16 for _,a in events]
    for i,j in PAIRS:
        si,a=events[i];sj,b=events[j]
        coordinates.append(owner_index('S' if si==sj else 'T',a,b))
    wanted=[Q(1)]+[full[k] for k in coordinates]
    assert len(wanted)==37 and all(0<=v<=1 for v in wanted)
    for i,j in PAIRS:
        value=wanted[9+PAIRS.index((i,j))]
        assert max(0,wanted[1+i]+wanted[1+j]-1)<=value<=min(wanted[1+i],wanted[1+j])
    return wanted,coordinates,full

def features(mask):
    bits=[int(bool(mask&(1<<i))) for i in range(8)]
    return [1,*bits,*[bits[i]*bits[j] for i,j in PAIRS]]

def allowed(events,X,Z):
    keep=[];reasons={}
    for mask in range(256):
        xs=[a for k,(side,a) in enumerate(events) if side=='X' and mask>>k&1]
        zs=[a for k,(side,a) in enumerate(events) if side=='Z' and mask>>k&1]
        why=[]
        if rank(X[j] for j in xs)!=len(xs):why.append('dependent_X')
        if rank(Z[j] for j in zs)!=len(zs):why.append('dependent_Z')
        if any(sum((X[i]&Z[j]).bit_count()%2 for j in zs)>1 for i in xs):why.append('X_degree_above_one')
        if any(sum((X[i]&Z[j]).bit_count()%2 for i in xs)>1 for j in zs):why.append('Z_degree_above_one')
        if why:reasons[str(mask)]=why
        else:keep.append(mask)
    assert 0 in keep and set(keep)|set(map(int,reasons))==set(range(256))
    return keep,reasons

def context(path):
    d=read(path);assert d['status']=='EXACT_GLOBAL_EIGHT_PROBE_LP_REQUIRES_REPLAY'
    assert d['events']==EVENTS and len(set(map(tuple,d['events'])))==8
    assert sha(d['point'])==d['point_sha256']==POINT_SHA
    assert all(sha(ROOT/p)==h for p,h in d['source_hashes'].items())
    X,Z,_=physical();masks,excluded=allowed(d['events'],X,Z)
    assert d['allowed_masks']==masks
    q,coordinates,owner=target(d['point'],d['events']);assert list(map(Q,d['targets']))==q
    F=[features(mask) for mask in masks];n=len(F)
    assert d['variable_count']==n and d['row_count']==37+n
    assert d['nonzeros']==sum(sum(f) for f in F)+n
    assert sha(d['lp'])==d['lp_sha256']
    return d,masks,excluded,q,coordinates,owner,F

def rows(q,F):
    n=len(F)
    for k in range(37):yield 'f'+str(k),{i:Q(f[k]) for i,f in enumerate(F) if f[k]},'=',q[k]
    for i in range(n):yield 'n'+str(i),{i:Q(-1)},'<=',Q(0)

def primal_check(values,q,F):
    assert len(values)==len(F) and all(w>=0 for w in values)
    assert all(sum(w*f[k] for w,f in zip(values,F))==q[k] for k in range(37))

def ray_check(raw,q,F):
    for sign in (1,-1):
        v={key:sign*x for key,x in raw.items()};coef=[v['f'+str(k)] for k in range(37)]
        if any(v['n'+str(i)]<0 for i in range(len(F))):continue
        if any(sum(c*x for c,x in zip(coef,f))!=v['n'+str(i)] for i,f in enumerate(F)):continue
        gap=-sum(c*x for c,x in zip(coef,q))
        if gap>0:return coef,gap,sign
    raise AssertionError('No exact full-mask Farkas separator')

def main():
    ap=argparse.ArgumentParser();ap.add_argument('--manifest',type=Path,required=True);ap.add_argument('--output',type=Path,required=True)
    group=ap.add_mutually_exclusive_group();group.add_argument('--primal',type=Path);group.add_argument('--farkas',type=Path)
    ap.add_argument('--solver-frozen',type=Path);a=ap.parse_args();start=time.monotonic();assert not a.output.exists()
    d,masks,excluded,q,coordinates,owner,F=context(a.manifest);n=len(F)
    tokens=Path(d['lp']).read_text().split();checked=parse(tokens,rows(q,F),n)
    rejected=[]
    bad=tokens.copy();bad[4]='x'+str(n)
    try:parse(bad,rows(q,F),n)
    except (AssertionError,ValueError,IndexError):rejected.append('wrong_objective_variable')
    else:raise AssertionError('Accepted corrupt objective')
    out=dict(status='PASS_EXACT_GLOBAL_EIGHT_PROBE_LP',masks_enumerated=256,allowed_mask_count=n,
             excluded_mask_count=len(excluded),exclusion_reasons=excluded,features_checked=37,lp_rows_checked=checked)
    if a.primal or a.farkas:
        assert a.solver_frozen is not None;frozen=read(a.solver_frozen)
        assert frozen['input_manifest_sha256']==sha(a.manifest) and frozen['input_lp_sha256']==d['lp_sha256']
        if a.primal:
            assert '-X='+str(a.primal.resolve()) in frozen['command']
            w=read_named_rational(a.primal,['x'+str(i) for i in range(n)]);weights=[w['x'+str(i)] for i in range(n)]
            primal_check(weights,q,F)
            for label,corrupt in [('negative_weight',[-Q(1),*weights[1:]]),('wrong_mass',[weights[0]+1,*weights[1:]])]:
                try:primal_check(corrupt,q,F)
                except AssertionError:rejected.append(label)
                else:raise AssertionError(label)
            out.update(status='PASS_EXACT_GLOBAL_EIGHT_PROBE_LOCAL_LAW',atoms=[dict(mask=m,weight=str(w)) for m,w in zip(masks,weights) if w],
                       positive_atoms=sum(w>0 for w in weights),primal=str(a.primal),primal_sha256=sha(a.primal))
        else:
            assert '-Y='+str(a.farkas.resolve()) in frozen['command']
            raw=read_named_rational(a.farkas,[*['f'+str(k) for k in range(37)],*['n'+str(i) for i in range(n)]],'farkas')
            coefficients,gap,sign=ray_check(raw,q,F)
            # Integer global owner row, keeping its constant on the RHS.
            D=math.lcm(*(v.denominator for v in coefficients));ints=[int(v*D) for v in coefficients]
            divisor=math.gcd(*ints);assert divisor>0;ints=[v//divisor for v in ints]
            terms=Counter()
            for index,value in zip(coordinates,ints[1:]):terms[index]-=value
            terms=dict(sorted((k,v) for k,v in terms.items() if v));rhs=ints[0]
            violation=sum(Q(v)*owner[k] for k,v in terms.items())-rhs
            assert violation==gap*D/divisor>0
            assert all(sum(v*x for v,x in zip(ints,f))>=0 for f in F)
            bad=raw.copy();bad['f0']+=1
            try:ray_check(bad,q,F)
            except AssertionError:rejected.append('corrupt_farkas_constant')
            else:raise AssertionError('Accepted corrupt Farkas')
            out.update(status='PASS_EXACT_GLOBAL_EIGHT_PROBE_MOMENT_SEPARATION',farkas_sign=sign,
                       feature_coefficients=ints,owner_terms=[[k,v] for k,v in terms.items()],owner_rhs=rhs,
                       exact_global_point_violation=str(violation),farkas=str(a.farkas),farkas_sha256=sha(a.farkas))
        out.update(solver_frozen=str(a.solver_frozen),solver_frozen_sha256=sha(a.solver_frozen))
    out.update(manifest=str(a.manifest),manifest_sha256=sha(a.manifest),lp_sha256=d['lp_sha256'],
               point_sha256=d['point_sha256'],consumer_sha256=sha(__file__),parser_sha256=sha(ROOT/'read_soplex_exact_output_v2.py'),
               events=d['events'],source_hashes=d['source_hashes'],negative_controls_rejected=rejected,
               source_C16_answered=False,full_frame_constructed=False,
               scope='Unrestricted local eight-event law with physical rank and induced-matching necessary constraints; all original auxiliary allocations are free.',
               nice=19,threads=1,elapsed_seconds=time.monotonic()-start)
    a.output.write_text(json.dumps(out,indent=2)+'\n')
    print(json.dumps({k:v for k,v in out.items() if k not in ('source_hashes','exclusion_reasons','atoms')}),flush=True)
if __name__=='__main__':main()
