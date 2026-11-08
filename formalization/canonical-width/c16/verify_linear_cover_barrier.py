#!/usr/bin/env python3
"""Check the16-dimensional annihilator certificate behind cover518.

The rank16368 lower bound is checked by a separate low-pivot C++ consumer on
transposed outer products whose coordinates are regenerated from physical
canonical seed pairings. The independent16-vector annihilator gives the upper
bound. The written local-ring argument proves no trace-one functional can
produce a strictly smaller cover contained in these518 classes.
"""
from pathlib import Path
import argparse
import hashlib
import json
import subprocess
import tempfile
import time

ROOT=Path(__file__).resolve().parent


def rank(vs):
    piv={}
    for v in vs:
        while v:
            k=v&-v
            if k not in piv:
                piv[k]=v
                break
            v^=piv[k]
    return len(piv)


def outer(x,z):
    result=0
    while x:
        b=x&-x
        result|=z << (128*(b.bit_length()-1))
        x^=b
    return result


def canonical(i,j):
    a,b,h=i//16,j//16,(j-i)%16
    return min((a,b,h),(b,a,-h%16))


def main():
    ap=argparse.ArgumentParser()
    ap.add_argument('--rank-checker',type=Path,required=True)
    ap.add_argument('--output',type=Path,required=True)
    a=ap.parse_args()
    start=time.monotonic()
    from audit_pools import exchange
    from verify_partial_frame import mask,shift
    source=json.loads((ROOT/'physical-pool-source.json').read_text())
    PZ=[shift(mask(seed),h) for seed in source['Z_orbit_representatives'] for h in range(16)]
    PX=[exchange(z) for z in PZ]
    canonical_vectors={s:[shift(mask(seed[s]),h) for seed in source['canonical_seeds'] for h in range(16)] for s in ['X','Z']}
    assert all((x&z).bit_count()%2==(i==j) for i,x in enumerate(canonical_vectors['X']) for j,z in enumerate(canonical_vectors['Z']))
    # This reconstructs the coordinate bridge instead of reading xcoords/zcoords.
    X=[sum(((x&z).bit_count()%2)<<j for j,z in enumerate(canonical_vectors['Z'])) for x in PX]
    Z=[sum(((z&x).bit_count()%2)<<j for j,x in enumerate(canonical_vectors['X'])) for z in PZ]
    assert rank(X)==rank(Z)==128
    assert all((x&z).bit_count()%2==(PX[i]&PZ[j]).bit_count()%2 for i,x in enumerate(X) for j,z in enumerate(Z))
    certpath=ROOT/'joint-cover-results/linear-cover-pruning.json'
    cert=json.loads(certpath.read_text())
    coverdata=json.loads((ROOT/'joint-cover-results/source-witness-cover.json').read_text())
    cover={tuple(c['orbit_tuple']) for c in coverdata['cases']}
    assert len(cover)==518
    u=coverdata['witness']['u_X_index']
    v=coverdata['witness']['v_Z_index']
    functionals=[outer(Z[v+t],X[u+t]) for t in range(16)]
    assert rank(functionals)==16
    diagonal=sum(1<<(129*i) for i in range(128))
    assert all((L&diagonal).bit_count()%2==1 for L in functionals)
    outside=0
    for i,x in enumerate(X):
        for j,z in enumerate(Z):
            if not (x&z).bit_count()%2 or canonical(i,j) in cover:
                continue
            outside+=1
            assert all(not (((PX[i]&PZ[v+t]).bit_count()%2) and ((PX[u+t]&PZ[j]).bit_count()%2)) for t in range(16))
    assert outside==cert['outside_atom_count']
    pairs=cert['outside_rank_witness_pairs']
    assert len(pairs)==len({tuple(p) for p in pairs})==cert['outside_span_rank']==16368
    with tempfile.TemporaryDirectory(prefix='c16-rank-replay-') as folder:
        binary=Path(folder)/'transposed-atoms.bin'
        with binary.open('wb') as stream:
            for i,j in pairs:
                assert 0<=i<720 and 0<=j<720 and (X[i]&Z[j]).bit_count()%2
                assert canonical(i,j) not in cover
                stream.write(outer(Z[j],X[i]).to_bytes(2048,'little'))
        run=subprocess.run([str(a.rank_checker),str(binary),'16368'],capture_output=True,text=True,check=True)
        rankcheck=json.loads(run.stdout)
        small=Path(folder)/'control.bin'
        small.write_bytes(b''.join((1<<i).to_bytes(2048,'little') for i in range(5)))
        good=subprocess.run([str(a.rank_checker),str(small),'5'],capture_output=True,text=True)
        assert good.returncode==0
        small.write_bytes(b''.join((1<<i).to_bytes(2048,'little') for i in [0,1,2,3,3]))
        bad=subprocess.run([str(a.rank_checker),str(small),'5'],capture_output=True,text=True)
        assert bad.returncode!=0 and json.loads(bad.stdout)['rank']==4
    # Check the emitted greedy functional too; it is a redundant direct witness,
    # while the rank+16 translates establish the full annihilator dimension.
    M=[int(s,16) for s in cert['functional_rows_hex']]
    assert len(M)==128 and all(0<=r<1<<128 for r in M)
    assert sum((r>>i)&1 for i,r in enumerate(M))%2==1
    got=set()
    for i,x in enumerate(X):
        transformed=0
        xx=x
        while xx:
            b=xx&-xx;xx^=b
            transformed^=M[b.bit_length()-1]
        for j,z in enumerate(Z):
            if (x&z).bit_count()%2 and (transformed&z).bit_count()%2:
                got.add(canonical(i,j))
    assert got==cover=={tuple(e) for e in cert['retained_case_tuples']}
    result={'status':'PASS','source_C16_answered':False,
            'certificate_sha256':hashlib.sha256(certpath.read_bytes()).hexdigest(),
            'outside_atom_count':outside,'independent_rank_check':rankcheck,
            'annihilator_dimension':16,'independent_translated_functionals':16,'each_translated_functional_trace':1,
            'emitted_trace_one_functional_cover_size':len(got),
            'rank_controls':['rank5 identity accepted','five rows with repeated fourth direction rejected with rank4'],
            'conclusion':'No trace-one linear functional on128x128 binary atoms can give a proper subcover of this518-case cover. The outside span has codimension16 and its annihilator is precisely the cyclic translates of the witness. Odd cyclic combinations are units in F2[t]/(t+1)^16 and preserve every nonzero orbit evaluation.',
            'scope':'Inclusion minimality within linear-identity covers only; does not rule out smaller nonnested linear covers, nonlinear frame-specific covers, or completing/excluding cases.',
            'elapsed_seconds':time.monotonic()-start}
    a.output.write_text(json.dumps(result,indent=2)+'\n')
    print(f'PASS: rank16368 from physical transposed atoms, annihilator16, no strictly contained linear cover; {result["elapsed_seconds"]:.1f}s',flush=True)


if __name__=='__main__':
    main()
