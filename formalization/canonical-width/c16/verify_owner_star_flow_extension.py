#!/usr/bin/env python3
"""Independent physical and exact-text proof of selected shared owner flows.

No extension producer, LP exporter or optimizer is imported. Existing checked
base coordinates are lifted independently; added ranks, stars and flows are
reconstructed from physical indices. Optional law pins are always explicit.
"""
import os
assert os.getpriority(os.PRIO_PROCESS,0)==19
for _key in ('OPENBLAS_NUM_THREADS','OMP_NUM_THREADS','MKL_NUM_THREADS','VECLIB_MAXIMUM_THREADS','NUMEXPR_NUM_THREADS','BLIS_NUM_THREADS'):
    assert os.environ.get(_key)=='1'
from pathlib import Path
from fractions import Fraction as Q
from collections import Counter
from itertools import combinations
import argparse,copy,gzip,hashlib,json,time
from verify_two_sided_full_basis_oracle import physical_source,domains,columns,point_owner,target
from verify_joint_general_literal import source_star,geometry,normalized_rank,rank

ROOT=Path(__file__).resolve().parent
HIGH=[7,11,13,14,15]
def sha(p):return hashlib.sha256((ROOT/p).read_bytes()).hexdigest()
def read(p):
    p=ROOT/p;b=p.read_bytes();return json.loads(gzip.decompress(b) if p.suffix=='.gz' else b)
def empty():return ({},{})
def term(k,j,v=1):
    e=empty()
    if v:e[k][j]=Q(v)
    return e
def add(a,b,c=1):
    e=(dict(a[0]),dict(a[1]))
    for k in (0,1):
        for j,v in b[k].items():
            q=e[k].get(j,Q(0))+c*v
            if q:e[k][j]=q
            else:e[k].pop(j,None)
    return e
def decode(e,nf,nv):
    assert isinstance(e,list) and len(e)==2;out=empty()
    for k,n in [(0,nf),(1,nv)]:
        for j,s in e[k]:
            assert type(j)is int and 0<=j<n and j not in out[k] and type(s)is str
            q=Q(s);assert q and str(q)==s;out[k][j]=q
    return out
def decode_model(raw):
    n=len(raw['variables']);M=dict(raw)
    M['lambda_expressions']=[decode(e,36496,n) for e in raw['lambda_expressions']]
    M['sectors']={s:dict(r,allocations=[[decode(e,36496,n) for e in row] for row in r['allocations']],local_consistency=[decode(e,36496,n) for e in r['local_consistency']]) for s,r in raw['sectors'].items()}
    M['star_rows']=[dict(r,expression=decode(r['expression'],36496,n)) for r in raw['star_rows']]
    return M
def coordinate(x,z):
    oi,ti=divmod(x,16);oj,tj=divmod(z,16);h=(tj-ti)%16
    if h>8:oi,oj,h=oj,oi,16-h
    if h in (0,8):oi,oj=sorted((oi,oj))
    return 18270+2025*h+45*oi+oj
def reasons(X,Z,xx,zz,m,x,z):
    why=[]
    for k,a in enumerate(xx):
        if x==a and not(m>>k&1):why.append(['absent_X_endpoint',a])
        if m>>k&1 and x!=a and (X[a]&Z[z]).bit_count()%2:why.append(['selected_other_X_owner',a])
    for k,b in enumerate(zz):
        if z==b and not(m>>(k+2)&1):why.append(['absent_Z_endpoint',b])
        if m>>(k+2)&1 and z!=b and (X[x]&Z[b]).bit_count()%2:why.append(['selected_other_Z_owner',b])
    return why

