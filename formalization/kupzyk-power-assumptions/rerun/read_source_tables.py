"""Extract published numerical table cells from Poppler's layout text."""
import csv
import re
import sys
from pathlib import Path

src, out = map(Path, sys.argv[1:])
out.mkdir(parents=True, exist_ok=True)
pages = src.read_text().split("\f")

def table(page, label):
    text = pages[page-1]
    start = re.search(r"(?m)^Table " + re.escape(label) + r"\.", text).end()
    return re.split(r"\nTable (?:[A-Z]\.)?\d", text[start:])[0]

def save(name, header, rows):
    with (out / f"table-{name}.csv").open("w",newline="") as f:
        w = csv.writer(f,lineterminator="\n")
        w.writerow(header)
        w.writerows(rows)

for num, page, labels, regex in (
    (1,102,[(i,a) for i in (.05,.10,.15) for a in (0,5,15)],r"(?<!\d)\.\d{5}\b"),
    (2,103,[(a,) for a in ("0","5","15","0 minus 5","0 minus 15")],r"\b0\.\d{5}\b"),
    (3,104,[(15,),(45,)],r"(?<!\d)\.\d{5}\b"),
    (4,106,[(i,) for i in (.05,.10,.15)],r"\b\d\.\d(?=%)"),
    (5,107,[(i,a) for i in (.05,.10,.15) for a in (0,5,15)],r"\(\d+\)|(?<![.\d])\b\d{2}\b(?!%)"),
):
    rows = []
    width = {1:6,2:6,3:3,4:5,5:7}[num]
    for line in table(page,str(num)).splitlines():
        values = re.findall(regex,line)
        if len(values)==width and (num!=5 or values[0].startswith("(")):
            rows.append([x.strip("()") for x in values])
    assert len(rows)==len(labels),(num,rows)
    six = [f"{allocation}_{sizes}" for allocation in ("balanced","unbalanced")
           for sizes in ("equal","normal","skewed")]
    header = {1:["icc","attrition_pct",*six],2:["contrast",*six],
              3:["final_attrition_pct","icc05","icc10","icc15"],
              4:["icc","attrition5_pp","attrition10_as_printed_pp","allocation70_pp","normal_pp","skewed_pp"],
              5:["icc","attrition_pct","bw_reference",*six]}[num]
    save(num, header, [a+tuple(b) for a,b in zip(labels,rows,strict=True)])

for i in range(1,7):
    label=f"C.{i}"
    pairs=re.findall(r"(?<!\d)(\d\.\d{4})\s+\((\d\.\d+)\)",table(140+(i-1)//2,label))
    assert len(pairs)==54, (label,len(pairs))
    save(label, ["cell","estimated_mean","population"],[(j,*p) for j,p in enumerate(pairs,1)])

for i in (1,2):
    label=f"D.{i}"
    rows=[]
    for line in table(143,label).splitlines():
        vals=re.match(r"^\s+(.+?)\s+(0\.\d{5})\s+([‐-]?0\.\d{4})\s+\((\.\d{5}),\s*(\.\d{5})\)\s+(.+?)\s{2,}(ok)\s+(0\.\d{5})\s*$",line)
        if vals:
            rows.append(tuple(x.replace("‐","-") for x in vals.groups()))
    assert len(rows)==5,(label,rows)
    save(label,["method","type_i_error","point05_minus_error","ci_low","ci_high",
                "ci_verdict","bradley","power"],rows)
