"""Independent low-pivot RREF and exact short-sum checks of source obstructions."""
from itertools import combinations


class SparseQuotientConsumer:
    def __init__(self, X, Z, dimension=128):
        self.X, self.Z, self.dimension = X, Z, dimension

    @staticmethod
    def quotient(values):
        rows = {}
        for value in values:
            for pivot, row in sorted(rows.items()):
                if value >> pivot & 1:
                    value ^= row
            if not value:
                continue
            pivot = (value & -value).bit_length()-1
            for other, row in list(rows.items()):
                if row >> pivot & 1:
                    rows[other] = row ^ value
            rows[pivot] = value
        def residue(value):
            for pivot, row in rows.items():
                if value >> pivot & 1:
                    value ^= row
            return value
        return residue

    def check(self, row, literal=False):
        assert row['kind'] == 'sparse_quotient_obstruction'
        side, ids, q = row['side'], row['mandatory_opposite'], row['order']
        assert side in (0, 1) and q in (0, 1, 2, 3) and len(ids) == len(set(ids))
        V, opposite = (self.X, self.Z) if side == 0 else (self.Z, self.X)
        assert all(0 <= i < len(opposite) for i in ids)
        w = int(row['witness_hex'], 16)
        assert 0 < w < 1 << self.dimension
        residue = self.quotient(opposite[i] for i in ids)
        target = residue(w)
        assert target
        singles = {0, *(residue(v) for v in opposite)}
        if q >= 1:
            assert target not in singles
        if q >= 2:
            assert all(target ^ v not in singles for v in singles)
        if q >= 3:
            # A separate representation: store target-translated pair sums,
            # then reject any overlap with the singleton quotient labels.
            labels = list(singles)
            translated_pairs = {target ^ a ^ b for i, a in enumerate(labels) for b in labels[i:]}
            assert translated_pairs.isdisjoint(singles)
        support = [i for i, x in enumerate(V) if all((x & opposite[j]).bit_count() % 2 == 0 for j in ids)
                   and (x & w).bit_count() % 2]
        assert support == row['detecting_support'] and len(support) == q
        assert row['minimum_outside_basis_terms'] == q+1
        offset = len(self.X) if side == 0 else 0
        clause = [-i-1-offset for i in ids]
        assert row['clause'] == clause
        if literal:
            for k in range(q+1):
                for subset in combinations(opposite, k):
                    value = w
                    for z in subset:
                        value ^= z
                    assert residue(value)
        return clause