def expression(M,d):
    k=d['kind'];lam=M['lambda_expressions']
    if k=='owner_star':return M['star_rows'][d['star_index']]['expression']
    if k=='lambda_nonnegative':return add(empty(),lam[d['mask']],-1)
    if k.startswith('owner_flow_'):
        meta=M['owner_flow_extension'];E=len(meta['physical_pairs']);n=meta['base_variable_count']
        if k=='owner_flow_column':
            edge=d['edge'];x,z=meta['physical_pairs'][edge];out=term(0,coordinate(x,z)+1,-1)
            for m in range(16):out=add(out,term(1,n+m*E+edge))
            return out
        if k=='owner_flow_row':
            st=meta['stars'][d['star']];m=d['mask'];out=add(empty(),M['sectors'][st['side']]['allocations'][m][st['probe']],-1)
            for edge in st['edges']:out=add(out,term(1,n+m*E+edge))
            return out
        assert k=='owner_flow_bound';m,e,b=d['mask'],d['edge'],d['bound'];x,z=meta['physical_pairs'][e];t=term(1,n+m*E+e)
        if b=='nonnegative':return add(empty(),t,-1)
        if b=='structural_zero':return t
        if b in ('X_upper','Z_upper'):
            s=b[0];return add(t,M['sectors'][s]['allocations'][m][x if s=='X' else z],-1)
        assert b=='frechet_lower'
        return add(add(add(M['sectors']['X']['allocations'][m][x],M['sectors']['Z']['allocations'][m][z]),lam[m],-1),t,-1)
    s=M['sectors'][d['side']];Y=s['allocations']
    if k=='local_consistency':return s['local_consistency'][d['local_index']]
    if k=='box':return add(empty(),Y[d['mask']][d['index']],-1) if d['bound']=='lower' else add(Y[d['mask']][d['index']],lam[d['mask']],-1)
    if k=='rank':
        r=s['rank_rows'][d['rank_index']];m,A,rr=r['mask'],r['indices'],r['contraction_rank']
    else:
        m=d['mask'];domain=s['domains'][m]
        if k=='zero_bucket':A=domain['zero_forced']+domain['zero_free'];rr=domain['zero_required']
        else:assert k=='owner_bucket';A=domain['bins'][d['owner']];rr=1
    out=add(empty(),lam[m],-rr)
    for j in A:out=add(out,Y[m][j])
    return out

