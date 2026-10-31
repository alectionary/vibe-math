#!/usr/bin/env python3
"""Verify the first six-hour checkpoint without treating controls as answers."""
import argparse
import gzip
import hashlib
import json
from pathlib import Path
import subprocess
import tempfile
from rank_cut_check import CutChecker,echelon


def main():
    ap=argparse.ArgumentParser();ap.add_argument('--drat-trim',type=Path);args=ap.parse_args()
    root=Path(__file__).parent;folder=root/'six-hours-results/checkpoint-1';manifest=json.loads((folder/'manifest.json').read_text())
    for name,record in manifest['sha256'].items():
        data=(folder/name).read_bytes();assert hashlib.sha256(data).hexdigest()==record['sha256'],name
        if name.endswith('.gz'):assert hashlib.sha256(gzip.decompress(data)).hexdigest()==record['uncompressed_sha256'],name
    X=[int(s,16) for s in (folder/'toy-xcoords.txt').read_text().split()];Z=[int(s,16) for s in (folder/'toy-zcoords.txt').read_text().split()]
    assert len(X)==len(Z)==720 and len(echelon(X))==len(echelon(Z))==128
    positive=json.loads((folder/'c16-six-cegar-positive.json').read_text());assert positive['status']=='SAT'
    pairs=positive['pool_pairs'];assert len(pairs)==128
    assert all((X[i]&Z[j]).bit_count()%2 == (a==b) for a,(i,_) in enumerate(pairs) for b,(_,j) in enumerate(pairs))
    chosen=[i for i,j in json.loads((folder/'c16-six-cegar-bad-basis.json').read_text())['pool_pairs']]
    assert len(chosen)==len(echelon(X[i] for i in chosen))==128
    # Directly enumerate all candidate duals to this fixed basis.
    labels={sum(((X[i]&z).bit_count()%2)<<k for k,i in enumerate(chosen)) for z in Z}
    missing=sum((1<<k) not in labels for k in range(128));assert missing>0
    checker=CutChecker(X,Z,cyclic=False)
    for line in (folder/'c16-six-cegar-negative.lemmas.jsonl').read_text().splitlines():checker.check(json.loads(line))
    assert json.loads((folder/'c16-six-cegar-negative.json').read_text())['status']=='UNSAT_PENDING_CERTIFICATE'
    assert 's VERIFIED' in (folder/'c16-six-cegar-negative-checked.log').read_text()
    if args.drat_trim:
        with tempfile.TemporaryDirectory() as temp:
            cnf=Path(temp)/'negative.cnf';cnf.write_bytes(gzip.decompress((folder/'c16-six-cegar-negative.final.cnf.gz').read_bytes()))
            result=subprocess.run([str(args.drat_trim),str(cnf),str(folder/'c16-six-cegar-negative.drat')],capture_output=True,text=True,timeout=60)
            assert result.returncode==0 and 's VERIFIED' in result.stdout,(result.returncode,result.stdout,result.stderr)
    mapping=json.loads((folder/'c16-six-orbit.mapping.json').read_text());tables={r['pattern']:set(map(tuple,r['allowed'])) for r in json.loads(gzip.decompress((folder/'c16-six-orbit.tables.json.gz').read_bytes()))}
    flow=json.loads((folder/'c16-six-orbit-flow.json').read_text());x,z,e=flow['X_counts'],flow['Z_counts'],flow['flow']
    assert sum(x)==sum(z)==128 and x[12]<=11 and z[12]<=11
    assert [sum(row) for row in e]==x and [sum(e[a][b] for a in range(45)) for b in range(45)]==z
    assert all((x[a],z[b],e[a][b]) in tables[mapping['canonical_patterns'][a][b]] for a in range(45) for b in range(45))
    print(json.dumps({'status':'PASS','artifacts':len(manifest['sha256']),'positive_control_pairs':128,'negative_control_missing_duals':missing,'negative_control_proof_replayed':bool(args.drat_trim),'cardinality_relaxation_feasible':True,'C16_question_answered':False}))


if __name__=='__main__':main()
