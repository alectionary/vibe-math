"""Native sparse evaluation discovery; no native UNSAT conclusion is trusted."""
import ctypes
from conditional_span_oracle import Certificate


class SparseQuotientOracle:
    def __init__(self, X, Z, library, dimension=128):
        self.X, self.Z, self.dimension = X, Z, dimension
        self.lib = ctypes.CDLL(str(library))
        u64, integer = ctypes.c_uint64, ctypes.c_int
        arrays = []
        for V in (X, Z):
            arrays.extend([(u64*len(V))(*(v & ((1 << 64)-1) for v in V)),
                           (u64*len(V))(*(v >> 64 for v in V))])
        create = self.lib.c16_sparse_create
        create.argtypes = [ctypes.POINTER(u64), ctypes.POINTER(u64), integer,
                           ctypes.POINTER(u64), ctypes.POINTER(u64), integer, integer]
        create.restype = ctypes.c_void_p
        self.ctx = create(arrays[0], arrays[1], len(X), arrays[2], arrays[3], len(Z), dimension)
        assert self.ctx
        self.fn = self.lib.c16_sparse_probe
        self.fn.argtypes = [ctypes.c_void_p, integer, ctypes.POINTER(integer), integer,
                           integer, ctypes.POINTER(Certificate), integer]
        self.fn.restype = integer
        self.destroy = self.lib.c16_sparse_destroy
        self.destroy.argtypes = [ctypes.c_void_p]
        self.destroy.restype = None

    def probe(self, side, mandatory_opposite, order=3, cap=4):
        ids = list(mandatory_opposite)
        assert len(ids) == len(set(ids)) and side in (0, 1) and order in (1, 2, 3)
        data = (ctypes.c_int*len(ids))(*ids)
        output = (Certificate*cap)()
        n = self.fn(self.ctx, side, data, len(ids), order, output, cap)
        assert 0 <= n <= cap, n
        V, opposite = (self.X, self.Z) if side == 0 else (self.Z, self.X)
        rows = []
        for raw in output[:n]:
            assert raw.kind == 5 and raw.side == side and list(raw.ids[:raw.count]) == ids
            w = raw.lo | (raw.hi << 64)
            support = [i for i, x in enumerate(V) if all((x & opposite[j]).bit_count() % 2 == 0 for j in ids)
                       and (x & w).bit_count() % 2]
            assert len(support) == raw.omitted <= order
            owner_offset = len(self.X) if side == 0 else 0
            rows.append({'kind': 'sparse_quotient_obstruction', 'side': side,
                         'mandatory_opposite': ids, 'witness_hex': hex(w),
                         'detecting_support': support, 'order': len(support),
                         'minimum_outside_basis_terms': len(support)+1,
                         'clause': [-j-1-owner_offset for j in ids]})
        return rows

    def close(self):
        if self.ctx:
            self.destroy(self.ctx)
            self.ctx = None