def validate_base(M,raw,base_path,receipt_path,X,Z,dd):
    b,r=read(base_path),read(receipt_path);n=len(b['variables'])
    assert r['status']=='PASS_EXACT_GENERAL_SHARED_LAW_MODEL' and r['model_sha256']==sha(base_path)
    assert r['consumer_sha256']==sha('verify_two_basis_joint_general.py') and r['point_sha256']==M['point_sha256']
    assert M['source_hashes'][str(base_path)]==sha(base_path) and M['source_hashes'][str(receipt_path)]==sha(receipt_path)
    assert M['variables'][:n]==b['variables'] and M['equalities'][:len(b['equalities'])]==b['equalities']
    assert M['high_masks']==b['high_masks']==HIGH and M['structural_only_elimination'] and not M['fixed_law_faces_used']
    assert [M[k] for k in ('X_anchors','Z_anchors')]==[b[k] for k in ('X_anchors','Z_anchors')]
    fmap=[0 if j is None else j+1 for j in columns(M['X_anchors'],M['Z_anchors'])]
    assert raw['source_feature_to_owner_target']==fmap and raw['feature_count']==36496
    def lift(e):
        q=decode(e,7211,n);out=({},dict(q[1]))
        for j,v in q[0].items():out=add(out,term(0,fmap[j],v))
        return out
    assert M['lambda_expressions']==[lift(e) for e in b['lambda_expressions']]
    for side in ('X','Z'):
        assert M['sectors'][side]['allocations']==[[lift(e) for e in row] for row in b['sectors'][side]['allocations']]
        assert M['sectors'][side]['local_consistency']==[lift(e) for e in b['sectors'][side]['local_consistency']]
        assert M['sectors'][side]['domains']==b['sectors'][side]['domains']
    expected={s:list(b['sectors'][s]['rank_rows']) for s in ('X','Z')}
    for item in M['additional_rank_bindings']:
        bank,checked=read(item['bank']),read(item['receipt']);side=bank['side']
        assert item['bank_sha256']==sha(item['bank'])==checked['bank_sha256'] and item['receipt_sha256']==sha(item['receipt'])
        assert checked['status'] in ('PASS_EXACT_PHYSICAL_CONDITIONAL_CLOSED_RANK_ROWS','PASS_EXACT_PHYSICAL_CONDITIONAL_RANK_ROWS')
        assert [bank[k] for k in ('X_anchors','Z_anchors')]==[M[k] for k in ('X_anchors','Z_anchors')]
        for p,h in bank['source_hashes'].items():assert sha(p)==h
        keys={(q['mask'],tuple(q['indices'])) for q in expected[side]};count=0
        for row in bank['cuts']:
            geometry(row,X if side=='X' else Z,[d[side] for d in dd]);key=row['mask'],tuple(row['indices'])
            if key not in keys:expected[side].append(normalized_rank(row));keys.add(key);count+=1
        assert count==item['added_rows']
    for side,U in [('X',X),('Z',Z)]:
        assert M['sectors'][side]['rank_rows']==expected[side]
        for row in expected[side]:geometry(row,U,[d[side] for d in dd])
    stars=[];data=dict(X=X,Z=Z,xa=M['X_anchors'],za=M['Z_anchors'])
    for bi,item in enumerate(M['star_bindings']):
        bank,checked=read(item['bank']),read(item['receipt'])
        assert sha(item['bank'])==item['bank_sha256']==checked['bank_sha256'] and sha(item['receipt'])==item['receipt_sha256']
        assert checked['status']=='PASS_EXACT_CONDITIONAL_OWNER_STAR_CUTS'
        assert item['consumer'] in ('verify_conditional_owner_star.py','verify_conditional_owner_star_v2.py')
        assert item['consumer_sha256']==checked['consumer_sha256']==sha(item['consumer'])
        assert [bank[k] for k in ('X_anchors','Z_anchors')]==[M[k] for k in ('X_anchors','Z_anchors')]
        assert checked['cuts_checked']==len(bank['cuts'])
        assert bank['source_hashes']==checked['source_hashes']
        for p,h in bank['source_hashes'].items():assert sha(p)==h
        for ci,cut in enumerate(bank['cuts']):
            coef=source_star(data,cut);e=empty()
            for key,v in coef.items():
                q=term(0,key[1]+1) if key[0]=='T' else M['lambda_expressions'][key[1]] if key[0]=='lambda' else M['sectors'][key[0]]['allocations'][key[1]][key[2]]
                e=add(e,q,v)
            stars.append(dict(binding=bi,cut_index=ci,expression=e,coefficients=coef))
    assert [dict(binding=s['binding'],cut_index=s['cut_index'],expression=s['expression']) for s in stars]==M['star_rows']
    meta=M['owner_flow_extension'];assert meta['base_variable_count']==n and meta['base_equality_count']==len(b['equalities'])
    prefix=M['inequalities'][:meta['base_inequality_count']]
    expected_desc=[dict(kind='lambda_nonnegative',mask=m) for m in range(16)]
    expected_desc += [dict(kind='box',side=s,mask=m,index=j,bound=k) for s in ('X','Z') for m in range(16) for j in range(720) for k in ('lower','upper')]
    expected_desc += [dict(kind='rank',side=s,rank_index=i) for s in ('X','Z') for i in range(len(expected[s]))]
    expected_desc += [dict(kind='owner_star',star_index=i) for i in range(len(stars))]
    key=lambda d:json.dumps(d,sort_keys=True)
    assert Counter(map(key,prefix))==Counter(map(key,expected_desc))
    return stars

