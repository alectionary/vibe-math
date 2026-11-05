#!/usr/bin/env python3
"""Join our Monte Carlo summaries to every printed Appendix C-F cell.

A cell matches when half-up rounding to the printed decimals equals the
published entry. It is close when that fails but the unrounded gap is at most
one unit in the last printed place (0.001, or 0.0001 for mean square error).
A larger gap is a mismatch. Cells with no finished replications are not run.
"""

import csv
import glob
import math
import os
from collections import defaultdict
from decimal import Decimal, ROUND_HALF_UP

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SIM = os.path.dirname(os.path.abspath(__file__))
PUBLISHED = os.path.join(SIM, "results", "published_cells.csv")
OUT = os.path.join(SIM, "results", "cell_match.csv")
SUMMARY = os.path.join(SIM, "results", "match_summary.csv")

RI_EST = ["us.ics", "um.ccs", "ws.ics", "wtm.ccs", "wam.ccs"]
RC_EST = ["us.ics", "um.ccs", "um.ics", "ws.ics", "wtm.ccs", "wtm.ics", "wam.ccs", "wam.ics"]
PARAMS = {"RI": ["g00", "g01", "g10"], "RC": ["g00", "g01", "g10", "g11"]}
SINGLE = {"us.ics", "ws.ics"}


def fnum(x):
    try:
        v = float(x)
    except (TypeError, ValueError):
        return float("nan")
    return v


def load_published():
    with open(PUBLISHED, newline="") as f:
        return list(csv.DictReader(f))


def add_rep(bucket, rec):
    bucket.append(rec)


def load_reps():
    reps = []
    # Gaussian random intercept, already finished at 1,000 requested replications.
    for path in sorted(glob.glob(os.path.join(SIM, "results", "cell_0*.csv"))):
        with open(path, newline="") as f:
            for r in csv.DictReader(f):
                reps.append(dict(
                    model="RI", outcome="normal", design=r["design"],
                    icc=fnum(r["icc"]), nj=int(float(r["nj"])),
                    estimator=r["estimator"], rep=int(float(r["rep"])),
                    g00=fnum(r["g00"]), g10=fnum(r["g10"]), g01=fnum(r["g01"]), g11=float("nan"),
                    se00=fnum(r["se00"]), se10=fnum(r["se10"]), se01=fnum(r["se01"]), se11=float("nan"),
                    tau=fnum(r.get("tau", "nan")), rmse=fnum(r["rmse"]),
                    converged=str(r["converged"]).lower() == "true",
                    t00=fnum(r["target_g00"]), t10=fnum(r["target_g10"]),
                    t01=fnum(r["target_g01"]), t11=float("nan"),
                    pa00=fnum(r["target_g00"]), pa10=fnum(r["target_g10"]),
                    pa01=fnum(r["target_g01"]), pa11=float("nan"),
                ))
    for path in glob.glob(os.path.join(SIM, "results", "grid", "*", "*.csv")):
        with open(path, newline="") as f:
            try:
                parsed = list(csv.DictReader(f))
            except Exception:
                continue
            for r in parsed:
                if "model" not in r or "rep" not in r or "estimator" not in r:
                    continue
                reps.append(dict(
                    model=r["model"], outcome=r["outcome"], design=r["design"],
                    icc=fnum(r["icc"]), nj=int(float(r["nj"])),
                    estimator=r["estimator"], rep=int(float(r["rep"])),
                    g00=fnum(r["g00"]), g10=fnum(r["g10"]), g01=fnum(r["g01"]), g11=fnum(r.get("g11", "nan")),
                    se00=fnum(r["se00"]), se10=fnum(r["se10"]), se01=fnum(r["se01"]), se11=fnum(r.get("se11", "nan")),
                    tau=fnum(r.get("tau", "nan")), rmse=fnum(r["rmse"]),
                    converged=str(r["converged"]).lower() == "true",
                    t00=fnum(r["t00"]), t10=fnum(r["t10"]), t01=fnum(r["t01"]), t11=fnum(r.get("t11", "nan")),
                    pa00=fnum(r.get("pa00", r["t00"])), pa10=fnum(r.get("pa10", r["t10"])),
                    pa01=fnum(r.get("pa01", r["t01"])), pa11=fnum(r.get("pa11", r.get("t11", "nan"))),
                ))
    return reps


