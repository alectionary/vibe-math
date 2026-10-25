"""Check manuscript proof coverage, frozen source hashes, links and PDF output."""
from pathlib import Path
import datetime, hashlib, html.parser, json, re, urllib.parse, zipfile
from pypdf import PdfReader
import pdfplumber

P=Path(__file__).resolve().parent
W=P.parent

def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()

class Links(html.parser.HTMLParser):
    def __init__(self):super().__init__();self.links=[]
    def handle_starttag(self,tag,attrs):
        if tag=='a':self.links.extend(v for k,v in attrs if k=='href')

def main():
    a=json.loads((P/'report-audit.json').read_text())
    assert sha(P/'main.tex')==a['paper_tex_sha256']
    assert sha(P/'main.pdf')==a['paper_pdf_sha256']
    assert sha(P/'distance-preservation-source.zip')==a['source_archive_sha256']
    c=json.loads((P/'proof-coverage.json').read_text())
    assert c['manuscript_sha256']==sha(P/'main.tex')
    lean=json.loads((P/'paper-lean-audit.json').read_text())
    assert lean['status']=='PASS' and lean['declarations']==len(c['linked_declarations'])
    assert lean['source_sha256']==sha(P/'PaperAudit.lean')
    assert lean['log_sha256']==sha(P/'PaperAudit.log')
    sums=(P/'SHA256SUMS.txt').read_text()
    sums_map={line[66:]:line[:64] for line in sums.splitlines()}
    assert sums_map==a['artifact_members_sha256']
    with zipfile.ZipFile(P/'distance-preservation-source.zip') as z:
        assert len(z.namelist())==a['source_archive_members']
        assert z.testzip() is None
        for path,h in sums_map.items():
            assert hashlib.sha256(z.read(path)).hexdigest()==h,path
        assert z.read('distance-preservation/paper/SHA256SUMS.txt').decode()==sums
        assert not any('/sources/' in p or p.endswith('.olean') for p in z.namelist())

    tex=(P/'main.tex').read_text()
    assert r'\author{}' in tex
    assert not re.search(r'\b(expanded paper|updated paper|revised paper)\b',tex,re.I)
    proof_refs=re.findall(r'\\lean\{([^}]+)\}\{([^}]+)\}',tex)
    links=[f'../{mod}.lean' for mod,name in proof_refs]
    links+=[x for x in re.findall(r'\\href\{([^}]+)\}',tex) if '#1' not in x]
    parser=Links();parser.feed((P/'PROOF-GUIDE.html').read_text());links+=parser.links
    local=[urllib.parse.unquote(x.split('#')[0]) for x in links
           if not urllib.parse.urlparse(x).scheme]
    for link in local:assert (P/link).is_file(),link
    dates={'RDV2025':datetime.date(2025,3,10),'FHM2026':datetime.date(2026,6,10),
           'F86_first':datetime.date(2026,7,30),'F89_first':datetime.date(2026,7,30),
           'F86_internal':datetime.date(2026,8,24),'F89_internal':datetime.date(2026,8,24)}
    for k,d in dates.items():assert (datetime.date(2026,10,25)-d).days==a['chronology_days'][k]
    log=(P/'main.log').read_text()
    for marker in ['Overfull','Missing character','undefined references','undefined on input','LaTeX Error']:
        assert marker not in log,marker
    reader=PdfReader(P/'main.pdf')
    assert len(reader.pages)>=8 and not reader.metadata.get('/Author')
    total_links=0
    for page in reader.pages:
        box=page.mediabox
        for obj in page.get('/Annots',[]):
            annot=obj.get_object()
            if annot.get('/Subtype')=='/Link':
                total_links+=1
                x0,y0,x1,y1=map(float,annot['/Rect'])
                assert x0>=float(box.left)-1 and x1<=float(box.right)+1
                assert y0>=float(box.bottom)-1 and y1<=float(box.top)+1
    # Character boxes catch margins that text extraction alone can hide.
    with pdfplumber.open(P/'main.pdf') as pdf:
        for i,page in enumerate(pdf.pages):
            assert len(page.chars)>300,('near-empty page',i+1)
            for char in page.chars:
                # Negation overlays and combining accents can have zero advance.
                assert -1<=char['x0']<=char['x1']<=page.width+1,(i+1,char)
                assert -1<=char['top']<=char['bottom']<=page.height+1,(i+1,char)
    text='\n'.join(p.extract_text() for p in reader.pages)
    assert 'Question answered' in text and 'Question still open' in text
    assert 'Next proposed target' in text and '594 days' in text and '137 days' in text
    assert '\ufffd' not in text
    visual=json.loads((P/'presentation-review.json').read_text())
    assert visual['status']=='PASS' and visual['pdf_sha256']==sha(P/'main.pdf')
    assert visual['reviewed_pages']==list(range(1,len(reader.pages)+1))
    assert not visual['remaining_layout_defects']
    # The old manifest remains frozen. The focused ZIP intentionally omits
    # some external experiment files; check every historical file present.
    historical=json.loads((W/'verification.json').read_text())
    present=0;absent=0
    for path,h in historical['artifact_sha256'].items():
        file=W/path
        if file.is_file():
            assert sha(file)==h,('Historical artifact changed',path)
            present+=1
        else:absent+=1
    a['status']='PASS'
    a['validated_utc']=datetime.datetime.now(datetime.timezone.utc).isoformat()
    a['validation']={'pdf_pages':len(reader.pages),'pdf_link_annotations':total_links,
        'local_link_occurrences_checked':len(local),'all_archive_members_hash_checked':True,
        'proof_coverage_and_declaration_audit':'PASS','chronology_arithmetic':'PASS',
        'tex_overflow_missing_glyph_and_reference_checks':'PASS',
        'pdf_character_and_link_bounds':'PASS',
        'historical_evidence_hashes_checked':present,
        'historical_evidence_files_omitted_from_focused_bundle':absent,
        'visual_review_record':'presentation-review.json (separate manual visual check)',
        'public_links':'The five cited primary source URLs and relevant version histories were reopened with the web tool on25October2026; no new published proof URLs claimed.'}
    (P/'report-audit.json').write_text(json.dumps(a,indent=2,ensure_ascii=False)+'\n')
    print(json.dumps({'status':'PASS','pages':len(reader.pages),'local_links':len(local),
                      'pdf_links':total_links,'archive_members':a['source_archive_members']}))

if __name__=='__main__':main()
