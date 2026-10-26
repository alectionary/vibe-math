"""Complete the first-pass catalog with cyclic two-torsion collisions.

Preserves first-pass outputs; creates separately named completed catalogs.
"""
import gzip,json
from pathlib import Path
from itertools import combinations
from collections import Counter
import integer_patterns as ip

R=Path(__file__).resolve().parent
for weight,gen in [(7,ip.pattern7),(10,ip.pattern10),(11,ip.pattern11)]:
    counts=Counter();left=[]
    with gzip.open(R/f'integer-patterns-{weight}.jsonl.gz','rt') as src, gzip.open(R/f'completed-patterns-{weight}.jsonl.gz','wt') as dst:
        for expected,(line,(_,vs,edges)) in enumerate(zip(src,gen())):
            rec=json.loads(line);assert rec['id']==expected
            rows,_,_=ip.constraints(vs,edges)
            if rec['certificate']['kind']=='unclassified':
                cert,_=ip.decompose(rows)
                for a,b in combinations(range(4),2):
                    fs=[ip.scale(2,ip.plus(ip.entry(i,a),ip.entry(i,b),-1)) for i in (1,2)]
                    cs=[cert(f) for f in fs]
                    if all(c is not None for c in cs):
                        rec['certificate']={'kind':'column_two_torsion','locator':[a,b],'forms':fs,'coefficients':cs};break
            for f,c in zip(rec['certificate'].get('forms',[]),rec['certificate'].get('coefficients',[])):
                assert tuple(sum(c[i]*rows[i][j] for i in range(len(rows))) for j in range(6))==tuple(f)
            kind=rec['certificate']['kind'];counts[kind]+=1
            if kind=='unclassified':left.append(rec)
            dst.write(json.dumps(rec,separators=(',',':'))+'\n')
    report={'weight':weight,'patterns':sum(counts.values()),'counts':dict(counts),'unclassified':left}
    (R/f'completed-patterns-{weight}-summary.json').write_text(json.dumps(report,indent=2)+'\n')
    print(json.dumps({'weight':weight,'patterns':sum(counts.values()),'counts':dict(counts)}),flush=True)