def validate_extension(M,X,Z,probes):
    meta=M['owner_flow_extension'];n=meta['base_variable_count'];xx,zz=M['X_anchors'],M['Z_anchors']
    assert len(probes) in (2,3,4) and len(set(map(tuple,probes)))==len(probes)
    assert {s for s,i in probes}=={'X','Z'}
    stars=[];pairs=set()
    for s,i in probes:
        assert type(i)is int and 0<=i<720 and i not in (xx if s=='X' else zz)
        near=[j for j in range(720) if ((X[i]&Z[j]) if s=='X' else (X[j]&Z[i])).bit_count()%2]
        edges=[(i,j) if s=='X' else (j,i) for j in near];pairs.update(edges)
        stars.append(dict(side=s,probe=i,neighbors=near,pairs=edges))
    pairs=sorted(pairs);E=len(pairs);lookup={p:i for i,p in enumerate(pairs)}
    for s in stars:s['edges']=[lookup[p] for p in s.pop('pairs')]
    assert meta['stars']==stars and meta['physical_pairs']==[list(p) for p in pairs]
    cells=[[m,x,z,n+m*E+e] for m in range(16) for e,(x,z) in enumerate(pairs)]
    assert meta['cells']==cells and len(M['variables'])==n+16*E
    assert M['variables'][n:]==[dict(kind='owner_joint',mask=m,X_index=x,Z_index=z) for m,x,z,v in cells]
    shared=[dict(edge=e,physical_pair=list(p),stars=[k for k,s in enumerate(stars) if e in s['edges']]) for e,p in enumerate(pairs) if sum(e in s['edges'] for s in stars)>1]
    assert meta['shared_edges']==shared and shared
    assert meta['all_sixteen_patterns'] is True and meta['copied_zero_tau_pins'] is False and meta['shared_physical_pair_cells'] is True
    eq=[dict(kind='owner_flow_row',star=k,mask=m) for k in range(len(stars)) for m in range(16)]
    eq += [dict(kind='owner_flow_column',edge=e) for e in range(E)]
    assert M['equalities'][meta['base_equality_count']:]==eq
    ub=[];zeros=[]
    for m,x,z,v in cells:
        e=lookup[x,z]
        ub += [dict(kind='owner_flow_bound',mask=m,edge=e,bound=k) for k in ('nonnegative','X_upper','Z_upper','frechet_lower')]
        why=reasons(X,Z,xx,zz,m,x,z)
        if why:
            zeros.append(dict(mask=m,edge=e,reasons=why));ub.append(dict(kind='owner_flow_bound',mask=m,edge=e,bound='structural_zero'))
    assert M['inequalities'][meta['base_inequality_count']:]==ub and meta['structural_zeros']==zeros
    total=empty()
    for e in M['lambda_expressions']:total=add(total,e)
    assert total==term(0,0)
    # Explicit exact nonnegative combination proves t<=1 without extra LP rows.
    for m,x,z,v in cells:
        e=lookup[x,z];upper=expression(M,dict(kind='owner_flow_bound',mask=m,edge=e,bound='X_upper'))
        upper=add(upper,expression(M,dict(kind='box',side='X',mask=m,index=x,bound='upper')))
        for q in range(16):
            if q!=m:upper=add(upper,expression(M,dict(kind='lambda_nonnegative',mask=q)))
        assert upper==add(term(1,v),term(0,0),-1)
        assert expression(M,dict(kind='owner_flow_bound',mask=m,edge=e,bound='nonnegative'))==term(1,v,-1)
    return dict(physical_edges=E,shared_edges=len(shared),joint_variables=len(cells),derived_joint_probability_bounds=len(cells),structural_zero_cells=len(zeros),added_equalities=len(eq),added_inequalities=len(ub))

def labels_and_rows(M,pinned):
    for kind,relation in [('equalities','='),('inequalities','<=')]:
        for i,d in enumerate(M[kind]):yield dict(name=kind+str(i),kind=kind,index=i),relation,expression(M,d)
    if pinned:
        for i,v in enumerate(M['variables']):
            if v['kind']=='tau':yield dict(name='zero_tau'+str(i),kind='zero_tau',index=i),'=',term(1,i)
