#!/usr/bin/env python3
"""Exact source-rank rectangles plus a residual-corrected SDP dual consumer.

All ranks are recomputed over F2 in epsilon coordinates. The numerical generator
and its t-basis rank enumerator are not imported. No full-source answer follows
unless all five source thin families are retained in the excluded model.
"""
from pathlib import Path
from itertools import product
import argparse,json,gzip
from block_moment_dual import layout,row,verify_patterns
from verify_inverse_lift import vp,outer,shifts,parts,cyclic,F,rank


def patterns_from_source(source,families):
    q=source['dictionary'];A=list(map(vp,q['X_left_dictionary']));B=list(map(vp,q['X_right_factors']))
    C=list(map(vp,q['Z_left_factors']));D=list(map(vp,q['Z_right_dictionary']))
    X=[outer(a,B[c]) for c in families for a in A]
    Z=[outer(c,d) for c in C for d in D]
    def tword(v):return [(a>>h&1)|((b>>h&1)<<1) for a,b in map(cyclic,parts(v)) for h in range(16)]
    xt=list(map(tword,X));patterns=[[0]*len(Z) for _ in X]
    for j,z in enumerate(Z):
        for h,w in enumerate(shifts(z)):
            zz=tword(w)
            for i,x in enumerate(xt):patterns[i][j]|=(sum((F[a][b]>>1)&1 for a,b in zip(x,zz))%2)<<h
    return patterns


def rectangle_constraints(source,families,cuts):
    q=source['dictionary'];A=list(map(vp,q['X_left_dictionary']));B=list(map(vp,q['X_right_factors']))
    C=list(map(vp,q['Z_left_factors']));D=list(map(vp,q['Z_right_dictionary']))
    orbits={'X':[[list(shifts(outer(a,b))) for a in A] for b in B],
            'Z':[[list(shifts(outer(c,d))) for d in D] for c in C]}
    N=9*len(families)+45;p,Cidx,V=layout(N,16);ineq=set();rank_cases=0
    for cut in cuts:
        side=cut['sector'];assert side in ['X','Z'];fam=families if side=='X' else list(range(5))
        offset=0 if side=='X' else 9*len(families);T=cut['thin_mask'];I=cut['thick_mask'];r=cut['rank']
        assert 0<T<32 and 0<I<512 and all(not(T>>j&1) or j in fam for j in range(5))
        S=[offset+9*c+i for c,j in enumerate(fam) if T>>j&1 for i in range(9) if I>>i&1]
        assert cut['columns']==S
        actual=rank(v for j in fam if T>>j&1 for i in range(9) if I>>i&1 for v in orbits[side][j][i])
        assert actual==r;rank_cases+=1
        if cut.get('first',True):ineq.add(row([(p[j],16) for j in S],r,'ineq'))
        if cut.get('conditional',False):
            for i in range(N):ineq.add(row([(Cidx[h][i][j],1) for h in range(16) for j in S]+[(p[i],-r)],0,'ineq'))
    return ineq,rank_cases


def verify(data,source,rational_psd=None):
    families=data['X_thin_families'];assert families==sorted(set(families)) and set(families)<=set(range(5))
    assert data['period']==16 and data['target']==128
    patterns=patterns_from_source(source,families)
    ineq,count=rectangle_constraints(source,families,data['rank_rectangles'])
    p,C,V=layout(9*len(families)+45,16)
    from moment_triangle_cuts import constraint as triangle_constraint,literal_control
    from moment_circuit_cuts import constraint as circuit_constraint,validate as validate_circuit,source_vectors
    literal_control()
    for cut in data.get('moment_triangles',[]):ineq.add(triangle_constraint(cut,p,C,16))
    from moment_integer_form_cuts import coefficients as integer_form_constraint
    for cut in data.get('moment_integer_forms',[]):ineq.add(integer_form_constraint(cut,p,C,16))
    from moment_owner_cuts import coefficients as owner_constraint,neighbor_polynomials
    owner_neighbors=neighbor_polynomials(patterns,16) if data.get('moment_owner_cuts') else None
    for cut in data.get('moment_owner_cuts',[]):ineq.add(owner_constraint(cut,patterns,p,C,16,owner_neighbors))
    from moment_matching_path_cuts import coefficients as path_constraint,validate as validate_path
    for cut in data.get('moment_matching_paths',[]):
        validate_path(cut,patterns,16);ineq.add(path_constraint(cut,p,C,16))
    checked_circuits=set();circuit_vectors={side:source_vectors(source,side) for side in ['X','Z']} if data.get('moment_circuits') else {}
    for cut in data.get('moment_circuits',[]):
        key=(cut['sector'],tuple(cut['circuit']))
        if key not in checked_circuits:validate_circuit(cut,source,circuit_vectors[cut['sector']]);checked_circuits.add(key)
        ineq.add(circuit_constraint(cut,p,C,families))
    result=verify_patterns(data,patterns,extra_inequalities=ineq,rational_psd=rational_psd)
    result.update(X_thin_families=families,rank_rectangles_checked=count,
        Boolean_triangle_inequalities=len(data.get('moment_triangles',[])),integer_affine_form_inequalities=len(data.get('moment_integer_forms',[])),matching_path_inequalities=len(data.get('moment_matching_paths',[])),private_partner_owner_inequalities=len(data.get('moment_owner_cuts',[])),
        source_circuit_orbits_checked=len(checked_circuits),conditional_circuit_inequalities=len(data.get('moment_circuits',[])),
        scope='No full original C16 frame whose X thin support is contained in the listed families.',
        source_C16_answered=(families==list(range(5))))
    return result


def main():
    ap=argparse.ArgumentParser();ap.add_argument('certificate',type=Path)
    ap.add_argument('--source',type=Path,default=Path(__file__).parent/'inversion-results/normal-form.json')
    ap.add_argument('--rational-psd',type=Path);ap.add_argument('--output',type=Path,required=True);a=ap.parse_args()
    raw=gzip.decompress(a.certificate.read_bytes()).decode() if a.certificate.suffix=='.gz' else a.certificate.read_text()
    from rational_cyclic_psd import read
    result=verify(json.loads(raw),json.loads(a.source.read_text()),rational_psd=read(a.rational_psd) if a.rational_psd else None)
    a.output.write_text(json.dumps(result,indent=2)+'\n');print(json.dumps(result),flush=True)
if __name__=='__main__':main()