def cell_key(r):
    return (r["model"], r["outcome"], r["design"], round(r["icc"], 2), int(r["nj"]))


def kept_reps(reps):
    """Keep a replication for an estimator when its point estimate is finite.

    A missing standard error drops that replication from coverage only. The
    Gaussian incorrect-covariance fits that stopped on the old tolerance still
    have the settled point estimate, so those replicates stay in the bias.
    """
    return [r for r in reps if math.isfinite(r["g00"])]


def round_half_up(x, nd):
    q = Decimal("1").scaleb(-nd)
    return float(Decimal(str(x)).quantize(q, rounding=ROUND_HALF_UP))


def label_for(ours, published, nd):
    if ours is None or not math.isfinite(ours):
        return "not_computed"
    unit = 10 ** (-nd)
    try:
        rounded = round_half_up(ours, nd)
    except Exception:
        return "not_computed"
    if abs(rounded - published) <= 10 ** (-(nd + 3)):
        return "match"
    if abs(ours - published) <= unit + 1e-12:
        return "close"
    return "mismatch"


def target_of(sample, parameter, scale, estimator):
    use_pa = scale == "marginal" or (sample["outcome"] == "bernoulli" and estimator in SINGLE)
    prefix = "pa" if use_pa else "t"
    return sample[prefix + parameter[1:]]


def estimate_of(sample, parameter, scale):
    est = sample[parameter]
    if scale == "marginal":
        tau = sample["tau"]
        if not math.isfinite(tau):
            return float("nan")
        return est / math.sqrt(1.0 + tau)
    return est


def summarize(rows):
    """rows: one estimator, one cell, kept replications."""
    return rows


def mc_mean(xs):
    n = len(xs)
    if n == 0:
        return float("nan"), float("nan"), 0
    m = sum(xs) / n
    if n == 1:
        return m, float("nan"), n
    var = sum((x - m) ** 2 for x in xs) / (n - 1)
    return m, math.sqrt(var / n), n


