"""Prepare complete selected owner-star flows, with shared physical edge cells.

No optimizer. All sixteen patterns and all five high moments remain available.
Cells are conditional joint probabilities, not products of conditional means.
"""
from pathlib import Path
from fractions import Fraction as Q
import argparse,gzip,json,os,time
from two_basis_joint_general_star import (
    ROOT,sha,read,empty,term,plus,value,encode,decode,
    row_expression as base_row_expression,
    probability_bound_guard as base_probability_bound_guard,
)

def coordinate(x,z):
    i,t=divmod(x,16);j,u=divmod(z,16);h=(u-t)%16
    if h>8:h,i,j=16-h,j,i
    if h in (0,8) and i>j:i,j=j,i
    return 18270+2025*h+45*i+j

def forbidden_reasons(pairing,xx,zz,mask,x,z):
    reasons=[]
    for h,a in enumerate(xx):
        if x==a and not(mask>>h&1):reasons.append(['absent_X_endpoint',a])
        if mask>>h&1 and a!=x and pairing(a,z):reasons.append(['selected_other_X_owner',a])
    for h,a in enumerate(zz):
        if z==a and not(mask>>(h+2)&1):reasons.append(['absent_Z_endpoint',a])
        if mask>>(h+2)&1 and a!=z and pairing(x,a):reasons.append(['selected_other_Z_owner',a])
    return reasons

def append_owner_flows(base,probes,X,Z):
    assert base['feature_layout']=='constant1,canonical_owner_vector[36495]'
    assert len(probes) in (2,3,4) and len(set(probes))==len(probes)
    assert {side for side,_ in probes}=={'X','Z'}
    model=dict(base);model['variables']=list(base['variables'])
    model['equalities']=list(base['equalities']);model['inequalities']=list(base['inequalities'])
    model['source_hashes']=dict(base['source_hashes'])
    xx,zz=base['X_anchors'],base['Z_anchors'];pairing=lambda x,z:bool((X[x]&Z[z]).bit_count()%2)
    stars=[];pairs=set()
    for side,i in probes:
        assert side in ('X','Z') and type(i)is int and 0<=i<720
        assert i not in (xx if side=='X' else zz),'selected centers must be unanchored'
        neighbors=[j for j in range(720) if pairing(i,j)] if side=='X' else [j for j in range(720) if pairing(j,i)]
        edges=[(i,j) if side=='X' else (j,i) for j in neighbors]
        stars.append(dict(side=side,probe=i,neighbors=neighbors,physical_pairs=edges));pairs.update(edges)
    pairs=sorted(pairs);pair_ids={p:i for i,p in enumerate(pairs)};base_n=len(model['variables'])
    cells=[];zeros=[]
    for m in range(16):
        for edge,(x,z) in enumerate(pairs):
            var=len(model['variables']);cells.append([m,x,z,var])
            model['variables'].append(dict(kind='owner_joint',mask=m,X_index=x,Z_index=z))
            for bound in ('nonnegative','X_upper','Z_upper','frechet_lower'):
                model['inequalities'].append(dict(kind='owner_flow_bound',mask=m,edge=edge,bound=bound))
            why=forbidden_reasons(pairing,xx,zz,m,x,z)
            if why:
                zeros.append(dict(mask=m,edge=edge,reasons=why))
                model['inequalities'].append(dict(kind='owner_flow_bound',mask=m,edge=edge,bound='structural_zero'))
    for k,star in enumerate(stars):
        star['edges']=[pair_ids[tuple(p)] for p in star.pop('physical_pairs')]
        for m in range(16):model['equalities'].append(dict(kind='owner_flow_row',star=k,mask=m))
    for edge,pair in enumerate(pairs):model['equalities'].append(dict(kind='owner_flow_column',edge=edge))
    incidence={edge:[] for edge in range(len(pairs))}
    for k,star in enumerate(stars):
        for edge in star['edges']:incidence[edge].append(k)
    shared=[dict(edge=edge,physical_pair=list(pairs[edge]),stars=ks) for edge,ks in incidence.items() if len(ks)>1]
    assert shared,'initial selected centers must have overlapping physical owner edges'
    model['owner_flow_extension']=dict(base_variable_count=base_n,base_equality_count=len(base['equalities']),
        base_inequality_count=len(base['inequalities']),stars=stars,physical_pairs=[list(p) for p in pairs],
        cells=cells,structural_zeros=zeros,shared_edges=shared,all_sixteen_patterns=True,
        copied_zero_tau_pins=False,shared_physical_pair_cells=True)
    model['source_hashes']['two_basis_owner_star_extension.py']=sha(__file__)
    return model

