"""Replace the six unresolved weight10 cases by classical weight<=10 certificates."""
import gzip,json
from pathlib import Path
from collections import Counter
import integer_patterns as ip
R=Path(__file__).resolve().parent
counts=Counter()
with gzip.open(R/'completed-patterns-10.jsonl.gz','rt') as src,gzip.open(R/'final-patterns-10.jsonl.gz','wt') as dst:
    for idx,(line,(_,vs,edges)) in enumerate(zip(src,ip.pattern10())):
        rec=json.loads(line);assert rec['id']==idx
        if rec['certificate']['kind']=='unclassified':
            rows,_,_=ip.constraints(vs,edges);cert,_=ip.decompose(rows)
            for c in range(1,4):
                fs=[ip.scale(5,ip.entry(i,c)) for i in (1,2)];cs=[cert(f) for f in fs]
                if all(x is not None for x in cs):
                    rec['certificate']={'kind':'classical_weight_le10','locator':[0,c],'forms':fs,'coefficients':cs};break
            assert rec['certificate']['kind']=='classical_weight_le10',rec
        counts[rec['certificate']['kind']]+=1
        dst.write(json.dumps(rec,separators=(',',':'))+'\n')
(R/'final-patterns-10-summary.json').write_text(json.dumps({'patterns':sum(counts.values()),'counts':dict(counts)},indent=2)+'\n')
print(json.dumps(dict(counts)))
