#!/usr/bin/env python3
"""Exact selected-cover-pair bridge to cyclic/sector averaged moment floors.

This verifies symmetry and literal indicator controls, not a full source frame
or the existing cover's SAT proof chain. The accepted cover remains a separate
dependency. Arbitrary binary selections used below are translation controls.
"""
from pathlib import Path
from fractions import Fraction
import argparse,json,hashlib,random,time
from verify_algebraic_model import physical
from verify_full_partner_basis_oracle import dimension
from verify_full_partner_projection_generic import coord,point_data
ROOT=Path(__file__).resolve().parent


def move(j,h):return 16*(j//16)+(j%16+h)%16
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()


def main():
    ap=argparse.ArgumentParser(description=__doc__);ap.add_argument('--point',type=Path)
    ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();assert not a.output.exists()
    started=time.monotonic();cover_path=ROOT/'transfer-results/cover-405.json'
    cover=json.loads(cover_path.read_text());assert cover['status']=='PASS' and len(cover['cases'])==405
    bindings_path=ROOT/'transfer-results/cover-bindings.json';bindings=json.loads(bindings_path.read_text())
    assert bindings['status']=='PASS' and bindings['cover_sha256']==sha(cover_path)
    X,Z,A=physical();assert dimension(X)==dimension(Z)==128
    assert X==[int(v,16) for v in (ROOT/'pools/xcoords.txt').read_text().split()]
    assert Z==[int(v,16) for v in (ROOT/'pools/zcoords.txt').read_text().split()]
    ranks=[dimension([x|(z<<128) for x,z in zip(X,Z)]),
        dimension([X[j]|(X[move(j,1)]<<128) for j in range(720)]),
        dimension([Z[j]|(Z[move(j,1)]<<128) for j in range(720)])]
    assert ranks==[128,128,128]
    assert all((A[i]>>j&1)==(A[j]>>i&1)==(A[move(i,1)]>>move(j,1)&1) for i in range(720) for j in range(720))
    owner=point_data(a.point,32)[0] if a.point else None
    records=[];rng=random.Random(20261030);literal_checks=0;random_lower_checks=0
    for case in cover['cases']:
        i,j,h=case['orbit_tuple'];xa,zb=case['X_index'],case['Z_index']
        assert xa==16*i and zb==16*j+h and A[xa]>>zb&1
        images=[(move(zb,r),move(xa,r)) if swap else (move(xa,r),move(zb,r))
            for swap in range(2) for r in range(16)]
        stabilizer=sum(e==(xa,zb) for e in images);orbit_size=len(set(images))
        assert stabilizer*orbit_size==32
        assert stabilizer==(2 if i==j and h in (0,8) else 1)
        floor=Fraction(stabilizer,32);column=coord('T',h,i,j)
        # Direct source-state formula, averaged over32 actions. Pair-only
        # indicators attain the combinatorial lower floor but are not frames.
        def numerator(xs,zs):
            return sum(int(16*i+t in xs and 16*j+(t+h)%16 in zs)+
                       int(16*i+t in zs and 16*j+(t+h)%16 in xs) for t in range(16))
        assert numerator({xa},{zb})==stabilizer;literal_checks+=1
        for _ in range(3):
            xs={k for k in range(720) if rng.random()<.12}|{xa}
            zs={k for k in range(720) if rng.random()<.12}|{zb}
            assert Fraction(numerator(xs,zs),32)>=floor;random_lower_checks+=1
        record={'case':case['orbit_tuple'],'X_index':xa,'Z_index':zb,'owner_coordinate':column,
            'edge_orbit_size':orbit_size,'edge_stabilizer_size':stabilizer,'necessary_floor':str(floor),
            'owner_inequality':{'indices':[column],'coefficients':[-orbit_size],'rhs':-1}}
        if owner is not None:
            record.update(point_moment=str(owner[column]),exact_floor_slack=str(owner[column]-floor),
                point_satisfies_floor=owner[column]>=floor)
        records.append(record)
    sources=['cover_case_moment_bridge.py','verify_algebraic_model.py','verify_full_partner_basis_oracle.py',
        'verify_full_partner_projection_generic.py','physical-pool-source.json','pools/xcoords.txt','pools/zcoords.txt',
        'transfer-results/cover-405.json','transfer-results/cover-bindings.json']
    out={'status':'PASS_SELECTED_PAIR_MOMENT_BRIDGE','source_C16_answered':False,'source_hashes':{p:sha(ROOT/p) for p in sources},
        'group_order':32,'physical_symmetry_graph_ranks':ranks,'physical_pairing_symmetry_checks':2*720*720,
        'case_count':len(records),'floor_1_over_32_cases':sum(r['edge_stabilizer_size']==1 for r in records),
        'floor_1_over_16_cases':sum(r['edge_stabilizer_size']==2 for r in records),
        'literal_pair_only_controls':literal_checks,'arbitrary_binary_superset_lower_bound_controls':random_lower_checks,
        'records':records,'point_sha256':sha(a.point) if a.point else None,
        'point_floor_pass_count':sum(r.get('point_satisfies_floor',False) for r in records) if a.point else None,
        'elapsed_seconds':time.monotonic()-started,
        'scope':'Each actual source frame containing the stated selected pair yields a cyclic/sector averaged moment point satisfying its necessary floor. A verified infeasibility certificate for a necessary zero-margin model plus this floor would exclude that full anchor. Literal controls are not frames; no case is excluded here and the405 cover proof chain is an existing dependency.'}
    a.output.write_text(json.dumps(out,indent=2)+'\n');print(json.dumps({k:v for k,v in out.items() if k not in ('records','source_hashes')},indent=2))


if __name__=='__main__':main()