def text_replay(path,M,saved,features):
    def tokens():
        with (ROOT/path).open() as f:
            for line in f:yield from line.split()
    it=iter(tokens());assert [next(it) for _ in range(7)]==['Minimize','obj:','+','0','x0','Subject','To']
    count=nz=0;n=len(M['variables'])
    for label,rel,e in labels_and_rows(M,saved['zero_tau_pins']):
        assert label==saved['row_labels'][count] and next(it)==label['name']+':'
        coeff={};token=next(it)
        while token in ('+','-'):
            q=Q(next(it))*(1 if token=='+' else -1);var=next(it)
            assert var.startswith('x') and 0<=int(var[1:])<n;j=int(var[1:]);coeff[j]=coeff.get(j,Q(0))+q;token=next(it)
        assert token==rel and Q(next(it))==-sum((q*features[j] for j,q in e[0].items()),Q(0))
        assert {j:q for j,q in coeff.items() if q}==e[1]
        count+=1;nz+=len(e[1])
    assert count==len(saved['row_labels']) and next(it)=='Bounds'
    for i in range(n):assert [next(it),next(it)]==['x'+str(i),'free']
    assert next(it)=='End' and next(it,None) is None
    return count,nz

def context(manifest_path,base_model,base_receipt,replay_lp=True):
    manifest=read(manifest_path);assert manifest['status']=='PASS_EXACT_OWNER_FLOW_LP_FRACTION_TEXT_ROUNDTRIP'
    assert manifest['semantic_sha256']==sha(manifest['semantic']) and manifest['lp_sha256']==sha(manifest['lp'])
    saved=read(manifest['semantic']);assert saved['status']=='EXACT_COMPLETE_OWNER_FLOW_LP_EXPORT_REQUIRE_REPLAY'
    M=decode_model(saved['model']);assert M['status']=='PREPARED_COMPLETE_SELECTED_OWNER_STAR_FLOW_EXTENSION_NO_SOLVE'
    assert saved['point_sha256']==M['point_sha256']==manifest['point_sha256']==sha(saved['point'])
    assert type(saved['zero_tau_pins'])is bool and saved['zero_tau_pins']==manifest['zero_tau_pins']
    for p,h in M['source_hashes'].items():assert sha(p)==h
    X,Z,_=physical_source();dd=domains(X,Z,M['X_anchors'],M['Z_anchors']);assert all(d['feasible'] for d in dd)
    features=[Q(1),*point_owner(saved['point'])];assert features==list(map(Q,saved['feature_values']))
    stars=validate_base(M,saved['model'],base_model,base_receipt,X,Z,dd)
    selection=read(manifest['selection']);assert sha(manifest['selection'])==manifest['selection_sha256']
    assert selection['point_sha256']==M['point_sha256'] and selection['probes']==manifest['probes']
    checks=validate_extension(M,X,Z,selection['probes'])
    for k in ('physical_edges','joint_variables','structural_zero_cells'):assert checks[k]==manifest[k]
    assert len(M['variables'])==manifest['variable_count'] and len(M['equalities'])==manifest['base_equalities'] and len(M['inequalities'])==manifest['inequalities']
    count,nz=text_replay(manifest['lp'],M,saved,features) if replay_lp else (len(saved['row_labels']),manifest['nonzeros'])
    assert count==manifest['row_count'] and nz==manifest['nonzeros']
    return manifest,saved,M,X,Z,dd,features,stars,checks

def flow_values(M,X,Z,lam,Y,owner,parameters):
    meta=M['owner_flow_extension'];E=len(meta['physical_pairs']);n=meta['base_variable_count'];assert len(parameters)==len(M['variables'])
    for m,x,z,v in meta['cells']:
        t=parameters[v];a,b=Y['X'][m][x],Y['Z'][m][z]
        assert 0<=t<=a and t<=b and t>=a+b-lam[m] and t<=1
        if reasons(X,Z,M['X_anchors'],M['Z_anchors'],m,x,z):assert t==0
    for st in meta['stars']:
        for m in range(16):assert sum(parameters[n+m*E+e] for e in st['edges'])==Y[st['side']][m][st['probe']]
    for e,(x,z) in enumerate(meta['physical_pairs']):assert sum(parameters[n+m*E+e] for m in range(16))==owner[coordinate(x,z)]
    return dict(joint_cells=len(meta['cells']),selected_center_rows=16*len(meta['stars']),physical_edge_columns=E,shared_edge_patterns=16*len(meta['shared_edges']))

