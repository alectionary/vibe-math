"""Checks for a replication comparison.

The functions are the rules a note has to apply before it gives a
verdict: round to the printed precision, keep scope in its own field,
withhold a verdict from an incomparable pair, and refuse to treat
recovery of a printed expression as the documented procedure.

Run from the repository root:

    python3 .agents/skills/replication-paper/scripts/checks.py
"""

from __future__ import annotations

import json
from decimal import Decimal, ROUND_HALF_UP, getcontext
from pathlib import Path

getcontext().prec = 80

NUMERICAL = ("match", "close", "mismatch")
SCOPE = ("exact", "limited", "unavailable")
LEDGER_STATUS = ("followed", "departed", "not applicable")

# Indices whose usual definition changes when a robust correction is
# applied. SRMR from correlation residuals does not.
ROBUST_SENSITIVE = ("chisq", "chi-square", "cfi", "tli", "rmsea")
VARIABLE_SENSITIVE = ROBUST_SENSITIVE + ("srmr", "aic")

# https://www.statmodel.com/chidiff.shtml
# T is the scaled MLM, MLR, or WLSM chi-square. c is the scaling
# correction printed for that model. T*c is the normal-theory chi-square.
# Satorra and Bentler (2001), Psychometrika 66, 507-514, put that
# normal-theory difference in the numerator.
MPLUS_DIFFERENCE_URL = "https://www.statmodel.com/chidiff.shtml"
SB2001 = "Satorra and Bentler (2001), Psychometrika 66, 507-514"

COMPARABILITY_FIELDS = (
    "estimator",
    "missingness",
    "n",
    "normalizer",
    "mean_structure",
    "variable_set",
    "df",
    "baseline",
    "robust_correction",
    "fit_index",
)


def _decimal(value) -> Decimal:
    return Decimal(str(value))


def numerical_verdict(published, ours, decimals: int, close_ulps: int = 1) -> str:
    """Match if `ours` rounds half up to `published` at `decimals`.

    Close if it does not, and the absolute gap is at most `close_ulps`
    units in the last printed place. Otherwise mismatch.
    """
    if decimals < 0:
        raise ValueError("decimals must be non-negative")
    published_d = _decimal(published)
    ours_d = _decimal(ours)
    quantum = Decimal(1).scaleb(-decimals)
    rounded = ours_d.quantize(quantum, rounding=ROUND_HALF_UP)
    printed = published_d.quantize(quantum, rounding=ROUND_HALF_UP)
    if rounded == printed:
        return "match"
    if abs(ours_d - published_d) <= Decimal(close_ulps) * quantum:
        return "close"
    return "mismatch"


def two_axis(published, ours, decimals: int, scope: str, close_ulps: int = 1) -> dict:
    """Numerical verdict and scope, kept in separate fields."""
    if scope not in SCOPE:
        raise ValueError(f"scope must be one of {SCOPE}")
    numerical = numerical_verdict(published, ours, decimals, close_ulps=close_ulps)
    return {
        "numerical": numerical,
        "scope": scope,
        "decimals": decimals,
        "verdict": None,
    }


def _robust_class(record: dict) -> str:
    label = str(record.get("robust_correction", "none")).strip().lower()
    estimator = str(record.get("estimator", "")).strip().lower()
    if label in ("", "none", "ml", "plain", "wishart"):
        if estimator in ("mlr", "mlm", "mlmv", "wlsm", "wlsmv"):
            return "robust"
        return "plain"
    return "robust"


def comparability(left: dict, right: dict, index: str) -> dict:
    """Return a flag instead of a verdict when the sides are not comparable.

    `index` is the statistic being compared, such as `cfi` or `srmr`.
    """
    missing = []
    for side_name, record in (("left", left), ("right", right)):
        for field in COMPARABILITY_FIELDS:
            if field not in record or record[field] in (None, ""):
                missing.append(f"{side_name}.{field}")
    if missing:
        return {
            "verdict_allowed": False,
            "numerical": None,
            "flag": "comparability record incomplete: " + ", ".join(missing),
        }

    index_key = index.strip().lower()
    reasons = []
    if index_key in ROBUST_SENSITIVE and _robust_class(left) != _robust_class(right):
        reasons.append(
            "plain maximum likelihood against a robust "
            f"{index_key}"
        )
    if index_key in VARIABLE_SENSITIVE and left["variable_set"] != right["variable_set"]:
        reasons.append(
            "different observed-variable sets "
            f"({left['variable_set']} against {right['variable_set']})"
        )
    if left["normalizer"] != right["normalizer"] and index_key in ("chisq", "chi-square", "aic"):
        reasons.append(
            f"N against N-1 ({left['normalizer']} against {right['normalizer']})"
        )
    if reasons:
        return {
            "verdict_allowed": False,
            "numerical": None,
            "flag": "; ".join(reasons),
        }
    return {"verdict_allowed": True, "numerical": None, "flag": None}


