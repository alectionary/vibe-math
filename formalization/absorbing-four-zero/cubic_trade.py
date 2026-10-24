"""Exact independent tests of the cubic Pasch trade and its (3,6) QC-GHP lifts."""
from pathlib import Path
import itertools,json,hashlib
import exact_counts as e
P=Path(__file__).resolve().parent
edges=list(itertools.combinations(range(4),2))
attachments=[{i,6+a,6+b} for i,(a,b) in enumerate(edges)]
A=[{i for i,x in enumerate(edges) if v in x} for v in range(4)]+attachments
B=[{i for i,x in enumerate(edges) if v not in x} for v in range(4)]+attachments
gram=lambda cols:[[sum(c in s and d in s for s in cols) for d in range(10)] for c in range(10)]
assert gram(A)==gram(B)
records=[];inputs=[];data=[]
for label,base,expected in [('star',A,1),('triangle',B,5)]:
 assert all(sum(c in s for s in base)==3 for c in range(10))
 e.p.check_graph(base)
 counts,witnesses=e.p.direct_counts(base);collision,cr=e.kernel_collision(base);root,rr=e.root_energy(base);mw,mr=e.walsh_macwilliams(base,10)
 assert counts.get(0,0)==collision==root==mw==expected
 sockets,cols=e.p.qc_ghp(base);rows=e.p.check_graph(cols)[1];assert set(map(len,rows.values()))=={6}
 q,qc=e.kernel_collision(cols);norm,nr=e.root_energy(cols,7,len(sockets));full,fr=e.root_energy(cols)
 assert q==norm==full==7*expected+10*7
 records.append(dict(name=label,base_count=expected,base_supports=witnesses[0],base_gram_equal=True,base_row_degree=3,base_collision=cr,base_root=rr,base_MacWilliams=mr,n=len(cols),checks=len(rows),check_degree=6,N40=q,collision=qc,normalized_root=nr,full_root=fr))
 inputs.append('140 70\n'+'\n'.join(' '.join(map(str,sorted(c))) for c in cols)+'\n')
 data.append(dict(label=label,base=[sorted(c) for c in base],columns=[sorted(c) for c in cols]))
(P/'source140-input.txt').write_text(''.join(inputs));(P/'source140-columns.json').write_text(json.dumps(data,indent=2)+'\n')
out=dict(evidence='exact_finite_computation',construction='Extend the elementary Pasch trade on six points by attaching each old edge label to its two new K4 endpoints.',priority='Explicit construction checked here; no claim that these10_3configurations, Pasch trade, or counts are new.',equal_integer_Gram=True,equal_full_complex_M_by_checked_source_identity=True,records=records,script_sha256=hashlib.sha256(Path(__file__).read_bytes()).hexdigest())
(P/'cubic-trade-counts.json').write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(out),flush=True)
