#!/usr/bin/env python3
"""Package only the new implementation and, separately, its five allowed inputs."""
import hashlib,json,pathlib,tarfile,io,gzip
HERE=pathlib.Path(__file__).resolve().parent
ROOT=HERE.parents[4]
PREFIX=pathlib.Path('formalization/canonical-width/c16/independent-check/codex-gpt6')
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def files():
 return sorted(p for p in HERE.rglob('*') if p.is_file() and '__pycache__' not in p.parts and p.suffix!='.pyc' and p.name not in ('MANIFEST.json','SHA256SUMS','GIT-MANIFEST.json'))
def main():
 p=HERE/'provenance.json';v=json.loads(p.read_text())
 for c in 'ABC':assert (HERE/'results'/f'real-{c}.json').exists()
 v['implementation_sha256']={q.name:sha(q) for q in sorted(HERE.iterdir()) if q.is_file() and (q.suffix in ('.py','.cpp') or q.name in ('orbit_clique','bundle_clique','requirements.txt','requirements-lock.txt'))}
 v['final_results_index']='results/index.json'
 p.write_text(json.dumps(v,indent=2)+'\n')
 fs=files();gitfiles=[q for q in fs if q.suffix!='.matrix' and q.name not in ('orbit_clique','bundle_clique')];scope=[str(PREFIX/q.relative_to(HERE)) for q in gitfiles]+[str(PREFIX/'GIT-MANIFEST.json')]
 (HERE/'publication-scope.txt').write_text('\n'.join(sorted(set(scope+[str(PREFIX/'publication-scope.txt')])) )+'\n')
 fs=files();gitfiles=[q for q in fs if q.suffix!='.matrix' and q.name not in ('orbit_clique','bundle_clique')]
 (HERE/'GIT-MANIFEST.json').write_text(json.dumps({'source_commit':v['source_commit'],'scope':str(PREFIX)+'/', 'exclusions':'Compiled binaries, derived .matrix, caches, full-archive manifest/checksums; this manifest excludes itself to avoid circularity', 'files':[{'path':str(PREFIX/q.relative_to(HERE)),'bytes':q.stat().st_size,'sha256':sha(q)} for q in gitfiles]},indent=2)+'\n')
 gitfiles.append(HERE/'GIT-MANIFEST.json');fs.append(HERE/'GIT-MANIFEST.json')
 manifest={'source_commit':v['source_commit'],'publication_scope':str(PREFIX)+'/', 'exclusions':'__pycache__, .pyc; manifest and checksum file excluded from manifest hash list to avoid circularity','files':[{'path':str(PREFIX/q.relative_to(HERE)),'bytes':q.stat().st_size,'sha256':sha(q)} for q in fs]}
 (HERE/'MANIFEST.json').write_text(json.dumps(manifest,indent=2)+'\n')
 fs=fs+[HERE/'MANIFEST.json']
 (HERE/'SHA256SUMS').write_text(''.join(f'{sha(q)}  {q.relative_to(HERE)}\n' for q in sorted(fs)))
 fs=fs+[HERE/'SHA256SUMS']
 allowed=[HERE.parents[1]/name for name in v['scientific_read_allowlist']]
 for q,name in zip(allowed,v['scientific_read_allowlist']):assert sha(q)==v['sha256'][name]
 outputs=[]
 for label,items in [('publication',gitfiles),('reproduce',fs+allowed)]:
  dest=pathlib.Path('/workspace')/f'c16-codex-gpt6-{label}.tar.gz'
  with dest.open('wb') as raw,gzip.GzipFile(fileobj=raw,mode='wb',mtime=0) as gz,tarfile.open(fileobj=gz,mode='w') as tar:
   for q in sorted(items):
    arc=str(q.relative_to(ROOT));data=q.read_bytes();info=tarfile.TarInfo(arc);info.size=len(data);info.mode=0o755 if q.name in ('orbit_clique','bundle_clique') else 0o644;tar.addfile(info,io.BytesIO(data))
  with tarfile.open(dest) as tar:
   names=tar.getnames();assert len(names)==len(items)
   if label=='publication':assert all(n.startswith(str(PREFIX)+'/') for n in names)
  outputs.append({'path':str(dest),'sha256':sha(dest),'bytes':dest.stat().st_size,'members':len(items)})
 print(json.dumps(outputs,indent=2))
if __name__=='__main__':main()
