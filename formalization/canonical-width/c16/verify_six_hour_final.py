#!/usr/bin/env python3
"""Independent exact checks of the six-hour structural records and archives."""
import argparse
import gzip
import hashlib
import itertools
import json
from pathlib import Path
import numpy as np
from pysat.solvers import Solver
from add_frame_symmetry import lex_clauses
from verify_partial_frame import rank
from rank_oracle import rotate_value


def main():
    ap=argparse.ArgumentParser();ap.add_argument('--output',type=Path,required=True);args=ap.parse_args();root=Path(__file__).parent;first=root/'six-hours-results/checkpoint-1';final=root/'six-hours-results/final'
    manifest=json.loads((final/'manifest.json').read_text())
    for name,digest in manifest['source_sha256'].items():assert hashlib.sha256((root/name).read_bytes()).hexdigest()==digest,name
    for name,record in manifest['sha256'].items():
        data=(final/name).read_bytes();assert hashlib.sha256(data).hexdigest()==record['sha256'],name
        assert hashlib.sha256(gzip.decompress(data)).hexdigest()==record['uncompressed_sha256'],name
    read=lambda name:json.loads(gzip.decompress((final/(name+'.gz')).read_bytes()))
    masks=list(map(int,(first/'c16-six-shape.masks.txt').read_text().split()));assert len(masks)==4116
    selected=np.array([[v>>i&1 for i in range(16)] for v in masks],dtype=np.int16);weights=selected.sum(axis=1)
    profiles=json.loads(gzip.decompress((first/'c16-six-shape.profiles.json.gz').read_bytes()));verified={}
    # Literal integer adjacency-matrix products, independent of the original
    # packed-column/intersection implementation. Products never exceed16.
    for row in profiles:
        f=row['pattern'];adj=np.array([[f>>((j-i)%16)&1 for j in range(16)] for i in range(16)],dtype=np.int16)
        degrees=selected@adj;zero=(degrees==0).sum(axis=1);owners=(selected&(((degrees==1).astype(np.int16)@adj.T)>0)).sum(axis=1)
        assert np.array_equal(zero,row['zero']) and np.array_equal(owners,row['owners']),f
        verified[f]=(zero,owners)
    mapping=json.loads((first/'c16-six-orbit.mapping.json').read_text());tables={r['pattern']:r['allowed'] for r in json.loads(gzip.decompress((first/'c16-six-orbit.tables.json.gz').read_bytes()))}
    hulls=read('c16-six-orbit.hulls.json');planes=0
    for row in hulls:
        for a,b,c,d in row['planes']:
            assert all(a*x+b*z+c*e<=d for x,z,e in tables[row['pattern']]);planes+=1
    even=read('c16-six-orbit-even.json');x,z,e=even['X_counts'],even['Z_counts'],even['flow']
    assert sum(x)==sum(z)==128 and x[12]<=11 and z[12]<=11
    assert [sum(r) for r in e]==x and [sum(e[a][b] for a in range(45)) for b in range(45)]==z
    table_sets={f:set(map(tuple,t)) for f,t in tables.items()}
    assert all((x[a],z[b],e[a][b]) in table_sets[mapping['canonical_patterns'][a][b]] for a in range(45) for b in range(45))
    assert all(v%2==0 for row in e for v in row)
    local=0;canonical=lambda f:min(((f<<h)|(f>>(16-h)))&65535 if h else f for h in range(16))
    with gzip.open(final/'c16-six-benders.cuts.jsonl.gz','rt') as source:
        for line in source:
            row=json.loads(line);assert row['side'] in ['X','Z'];possible=weights==row['count']
            for demand in row['demands']:
                f=canonical(mapping['patterns'][row['owner']][demand['opposite']]);assert f==demand['pattern'];zero,own=verified[f]
                possible&=(zero>=demand['zero'])&(own>=demand['owners'])
            assert not np.any(possible);local+=1
    X=[int(v,16) for v in (root/'pools/xcoords.txt').read_text().split()]
    assert all(rotate_value(v,h)==X[i//16*16+(i%16+h)%16] for i,v in enumerate(X) for h in range(16))
    flats=0
    with gzip.open(final/'c16-six-flat-global.flats.jsonl.gz','rt') as source:
        for line in source:
            row=json.loads(line);ids=row['indices'];assert len(ids)==len(set(ids)) and all(0<=i<720 for i in ids)
            assert rank(X[i] for i in ids)==row['rank'];flats+=1
    comparisons=0
    for n in range(1,7):
        for sign in [1,-1]:
            clauses,top=lex_clauses(list(range(1,n+1)),[sign*(n+i+1) for i in range(n)],2*n)
            with Solver(name='glucose42',bootstrap_with=clauses) as solver:
                for bits in itertools.product([False,True],repeat=2*n):
                    assert solver.solve(assumptions=[i+1 if b else -i-1 for i,b in enumerate(bits)])==(bits[:n]>=tuple(b if sign==1 else not b for b in bits[n:]));comparisons+=1
    result={'status':'PASS','frozen_artifacts':len(manifest['sha256']),'complete_production_profile_entries':len(profiles)*len(masks),'supporting_planes':planes,'local_shape_cuts':local,'independently_replayed_flat_cuts':flats,'lexicographic_control_assignments':comparisons,'even128_pair_cardinality_relaxation':True,'question_answered':False,'limits':'No SAT UNSAT proof and no complete global frontier. Individual CEGAR clauses were independently checked inline by their producers; this final script checks archive hashes rather than replaying every propagation clause.'}
    args.output.write_text(json.dumps(result,indent=2)+'\n');print(json.dumps(result))


if __name__=='__main__':main()
