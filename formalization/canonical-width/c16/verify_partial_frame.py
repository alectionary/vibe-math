#!/usr/bin/env python3
"""Check a recorded partial canonical frame for C^LP_{16,9}.

The checks are rebuilt from the coefficient and exponent arrays in Lee,
arXiv:2610.06820v1, equation (50), using the balanced binary trace expansion
of equations (14)--(18) and Appendix B.3. The witness stores physical supports
only. This script does not read the upstream pool or checker.

With no argument it checks partial-frame-84.json. Pass a witness path to check
another file in the same schema, including partial-frame-88.json.
"""
from __future__ import annotations

import json
import sys
from pathlib import Path

P = 16
N = 1088
R, S = 3, 5
# Equation (50). Coefficients 0,1,omega,omega^2 are 0,1,2,3.
C = ((1, 1, 1, 1, 1), (1, 1, 2, 0, 3), (1, 3, 1, 2, 0))
E = ((0, 0, 0, 0, 0), (0, 6, 12, 9, 3), (0, 12, 6, 2, 14))
# rho(1)=I, rho(omega)=[[0,1],[1,1]], rho(omega^2)=[[1,1],[1,0]].
RHO = (
    ((0, 0), (0, 0)),
    ((1, 0), (0, 1)),
    ((0, 1), (1, 1)),
    ((1, 1), (1, 0)),
)


def mask(support: list[int]) -> int:
    value = 0
    for q in support:
        if not 0 <= q < N:
            raise SystemExit(f"qubit {q} outside 0..{N - 1}")
        bit = 1 << q
        if value & bit:
            raise SystemExit(f"repeated qubit {q}")
        value |= bit
    return value


def parity(x: int, y: int) -> int:
    return (x & y).bit_count() & 1


def shift(value: int, h: int) -> int:
    result = 0
    while value:
        bit = value & -value
        q = bit.bit_length() - 1
        block, pos = divmod(q, P)
        result |= 1 << (block * P + (pos + h) % P)
        value ^= bit
    return result


def reconstruct_checks() -> tuple[list[int], list[int]]:
    """Balanced H_X and H_Z rows. B = A^dagger uses the group inverse."""
    hx_rows, hz_rows = [], []
    for i in range(R):
        for b in range(S):
            hx_rows.append(
                [(a * S + b, C[i][a], E[i][a]) for a in range(S)]
                + [(S * S + i * R + j, C[j][b], -E[j][b]) for j in range(R)]
            )
    for a in range(S):
        for j in range(R):
            hz_rows.append(
                [(a * S + b, C[j][b], E[j][b]) for b in range(S)]
                + [(S * S + i * R + j, C[i][a], -E[i][a]) for i in range(R)]
            )

    def expand(rows: list[list[tuple[int, int, int]]]) -> list[int]:
        balanced = []
        for monomials in rows:
            first = [0, 0]
            for block, coeff, exponent in monomials:
                for a in range(2):
                    for b in range(2):
                        if RHO[coeff][a][b]:
                            first[a] ^= 1 << ((2 * block + b) * P + (-exponent) % P)
            three = [first[0], first[1], first[0] ^ first[1]]
            chosen = sorted(range(3), key=lambda i: (three[i].bit_count(), i))[:2]
            balanced.extend(shift(three[i], h) for i in chosen for h in range(P))
        return balanced

    return expand(hx_rows), expand(hz_rows)


def rank(rows: list[int]) -> int:
    pivots: dict[int, int] = {}
    for row in rows:
        while row:
            pivot = row.bit_length() - 1
            if pivot not in pivots:
                pivots[pivot] = row
                break
            row ^= pivots[pivot]
    return len(pivots)


def main() -> None:
    path = Path(sys.argv[1]) if len(sys.argv) > 1 else Path(__file__).with_name("partial-frame-84.json")
    witness = json.loads(path.read_text())
    pairs = witness["pairs"]
    n_pairs = witness["n_pairs"]
    if len(pairs) != n_pairs or n_pairs < 1:
        raise SystemExit(f"expected {n_pairs} pairs")
    hx, hz = reconstruct_checks()
    if len(hx) != 480 or len(hz) != 480:
        raise SystemExit(f"unexpected check counts {len(hx)} {len(hz)}")
    if max(v.bit_count() for v in hx) > 9 or max(v.bit_count() for v in hz) > 9:
        raise SystemExit("check weight exceeds 9")
    if any(parity(x, z) for x in hx for z in hz):
        raise SystemExit("CSS checks fail to commute")
    rx, rz = rank(hx), rank(hz)
    if (rx, rz) != (480, 480) or N - rx - rz != 128:
        raise SystemExit(f"unexpected ranks {rx} {rz}")

    xs, zs = [], []
    for pair in pairs:
        x, z = mask(pair["X"]), mask(pair["Z"])
        if x.bit_count() != 16 or z.bit_count() != 16:
            raise SystemExit("pair weight is not 16")
        if any(parity(row, x) for row in hz) or any(parity(row, z) for row in hx):
            raise SystemExit("nonzero syndrome")
        xs.append(x)
        zs.append(z)
    for i, x in enumerate(xs):
        for j, z in enumerate(zs):
            if parity(x, z) != (i == j):
                raise SystemExit(f"Gram failure at {(i, j)}")
    if len(set(xs)) != n_pairs or len(set(zs)) != n_pairs:
        raise SystemExit("duplicate operators")
    print(f"partial canonical frame ok: {n_pairs} pairs, weight 16, zero syndromes, Gram identity")
    print(f"rebuilt checks: {len(hx)} rows, max weight 9, ranks {(rx, rz)}, k={N - rx - rz}")


if __name__ == "__main__":
    main()
