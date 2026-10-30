"""Independent byte/exact-value bridge from accepted joint to sector records."""
from pathlib import Path
import argparse
import gzip
import hashlib
import json
import os

ROOT = Path(__file__).resolve().parent
def sha(p): return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def read(p):
    p = Path(p)
    return json.loads(gzip.decompress(p.read_bytes()) if p.suffix == '.gz' else p.read_bytes())


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--joint', type=Path, required=True)
    ap.add_argument('--joint-receipt', type=Path, required=True)
    ap.add_argument('--sector-prefix', type=Path, required=True)
    ap.add_argument('--output', type=Path, required=True)
    a = ap.parse_args()
    assert os.getpriority(os.PRIO_PROCESS, 0) == 19 and not a.output.exists()
    joint, accepted = read(a.joint), read(a.joint_receipt)
    assert accepted['status'] == 'PASS_EXACT_JOINT_FIXED_ALLOCATION_LISTED_RANK_AND_STAR_ROWS'
    assert accepted['certificate_sha256'] == sha(a.joint)
    assert accepted['consumer_sha256'] == sha(ROOT/'verify_two_basis_joint_fixed_star.py')
    assert all(sha(ROOT/p) == h for p, h in accepted['source_hashes'].items())
    assert joint['status'] == 'EXACT_JOINT_FIXED_ALLOCATION_REQUIRES_REPLAY'
    paths = [a.joint, a.joint_receipt, Path(__file__)]
    counts = {}
    for side in ['X', 'Z']:
        base = str(a.sector_prefix)+'-'+side
        cp, fp, rp = [Path(base+s) for s in ['.json.gz', '.frozen.json', '-independent.json']]
        c, f, r = read(cp), read(fp), read(rp)
        assert c['status'] == 'EXACT_DIRECT_COUNT_ALLOCATION_REQUIRES_REPLAY'
        assert c['joint_certificate_sha256'] == sha(a.joint)
        assert c['joint_receipt_sha256'] == sha(a.joint_receipt)
        assert c['frozen_sha256'] == sha(fp) and f['side'] == side
        assert c['rounding_performed'] is False
        assert c['exact_allocations'] == joint['exact_allocations'][side]
        assert r['status'] == 'PASS_EXACT_DIRECT_COUNT_AND_LISTED_RANK_ROWS'
        assert r['certificate_sha256'] == sha(cp)
        assert r['consumer_sha256'] == sha(ROOT/'verify_two_basis_rank_closed_allocation.py')
        assert all(sha(ROOT/p) == h for p, h in f['source_hashes'].items())
        assert len(c['exact_allocations']) == 16 and all(len(row) == 720 for row in c['exact_allocations'])
        counts[side] = 16*720
        paths.extend([cp, fp, rp])
    result = dict(status='PASS_EXACT_JOINT_TO_SECTOR_HANDOFF',
                  literal_rational_strings_compared=counts, rounding_performed=False,
                  source_hashes={str(p): sha(p) for p in paths},
                  consumer_sha256=sha(Path(__file__)), nice=os.getpriority(os.PRIO_PROCESS, 0),
                  source_C16_answered=False)
    a.output.write_text(json.dumps(result, indent=2)+'\n')
    print(result['status'], counts, flush=True)


if __name__ == '__main__': main()
