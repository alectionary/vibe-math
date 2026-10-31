#!/usr/bin/env python3
"""Independent complete conditional eight-event law and parent-prefix proof."""
import os
assert os.getpriority(os.PRIO_PROCESS,0)==19
for k in ('OPENBLAS_NUM_THREADS','OMP_NUM_THREADS','MKL_NUM_THREADS','VECLIB_MAXIMUM_THREADS','NUMEXPR_NUM_THREADS','BLIS_NUM_THREADS'):assert os.environ.get(k)=='1'
from pathlib import Path
from fractions import Fraction as Q
from itertools import combinations
import argparse,copy,hashlib,json,time
from verify_owner_star_flow_extension import ROOT,sha,read,decode_model,empty,term,add,decode
from verify_global_eight_probe_law import EVENTS,target,features
from verify_algebraic_model import physical
XX=(614,281);ZZ=(51,83);CENTERS=(0,1,2,4,8,3,5,9,6,10,12)
def rank(vs):
    rows={}
    for v in vs:
        while v:
            p=v&-v
            if p in rows:v^=rows[p]
            else:rows[p]=v;break
    return len(rows)
def allowed_masks(X,Z):
    out=[]
    for m in range(256):
        x=[j for k,(s,j) in enumerate(EVENTS) if s=='X' and m>>k&1]
        z=[j for k,(s,j) in enumerate(EVENTS) if s=='Z' and m>>k&1]
        if rank(X[j] for j in x)!=len(x) or rank(Z[j] for j in z)!=len(z):continue
        if any(sum((X[i]&Z[j]).bit_count()%2 for j in z)>1 for i in x):continue
        if any(sum((X[i]&Z[j]).bit_count()%2 for i in x)>1 for j in z):continue
        out.append(m)
    return out
def atoms(M,m):
    sx=term(1,22481+2*m);sz=term(1,22482+2*m)
    pairs={tuple(p):i for i,p in enumerate(M['owner_flow_extension']['physical_pairs'])}
    A={3:sx,12:sz}
    for i,x in enumerate(XX):
        for j,z in enumerate(ZZ):A[(1<<i)|(1<<(j+2))]=term(1,13393+568*m+pairs[x,z])
    y=[M['sectors']['X']['allocations'][m][j] for j in XX]+[M['sectors']['Z']['allocations'][m][j] for j in ZZ]
    pair_masks=list(A)
    for i in range(4):
        e=y[i]
        for b in pair_masks:
            if b>>i&1:e=add(e,A[b],-1)
        A[1<<i]=e
    e=M['lambda_expressions'][m]
    for v in A.values():e=add(e,v,-1)
    A[0]=e;assert set(A)==set(CENTERS)
    return A
def expected_rows(M,allowed):
    out=[]
    for side,owner in [('X',7847),('Z',185)]:
        e=term(0,owner+1,-1)
        for m in range(16):e=add(e,term(1,22481+2*m+(side=='Z')))
        out.append(dict(name='k22_sum_'+side,relation='=',expression=e,kind='global_same_sector_pair',side=side))
    for m in range(16):
        A=atoms(M,m)
        for b in (3,12,1,2,4,8,0):out.append(dict(name=f'k22_atom_{m}_{b}',relation='<=',expression=add(empty(),A[b],-1),kind='center_atom_nonnegative',mask=m,center_mask=b))
    for m in range(16):
        for b,e in sorted(atoms(M,m).items()):
            if m|(b<<4) not in allowed:out.append(dict(name=f'k22_forbidden_{m}_{b}',relation='=',expression=e,kind='forbidden_eight_event_atom',mask=m,center_mask=b,full_mask=m|(b<<4)))
    return out
