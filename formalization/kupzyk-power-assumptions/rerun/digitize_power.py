"""Recover plotted power from markers, without imputing hidden series."""
import csv
import sys
from pathlib import Path

sys.path.insert(0,str(Path(__file__).resolve().parents[3]/".agents/skills/replication-paper/scripts"))
from digitize import Axis, vector_markers

pdf, out = sys.argv[1:]
panels = [
    # Figure, page, ICC, high and low border y, six marker columns.
    (6,97,.05,81.57,261.48,[166,211,256,314,362,410]),
    (7,98,.10,81.63,253.65,[164.5,209.6,254,312.1,358.6,405.1]),
    (8,98,.15,423.57,592.38,[165.2,210.1,255.1,313.6,360.6,406.9]),
    (9,100,.05,441.45,634.77,[170.8,221.5,272.1,338.2,391.2,444.1]),
    (10,101,.10,165.36,351.87,[176.6,226.2,275.8,340.5,393.1,445.8]),
    (11,102,.15,82.8,273.57,[173.9,224.7,275.5,341.7,395.6,449.5]),
]
with open(out,"w",newline="") as f:
    writer=csv.writer(f,lineterminator="\n")
    writer.writerow(["figure","pdf_page","icc","allocation","size","method","attrition_pct",
                     "power","reading_error","x","y","read"])
    for fig,page,icc,top,bottom,cols in panels:
        final=fig>=9
        axis=Axis.from_references([(top,.82 if final else .91),(bottom,.65 if final else .69)])
        source=vector_markers(pdf,page)
        for col,x in enumerate(cols):
            markers=[m for m in source if abs(m["x"]-x)<1.2 and top<m["y"]<bottom
                     and 3<m["width"]<7.5 and 3<m["height"]<7.5 and max(m["fill"])<.1]
            solid={0:1,5:6,15:4}
            for method in (["exemplary"] if final else ["empirical","exemplary"]):
                for a in (0,5,15):
                    is_solid=final or method=="empirical"
                    if is_solid:
                        candidates=[m for m in markers if m["items"]==solid[a]]
                    else:
                        # Filled markers have their own outline drawn at the same position;
                        # remove these outlines instead of assigning them to the open series.
                        outline={0:lambda n:n==15,5:lambda n:n in (27,28),15:lambda n:n>100}
                        candidates=[m for m in markers if outline[a](m["items"]) and
                                    not any(s["items"]==solid[a] and abs(s["y"]-m["y"])<.25
                                            for s in markers)]
                    row=[fig,page,icc,.5 if col<3 else .7,("equal","normal","skewed")[col%3],method,a]
                    if len(candidates)==1:
                        m=candidates[0]
                        # Allow for vector chart coordinate quantization and triangle centering.
                        writer.writerow(row+[f'{axis.value(m["y"]):.6f}',
                                             f'{axis.error(1.8 if a==5 else 1.25):.6f}',m["x"],m["y"],"direct"])
                    else:
                        writer.writerow(row+["","","","","occluded or ambiguous"])
