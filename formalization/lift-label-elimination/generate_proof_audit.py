"""Generate an axiom query for every named authored declaration, not just headlines."""
from pathlib import Path
import json,re,hashlib
P=Path(__file__).resolve().parent
files=sorted(p for p in P.glob('*.lean') if p.name!='AuditAll.lean')
rows=[]
for p in files:
 s=p.read_text();namespace=None;count=0
 for line in s.splitlines():
  n=re.match(r'^namespace\s+(\S+)',line)
  if n:
   assert namespace is None,(p,line)
   namespace=n[1]
  if namespace and line.strip()=='end '+namespace:namespace=None
  d=re.match(r'^(?:(?:noncomputable|protected)\s+)?(theorem|lemma|def|abbrev)\s+([^\s({:\[]+)',line)
  if d:
   assert namespace,(p,line)
   rows.append(dict(module=p.stem,kind=d[1],name=namespace+'.'+d[2],source_sha256=hashlib.sha256(p.read_bytes()).hexdigest()));count+=1
 assert count,p
body='\n'.join('import '+p.stem for p in files)+'\n\n'
body+='\n'.join('#print axioms '+r['name'] for r in rows)+'\n'
(P/'AuditAll.lean').write_text(body)
(P/'authored-declarations.json').write_text(json.dumps(dict(module_count=len(files),declaration_count=len(rows),declarations=rows),indent=2)+'\n')
print('Audit generated:',len(files),'modules,',len(rows),'named declarations.')
