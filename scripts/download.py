"""Download canonical public PDFs, or verify existing files against the manifest.

If a source requires browser verification, use its Source record's Download button,
then save the PDF with the catalog filename. This tool does not bypass challenges.
"""
import argparse,hashlib,json,pathlib,urllib.request,urllib.error
ROOT=pathlib.Path(__file__).resolve().parent.parent
parser=argparse.ArgumentParser();parser.add_argument('--verify-only',action='store_true');args=parser.parse_args()
items=json.loads((ROOT/'source-manifest.json').read_text());failures=[]
for i in items:
    path=ROOT/i['filename']
    if not path.exists() and not args.verify_only:
        try:
            with urllib.request.urlopen(i['pdf_url'],timeout=60) as response: data=response.read()
            if not data.startswith(b'%PDF-'):raise ValueError('Response is not a PDF')
            if hashlib.sha256(data).hexdigest()!=i['sha256']:raise ValueError('Source hash changed; review before replacing the pinned document')
            path.write_bytes(data)
        except (urllib.error.URLError,ValueError) as exc:
            failures.append((i['id'],str(exc),i['source_url']));continue
    if not path.exists():failures.append((i['id'],'Missing local PDF',i['source_url']));continue
    if hashlib.sha256(path.read_bytes()).hexdigest()!=i['sha256']:
        failures.append((i['id'],'SHA-256 mismatch',i['source_url']))
    else:print('Verified',i['id'])
if failures:
    for key,error,url in failures: print(f'{key}: {error}\n  Use the public Source record: {url}')
    raise SystemExit(1)
print(f'All {len(items)} source hashes verified.')