def cell(model,m,edge):
    meta=model['owner_flow_extension'];assert type(m)is int and 0<=m<16
    assert type(edge)is int and 0<=edge<len(meta['physical_pairs'])
    return term(1,meta['base_variable_count']+m*len(meta['physical_pairs'])+edge)

def row_expression(model,d):
    kind=d['kind'];meta=model['owner_flow_extension']
    if kind=='owner_flow_column':
        x,z=meta['physical_pairs'][d['edge']];e=term(0,coordinate(x,z)+1,-1)
        for m in range(16):e=plus(e,cell(model,m,d['edge']))
        return e
    if kind=='owner_flow_row':
        star=meta['stars'][d['star']];m=d['mask']
        e=plus(empty(),model['sectors'][star['side']]['allocations'][m][star['probe']],-1)
        for edge in star['edges']:e=plus(e,cell(model,m,edge))
        return e
    if kind!='owner_flow_bound':return base_row_expression(model,d)
    m,edge,bound=d['mask'],d['edge'],d['bound'];x,z=meta['physical_pairs'][edge];t=cell(model,m,edge)
    if bound=='nonnegative':return plus(empty(),t,-1)
    if bound=='structural_zero':return t
    if bound in ('X_upper','Z_upper'):
        side=bound[0];return plus(t,model['sectors'][side]['allocations'][m][x if side=='X' else z],-1)
    assert bound=='frechet_lower'
    e=plus(model['sectors']['X']['allocations'][m][x],model['sectors']['Z']['allocations'][m][z])
    return plus(plus(e,model['lambda_expressions'][m],-1),t,-1)

def probability_bound_guard(model):
    meta=model['owner_flow_extension'];n=meta['base_variable_count'];E=len(meta['physical_pairs'])
    base=dict(model);base['variables']=model['variables'][:n]
    base_probability_bound_guard(base)
    bounds={(d['mask'],d['edge'],d['bound']):d for d in model['inequalities'] if d['kind']=='owner_flow_bound'}
    boxes={(d['side'],d['mask'],d['index'],d['bound']):d for d in model['inequalities'] if d['kind']=='box'}
    lambda_rows={d['mask']:d for d in model['inequalities'] if d['kind']=='lambda_nonnegative'}
    assert set(lambda_rows)==set(range(16));other=[]
    for m in range(16):
        e=empty()
        for q in range(16):
            if q!=m:e=plus(e,base_row_expression(model,lambda_rows[q]))
        assert e==plus(model['lambda_expressions'][m],term(0,0),-1)
        other.append(e)
    pair_ids={tuple(pair):edge for edge,pair in enumerate(meta['physical_pairs'])}
    assert len(model['variables'])==n+16*E
    assert len({tuple(c[:3]) for c in meta['cells']})==16*E
    for m,x,z,v in meta['cells']:
        edge=pair_ids[x,z];assert v==n+m*E+edge
        assert model['variables'][v]==dict(kind='owner_joint',mask=m,X_index=x,Z_index=z)
        assert row_expression(model,bounds[m,edge,'nonnegative'])==term(1,v,-1)
        upper=row_expression(model,bounds[m,edge,'X_upper'])
        assert upper==plus(term(1,v),model['sectors']['X']['allocations'][m][x],-1)
        box=base_row_expression(model,boxes['X',m,x,'upper'])
        assert box==plus(model['sectors']['X']['allocations'][m][x],model['lambda_expressions'][m],-1)
        assert plus(plus(upper,box),other[m])==plus(term(1,v),term(0,0),-1)