def finite_controls(M,X,Z,probes):
    frames_checked=edge_checks=mixture_checks=all_pool_counterexamples=0
    denominators=[]
    for dim in (2,3):
        U=list(range(1,1<<dim));n=len(U);anchors=[0,1]
        bases=[b for b in combinations(range(n),dim) if rank(U[j] for j in b)==dim]
        frames=[];edges=[(x,z) for x in range(n) for z in range(n) if (U[x]&U[z]).bit_count()%2]
        for xb in bases:
            for zb in bases:
                if not all(sum((U[x]&U[z]).bit_count()%2 for z in zb)==1 for x in xb):continue
                if not all(sum((U[x]&U[z]).bit_count()%2 for x in xb)==1 for z in zb):continue
                m=sum(int(a in xb)<<i for i,a in enumerate(anchors))+sum(int(a in zb)<<(i+2) for i,a in enumerate(anchors))
                frames.append((m,set(xb),set(zb)));frames_checked+=1
                for x,z in edges:
                    a,b=int(x in xb),int(z in zb);t=a*b;zero=bool(reasons(U,U,anchors,anchors,m,x,z))
                    assert max(0,a+b-1)<=t<=(0 if zero else min(a,b));edge_checks+=1
                for x in xb:
                    assert sum(int(z in zb) for z in range(n) if (U[x]&U[z]).bit_count()%2)==1
                    assert sum(int(z in zb) for z in range(n))==dim
                    all_pool_counterexamples+=1
        D=len(frames);assert D;denominators.append(D)
        lam=[Q(0)]*16;Y={s:[[Q(0)]*n for _ in range(16)] for s in ('X','Z')};T={(m,x,z):Q(0) for m in range(16) for x,z in edges}
        for m,xb,zb in frames:
            lam[m]+=Q(1,D)
            for x in xb:Y['X'][m][x]+=Q(1,D)
            for z in zb:Y['Z'][m][z]+=Q(1,D)
            for x,z in edges:T[m,x,z]+=Q(int(x in xb and z in zb),D)
        for m in range(16):
            for x,z in edges:
                t=T[m,x,z];a,b=Y['X'][m][x],Y['Z'][m][z]
                assert 0<=t<=a and t<=b and t>=a+b-lam[m]
                if reasons(U,U,anchors,anchors,m,x,z):assert t==0
                mixture_checks+=1
            for x in range(n):assert sum(T[m,x,z] for z in range(n) if (x,z) in edges)==Y['X'][m][x]
            for z in range(n):assert sum(T[m,x,z] for x in range(n) if (x,z) in edges)==Y['Z'][m][z]
        for x,z in edges:assert sum(T[m,x,z] for m in range(16))==Q(sum(x in xb and z in zb for _,xb,zb in frames),D)
    # Compare the folded T index with literal simultaneous rotations and sector swap.
    pairs=M['owner_flow_extension']['physical_pairs']+[[a,16+b] for a in range(16) for b in range(16)]
    coordinates=0
    for seed in (1,7,19):
        xb=[int((j*j+seed*j+3)%11<5) for j in range(720)]
        zb=[int((seed*j*j+5*j+1)%13<6) for j in range(720)]
        for x,z in pairs:
            oi,ti=divmod(x,16);oj,tj=divmod(z,16);q=coordinate(x,z)-18270;h,q=divmod(q,2025);i,j=divmod(q,45)
            direct=sum(xb[16*oi+(ti+r)%16]*zb[16*oj+(tj+r)%16]+zb[16*oi+(ti+r)%16]*xb[16*oj+(tj+r)%16] for r in range(16))
            canonical=sum(xb[16*i+r]*zb[16*j+(r+h)%16]+zb[16*i+r]*xb[16*j+(r+h)%16] for r in range(16))
            assert direct==canonical;coordinates+=1
    rejected=[];meta=M['owner_flow_extension']
    for label in ('duplicate-cell-index','missing-X-upper','changed-column-edge','false-structural-zero','copied-law-pins'):
        bad=dict(M);bm=dict(meta);bad['owner_flow_extension']=bm
        if label=='duplicate-cell-index':
            bm['cells']=list(meta['cells']);bm['cells'][0]=list(bm['cells'][0]);bm['cells'][0][-1]+=1
        elif label=='missing-X-upper':
            k=next(i for i,d in enumerate(M['inequalities']) if d['kind']=='owner_flow_bound' and d['bound']=='X_upper');bad['inequalities']=M['inequalities'][:k]+M['inequalities'][k+1:]
        elif label=='changed-column-edge':
            k=next(i for i,d in enumerate(M['equalities']) if d['kind']=='owner_flow_column');bad['equalities']=list(M['equalities']);bad['equalities'][k]=dict(bad['equalities'][k],edge=-1)
        elif label=='false-structural-zero':
            bm['structural_zeros']=list(meta['structural_zeros']);bm['structural_zeros'][0]=dict(bm['structural_zeros'][0],reasons=[['invented',-1]])
        else:bm['copied_zero_tau_pins']=True
        try:validate_extension(bad,X,Z,probes)
        except AssertionError:rejected.append(label)
        else:raise AssertionError(('accepted flow-model mutant',label))
    return dict(actual_tiny_dual_frames=frames_checked,literal_source_edge_bounds=edge_checks,
                non_dyadic_mixture_denominators=denominators,conditional_mixture_edge_bounds=mixture_checks,
                all_pool_instead_of_neighbors_counterexamples=all_pool_counterexamples,
                literal_32_action_coordinate_checks=coordinates,corruptions_rejected=rejected)