def context(manifest):
    d=read(manifest);assert d['status']=='PASS_EXACT_OWNER_K22_CAPACITY_LP_TEXT_ROUNDTRIP'
    assert sha(d['semantic'])==d['semantic_sha256'] and sha(d['lp'])==d['lp_sha256']
    w=read(d['semantic']);assert w['status']=='FROZEN_COMPLETE_EIGHT_EVENT_CAPACITY_EXTENSION'
    for p,h in w['source_hashes'].items():assert sha(p)==h
    for field in ('parent_face_manifest','parent_face_receipt','parent_mapping','parent_full_manifest','parent_semantic','parent_lp','global_eight_manifest','global_eight_receipt'):
        assert sha(w[field])==w[field+'_sha256']
    face=read(w['parent_face_manifest']);fr=read(w['parent_face_receipt']);mapping=read(w['parent_mapping'])
    assert face['status']=='PASS_EXACT_ZERO_FACE_LP_TEXT_ROUNDTRIP' and fr['status']=='PASS_EXACT_OWNER_CAPACITY_ZERO_FACE_REDUCTION'
    assert fr['manifest_sha256']==w['parent_face_manifest_sha256']==d['parent_face_manifest_sha256']
    assert fr['consumer_sha256']==sha('verify_owner_capacity_zero_face.py')
    assert face['mapping_sha256']==fr['mapping_sha256']==w['parent_mapping_sha256']
    assert face['semantic_sha256']==fr['semantic_sha256']==w['parent_semantic_sha256']
    assert face['lp_sha256']==w['parent_lp_sha256'] and face['full_manifest_sha256']==w['parent_full_manifest_sha256']
    assert face['zero_tau_pins'] is mapping['zero_tau_pins'] is w['zero_tau_pins'] is d['zero_tau_pins'] is True
    for p,h in fr['source_hashes'].items():assert sha(p)==h
    saved=read(w['parent_semantic']);M=decode_model(saved['model'])
    assert M['X_anchors']==[80,512] and M['Z_anchors']==[186,433] and len(M['variables'])==22481
    gm=read(w['global_eight_manifest']);gr=read(w['global_eight_receipt'])
    assert gm['status']=='EXACT_GLOBAL_EIGHT_PROBE_LP_REQUIRES_REPLAY' and gr['status']=='PASS_EXACT_GLOBAL_EIGHT_PROBE_LP'
    assert gr['manifest_sha256']==w['global_eight_manifest_sha256'] and gr['consumer_sha256']==sha('verify_global_eight_probe_law.py')
    assert gm['events']==EVENTS and EVENTS==[['X',80],['X',512],['Z',186],['Z',433],['X',614],['X',281],['Z',51],['Z',83]]
    assert w['point']==saved['point'] and sha(w['point'])==w['point_sha256']==d['point_sha256']==gm['point_sha256']==saved['point_sha256']
    q,coords,owner=target(ROOT/w['point'],EVENTS);assert q==list(map(Q,gm['targets']))
    features_owner=[Q(1),*owner];assert features_owner==list(map(Q,saved['feature_values']))
    assert coords[8+list(combinations(range(8),2)).index((4,5))]==7847
    assert coords[8+list(combinations(range(8),2)).index((6,7))]==185
    X,Z,_=physical();allowed=allowed_masks(X,Z);assert len(allowed)==152 and allowed==gm['allowed_masks']
    assert all((X[x]&Z[z]).bit_count()%2 for x in XX for z in ZZ)
    return d,w,face,mapping,saved,M,features_owner,q,allowed
