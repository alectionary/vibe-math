#!/usr/bin/env python3
"""Exact identification checks for the equation-(7) multi-trait SEM.

Two covariance implementations are independent: Gaussian elimination on I-B,
and the closed unit-upper-triangular inverse for this zero pattern. Equality
is exact rational arithmetic. A finite grid checks the diagonal recovery map.
It does not replace the written proof of injectivity on the whole positive
domain.
"""

from __future__ import annotations

import json
from fractions import Fraction
from pathlib import Path

N = 3


def F(x) -> Fraction:
    return Fraction(x)


def eye(n: int = N):
    return [[F(1 if i == j else 0) for j in range(n)] for i in range(n)]


def matmul(a, b):
    p, q, r = len(a), len(b), len(b[0])
    return [[sum(a[i][k] * b[k][j] for k in range(q)) for j in range(r)] for i in range(p)]


def transpose(a):
    return [list(row) for row in zip(*a)]


def add(a, b):
    return [[a[i][j] + b[i][j] for j in range(len(a[0]))] for i in range(len(a))]


def sub(a, b):
    return [[a[i][j] - b[i][j] for j in range(len(a[0]))] for i in range(len(a))]


def invert(a):
    """Invert a square matrix by Gauss-Jordan elimination over the rationals."""
    n = len(a)
    m = [row[:] + eye(n)[i] for i, row in enumerate(a)]
    for col in range(n):
        pivot = next(i for i in range(col, n) if m[i][col] != 0)
        m[col], m[pivot] = m[pivot], m[col]
        scale = m[col][col]
        m[col] = [entry / scale for entry in m[col]]
        for row in range(n):
            if row == col:
                continue
            factor = m[row][col]
            if factor == 0:
                continue
            m[row] = [m[row][j] - factor * m[col][j] for j in range(2 * n)]
    return [row[n:] for row in m]


def L_closed(b):
    """(I-B)^{-1} when only B_12, B_13, B_23 may be nonzero (0-based)."""
    b12, b13, b23 = b[0][1], b[0][2], b[1][2]
    return [
        [F(1), b12, b13 + b12 * b23],
        [F(0), F(1), b23],
        [F(0), F(0), F(1)],
    ]


def sigma_from_L(L, gamma, psi, phi):
    pi = matmul(L, gamma)
    yy = add(matmul(matmul(L, psi), transpose(L)), matmul(matmul(pi, phi), transpose(pi)))
    yx = matmul(pi, phi)
    return {"yy": yy, "yx": yx, "xx": phi}


def sigma_general(b, gamma, psi, phi):
    return sigma_from_L(invert(sub(eye(), b)), gamma, psi, phi)


def sigma_closed(b, gamma, psi, phi):
    return sigma_from_L(L_closed(b), gamma, psi, phi)


def zeros():
    return [[F(0) for _ in range(N)] for _ in range(N)]


def diag(vs):
    m = zeros()
    for i, v in enumerate(vs):
        m[i][i] = F(v)
    return m


def principal_minors(a):
    minors = []
    for k in range(1, N + 1):
        block = [row[:k] for row in a[:k]]
        # determinant by expansion; k <= 3
        minors.append(det(block))
    return minors


def det(a):
    n = len(a)
    if n == 1:
        return a[0][0]
    if n == 2:
        return a[0][0] * a[1][1] - a[0][1] * a[1][0]
    return (
        a[0][0] * (a[1][1] * a[2][2] - a[1][2] * a[2][1])
        - a[0][1] * (a[1][0] * a[2][2] - a[1][2] * a[2][0])
        + a[0][2] * (a[1][0] * a[2][1] - a[1][1] * a[2][0])
    )


def recover_diagonal(omega):
    """Left inverse of Omega = L Psi L^T for diagonal positive Psi."""
    v3 = omega[2][2]
    b23 = omega[2][1] / v3
    c13 = omega[2][0] / v3
    v2 = omega[1][1] - b23 * b23 * v3
    b12 = (omega[1][0] - b23 * c13 * v3) / v2
    b13 = c13 - b12 * b23
    v1 = omega[0][0] - b12 * b12 * v2 - c13 * c13 * v3
    b = zeros()
    b[0][1], b[0][2], b[1][2] = b12, b13, b23
    return b, diag([v1, v2, v3])


def conditional_omega(b, psi):
    L = L_closed(b)
    return matmul(matmul(L, psi), transpose(L))


def eq(a, b) -> bool:
    return all(a[i][j] == b[i][j] for i in range(len(a)) for j in range(len(a[0])))


def as_lists(m):
    return [[str(entry) for entry in row] for row in m]


def support_ok(b) -> bool:
    banned = [(0, 0), (1, 0), (1, 1), (2, 0), (2, 1), (2, 2)]
    return all(b[i][j] == 0 for i, j in banned)


def base_point():
    return {
        "name": "diagonal-base",
        "B": zeros(),
        "Gamma": eye(),
        "Psi": eye(),
        "Phi": eye(),
    }


def bow(name, b_entries, psi, gamma):
    b = zeros()
    for (i, j), value in b_entries.items():
        b[i][j] = F(value)
    return {"name": name, "B": b, "Gamma": gamma, "Psi": psi, "Phi": eye()}


