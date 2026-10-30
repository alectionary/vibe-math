#!/usr/bin/env python3
"""Individually stronger anchor/phase-mask necessities from saved certificates.

The returned predicate is an OUTER compatibility predicate: True means only
unexcluded. It never certifies a frame, and it does not change the unconditional
mask universe used by common_profile_probe.py. All tables are intersected with
that universe, so callers may continue using their old allowed-mask list.

Coordinates are physical pool indices: P selects X[16*orbit+h]; anchor S,a is
X[16*a], and anchor T,a is Z[16*a]. For S, the existing X-only quotient has fixed
X[16*a] and counted projected X. Remove the fixed anchor from P when a==orbit.
For T, first exchange X_i and Z_i by the checked linear sector isomorphism;
the anchor becomes X[16*a] and P becomes Z[16*orbit+h], with phases UNCHANGED.
A full Gram-identity frame has at most one member of P pairing with the anchor.
Remove that possible partner before applying the saved counted-Z quotient
profile: every remaining selected Z annihilates the selected X anchor and is a
member of the 127-dimensional dual quotient frame. Never require the possible
partner itself to lie in the quotient's eligible mask.

Absent-anchor tables use unconditional restrictions, the obvious same-vector
absence, and the sole existing deletion bank (T,a=21). They do not extrapolate
that bank to the other 44 normalized anchors. No point-specific hull weights
are used as exclusions. A separate consumer binds/replays physical witnesses.
"""
from pathlib import Path
import argparse
import gzip
import hashlib
import json
import numpy as np

ROOT = Path(__file__).resolve().parent


