"""Build a navigational index of detected numbered statement headings.

Detection is intentionally conservative and does NOT determine proof validity,
novelty, completeness, or whether a displayed question remains open.
"""
import json,pathlib,re
ROOT=pathlib.Path(__file__).resolve().parent.parent
pattern=re.compile(r'(?m)^\s*(Theorem|Lemma|Proposition|Corollary|Conjecture|Question|Problem|Assumption|Definition)\s*([A-Z]?\.?\d+(?:\.\d+)*)(?=[.\s:(])')
all_items=[]
for source in json.loads((ROOT/'source-manifest.json').read_text()):
    pages=json.loads((ROOT/'local-extraction'/f"{source['id']}.json").read_text())
    found={}
    for p in pages:
        for m in pattern.finditer(p['text']):
            kind,number=m.groups();key=(kind,number)
            entry=found.setdefault(key,dict(dissertation_id=source['id'],kind=kind,number=number,pdf_pages=[],review_status='Automatically detected heading or mention; not individually classified'))
            if p['pdf_page'] not in entry['pdf_pages']:entry['pdf_pages'].append(p['pdf_page'])
    all_items.extend(found.values())
(ROOT/'reviews'/'statement-index.json').write_text(json.dumps(all_items,ensure_ascii=False,indent=2)+'\n')
print('Indexed',len(all_items),'unique kind/number pairs; navigation only, not a count of proved results.')
