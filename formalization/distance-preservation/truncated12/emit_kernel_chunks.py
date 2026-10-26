"""Emit closed individual kernel checks, with an aggregate axiom audit per chunk.

Each reduction has its own declaration, preventing a large kernel reduction
cache from retaining an entire batch. Chunks give incremental build records.
"""
from pathlib import Path
import gzip,json,argparse,hashlib
R=Path(__file__).resolve().parent

def main():
 ap=argparse.ArgumentParser();ap.add_argument('--chunk',type=int,default=1000);ap.add_argument('--fast',action='store_true');a=ap.parse_args()
 out=R/'catalog-chunks';out.mkdir(exist_ok=True);records=[];targets=json.loads((R/'catalog-targets.json').read_text())
 for w in [7,10,11]:
  codes=json.load(gzip.open(R/f'encoded-catalog-{w}.json.gz','rt'));mods=[]
  for n,start in enumerate(range(0,len(codes),a.chunk)):
   block=codes[start:start+a.chunk];mod=f'{"F" if a.fast else "C"}{w}_{n:03d}';mods.append(mod)
   lines=['import FastCatalogChecker' if a.fast else 'import SparseCatalogChecker','set_option maxHeartbeats 0','set_option maxRecDepth 1000000','namespace KernelCatalog']
   names=[];props=[]
   for j,c in enumerate(block,start):
    name=f'{"fastCase" if a.fast else "case"}{w}_{j}';cn=f'{"fastCert" if a.fast else "cert"}{w}_{j}';code=int(c);kind=code%256;bits=(code//256)%256
    arity=len(targets[kind]['forms']);terms=[]
    for t in range(arity):
     for i in range(18):
      z=(code//(2**(16+bits*(18*t+i))))%(2**bits);v=z//2 if z%2==0 else -(z+1)//2
      if v:terms.append((t,i,v))
    body='0'
    for t,i,v in reversed(terms):body=f'if t={t} ∧ i={i} then ({v}) else '+body
    lines.append(f'def {cn} : Certificate := ⟨{kind},fun t i => {body}⟩')
    prop=f'{"checkCertificateFast" if a.fast else "checkCertificate"} {w} {j} {cn}=true';names.append(name);props.append(prop)
    lines.append(f'theorem {name} : {prop} := by decide +kernel')
   lines +=[f'theorem aggregate_{mod} : '+' ∧ '.join('('+p+')' for p in props)+' :=\n  ⟨'+','.join(names)+'⟩',f'#print axioms aggregate_{mod}','end KernelCatalog']
   p=out/(mod+'.lean');p.write_text('\n'.join(lines)+'\n')
   records.append(dict(module=mod,weight=w,start=start,count=len(block),source_sha256=hashlib.sha256(p.read_bytes()).hexdigest()))
  # Import wrapper is generated separately from full coverage claims.
  (R/f'Catalog{w}.lean').write_text('\n'.join('import '+m for m in mods)+'\n')
 (R/'kernel-chunk-plan.json').write_text(json.dumps(dict(chunk_size=a.chunk,modules=records,scope='Generated declarations are unverified until their exact source build succeeds. Each module aggregate axiom audit includes every individual case.'),indent=2)+'\n')
 print({w:len([x for x in records if x['weight']==w]) for w in [7,10,11]})
if __name__=='__main__':main()
