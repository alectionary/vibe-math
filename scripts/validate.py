"""Check review coverage, citation bounds, generated links, and local source hashes."""
import pathlib,json,hashlib,re
from html.parser import HTMLParser
from urllib.parse import urlparse,unquote
ROOT=pathlib.Path(__file__).resolve().parent.parent
sources=json.loads((ROOT/'source-manifest.json').read_text())
reviews=json.loads((ROOT/'reviews'/'reviews.json').read_text())
assert len(sources)==len(reviews)==20
assert {s['id'] for s in sources}==set(reviews)
source_by_id={s['id']:s for s in sources}
fields=['definitions','proved_or_derived','assumptions','imported_results','computational_or_empirical','open_questions','interpretation_notes']
entry_count=0
for s in sources:
    for suffix in ['.html','.md']:assert (ROOT/'reviews'/(s['id']+suffix)).is_file()
    for field in fields:
        assert reviews[s['id']][field]
        for e in reviews[s['id']][field]:
            assert e['text'] and e['pdf_pages']
            assert all(isinstance(p,int) and 1<=p<=s['pages'] for p in e['pdf_pages'])
            entry_count+=1
    p=ROOT/s['filename']
    if p.exists():assert hashlib.sha256(p.read_bytes()).hexdigest()==s['sha256']
index=json.loads((ROOT/'reviews'/'statement-index.json').read_text())
for entry in index:
    s=source_by_id[entry['dissertation_id']]
    assert all(1<=p<=s['pages'] for p in entry['pdf_pages'])
class Links(HTMLParser):
    def __init__(self):super().__init__();self.links=[]
    def handle_starttag(self,tag,attrs):
        if tag=='a':self.links += [v for k,v in attrs if k=='href']
for page in [ROOT/'analysis.html',ROOT/'index.html',*list((ROOT/'reviews').glob('*.html'))]:
    parser=Links();parser.feed(page.read_text())
    for href in parser.links:
        url=urlparse(href)
        if url.scheme or not url.path:continue
        path=(page.parent/unquote(url.path)).resolve()
        assert path.is_relative_to(ROOT),path
        # PDFs intentionally absent from Git clones, but present in the downloaded collection.
        if path.suffix!='.pdf':assert path.exists(),(page,href)
        if url.fragment.startswith('page='):
            s=next(s for s in sources if s['filename']==path.name)
            assert 1<=int(url.fragment[5:])<=s['pages']
print(f'Validated 20 reviews, {entry_count} curated evidence entries, {len(index)} indexed kind/number pairs, all generated local links and available PDF hashes.')
