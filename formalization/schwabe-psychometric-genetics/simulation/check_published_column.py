"""Study-specific source-attribution guard; semantic fidelity needs source review."""
import json
from pathlib import Path
import re
import math
import unicodedata
import fitz
ROOT=Path(__file__).resolve().parents[1]
def norm(s):
 s=unicodedata.normalize('NFKC',s).replace('\u2212','-')
 return re.sub(r'\s+',' ',re.sub(r'-\s+','-',s)).strip().lower()
def check_source_text(text):
 if not text.strip():raise ValueError('Missing source statement')
 if re.search(r'\b(not established|not replicated|blocked|unresolved)\b',norm(text)):
  raise ValueError('Replication verdict incorrectly placed in Published cell')
def validate_boxes(published,ours,row,table):
 for box in (published,ours,row,table):
  assert all(math.isfinite(x) for x in box) and not box.is_empty, "Invalid rectangle"
 assert table.contains(row) and row.contains(published) and row.contains(ours), "Source/Ours outside mapped row/table"
 assert published.x1<=ours.x0 and not published.intersects(ours), "Source/Ours order or overlap"
def check(pdf,manifest,packet):
 rows=manifest['first_page']['table']['rows'];effects={e['id']:e for e in packet['headline_effects']}
 assert len(rows)==28 and {r['effect_id'] for r in rows}==set(effects)
 d=fitz.open(pdf);page=d[0];out=[]
 for row in rows:
  ident=row['effect_id'];expected=row['published_text'];check_source_text(expected)
  box=fitz.Rect(row['published_bbox']);ours=fitz.Rect(row['ours_bbox'])
  validate_boxes(box,ours,fitz.Rect(row['bbox']),fitz.Rect(manifest['first_page']['table']['bbox']))
  actual=page.get_textbox(box);check_source_text(actual)
  assert norm(expected)==norm(actual),(ident,expected,actual)
  assert norm(row['ours_text'])==norm(page.get_textbox(ours)),(ident,'Ours mapping mismatch')
  if effects[ident].get('published_effect') is None:
   assert effects[ident].get('published_statement'),(ident,'Known source statement missing from packet')
  out.append({'effect_id':ident,'published':actual,'ours':page.get_textbox(ours)})
 return {'first_page_rows_verified':len(out),'rows':out,'scope':'Rendered/source-ledger separation only. Independent review must verify concise source paraphrases against the dissertation.','reusable_skill_modified':False}
if __name__=='__main__':
 m=json.loads((ROOT/'handoff/a0-writer-manifest.json').read_text());p=json.loads((ROOT/'handoff/a0-evidence-packet.json').read_text())
 print(json.dumps(check(ROOT/'paper/a0-main.pdf',m,p),indent=2))