def exact_projected_combination(model,equality_weights,inequality_weights,residual_correction=False):
    out=empty()
    for kind,weights in [('equalities',equality_weights),('inequalities',inequality_weights)]:
        for i,w in weights:
            assert type(i)is int and 0<=i<len(model[kind]);w=Q(w)
            assert kind=='equalities' or w>=0
            out=plus(out,row_expression(model,model[kind][i]),w)
    residual=dict(out[1]);correction=Q(0)
    if residual:
        assert residual_correction,'uncancelled reduced or joint variables'
        probability_bound_guard(model)
        correction=sum((min(Q(0),r) for r in residual.values()),Q(0))
        out=plus(out,term(0,0,correction));out[1].clear()
    return dict(owner_target_coefficients=[[j,str(v)] for j,v in sorted(out[0].items())],
        residual_coefficients=[[j,str(v)] for j,v in sorted(residual.items())],
        exact_residual_correction=str(correction),exact_cancellation=not residual,
        probability_bounds_proved=True if residual else None)

def main():
    assert os.getpriority(os.PRIO_PROCESS,0)==19
    ap=argparse.ArgumentParser();ap.add_argument('--semantic',type=Path,required=True);ap.add_argument('--selection',type=Path,required=True)
    ap.add_argument('--output-prefix',type=Path,required=True);a=ap.parse_args();start=time.monotonic()
    saved=read(a.semantic);base=decode(saved['model'])
    assert saved['status']=='EXACT_GENERAL_JOINT_LP_EXPORT_REQUIRE_REPLAY'
    assert base['structural_only_elimination'] and not base['fixed_law_faces_used']
    assert all(sha(ROOT/p)==h for p,h in base['source_hashes'].items())
    X,Z=[[int(v,16) for v in (ROOT/f'pools/{side}coords.txt').read_text().split()] for side in 'xz']
    selection=read(a.selection);assert selection['point_sha256']==base['point_sha256']
    assert selection['cohort_sha256']==sha(ROOT/selection['cohort'])
    probes=[tuple(p) for p in selection['probes']]
    model=append_owner_flows(base,probes,X,Z);probability_bound_guard(model)
    model['source_hashes'][str(a.semantic)]=sha(a.semantic)
    model['source_hashes'][str(a.selection)]=sha(a.selection)
    model['source_hashes'][selection['cohort']]=selection['cohort_sha256']
    meta=model['owner_flow_extension'];model['status']='PREPARED_COMPLETE_SELECTED_OWNER_STAR_FLOW_EXTENSION_NO_SOLVE'
    model['lp_run']=False;model['source_C16_answered']=False
    output=Path(str(a.output_prefix)+'.model.json.gz');summary=Path(str(a.output_prefix)+'.json')
    assert not output.exists() and not summary.exists()
    output.write_bytes(gzip.compress((json.dumps(encode(model),separators=(',',':'))+'\n').encode(),mtime=0))
    result=dict(status=model['status'],model=str(output),model_sha256=sha(output),producer_sha256=sha(__file__),
        source_semantic=str(a.semantic),source_semantic_sha256=sha(a.semantic),point_sha256=base['point_sha256'],
        probes=[list(p) for p in probes],degrees=[len(s['neighbors']) for s in meta['stars']],
        physical_edges=len(meta['physical_pairs']),shared_edges=meta['shared_edges'],
        new_variables=len(meta['cells']),variables=len(model['variables']),
        added_equalities=len(model['equalities'])-len(base['equalities']),
        added_inequalities=len(model['inequalities'])-len(base['inequalities']),
        structural_zero_cells=len(meta['structural_zeros']),all_sixteen_patterns=True,
        input_wrapper_zero_tau_pins=saved['zero_tau_pins'],copied_zero_tau_pins=False,
        residual_guard='Base variable-prefix proof, explicit -t<=0, and exact nonnegative combination (t-yX)+(yX-lambda_m)+sum_q!=m(-lambda_q)=t-1 for every shared cell.',
        independent_acceptance=False,source_C16_answered=False,solver_run=False,
        stronger_than_separate_stars='Valid shared-cell consistency; strictness not established by this preparation.',
        elapsed_seconds=time.monotonic()-start)
    summary.write_text(json.dumps(result,indent=2)+'\n');print(json.dumps(result,indent=2))

if __name__=='__main__':main()
