"""Versioned shared owner-capacity extension; frozen owner-flow source unchanged."""
from fractions import Fraction as Q
from two_basis_owner_star_extension import (
    ROOT,sha,read,empty,term,plus,encode,decode,cell,
    row_expression as flow_row_expression,probability_bound_guard,
)

def append_capacities(base):
    model=dict(base);model['inequalities']=list(base['inequalities']);model['source_hashes']=dict(base['source_hashes'])
    meta=base['owner_flow_extension'];chosen={side:{s['probe'] for s in meta['stars'] if s['side']==side} for side in 'XZ'}
    incidence={'X':{},'Z':{}}
    for edge,(x,z) in enumerate(meta['physical_pairs']):
        if z in chosen['Z']:incidence['X'].setdefault(x,[]).append(edge)
        if x in chosen['X']:incidence['Z'].setdefault(z,[]).append(edge)
    vertices={side:sorted(i for i,edges in incidence[side].items() if i not in chosen[side] and len(edges)>=2) for side in 'XZ'}
    start=len(model['inequalities']);records=[]
    for side in 'XZ':
        for i in vertices[side]:
            edges=sorted(incidence[side][i])
            for m in range(16):
                d=dict(kind='owner_neighbor_capacity',side=side,index=i,mask=m,edges=edges)
                records.append(dict(inequality_index=len(model['inequalities']),**d));model['inequalities'].append(d)
    model['owner_capacity_extension']=dict(parent_inequality_count=start,chosen_centers={s:sorted(v) for s,v in chosen.items()},
        common_unchosen_vertices=vertices,rows=records,all_sixteen_patterns=True,structural_zero_rows_retained=True)
    model['source_hashes']['two_basis_owner_star_capacity.py']=sha(__file__)
    return model

def row_expression(model,d):
    if d['kind']!='owner_neighbor_capacity':return flow_row_expression(model,d)
    e=plus(empty(),model['sectors'][d['side']]['allocations'][d['mask']][d['index']],-1)
    for edge in d['edges']:e=plus(e,cell(model,d['mask'],edge))
    return e

def exact_projected_combination(model,equality_weights,inequality_weights,residual_correction=False):
    out=empty()
    for kind,weights in [('equalities',equality_weights),('inequalities',inequality_weights)]:
        for i,w in weights:
            assert type(i)is int and 0<=i<len(model[kind]);w=Q(w);assert kind=='equalities' or w>=0
            out=plus(out,row_expression(model,model[kind][i]),w)
    residual=dict(out[1]);correction=Q(0)
    if residual:
        assert residual_correction,'uncancelled reduced or shared variables'
        probability_bound_guard(model)
        correction=sum((min(Q(0),v) for v in residual.values()),Q(0));out=plus(out,term(0,0,correction));out[1].clear()
    return dict(owner_target_coefficients=[[j,str(v)] for j,v in sorted(out[0].items())],
        residual_coefficients=[[j,str(v)] for j,v in sorted(residual.items())],exact_residual_correction=str(correction),exact_cancellation=not residual)
