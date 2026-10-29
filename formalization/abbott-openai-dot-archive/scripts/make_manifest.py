#!/usr/bin/env python3
"""Create final file hashes and line-index traceability; no network access."""
from pathlib import Path
import ast,hashlib,json,platform
ROOT=Path(__file__).resolve().parents[1]
def main():
 functions=[]
 for path in sorted((ROOT/'scripts').glob('*.py')):
  tree=ast.parse(path.read_text())
  for node in ast.walk(tree):
   if isinstance(node,(ast.FunctionDef,ast.AsyncFunctionDef,ast.ClassDef)):
    functions.append({'file':str(path.relative_to(ROOT)),'name':node.name,'kind':type(node).__name__,'start_line':node.lineno,'end_line':node.end_lineno})
 (ROOT/'outputs/function_index.json').write_text(json.dumps(functions,indent=2)+'\n')
 rows=[]
 for p in sorted(ROOT.rglob('*')):
  if not p.is_file() or '__pycache__' in p.parts or p.suffix=='.pyc' or 'report_qa' in p.parts or 'report_render' in p.parts or p.name=='file_manifest.json':continue
  rows.append({'path':str(p.relative_to(ROOT)),'bytes':p.stat().st_size,'sha256':hashlib.sha256(p.read_bytes()).hexdigest()})
 (ROOT/'outputs/file_manifest.json').write_text(json.dumps({'algorithm':'sha256','scope':'All bundle files except this manifest, Python bytecode, and PDF QA page renders','files':rows},indent=2)+'\n')
 print('Hashed',len(rows),'files; indexed',len(functions),'functions/classes')
if __name__=='__main__':main()
