"""Documentary supplement; extracts existing checked proofs, creates no new theorem."""
from pathlib import Path
import json,os
from xml.sax.saxutils import escape
from reportlab.platypus import Paragraph,PageBreak,Spacer,Table,TableStyle,KeepTogether,Preformatted
from reportlab.lib.styles import ParagraphStyle
from reportlab.lib import colors
from reportlab.pdfbase import pdfmetrics
from reportlab.pdfbase.ttfonts import TTFont

def append_compliance(story,styles,root):
 d=json.loads((Path(root)/'compliance-data.json').read_text())
 fonts=Path(os.environ.get('PAPER_FONT_DIR',str(Path.home()/'.cache/codex-runtimes/codex-primary-runtime/dependencies/native/libreoffice-headless/libreoffice/LibreOfficeDev.app/Contents/Resources/fonts/truetype')))
 pdfmetrics.registerFont(TTFont('ProofMono',str(fonts/'DejaVuSansMono.ttf')))
 small=ParagraphStyle('ComplianceSmall',parent=styles['Small2'],fontSize=8.2,leading=11,spaceAfter=8)
 urlstyle=ParagraphStyle('ComplianceURL',parent=small,fontSize=7.6,leading=10,splitLongWords=True,spaceAfter=4)
 code=ParagraphStyle('ActualLean',fontName='ProofMono',fontSize=7.1,leading=9.6,spaceAfter=12)
 def p(x,st=small):story.append(Paragraph(x,st))
 def h(x):p(x,styles['Heading'])
 story.append(PageBreak());h('Appendix A. Actual checked Lean and dependencies')
 p('This is a documentation revision of an already checked result, not a new research target. The declaration and proof below are extracted verbatim from the committed Lean source. The earlier proof-to-Lean tables identify the individual mathematical claims; Appendix B gives full current and immutable URLs for every research and audit module in this artifact, including inherited dependencies.')
 story.append(Preformatted(d['checked_excerpt'],code,maxLineLength=115))
 h('Dependency guide');p(escape(d['dependency_guide']))
 p('Translation and boundary check: source binary expanded incidence is the real zero-one matrix used for its Gram spectrum, with descending eigenvalues counted with multiplicity; stopping supports are nonempty and permit stabilizer supports. The source roots retain the separate small-size branch. The cover and classification interfaces instead use the actual binary HX2/HZ2 matrices; base-only classification and positive-cover distance are distinct statements. These definitions and bridges, rather than a numerically assumed spectral envelope, carry the translation.')
 p('The imported research modules are included in the published source tree. Only standard mathlib axioms appear in the recorded audits. Source interpretation and prior-art comparisons remain documentary judgments; a successful Lean build alone does not certify those judgments. The only added formal work is the explicitly identified dense-source bridge in the parameter-answer artifact; the earlier universal, family and classification proofs remain unchanged.')
 if d.get('additional_checked_excerpt'):
  story.append(PageBreak());h('Appendix A (continued). Dense source-construction bridge')
  p('Newly checked consumer: the source constituents are length-two support circulants for1+x. The definitions above this theorem in DenseSourceBridge.lean construct actual HX/HZ and bijective coordinate maps. This theorem checks the complete dense example in those coordinates. All20 declarations in the module have a standard-axiom audit; no external numerical result is assumed.')
  story.append(Preformatted(d['additional_checked_excerpt'],code,maxLineLength=115))
 entries=d['paper_lean_files']
 for i,e in enumerate(entries):
  if i%8==0:
   story.append(PageBreak());h('Appendix B. Complete Lean file URLs'+(' (continued)' if i else ''))
   if i==0:p('Every URL is printed in full and is clickable. Current links follow master; immutable links identify the exact checked file at revision '+d['checked_source_commit']+'. Audit programs and vendored dependencies are included rather than hidden behind folder links.')
  block=[Paragraph('<b>'+escape(e['local_path'])+'</b> - '+escape(e['role']),small)]
  for label,key in [('Current','branch_url'),('Immutable','pinned_url')]:
   u=escape(e[key]);block.append(Paragraph(label+': <link href="'+u+'" color="blue">'+u+'</link>',urlstyle))
  block.append(Spacer(1,5));story.append(KeepTogether(block))
 story.append(PageBreak());h('Appendix C. Calendar deltas for all compared sources')
 p(escape(d['chronology_rule']))
 p('This consolidated ledger covers the original parameter result and both follow-ups. Rows explicitly distinguish full-text mathematical comparisons, metadata-only or unavailable papers, discovery provenance, software snapshots and inspected X posts. Rechecking dates did not add a paper or a new full-text question screen. Earlier table dates remain valid; this table supplies the previously missing arithmetic and additional sources.')
 rows=[[Paragraph('<b>Source / role</b>',small),Paragraph('<b>Milestone date and elapsed calendar days</b>',small),Paragraph('<b>Access / precision limit</b>',small)]]
 for s in d['chronology']:
  name='<link href="'+escape(s['url'])+'" color="blue">'+escape(s['id']+': '+s['title'])+'</link><br/>'+escape(s['role'])
  vals=[]
  for m in s['milestones']:
   a,b=m['delta_days_min'],m['delta_days_max'];diff=str(a) if a==b else str(a)+'-'+str(b)
   vals.append(escape(m['label']+': '+m['date']+'; '+diff+' days ('+m['precision']+' precision)'))
  rows.append([Paragraph(name,small),Paragraph('<br/>'.join(vals),small),Paragraph(escape(s['access_status'].replace('_',' ')),small)])
 t=Table(rows,colWidths=[160,235,97],repeatRows=1,hAlign='LEFT');t.setStyle(TableStyle([('BACKGROUND',(0,0),(-1,0),colors.HexColor('#e9eef4')),('VALIGN',(0,0),(-1,-1),'TOP'),('GRID',(0,0),(-1,-1),.3,colors.HexColor('#ccd3dc')),('LEFTPADDING',(0,0),(-1,-1),6),('RIGHTPADDING',(0,0),(-1,-1),6),('TOPPADDING',(0,0),(-1,-1),6),('BOTTOMPADDING',(0,0),(-1,-1),4)]));story.append(t)
 p(escape(d['unresolved_chronology']))
 p('The earliest date in a row means the earliest relevant milestone established by this audit, not a claim of historical priority. Tanner’s manuscript reports an older1982 submission, which is not treated as a verified public1982 publication. Metadata-only and unavailable sources supply no theorem premise and no zero-question screening claim. The X paper-announcement timestamp is16July2026UTC;15July is the arXiv paper date. Source age is distinct from the duration of an unresolved question.')
 p('The clause-by-clause audit and machine-readable date evidence are published at <link href="https://github.com/alectionary/vibe-math/blob/master/formalization/stopping-bound/SKILL-COMPLIANCE-AUDIT.md" color="blue">SKILL-COMPLIANCE-AUDIT.md</link> and <link href="https://github.com/alectionary/vibe-math/blob/master/formalization/stopping-bound/compliance-data.json" color="blue">compliance-data.json</link>. Existing named full-text, citation-index and social-search access gaps remain explicitly unresolved. Neither X posting nor a historical-priority claim is made.')
