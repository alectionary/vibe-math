#!/usr/bin/env python3
"""Independent physical checks for matrix witnesses and conditional minors."""
from pathlib import Path
import argparse
import gzip
import itertools
import json
import time

ROOT=Path(__file__).resolve().parent


def rank(vs):
    piv={}
    for v in vs:
        while v:
            b=v&-v
            if b not in piv:piv[b]=v;break
            v^=piv[b]
    return len(piv)


def canon(i,j):
    a,b,h=i//16,j//16,(j-i)%16
    return min((a,b,h),(b,a,-h%16))


def determinant_control():
    count=0
    for n in range(1,4):
        witnesses=[0]+[1<<j for j in range(n)]+([3] if n==3 else [])
        for X in itertools.permutations(range(1,1<<n),n):
            if rank(X)!=n:continue
            Z=[next(z for z in range(1<<n) if all(((x&z).bit_count()%2)==(i==j) for j,x in enumerate(X))) for i in range(n)]
            for u1,u2,v1,v2 in itertools.product(witnesses,repeat=4):
                b=lambda x,z:(x&z).bit_count()%2
                lhs=(b(u1,v1)*b(u2,v2))^(b(u1,v2)*b(u2,v1))
                rhs=0
                for i,j in itertools.combinations(range(n),2):
                    da=(b(u1,Z[i])*b(u2,Z[j]))^(b(u1,Z[j])*b(u2,Z[i]))
                    db=(b(X[i],v1)*b(X[j],v2))^(b(X[i],v2)*b(X[j],v1))
                    rhs^=da*db
                assert lhs==rhs;count+=1
    return count


