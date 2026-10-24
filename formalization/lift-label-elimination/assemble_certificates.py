"""Assemble unchanged generated certificates in batches to share Lean import costs.
The component files are retained as literal generator output under certificates/;
only the assembled root modules are imported and built by verify_lean.py.
"""
from pathlib import Path
import re,json,hashlib
P=Path(__file__).resolve().parent
C=P/'certificates';C.mkdir(exist_ok=True)
groups={'StarCertificates':[],'JointCertificates':['NFDualRaw1','NFJointRaw1','ConnectJointFirst','ConnectJointDual','ConnectJointBoth']}
for scope in ['Raw','Gauge']:
 for mask in [0,1]:groups['StarCertificates'] += [f'NFStar{scope}{mask}',f'ConnectStar{scope}{mask}']
 for group in range(4):
  name=f'Triangle{scope}Certificates{group}'
  groups[name]=[f'{prefix}Triangle{scope}{mask}' for mask in range(group*8,group*8+8) for prefix in ['NF','Connect']]
owner={n:g for g,ns in groups.items() for n in ns}
assert len(owner)==141
for n in owner:
 src=P/(n+'.lean');dst=C/src.name
 if src.exists():dst.write_bytes(src.read_bytes())
 assert dst.exists(),dst
assembly=[]
for group,names in groups.items():
 imports=[];bodies=[];components=[]
 for n in names:
  src=C/(n+'.lean');body=src.read_text();components.append(dict(namespace=n,path='certificates/'+src.name,sha256=hashlib.sha256(src.read_bytes()).hexdigest()))
  for imp in re.findall(r'^import\s+(\S+)',body,re.M):
   imp=owner.get(imp,imp)
   if imp!=group and imp not in imports:imports.append(imp)
  bodies.append(re.sub(r'^import\s+\S+\n','',body,flags=re.M).strip())
 out='\n'.join('import '+n for n in imports)+'\n\n'
 out+='\n\n'.join(bodies)+'\n'
 (P/(group+'.lean')).write_text(out)
 assembly.append(dict(module=group,components=components,source_sha256=hashlib.sha256(out.encode()).hexdigest()))
for p in P.glob('*.lean'):
 if p.stem in owner:continue
 s=p.read_text()
 s=re.sub(r'^import\s+(\S+)$',lambda m:'import '+owner.get(m[1],m[1]),s,flags=re.M)
 seen=set();lines=[]
 for line in s.splitlines():
  if line.startswith('import '):
   if line in seen:continue
   seen.add(line)
  lines.append(line)
 p.write_text('\n'.join(lines)+'\n')
for n in owner:(P/(n+'.lean')).unlink(missing_ok=True)
(P/'certificate-assembly.json').write_text(json.dumps(dict(component_count=len(owner),assembled_module_count=len(groups),modules=assembly),indent=2)+'\n')
for filename in ['normal-form-index.json','joint-normal-form-index.json']:
 p=P/filename;data=json.loads(p.read_text())
 assert isinstance(data,list),filename
 for r in data:
  if r['module'] in owner:r['source_module']=owner[r['module']];r['namespace']=r['module']
 p.write_text(json.dumps(data,indent=2)+'\n')
print('Assembled',len(owner),'unchanged components into',len(groups),'modules.')