def witnesses():
    g12 = eye()
    g12[0][1] = F(1)
    g13 = eye()
    g13[0][2] = F(-1)
    g23 = eye()
    g23[1][2] = F(-1)
    psi12 = eye()
    psi12[0][0] = F(2)
    psi12[0][1] = psi12[1][0] = F(1)
    psi13 = eye()
    psi13[0][0] = F(2)
    psi13[0][2] = psi13[2][0] = F(-1)
    psi23 = eye()
    psi23[1][1] = F(2)
    psi23[1][2] = psi23[2][1] = F(-1)
    return [
        base_point(),
        bow("residual-12", {(0, 1): -1}, psi12, g12),
        bow("residual-13", {(0, 2): 1}, psi13, g13),
        bow("residual-23", {(1, 2): 1}, psi23, g23),
    ]


def paper_point():
    """Equation (7): y = -M y + G x + e, so B = -M."""
    b = zeros()
    b[0][1], b[0][2], b[1][2] = F(-1, 2), F(-1, 4), F(-1, 2)
    gamma = [
        [F(1, 8), F(1, 4), F(1, 2)],
        [F(1, 2), F(1, 2), F(1, 2)],
        [F(1, 4), F(1, 8), F(1, 4)],
    ]
    psi = diag([F(8, 5), F(9, 5), F(5, 2)])
    return {"name": "equation-7", "B": b, "Gamma": gamma, "Psi": psi, "Phi": eye()}


def check_point(point, base_sigma=None):
    general = sigma_general(point["B"], point["Gamma"], point["Psi"], point["Phi"])
    closed = sigma_closed(point["B"], point["Gamma"], point["Psi"], point["Phi"])
    same_impl = all(eq(general[k], closed[k]) for k in ("yy", "yx", "xx"))
    minors = principal_minors(point["Psi"])
    record = {
        "name": point["name"],
        "implementations_agree": same_impl,
        "support_ok": support_ok(point["B"]),
        "psi_principal_minors": [str(m) for m in minors],
        "psi_positive_definite": all(m > 0 for m in minors),
        "phi_positive_definite": all(m > 0 for m in principal_minors(point["Phi"])),
        "sigma_yy": as_lists(closed["yy"]),
        "sigma_yx": as_lists(closed["yx"]),
        "sigma_xx": as_lists(closed["xx"]),
    }
    if base_sigma is not None:
        record["matches_base_sigma"] = all(eq(closed[k], base_sigma[k]) for k in ("yy", "yx", "xx"))
        record["parameters_differ_from_base"] = not (
            eq(point["B"], zeros()) and eq(point["Gamma"], eye()) and eq(point["Psi"], eye())
        )
    return record, closed


def diagonal_grid():
    values_b = [-2, -1, 0, 1, 2]
    values_v = [1, 2, 3]
    checked = 0
    for b12 in values_b:
        for b13 in values_b:
            for b23 in values_b:
                for v1 in values_v:
                    for v2 in values_v:
                        for v3 in values_v:
                            b = zeros()
                            b[0][1], b[0][2], b[1][2] = F(b12), F(b13), F(b23)
                            psi = diag([v1, v2, v3])
                            omega = conditional_omega(b, psi)
                            rb, rpsi = recover_diagonal(omega)
                            if not (eq(rb, b) and eq(rpsi, psi)):
                                raise SystemExit(f"recovery failed at {b12,b13,b23,v1,v2,v3}")
                            checked += 1
    return checked


def main():
    points = witnesses()
    base = points[0]
    _, base_sigma = check_point(base)
    records = []
    for point in points:
        record, _ = check_point(point, None if point is base else base_sigma)
        records.append(record)
    paper = paper_point()
    omega = conditional_omega(paper["B"], paper["Psi"])
    rb, rpsi = recover_diagonal(omega)
    pi = matmul(L_closed(paper["B"]), paper["Gamma"])
    recovered_gamma = matmul(sub(eye(), rb), pi)
    paper_record = {
        "name": paper["name"],
        "B_recovered": as_lists(rb),
        "Psi_recovered": as_lists(rpsi),
        "Gamma_recovered": as_lists(recovered_gamma),
        "matches_equation_7": eq(rb, paper["B"]) and eq(rpsi, paper["Psi"]) and eq(recovered_gamma, paper["Gamma"]),
    }
    grid = diagonal_grid()
    # Implementations agree on the inverse at the paper point as well.
    paper_sigma_ok = all(
        eq(sigma_general(paper["B"], paper["Gamma"], paper["Psi"], paper["Phi"])[k],
           sigma_closed(paper["B"], paper["Gamma"], paper["Psi"], paper["Phi"])[k])
        for k in ("yy", "yx", "xx")
    )
    report = {
        "arithmetic": "fractions.Fraction",
        "grid": {
            "B_entries": [-2, -1, 0, 1, 2],
            "variances": [1, 2, 3],
            "points": grid,
            "exhaustive_for_that_box": True,
            "covers_all_positive_reals": False,
        },
        "points": records,
        "equation_7": paper_record,
        "equation_7_implementations_agree": paper_sigma_ok,
        "collisions_established": all(
            r["matches_base_sigma"] and r["parameters_differ_from_base"] and r["psi_positive_definite"]
            for r in records
            if r["name"] != "diagonal-base"
        ),
        "diagonal_base_positive_definite": records[0]["psi_positive_definite"],
    }
    out = Path(__file__).with_name("witnesses.json")
    out.write_text(json.dumps(report, indent=2) + "\n")
    print(json.dumps({
        "grid_points": grid,
        "collisions_established": report["collisions_established"],
        "equation_7_matches": paper_record["matches_equation_7"],
        "implementations_agree": all(r["implementations_agree"] for r in records) and paper_sigma_ok,
    }, indent=2))
    if not report["collisions_established"] or not paper_record["matches_equation_7"]:
        raise SystemExit(1)


if __name__ == "__main__":
    main()