def main():
    ap=argparse.ArgumentParser();ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();start=time.monotonic()
    from audit_pools import exchange
    from verify_partial_frame import mask,shift
    source=json.loads((ROOT/'physical-pool-source.json').read_text())
    Zp=[shift(mask(seed),h) for seed in source['Z_orbit_representatives'] for h in range(16)];Xp=list(map(exchange,Zp))
    beta=lambda x,z:(x&z).bit_count()%2
    A=[[beta(x,z) for z in Zp] for x in Xp]
    frame={s:[shift(mask(seed[s]),h) for seed in source['canonical_seeds'] for h in range(16)] for s in ['X','Z']}
    assert all(beta(x,z)==(i==j) for i,x in enumerate(frame['X']) for j,z in enumerate(frame['Z']))
    X=[sum(beta(x,z)<<i for i,z in enumerate(frame['Z'])) for x in Xp]
    Z=[sum(beta(x,z)<<i for i,x in enumerate(frame['X'])) for z in Zp]
    assert all(beta(x,z)==A[i][j] for i,x in enumerate(X) for j,z in enumerate(Z))
    for side,values in [('x',X),('z',Z)]:assert values==[int(s,16) for s in (ROOT/f'pools/{side}coords.txt').read_text().split()]
    folder=ROOT/'matrix-witness-results'
    broad=json.loads((folder/'broader-rank-one-screen.json').read_text());u=int(broad['u_hex'],16);v=int(broad['v_hex'],16)
    assert beta(u,v)==1
    pairs={canon(i,j) for i,x in enumerate(X) for j,z in enumerate(Z) if A[i][j] and beta(x,v) and beta(u,z)}
    assert len(pairs)==broad['best_case_count']==518 and sorted(pairs)==[tuple(e) for e in broad['case_tuples']]
    structured=json.loads((folder/'structured-matrix-screen.json').read_text());M=[int(s,16) for s in structured['matrix_rows_hex']]
    assert len(M)==128 and sum((r>>i)&1 for i,r in enumerate(M))%2==1
    pairs2=set()
    for i,x in enumerate(X):
        mx=0
        for k in range(128):
            if x>>k&1:mx^=M[k]
        for j,z in enumerate(Z):
            if A[i][j] and beta(mx,z):pairs2.add(canon(i,j))
    assert len(pairs2)==structured['best_case_count']==518
    d=json.loads(gzip.decompress((folder/'determinant-pilot.json.gz').read_bytes()))
    anchors=json.loads((ROOT/'joint-cover-results/source-witness-cover.json').read_text())['cases'];by={r['id']:r for r in d['records']}
    assert len(by)==len(anchors)==518
    count=0
    for c in anchors:
        x0,z0=c['X_index'],c['Z_index'];r=by[c['id']]
        assert (r['X_index'],r['Z_index'])==(x0,z0) and A[x0][z0]
        saved={(w[0],w[1]):w[2:] for w in r['two_edge_minor_witnesses']}
        assert len(saved)==len(r['two_edge_minor_witnesses'])
        expected=set()
        H=[[A[608+t][608+s]^(A[608+t][z0]*A[x0][608+s]) for s in range(16)] for t in range(16)]
        for t,s in itertools.combinations(range(16),2):
            determinant=(H[t][t]*H[s][s])^(H[t][s]*H[s][t])
            if not determinant:continue
            expected.add((t,s));i,j,k,l=saved[t,s]
            assert A[i][j] and A[k][l] and not A[i][l] and not A[k][j]
            assert not A[i][z0] and not A[x0][j] and not A[k][z0] and not A[x0][l]
            da=(A[608+t][j]*A[608+s][l])^(A[608+t][l]*A[608+s][j])
            db=(A[i][608+t]*A[k][608+s])^(A[i][608+s]*A[k][608+t])
            assert da*db==1;count+=1
        assert set(saved)==expected
    assert count==d['nonzero_minor_conditions_tested']==26964 and not d['excluded_anchor_cases']
    # Explicit single-class partial matching witnesses lower-bound what this
    # particular signature-only cover refinement can remove.
    single=json.loads((folder/'single-class-signature-screen.json').read_text());positive=0
    for r in single['records']:
        if not r['satisfiable_partial_signature_matching']:continue
        chosen=r['witness'];value=0
        for index,(i,j) in enumerate(chosen):
            assert canon(i,j)==tuple(r['case']) and A[i][j]
            for ii,jj in chosen[:index]:assert i!=ii and j!=jj and not A[i][jj] and not A[ii][j]
            value^=sum((A[i][608+t]*A[608+t][j])<<t for t in range(16))
        assert value==65535;positive+=1
    assert positive==85
    conditional=json.loads((folder/'conditional-signature-screen.json').read_text())
    newcover=json.loads((folder/'signature-cover-505-independent.json').read_text())
    wanted={r['id']:(r['X_index'],r['Z_index']) for r in newcover['cases']}
    assert conditional['tested']==conditional['satisfiable']==505 and conditional['unsatisfiable']==conditional['unknown']==0
    assert {r['id'] for r in conditional['records']}==set(wanted)
    partial_sizes=[]
    for r in conditional['records']:
        assert r['answer'] is True and (r['X_index'],r['Z_index'])==wanted[r['id']]
        chosen=r['partial_matching'];assert tuple(chosen[0])==wanted[r['id']]
        value=0
        for index,(i,j) in enumerate(chosen):
            assert A[i][j]
            for ii,jj in chosen[:index]:assert i!=ii and j!=jj and not A[i][jj] and not A[ii][j]
            value^=sum((A[i][608+t]*A[608+t][j])<<t for t in range(16))
        assert value==65535 and len(chosen)<=17;partial_sizes.append(len(chosen))
    controls=determinant_control()
    residual=json.loads((folder/'residual-selected-witness.json').read_text())
    chosen=residual['partial_matching'];m=len(chosen)
    assert residual['anchor']['id']==conditional['records'][0]['id'] and chosen==conditional['records'][0]['partial_matching']
    R=[int(s,16) for s in residual['residual_rows_hex']]
    actual=[1<<i for i in range(128)]
    for i,j in chosen:
        for k in range(128):
            if X[i]>>k&1:actual[k]^=Z[j]
    assert R==actual and rank(R)==residual['residual_rank']==128-m
    columns=[sum(((R[i]>>j)&1)<<i for i in range(128)) for j in range(128)]
    for c in columns:
        square=0
        for j in range(128):
            if c>>j&1:square^=columns[j]
        assert square==c
    u=residual['new_witness']['u_X_index'];v=residual['new_witness']['v_Z_index']
    assert A[u][v]==1 and sum(A[u][j]*A[i][v] for i,j in chosen)%2==residual['new_witness']['saved_partial_value']==0
    def transpose_functional(i,j):return sum(Z[j]<<(128*k) for k in range(128) if X[i]>>k&1)
    fs=[transpose_functional(608+t,608+t) for t in range(16)]
    assert rank(fs)==residual['old_functional_span_rank']==16
    fs.extend(transpose_functional(16*(u//16)+(u+t)%16,16*(v//16)+(v+t)%16) for t in range(16))
    assert rank(fs)==residual['new_functional_span_rank']==32
    result={'status':'PASS','source_C16_answered':False,'physical_coordinates_regenerated':1440,'physical_pairings_checked':518400,'best_arbitrary_vector_cover_checked':518,'best_structured_matrix_cover_checked':518,'broader_vector_search_candidates_reported':broad['tested_trace_one_witnesses'],'structured_matrix_candidates_reported':structured['tested_trace_one_matrices'],'search_scope':'The saved best witnesses are independently checked; no unrestricted minimum or independently exhaustive replay of every negative discovery candidate is claimed.','principal_conditional_minor_witnesses_checked':count,'anchor_cases_excluded_by_this_minor_existence_family':0,'small_full_basis_Cauchy_Binet_controls':controls,'single_class_signature_matching_witnesses_checked':positive,'signature_refinement_lower_bound':85,'lower_bound_scope':'At least these85 classes must be retained by a proof that uses only the16 witness signatures and induced-matching compatibility; this is not a bound for arbitrary covers or evidence any full128-frame exists.','conditional_signature_partial_matchings_checked':505,'conditional_partial_matching_size_range':[min(partial_sizes),max(partial_sizes)],'conditional_scope':'Every retained anchor admits a compatible partial matching with the required16 signatures; none is a full128-frame or proof of full completion. The16-signature partial-matching test alone cannot exclude these individual cases.','residual_guided_witness':{'anchor':residual['anchor'],'partial_rank':m,'residual_rank':128-m,'new_witness_indices':[u,v],'full_basis_value':1,'saved_partial_value':0,'functional_span_rank_before':16,'functional_span_rank_after':32,'solver_gate':'unrun'},'elapsed_seconds':time.monotonic()-start}
    a.output.write_text(json.dumps(result,indent=2)+'\n');print('PASS: physical broad witnesses,26964 minor witnesses,85 partial signature controls,',controls,'Cauchy-Binet checks;',result['elapsed_seconds'],'seconds',flush=True)


if __name__=='__main__':main()