def sha(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def read_json(path):
    raw = Path(path).read_bytes()
    return json.loads(gzip.decompress(raw) if str(path).endswith('.gz') else raw)


def coefficients(value, vectors):
    """Return a subset expressing value, or None (low-pivot elimination)."""
    rows = {}
    for k, value0 in enumerate(vectors):
        tag = 1 << k
        while value0:
            pivot = value0 & -value0
            if pivot not in rows:
                rows[pivot] = value0, tag
                break
            row, oldtag = rows[pivot]
            value0 ^= row
            tag ^= oldtag
        assert value0, 'counted orbit must be independent'
    tag = 0
    while value:
        pivot = value & -value
        if pivot not in rows:
            return None
        row, oldtag = rows[pivot]
        value ^= row
        tag ^= oldtag
    return tag


class ConditionalProfileCompatibility:
    def __init__(self, root=ROOT):
        self.root = Path(root)
        self.inputs = {}
        self.rows = {}
        self.tables = {}
        self.n = np.arange(65536, dtype=np.int64)
        self.pop = np.array([m.bit_count() for m in range(65536)], dtype=np.int8)
        self.pools = []
        for side in 'xz':
            p = self.root / f'pools/{side}coords.txt'
            self.bind(p)
            self.pools.append([int(v, 16) for v in p.read_text().split()])
        self.bind(self.root / 'physical-pool-source.json')
        self.profiles = self.load('algebraic-results/orbit-rank-profiles.json.gz')
        self.hulls = self.load('algebraic-results/hulls-16-rank.json.gz')
        self.cohorts = {}
        self.replays = {}
        for side, folder in [('S', 'conditional-capacity'), ('T', 'conditional-cross-capacity')]:
            self.cohorts[side] = self.load(f'algebraic-results/{folder}/cohort.json')
            self.replays[side] = self.load(f'algebraic-results/{folder}/independent.json')
            assert self.cohorts[side]['status'] == 'COMPLETE_GENERATION_REQUIRES_PHYSICAL_REPLAY'
            assert self.replays[side]['status'] == 'PASS'
            assert len(self.cohorts[side]['records']) == len(self.replays[side]['records']) == 45

    def bind(self, path):
        path = Path(path)
        key = str(path.resolve().relative_to(self.root.resolve()))
        value = sha(path)
        if key in self.inputs:
            assert self.inputs[key] == value
        self.inputs[key] = value
        return value

    def load(self, rel):
        path = self.root / rel
        self.bind(path)
        return read_json(path)

    def conditional_record(self, orbit, side, anchor):
        key = orbit, side, anchor
        if key not in self.rows:
            folder = 'conditional-capacity' if side == 'S' else 'conditional-cross-capacity'
            record = next(r for r in self.cohorts[side]['records'] if r['orbit'] == anchor)
            path = self.root / 'algebraic-results' / folder / record['certificate_file']
            assert self.bind(path) == record['certificate_sha256']
            report = next(r for r in self.replays[side]['records'] if r['orbit'] == anchor)
            assert report['status'] == 'PASS' and report['certificate_sha256'] == sha(path)
            report_path = path.parent / report['report_file']
            assert self.bind(report_path) == report['report_sha256']
            d = read_json(path)
            assert d['conditioned_on_X_index'] == 16*anchor
            assert d.get('selected_quotient_sector', 'X') == ('X' if side == 'S' else 'Z')
            meta = self.root / d['quotient_metadata_c16_path']
            assert self.bind(meta) == d['quotient_metadata_sha256']
            self.rows[key] = next(row for row in d['records'] if row['orbit'] == orbit)
        return self.rows[key]

    def survivor_table(self, row):
        eligible = row.get('eligible_mask', 65535)
        bad = (self.n & ~eligible) != 0
        for cert in row['minimal_bad_certificates']:
            bad[cert['mask']] = True
        for h in range(16):
            view = bad.reshape(-1, 2, 1 << h)
            view[:, 1, :] |= view[:, 0, :]
        return ~bad

    def unconditional(self, orbit):
        key = orbit, 'unconditional'
        if key not in self.tables:
            row = next(r for r in self.profiles['records'] if r['orbit'] == orbit)
            table = self.survivor_table(row)
            if orbit == 12:
                table &= self.pop <= 11
            expected = next(r for r in self.hulls['records'] if r['orbit'] == orbit)['phase_patterns']
            assert int(table.sum()) == expected
            table.setflags(write=False)
            self.tables[key] = table
        return self.tables[key]

    def baseline(self, orbit, side, anchor, condition=1):
        """Old rank/degree predicate, intersected with the old mask universe."""
        assert side in ('S', 'T') and condition in (0, 1)
        assert 0 <= orbit < 45 and 0 <= anchor < 45
        table = self.unconditional(orbit).copy()
        if not condition:
            if side == 'S' and orbit == anchor:
                table &= (self.n & 1) == 0
        elif side == 'S':
            if orbit == anchor:
                table &= (self.n & 1) != 0
            else:
                subset = coefficients(self.pools[0][16*anchor], self.pools[0][16*orbit:16*orbit+16])
                if subset is not None:
                    table &= (self.n & subset) != subset
        else:
            neighbor = self.neighbor_mask(orbit, anchor)
            table &= self.pop[self.n & neighbor] <= 1
        return table

    def neighbor_mask(self, orbit, anchor):
        z = self.pools[1][16*anchor]
        return sum(((x & z).bit_count() % 2) << h for h, x in enumerate(self.pools[0][16*orbit:16*orbit+16]))

    def table(self, orbit, side, anchor_orbit, condition=1):
        key = orbit, side, anchor_orbit, condition
        if key not in self.tables:
            table = self.baseline(orbit, side, anchor_orbit, condition)
            if condition:
                row = self.conditional_record(orbit, side, anchor_orbit)
                quotient = self.n & (~1 if side == 'S' and orbit == anchor_orbit else 65535)
                if side == 'T':
                    quotient = self.n & ~self.neighbor_mask(orbit, anchor_orbit)
                table &= self.survivor_table(row)[quotient]
            elif side == 'T' and anchor_orbit == 21:
                d = self.load('algebraic-results/absent336-Z-profiles.json.gz')
                rep = self.load('algebraic-results/absent336-Z-profiles-independent.json')
                assert d['conditioned_on_X_absent'] == 336 and d['selected_quotient_sector'] == 'Z'
                assert rep['status'] == 'PASS'
                assert rep['certificate_sha256'] == self.inputs['algebraic-results/absent336-Z-profiles.json.gz']
                row = next(r for r in d['records'] if r['orbit'] == orbit)
                table &= self.survivor_table(row)
            table.setflags(write=False)
            self.tables[key] = table
        return self.tables[key]

    def manifest(self):
        return dict(sorted(self.inputs.items()))


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--orbits', nargs='+', type=int, default=[32])
    ap.add_argument('--output', type=Path, required=True)
    args = ap.parse_args()
    oracle = ConditionalProfileCompatibility()
    rows = []
    for orbit in args.orbits:
        for side in 'ST':
            for anchor in range(45):
                for condition in (0, 1):
                    table = oracle.table(orbit, side, anchor, condition)
                    baseline = oracle.baseline(orbit, side, anchor, condition)
                    rows.append({'orbit': orbit, 'side': side, 'anchor': anchor, 'condition': condition,
                                 'old_compatible': int(baseline.sum()), 'compatible': int(table.sum()),
                                 'new_exclusions': int((baseline & ~table).sum()),
                                 'table_sha256': hashlib.sha256(table.tobytes()).hexdigest()})
    out = {'status': 'CANDIDATE_REQUIRES_INDEPENDENT_PHYSICAL_REPLAY', 'source_C16_answered': False,
           'orbits': args.orbits, 'records': rows, 'source_hashes': oracle.manifest(),
           'producer_sha256': sha(Path(__file__)),
           'scope': 'Necessary individual compatibility only. True means unexcluded; the original unconditional allowed-mask set, source width and cover are unchanged.'}
    args.output.write_text(json.dumps(out, indent=2)+'\n')
    print({'tables': len(rows), 'new_exclusions': sum(r['new_exclusions'] for r in rows)}, flush=True)


if __name__ == '__main__':
    main()
