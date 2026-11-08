#!/usr/bin/env python3
"""Recompute the printed differences and standardized biases (SB) in Chen (2021) Tables 4.6-4.7
from the printed RCT and RDD estimates. Equation 3.12 defines SB = (RDD - RCT) / sigma_RCT with
sigma_RCT 'the standard deviation of the RCT outcome'. We test two readings of the divisor:
(i) the printed RCT standard error / SD of the estimate (in parentheses), and
(ii) recovery of an implied divisor = (RDD - RCT) / SB_printed.
MSE is not recomputable from printed numbers (it averages over bootstrap draws)."""
import csv, json, sys
# (effect, RCT est, RCT SE, cut, RDD est, printed difference, printed SB)
T46 = [('a', 2.066, .733, 1, 1.301, .765, -1.044), ('a', 2.066, .733, 2, 1.112, .954, -1.302), ('a', 2.066, .733, 3, 1.135, .931, -1.270),
       ('b', .033, .010, 1, .022, .011, -1.100), ('b', .033, .010, 2, .030, .003, -.300), ('b', .033, .010, 3, .056, -.023, 2.300),
       ("c'", -.268, .312, 1, -1.025, .757, -2.426), ("c'", -.268, .312, 2, -1.037, .769, -2.465), ("c'", -.268, .312, 3, .931, -1.199, 3.843),
       ('h', .003, .012, 1, .001, .002, -.167), ('h', .003, .012, 2, .001, .002, -.167), ('h', .003, .012, 3, -.028, .031, -2.583)]
T47 = [('PNIE', .069, .035, 1, .028, .041, -1.171), ('PNIE', .069, .035, 2, .034, .035, -1.000), ('PNIE', .069, .035, 3, .064, .005, -.143),
       ('TNIE', .075, .030, 1, .030, .045, -1.500), ('TNIE', .075, .030, 2, .035, .040, -1.333), ('TNIE', .075, .030, 3, .032, .043, -1.433),
       ('PNDE', -.209, .193, 1, -.998, .789, -4.088), ('PNDE', -.209, .193, 2, -1.021, .812, -4.207), ('PNDE', -.209, .193, 3, .312, -.521, 2.699),
       ('TNDE', -.204, .195, 1, -.996, .792, -4.062), ('TNDE', -.204, .195, 2, -1.020, .816, -4.185), ('TNDE', -.204, .195, 3, .280, -.484, 2.482)]
rows = []
for table, data in (('4.6', T46), ('4.7', T47)):
    for eff, rct, se, cut, rdd, diff, sb in data:
        d = round(rct - rdd, 3)
        sb_se = (rdd - rct) / se
        rows.append(dict(table=table, effect=eff, cut=cut, rct=rct, rct_se=se, rdd=rdd, printed_difference=diff,
                         recomputed_difference_rct_minus_rdd=d, difference_matches=abs(d - diff) < 0.0015,
                         printed_sb=sb, sb_with_rct_se=round(sb_se, 3), sb_matches_rct_se=abs(sb_se - sb) < 0.006,
                         implied_divisor=round((rdd - rct) / sb, 4) if sb else None))
w = csv.DictWriter(open('table_arithmetic.csv', 'w', newline=''), fieldnames=list(rows[0]))
w.writeheader(); w.writerows(rows)
print(json.dumps(dict(rows=len(rows), difference_matches=sum(r['difference_matches'] for r in rows),
                      sb_matches_using_rct_se=sum(r['sb_matches_rct_se'] for r in rows)), indent=1))
for r in rows:
    if not (r['difference_matches'] and r['sb_matches_rct_se']):
        print('MISMATCH', r)