def main():
    published = load_published()
    raw = load_reps()
    kept = kept_reps(raw)
    groups = defaultdict(list)
    for r in kept:
        groups[(cell_key(r), r["estimator"])].append(r)
    out_rows = []
    for pub in published:
        model = pub["model"]
        outcome = pub["outcome"]
        design = pub["design"]
        icc = round(float(pub["icc"]), 2)
        nj = int(float(pub["nj"]))
        est = pub["estimator"]
        parameter = pub["parameter"]
        stat = pub["statistic"]
        scale = pub["scale"]
        published_value = float(pub["published"])
        nd = 4 if stat == "mse" else 3
        sample_rows = groups.get(((model, outcome, design, icc, nj), est), [])
        n = len(sample_rows)
        ours = float("nan")
        mc_se = float("nan")
        if n and parameter == "eta" and stat == "rmse" and scale == "cs":
            xs = [r["rmse"] for r in sample_rows if math.isfinite(r["rmse"])]
            ours, mc_se, n = mc_mean(xs)
        elif n and stat in ("bias", "rel_bias", "mse", "coverage") and parameter != "eta":
            vals = []
            covers = []
            sq = []
            for r in sample_rows:
                est_v = estimate_of(r, parameter, scale)
                tgt = target_of(r, parameter, scale, est)
                se = r["se" + parameter[1:]]
                if not math.isfinite(est_v) or not math.isfinite(tgt):
                    continue
                # Marginal targets are population constants; a missing PA target
                # (normal cells) falls back to the cluster-specific value.
                if not math.isfinite(tgt):
                    continue
                vals.append(est_v - tgt)
                sq.append((est_v - tgt) ** 2)
                if math.isfinite(se):
                    covers.append(1.0 if abs(est_v - tgt) <= 1.96 * se else 0.0)
            if stat in ("bias", "rel_bias") and vals:
                bias, se_b, n = mc_mean(vals)
                tgt0 = target_of(sample_rows[0], parameter, scale, est)
                if stat == "bias":
                    ours, mc_se = bias, se_b
                elif math.isfinite(tgt0) and abs(tgt0) > 1e-8:
                    ours = bias / tgt0
                    mc_se = se_b / abs(tgt0) if math.isfinite(se_b) else float("nan")
                else:
                    ours = float("nan")
            elif stat == "mse" and sq:
                ours, mc_se, n = mc_mean(sq)
            elif stat == "coverage" and covers:
                ours, n = sum(covers) / len(covers), len(covers)
                mc_se = math.sqrt(ours * (1 - ours) / n) if n else float("nan")
        if scale == "marginal" and stat == "rmse":
            # Marginal RMSE needs the person-level predictor, which the
            # checkpoint stores only for the cluster-specific linear predictor.
            ours = float("nan")
        verdict = "not_run" if n == 0 else label_for(ours, published_value, nd)
        if n and not math.isfinite(ours):
            verdict = "not_computed"
        gap = ours - published_value if math.isfinite(ours) else float("nan")
        out_rows.append(dict(
            table=pub["table"], metric=pub["metric"], model=model, outcome=outcome,
            design=design, icc=icc, nj=nj, estimator=est, parameter=parameter,
            statistic=stat, scale=scale, published=published_value,
            ours="" if not math.isfinite(ours) else f"{ours:.8g}",
            gap="" if not math.isfinite(gap) else f"{gap:.8g}",
            mc_se="" if not math.isfinite(mc_se) else f"{mc_se:.8g}",
            reps=n, verdict=verdict, page=pub["page"],
        ))
    fields = ["table", "metric", "model", "outcome", "design", "icc", "nj", "estimator",
              "parameter", "statistic", "scale", "published", "ours", "gap", "mc_se",
              "reps", "verdict", "page"]
    with open(OUT, "w", newline="") as f:
        w = csv.DictWriter(f, fieldnames=fields)
        w.writeheader()
        w.writerows(out_rows)
    # Pattern summary on cells that were actually compared.
    compared = [r for r in out_rows if r["verdict"] in ("match", "close", "mismatch")]
    factors = {
        "overall": lambda r: "all",
        "model_outcome": lambda r: f"{r['model']}_{r['outcome']}",
        "outcome": lambda r: r["outcome"],
        "design": lambda r: r["design"],
        "icc": lambda r: str(r["icc"]),
        "nj": lambda r: str(r["nj"]),
        "estimator": lambda r: r["estimator"],
        "statistic": lambda r: r["statistic"],
        "scale": lambda r: r["scale"],
        "table": lambda r: r["table"],
    }
    summary = []
    for factor, fn in factors.items():
        buckets = defaultdict(list)
        for r in compared:
            buckets[fn(r)].append(r)
        for level, rs in sorted(buckets.items()):
            n = len(rs)
            counts = {k: sum(1 for r in rs if r["verdict"] == k) for k in ("match", "close", "mismatch")}
            gaps = [float(r["gap"]) for r in rs if r["gap"] != ""]
            mean_gap = sum(gaps) / len(gaps) if gaps else float("nan")
            summary.append(dict(
                factor=factor, level=level, n=n,
                match=counts["match"], close=counts["close"], mismatch=counts["mismatch"],
                match_rate=f"{counts['match'] / n:.4f}" if n else "",
                match_or_close_rate=f"{(counts['match'] + counts['close']) / n:.4f}" if n else "",
                mean_gap=f"{mean_gap:.6g}" if gaps else "",
            ))
    with open(SUMMARY, "w", newline="") as f:
        w = csv.DictWriter(f, fieldnames=["factor", "level", "n", "match", "close", "mismatch",
                                          "match_rate", "match_or_close_rate", "mean_gap"])
        w.writeheader()
        w.writerows(summary)
    n_all = len(out_rows)
    by = defaultdict(int)
    for r in out_rows:
        by[r["verdict"]] += 1
    print(f"published cells {n_all}")
    for k in ("match", "close", "mismatch", "not_run", "not_computed"):
        print(f"  {k} {by[k]}")
    if compared:
        print(f"compared {len(compared)} match rate {by['match'] / len(compared):.3f} "
              f"match-or-close {(by['match'] + by['close']) / len(compared):.3f}")


if __name__ == "__main__":
    main()
