"""Render actual requirement/status/evidence and dated source rows."""
import json
from pathlib import Path
root=Path(__file__).resolve().parents[1]
def esc(s):
 for a,b in [('\\',r'\textbackslash{}'),('&',r'\&'),('%',r'\%'),('_',r'\_'),('#',r'\#')]:s=s.replace(a,b)
 return s
def table(headers,rows,widths):
 out=[r'\small\begin{longtable}{'+''.join('p{'+str(w)+r'\linewidth}' for w in widths)+'}',r'\toprule '+' & '.join(headers)+r'\\\midrule\endhead']
 for row in rows:out.append(' & '.join(esc(x) for x in row)+r'\\')
 out.append(r'\bottomrule\end{longtable}\normalsize');return '\n'.join(out)+'\n'
a=json.loads((root/'provenance/availability_and_compliance.json').read_text())
rows=[]
for r in a['compliance']:
 rows.append((r['requirement'],r['status'],r.get('justification','')+' '+r['evidence']))
(root/'paper/compliance_table.tex').write_text(table(['Requirement','Status','Evidence or limitation'],rows,[.26,.14,.50]))
rows=[(a['date_utc'],r['source'],r['result']) for r in a['availability']]
(root/'paper/availability_table.tex').write_text(table(['Date (UTC)','Source','Result'],rows,[.15,.25,.50]))
