"""Extract local source PDFs for review; outputs are deliberately gitignored."""
import json, re, pathlib, hashlib
from pypdf import PdfReader
ROOT=pathlib.Path(__file__).resolve().parent.parent
OUT=ROOT/'local-extraction'
OUT.mkdir(exist_ok=True)
records=[]
for item in json.loads((ROOT/'catalog.json').read_text()):
    path=ROOT/item['filename']
    key=f"{item['year']}-{item['filename'].split('-')[1]}"
    if 'Vander-Woude' in path.name:key=f"{item['year']}-Vander-Woude"
    reader=PdfReader(path)
    pages=[]
    for num,page in enumerate(reader.pages,1):
        text=page.extract_text() or ''
        labels=reader.page_labels
        pages.append({'pdf_page':num,'pdf_label':labels[num-1] if labels else str(num),'text':text})
    (OUT/f'{key}.json').write_text(json.dumps(pages,ensure_ascii=False,indent=2))
    (OUT/f'{key}.txt').write_text('\n\n'.join(f"=== PDF PAGE {p['pdf_page']} | LABEL {p['pdf_label']} ===\n{p['text']}" for p in pages))
    records.append({**item,'id':key,'sha256':hashlib.sha256(path.read_bytes()).hexdigest()})
    print(key,len(pages),'pages extracted',flush=True)
(ROOT/'source-manifest.json').write_text(json.dumps(records,ensure_ascii=False,indent=2)+'\n')
