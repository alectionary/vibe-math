"""Transcribe calibrated Figure 4 line vertices and Figure 5 design counts."""
import csv
import sys
from pathlib import Path

sys.path.insert(0,str(Path(__file__).resolve().parents[3]/".agents/skills/replication-paper/scripts"))
from digitize import Axis

out = Path(sys.argv[1])
# Figure 4: 2x rendering of PDF page 72 cropped to [106,100,546,308] pt.
# Calibrate the y-axis with all six readable labelled tick marks.
axis = Axis.from_references(list(zip((347,320,293,266,239,212,186,159,132,105,78),
                                   (.76,.77,.78,.79,.80,.81,.82,.83,.84,.85,.86))))
with (out/"figure-4.csv").open("w",newline="") as f:
    w=csv.writer(f)
    w.writerow(["panel","n","power","reading_error","pixel_y"])
    for panel, ys in ((1,[266,202,197,143,213,181,154,159,164,127,100]),
                      (2,[261,314,294,267,239,266,196,276,196,175,158])):
        for n,y in enumerate(ys,71):
            w.writerow([panel,n,f"{axis.value(y):.6f}",f"{axis.error(2):.6f}",y])
with (out/"figure-5.csv").open("w",newline="") as f:
    w=csv.writer(f)
    w.writerow(["icc","interval_attrition_pct","treatment_target","cluster_size","od_clusters","planned_adjusted_clusters"])
    for icc,base,adjusted in [(.05,16,[16,18,23]),(.10,22,[22,25,32]),(.15,28,[28,32,41])]:
        for a,j in zip((0,5,15),adjusted,strict=True):
            for allocation in (.5,.7):
                for size in ("equal","normal","skewed"):
                    w.writerow([icc,a,allocation,size,base,j])