def main():
    p=argparse.ArgumentParser();p.add_argument('--manifest',type=Path,required=True);p.add_argument('--output',type=Path,required=True)
    p.add_argument('--base-model',type=Path,default=Path('two-basis-results/two-basis-joint-general-point22.json.gz'))
    p.add_argument('--base-receipt',type=Path,default=Path('two-basis-results/two-basis-joint-general-point22-independent.json'))
    a=p.parse_args();assert not a.output.exists();start=time.monotonic()
    manifest,saved,M,X,Z,dd,features,stars,checks=context(a.manifest,a.base_model,a.base_receipt)
    controls=finite_controls(M,X,Z,manifest['probes'])
    out=dict(status='PASS_EXACT_COMPLETE_SELECTED_OWNER_FLOW_MODEL',manifest_sha256=sha(a.manifest),model_sha256=sha(manifest['semantic']),
             lp_sha256=sha(manifest['lp']),point_sha256=M['point_sha256'],consumer_sha256=sha(Path(__file__).name),
             source_hashes=M['source_hashes'],base_receipt_sha256=sha(a.base_receipt),**checks,
             variables=len(M['variables']),exact_LP_rows=manifest['row_count'],exact_LP_nonzeros=manifest['nonzeros'],
             base_rank_rows=sum(len(s['rank_rows']) for s in M['sectors'].values()),base_star_rows=len(stars),
             all_sixteen_patterns=True,zero_tau_pins=saved['zero_tau_pins'],pins_outside_general_model=True,
             finite_controls=controls,
             solver_run=False,source_C16_answered=False,C16_strictness_proved=False,
             scope='Independent source/physical/shared-cell/probability-bound and full LP-text proof. No optimization or feasibility claim.',
             priority=19,elapsed_seconds=time.monotonic()-start)
    a.output.write_text(json.dumps(out,sort_keys=True,indent=2)+'\n');print(json.dumps({k:v for k,v in out.items() if k!='source_hashes'}),flush=True)

if __name__=='__main__':main()
