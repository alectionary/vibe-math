#!/usr/bin/env python3
"""Exact induced-matching test for the block-B identity.

A width-16 CSS canonical frame in these pools is a dual pair of bases, so
sum_j beta_j alpha_j^T = I_128. The diagonal block on seeds 4 and 5 is therefore
I_32. Only anticommuting pool pairs with both B-components nonzero contribute.
This script asks CryptoMiniSat whether any induced matching of those pairs has
B-outer-products summing to the chosen 32x32 target over F_2.

Targets:
  I32       the identity, necessary for a canonical frame
  seed5     the coordinate projection onto seed 5, realized by the 16 monomials

The seed5 target is a sanity check of the encoding. A negative answer for I32
is an exact finite proof that these pools contain no width-16 CSS canonical frame.
"""

from __future__ import annotations

import sys
import time
from pathlib import Path

from pysat.solvers import CryptoMinisat


def load(path: Path) -> list[int]:
    return [int(line, 16) for line in path.read_text().splitlines() if line.strip()]


def target_matrix(name: str) -> list[int]:
    """Return 32 row-bitmasks. Bit c of row r is the matrix entry (r, c)."""
    rows = [0] * 32
    if name == "I32":
        for i in range(32):
            rows[i] |= 1 << i
    elif name == "seed5":
        for i in range(16, 32):
            rows[i] |= 1 << i
    else:
        raise SystemExit(f"unknown target {name}")
    return rows


def main() -> None:
    if len(sys.argv) < 4:
        raise SystemExit("usage: b_identity_cms.py xcoords.txt zcoords.txt I32|seed5")
    x = load(Path(sys.argv[1]))
    z = load(Path(sys.argv[2]))
    target = target_matrix(sys.argv[3])
    t0 = time.perf_counter()
    edges: list[tuple[int, int, int, int]] = []
    x_edges: list[list[int]] = [[] for _ in x]
    z_edges: list[list[int]] = [[] for _ in z]
    for i, a in enumerate(x):
        ab = (a >> 64) & 0xFFFFFFFF
        if not ab:
            continue
        for j, b in enumerate(z):
            bb = (b >> 64) & 0xFFFFFFFF
            if not bb:
                continue
            if (a & b).bit_count() & 1:
                eid = len(edges)
                edges.append((i, j, ab, bb))
                x_edges[i].append(eid)
                z_edges[j].append(eid)
    print(f"pairs {len(edges)} build {time.perf_counter() - t0:.2f}s", flush=True)

    # Matrix-bit -> pair variables (1-based, pair id + 1).
    bits: list[list[int]] = [[] for _ in range(1024)]
    for eid, (_i, _j, ab, bb) in enumerate(edges):
        var = eid + 1
        aa, bbv = ab, bb
        while aa:
            c = (aa & -aa).bit_length() - 1
            aa ^= 1 << c
            row = bbv
            while row:
                r = (row & -row).bit_length() - 1
                row ^= 1 << r
                bits[r * 32 + c].append(var)

    solver = CryptoMinisat(use_timer=True)
    nvars = len(edges)
    for r in range(32):
        for c in range(32):
            lits = bits[r * 32 + c]
            rhs = bool((target[r] >> c) & 1)
            if not lits:
                if rhs:
                    solver.add_clause([1])
                    solver.add_clause([-1])
                continue
            solver.add_xor_clause(lits, value=rhs)

    def atmost_one(ids: list[int]) -> None:
        nonlocal nvars
        if len(ids) <= 1:
            return
        # Sequential counter: s_i means one of the first i literals is true.
        prev = None
        for eid in ids:
            lit = eid + 1
            nvars += 1
            s = nvars
            if prev is None:
                solver.add_clause([-lit, s])
                solver.add_clause([lit, -s])
            else:
                solver.add_clause([-lit, -prev])
                solver.add_clause([-lit, s])
                solver.add_clause([-prev, s])
                solver.add_clause([lit, prev, -s])
            prev = s

    for ids in x_edges:
        atmost_one(ids)
    for ids in z_edges:
        atmost_one(ids)
    print(f"vars {nvars} encoded {time.perf_counter() - t0:.2f}s", flush=True)
    status = solver.solve()
    print(f"status {status} time {solver.time():.2f}s", flush=True)
    if status:
        model = set(lit for lit in solver.get_model() if lit > 0 and lit <= len(edges))
        chosen = [edges[v - 1][:2] for v in sorted(model)]
        print(f"matching {len(chosen)}")
        out = Path(sys.argv[4]) if len(sys.argv) > 4 else None
        if out:
            out.write_text("".join(f"{i} {j}\n" for i, j in chosen))
            print(f"wrote {out}")
    solver.delete()


if __name__ == "__main__":
    main()