def replay_wrapper(w,data):
    d,_,face,mapping,saved,M,f,q,allowed=data
    assert w['centers']=={'X':list(XX),'Z':list(ZZ)}
    assert [w[k] for k in ('parent_full_variables','parent_reduced_variables','full_variables','reduced_variables')]==[22481,12623,22513,12655]
    assert w['retained_old_full_rows']==98730 and w['retained_old_reduced_rows']==64697
    assert w['old_omitted_probability_proofs_unchanged'] is w['new_zero_mass_variables_retained'] is w['all_sixteen_patterns'] is True
    expected_vars=[dict(mask=m,side=s,full_index=22481+2*m+i,reduced_index=12623+2*m+i) for m in range(16) for i,s in enumerate('XZ')]
    assert w['new_variables']==expected_vars
    rows=expected_rows(M,set(allowed));assert len(rows)==138 and sum(r['kind']=='forbidden_eight_event_atom' for r in rows)==24
    assert w['forbidden_eight_atom_equalities']==24 and len(w['appended_rows'])==len(rows)
    for stored,r in zip(w['appended_rows'],rows):
        assert {k:v for k,v in stored.items() if k!='expression'}=={k:v for k,v in r.items() if k!='expression'}
        assert decode(stored['expression'],36496,22513)==r['expression']
    keep=mapping['retained_variables'];assert len(keep)==12623 and len(set(keep))==12623
    renumber={j:i for i,j in enumerate(keep)};renumber.update({22481+i:12623+i for i in range(32)})
    reduced=[]
    for r in rows:
        e=r['expression'];constant=sum((v*f[j] for j,v in e[0].items()),Q(0))
        c={renumber[j]:v for j,v in e[1].items() if j in renumber}
        reduced.append(dict(name=r['name'],relation=r['relation'],coefficients=[[j,str(v)] for j,v in sorted(c.items())],rhs=str(-constant)))
    assert reduced==w['reduced_appended_rows']
    assert [d[k] for k in ('variable_count','full_variable_count','row_count','full_row_count','appended_rows','appended_inequalities','appended_equalities')]==[12655,22513,64835,98868,138,112,26]
    assert d['nonzeros']==face['nonzeros']+sum(len(r['coefficients']) for r in reduced)
    return rows,reduced
def text_replay(raw,w,reduced):
    old=(ROOT/w['parent_lp']).read_bytes();parts=old.split(b'Bounds\n');assert len(parts)==2
    prefix=parts[0];assert len(prefix)==w['parent_row_prefix_bytes'] and hashlib.sha256(prefix).hexdigest()==w['parent_row_prefix_sha256']
    assert raw.startswith(prefix)
    assert parts[1].split()==[v for i in range(12623) for v in [('x'+str(i)).encode(),b'free']]+[b'End']
    tokens=raw[len(prefix):].decode().split();i=0
    for row in reduced:
        assert tokens[i]==row['name']+':';i+=1;c={}
        while tokens[i] in ('+','-'):
            v=Q(tokens[i+1])*(1 if tokens[i]=='+' else -1);name=tokens[i+2]
            assert name.startswith('x') and name[1:].isdigit();j=int(name[1:]);assert 0<=j<12655 and j not in c
            c[j]=v;i+=3
        assert {j:v for j,v in c.items() if v}=={j:Q(v) for j,v in row['coefficients']}
        assert tokens[i]==row['relation'] and Q(tokens[i+1])==Q(row['rhs']);i+=2
    assert tokens[i]=='Bounds';i+=1
    for j in range(12655):assert tokens[i:i+2]==['x'+str(j),'free'];i+=2
    assert tokens[i:]==['End']
def atom_values(lam,y,t,sx,sz):
    A={3:sx,12:sz,5:t[0,2],9:t[0,3],6:t[1,2],10:t[1,3]}
    pair_masks=list(A)
    for i in range(4):A[1<<i]=y[i]-sum(A[b] for b in pair_masks if b>>i&1)
    A[0]=lam-sum(A.values());return A
