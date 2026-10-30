"""Regenerate limited, attributed scholarly crops from the locally held thesis."""
import fitz,json,pathlib,hashlib,sys
pdf=fitz.open(sys.argv[1]);rows=json.load(open('provenance/source-crops.json'))
for r in rows:
 path=pathlib.Path(r['file']);pdf[r['page']+8].get_pixmap(matrix=fitz.Matrix(r['dpi']/72,r['dpi']/72),clip=fitz.Rect(r['rectangle'])).save(path)
 assert hashlib.sha256(path.read_bytes()).hexdigest()==r['sha256'],path
print('Verified',len(rows),'source crops against recorded hashes')
