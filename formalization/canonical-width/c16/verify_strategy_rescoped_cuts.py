#!/usr/bin/env python3
"""Reproduce universal-cut conversion and the historical direct-subset screen."""
from pathlib import Path
import argparse
import gzip
import hashlib
import itertools
import json
from verify_algebraic_model import physical
from verify_mandatory_closure import ClosureConsumer

ROOT = Path(__file__).resolve().parent


def sha(p):
    return hashlib.sha256(p.read_bytes()).hexdigest()


def load(p):
    return json.loads(gzip.decompress(p.read_bytes()) if p.suffix == '.gz' else p.read_bytes())


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--output', type=Path, required=True)
    a = parser.parse_args()
    folder = ROOT/'strategy-results'
    universal = load(folder/'universal-from-domain416.json')
    original = load(folder/'domain416-a-discovered-cuts.json')
    X, Z, A = physical()
    consumer = ClosureConsumer(X, Z, A)
    converted = []
    for cut in original['cuts']:
        req = [[], []]
        if 'required_X' in cut:
            req = [cut['required_X'], cut['required_Z']]
        else:
            req[cut['sector']] = cut['indices']
        if not consumer.replay(*req)['possible']:
            row = dict(cut)
            row['kind'] = row['kind'].replace('domain_', '')
            converted.append(row)
    assert converted == universal['cuts'] and len(converted) == 788
    patterns = set()

    def rotations(ids):
        for h in range(16):
            patterns.add(tuple(sorted(16*(i//16)+(i%16+h)%16 for i in ids)))

    inputs = [ROOT/'algebraic-results/small-conditional-original.json.gz']
    for cut in load(inputs[0])['cuts']:
        rotations([cut['anchor_X_index'], *cut['other_X_indices']])
    for name in ['rank-global.json', 'closure-global.json', 'matroid-closure-global.json',
                 'phase-matroid-closure-global.json', 'closure-cover-extension.json']:
        path = folder/name
        inputs.append(path)
        for cut in load(path)['cuts']:
            # The historical screen compared one-sector subsets only. Joint
            # clauses cannot subsume a one-sector clause with both sides nonempty.
            if 'indices' in cut:
                rotations(cut['indices'])
            else:
                assert cut['required_X'] and cut['required_Z']
    path = ROOT/'algebraic-results/orbit-rank-profiles.json.gz'
    inputs.append(path)
    for record in load(path)['records']:
        for cut in record['minimal_bad_certificates']:
            rotations([16*record['orbit']+h for h in range(16) if cut['mask'] >> h & 1])
    assert len(patterns) == 276174, len(patterns)
    old_patterns = set(patterns)
    kept = []
    subsumed = []
    for index, cut in enumerate(converted):
        witness = None
        if 'indices' in cut:
            ids = sorted(cut['indices'])
            witness = next((part for size in range(len(ids)+1)
                            for part in itertools.combinations(ids, size) if part in patterns), None)
        if witness is None:
            kept.append(cut)
            if 'indices' in cut:
                rotations(cut['indices'])
        else:
            subsumed.append({'index': index, 'existing_subset': witness,
                             'in_old_library': witness in old_patterns})
    historical = load(folder/'universal-from-domain416-incremental.json')
    assert len(kept) == 783, (len(kept), subsumed)
    assert {json.dumps(c, sort_keys=True) for c in kept} == {json.dumps(c, sort_keys=True) for c in historical['cuts']}
    out = {'status': 'PASS', 'source_C16_answered': False,
           'domain_cores_checked_in_unrestricted_graph': len(original['cuts']),
           'universal_cores_reproduced': len(converted),
           'cores_not_rejected_by_this_propagation': len(original['cuts'])-len(converted),
           'old_expanded_patterns': len(old_patterns), 'retained_incremental_cores': len(kept),
           'subsumed': subsumed, 'source_dependencies': [
               {'c16_path': str(p.relative_to(ROOT)), 'sha256': sha(p)} for p in inputs],
           'physical_coloop_covectors_checked': consumer.forced_covectors_checked,
           'scope': 'The72 remaining cores are unproved by this unrestricted propagation, not proved extendible. Incremental screening includes rotations of already retained new cores: all5 removed rows duplicate another new core, and none is subsumed by the old library alone. This is not logical independence.'}
    a.output.write_text(json.dumps(out, indent=2)+'\n')
    print({k: v for k, v in out.items() if k not in ['source_dependencies', 'subsumed']}, flush=True)


if __name__ == '__main__':
    main()
