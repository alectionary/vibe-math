"""User-authorized study-specific numerical-opening contract, not a reusable skill edit."""
import importlib.util,json,re,math,unicodedata
from pathlib import Path
from decimal import Decimal,ROUND_HALF_UP
import fitz
REF=Path(__file__).resolve().parents[1]/'handoff/numerical-validation-reference'
spec=importlib.util.spec_from_file_location('schwabe_stage_reference',REF/'stage_checks.py');st=importlib.util.module_from_spec(spec);spec.loader.exec_module(st)

def stage_errors(record,root):
 root=Path(root);errors=[]
 if record.get('contract_version')!=2:errors.append('delivery contract_version2 required')
 for name in ['packet','writer_manifest','study_contract']:
  errors+=st.artifact_errors(record.get(name),root,name)
 if errors:return errors
 packet=json.loads((root/record['packet']['path']).read_text());w=json.loads((root/record['writer_manifest']['path']).read_text())
 errors+=st.packet_errors(packet,root)
 if not st.text(w.get('writer')) or w.get('context')!='continuing_revision':errors.append('Disclosed continuing writer revision required')
 if not w.get('revision_lineage'):errors.append('Original isolated writer lineage required')
 if w.get('packet_sha256')!=record['packet']['sha256']:errors.append('Writer packet hash stale')
 for item in w.get('inputs',[]):errors+=st.artifact_errors(item,root,'writer input')
 for name in ['packet','template','study_contract']:
  item=record[name]
  if not any(i.get('path')==item['path'] and i.get('sha256')==item['sha256'] for i in w.get('inputs',[])):errors.append('Writer missing input '+name)
 for field,keys in [('claim_map',{c['id'] for c in packet['claims']}),('limitations_map',{str(i) for i in range(len(packet['limitations']))})]:
  m=w.get(field,{})
  if set(m)!=keys or not all(st.text(v) for v in m.values()):errors.append('Incomplete '+field)
 expected={e['id'] for e in packet['headline_effects']};coverage=w.get('headline_coverage_map',{})
 if set(coverage)!=expected or not all(st.text(v) for v in coverage.values()):errors.append('Full28-effect coverage mapping required outside opening')
 review=record.get('review',{})
 for name in ['packet','writer_manifest']:
  if review.get(name+'_sha256')!=record[name]['sha256']:errors.append('Stale review '+name)
 if review.get('reviewer')==w['writer']:errors.append('Writer cannot independently review own manuscript')
 cues=[]
 for i in record.get('build_inputs',[]):
  p=root/i['path']
  if p.suffix.lower() in ('.tex','.txt','.md','.bib','.csv'):cues+=st.phrase_cues(p.read_text(),i['path'])
 errors+=st.editorial_errors(review.get('editorial'),cues)
 return errors

def norm(s):return re.sub(r'\s+',' ',unicodedata.normalize('NFKC',s).replace('−','-')).strip().lower()
def first_number(s):
 m=re.search(r'[-+]?(?:\d+(?:\.\d*)?|\.\d+)(?:[eE][-+]?\d+)?',norm(s))
 if not m:raise ValueError('Numeric estimate missing')
 return Decimal(m.group())
def validate_source_text(s):
 if re.search(r'\b(not established|not estimated|blocked|unresolved|not replicated)\b',norm(s)):raise ValueError('Our status incorrectly placed in Published')
def verify_number(text,value,decimals):
 expected=Decimal(str(value)).quantize(Decimal(1).scaleb(-decimals),rounding=ROUND_HALF_UP)
 if value!=0 and expected==0:raise ValueError('Displayed precision conceals nonzero estimate')
 if first_number(text)!=expected:raise ValueError('Displayed estimate does not equal declared source rounding')
def geometry(row,table):
 boxes=[fitz.Rect(row[k]) for k in ['row_bbox','published_bbox','ours_bbox']];rr,pub,ours=boxes
 if any(b.is_empty or any(not math.isfinite(v) for v in b) for b in boxes):raise ValueError('Invalid cell geometry')
 if not fitz.Rect(table).contains(rr) or not rr.contains(pub) or not rr.contains(ours) or pub.x1>ours.x0:raise ValueError('Source/Ours cell displacement or overlap')
def opening_errors(record,root):
 errors=[];root=Path(root)
 try:
  p=json.loads((root/record['packet']['path']).read_text());w=json.loads((root/record['writer_manifest']['path']).read_text());contract=json.loads((root/record['study_contract']['path']).read_text())
  components={c['id']:c for e in p['headline_effects'] for c in e.get('component_comparisons',[])};claims={c['id']:c for c in p['claims']}
  opening=w['numerical_opening'];rows=opening['rows'];ids=[r['result_id'] for r in rows]
  if ids!=contract['opening_ids']:errors.append('Opening differs from declared8-row presentation selection')
  if opening['page']!=1:errors.append('Numerical opening must be page1')
  cont=w['numerical_continuation'];expected=set(contract['source_only_empirical'])|{c['id'] for c in p['claims'] if c['id'].startswith('C2-3.power.N')}
  if len(cont)!=17 or {r['result_id'] for r in cont}!=expected:errors.append('All5 source slopes and12 power cells required in continuation')
  doc=fitz.open(root/record['primary']['path'])
  for row in rows+cont:
   ident=row['result_id'];page=row.get('page',1);table=row.get('table_bbox',opening['table_bbox']);geometry(row,table)
   source=doc[page-1].get_textbox(fitz.Rect(row['published_bbox']));ours=doc[page-1].get_textbox(fitz.Rect(row['ours_bbox']))
   if norm(source)!=norm(row['published_text']) or norm(ours)!=norm(row['ours_text']):raise ValueError(ident+': cell excerpt mismatch')
   validate_source_text(source)
   if ident in components:a,b=components[ident]['published_effect'],components[ident]['ours_effect']
   else:a,b=claims[ident]['published']['value'],claims[ident]['ours']['value']
   decimals=row['decimals'];da,db=(decimals,decimals) if isinstance(decimals,int) else decimals
   if a is None:raise ValueError(ident+': selected source value is known; do not erase it')
   verify_number(source,a,da)
   if b is None:
    if norm(ours)!='not estimated':raise ValueError(ident+': unavailable matching estimate must say Not estimated')
   else:verify_number(ours,b,db)
  text=norm(doc[0].get_text())
  for term in ['108','72','11','216','not estimated']:
   if term not in text and not (term=='11' and 'eleven' in text):errors.append('Opening lacks full-scope disclosure '+term)
  if not any(x in text for x in ['illustrat','not pooled']):errors.append('Opening must qualify selected examples')
  review=record.get('review',{}).get('numerical_opening',{})
  if review.get('verdict')!='pass' or not review.get('findings'):errors.append('Independent source/numerical-opening semantic review required')
 except (KeyError,ValueError,TypeError,OSError,IndexError) as e:errors.append('Numerical opening: '+str(e))
 return errors