def controls(allowed):
    accepted=[];case_count=0
    for full in range(256):
        m=full&15;b=full>>4;y=[Q((b>>i)&1) for i in range(4)]
        t={(i,j):y[i]*y[j] for i in (0,1) for j in (2,3)}
        A=atom_values(Q(1),y,t,y[0]*y[1],y[2]*y[3]);assert sum(A.values())==1
        valid=min(A.values())>=0 and all(not value for c,value in A.items() if m|(c<<4) not in allowed)
        assert valid==(full in allowed)
        if valid:assert A[b]==1 and sum(v!=0 for v in A.values())==1;accepted.append(full)
        case_count+=1
    assert accepted==list(allowed)
    # Eleven vertex images and one rational convex combination prove the
    # displayed linear inverse literally, without assuming four-bit geometry.
    mass={c:Q(i+1,66) for i,c in enumerate(sorted(CENTERS))};assert sum(mass.values())==1
    y=[sum(v for c,v in mass.items() if c>>i&1) for i in range(4)]
    t={(i,j):sum(v for c,v in mass.items() if c>>i&1 and c>>j&1) for i in (0,1) for j in (2,3)}
    assert atom_values(Q(1),y,t,mass[3],mass[12])==mass
    return dict(physical_eight_assignments_checked=case_count,allowed_assignments=len(accepted),conditional_atom_slots=176,forbidden_atom_slots=24,rational_inverse_control=True)
def main():
    ap=argparse.ArgumentParser();ap.add_argument('--manifest',required=True);ap.add_argument('--output',required=True);a=ap.parse_args();start=time.monotonic()
    data=context(a.manifest);d,w,face,mapping,saved,M,f,q,allowed=data;rows,reduced=replay_wrapper(w,data);raw=(ROOT/d['lp']).read_bytes();text_replay(raw,w,reduced);finite=controls(allowed)
    rejected=[]
    for label in ('wrong_S_sign','missing_forbidden_atom','wrong_variable_map'):
        bad=copy.deepcopy(w)
        if label=='wrong_S_sign':bad['appended_rows'][0]['expression'][0][0][1]='1'
        elif label=='missing_forbidden_atom':bad['appended_rows'].pop()
        else:bad['new_variables'][0]['full_index']+=1
        try:replay_wrapper(bad,data)
        except (AssertionError,ValueError,KeyError):rejected.append(label)
        else:raise AssertionError(('accepted corruption',label))
    for label,bad in [('changed_old_prefix',raw.replace(b'obj: + 0 x0',b'obj: + 1 x0',1)),('implicit_new_bound',raw.replace(b'x12654 free',b'0 <= x12654',1))]:
        try:text_replay(bad,w,reduced)
        except (AssertionError,ValueError,IndexError):rejected.append(label)
        else:raise AssertionError(('accepted corruption',label))
    sources=dict(w['source_hashes'])
    for p in [a.manifest,d['semantic'],Path(__file__).name,'verify_owner_star_flow_extension.py','verify_global_eight_probe_law.py','verify_algebraic_model.py']:sources[p]=sha(p)
    out=dict(status='PASS_EXACT_OWNER_K22_CAPACITY_MODEL',manifest_sha256=sha(a.manifest),model_sha256=d['semantic_sha256'],semantic_sha256=d['semantic_sha256'],lp_sha256=d['lp_sha256'],consumer_sha256=sha(Path(__file__).name),source_hashes=sources,
        point_sha256=w['point_sha256'],parent_full_rows_retained=98730,parent_reduced_rows_verbatim=64697,new_variables=32,new_inequalities=112,new_same_sector_equalities=2,new_forbidden_atom_equalities=24,
        full_variables=22513,reduced_variables=12655,full_rows=98868,reduced_rows=64835,finite_controls=finite,corruptions_rejected=rejected,all_parent_zero_proofs_unchanged=True,
        zero_tau_pins=True,source_C16_answered=False,global_target_exclusion_proved=False,scope='Complete152-state physical eight-event marginal law shares the old capacity variables at the pinned law. No basis extension or global target exclusion follows from preparation.',priority=19,elapsed_seconds=time.monotonic()-start)
    path=ROOT/a.output;assert not path.exists();path.write_text(json.dumps(out,indent=2,sort_keys=True)+'\n');print(json.dumps({k:v for k,v in out.items() if k!='source_hashes'}))
if __name__=='__main__':main()