def scaled_chi_square_difference(t0, df0, c0, t1, df1, c1) -> dict:
    """Documented Satorra-Bentler difference, and the other expression.

    `t0` and `t1` are scaled chi-squares. `c0` and `c1` are the scaling
    corrections for which `t * c` is the normal-theory chi-square.
    The nested model is the first argument.
    """
    t0, df0, c0 = _decimal(t0), _decimal(df0), _decimal(c0)
    t1, df1, c1 = _decimal(t1), _decimal(df1), _decimal(c1)
    df = df0 - df1
    if df == 0:
        raise ValueError("the models have the same degrees of freedom")
    cd = (df0 * c0 - df1 * c1) / df
    documented = (t0 * c0 - t1 * c1) / cd
    arithmetic_recovery = (t0 - t1) / cd
    return {
        "cd": cd,
        "df": df,
        "documented": documented,
        "arithmetic_recovery": arithmetic_recovery,
        "source": MPLUS_DIFFERENCE_URL,
        "procedure": SB2001,
        "t_definition": (
            "T is the scaled chi-square. c is the scaling correction. "
            "The documented numerator is T*c, the normal-theory chi-square."
        ),
    }


def procedure_comparison(printed, result: dict, decimals: int) -> dict:
    """Judge the printed value against the documented statistic only.

    A match of `arithmetic_recovery` is reported and is not a match of
    the procedure.
    """
    documented = numerical_verdict(printed, result["documented"], decimals)
    recovered = numerical_verdict(printed, result["arithmetic_recovery"], decimals)
    return {
        "procedure_numerical": documented,
        "arithmetic_recovery_numerical": recovered,
        "procedure_validated": documented == "match",
        "df": result["df"],
        "documented": result["documented"],
        "arithmetic_recovery": result["arithmetic_recovery"],
    }


def validate_ledger(rows: list) -> list:
    """Return a list of problems. An empty list means the ledger is usable."""
    problems = []
    if not rows:
        problems.append("ledger is empty")
        return problems
    for i, row in enumerate(rows):
        status = row.get("status")
        if status not in LEDGER_STATUS:
            problems.append(f"row {i}: status must be one of {LEDGER_STATUS}")
            continue
        if not str(row.get("requirement", "")).strip():
            problems.append(f"row {i}: requirement is blank")
        if not str(row.get("evidence", "")).strip():
            problems.append(f"row {i}: evidence is blank")
        if status == "departed" and not str(row.get("justification", "")).strip():
            problems.append(f"row {i}: a departure needs a justification")
    return problems


def _show(value: Decimal) -> str:
    text = format(value, "f")
    if "." in text:
        text = text.rstrip("0").rstrip(".")
    return text


def main() -> None:
    fixture = Path(__file__).resolve().parents[1] / "fixtures" / "abbott_regression.json"
    data = json.loads(fixture.read_text())
    pair = data["scaled_difference"]["initial_versus_refined"]
    result = scaled_chi_square_difference(
        pair["t0"], pair["df0"], pair["c0"], pair["t1"], pair["df1"], pair["c1"]
    )
    judged = procedure_comparison(pair["printed"], result, pair["decimals"])
    rounding = data["rounding_match"]
    axes = two_axis(
        rounding["published"], rounding["ours"], rounding["decimals"], rounding["scope"]
    )
    blocked = data["incomparable"][0]
    flag = comparability(blocked["left"], blocked["right"], blocked["index"])
    print("numerical", json.dumps(axes))
    print("documented_difference", _show(result["documented"]))
    print("arithmetic_recovery", _show(result["arithmetic_recovery"]))
    print("procedure_validated", judged["procedure_validated"])
    print("incomparable_flag", flag["flag"])
    print("incomparable_numerical", flag["numerical"])


if __name__ == "__main__":
    main()
