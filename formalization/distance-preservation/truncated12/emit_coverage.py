"""Assemble admitted closed case proofs into quantified, balanced range coverage.
No certificate identity is recomputed or assumed by this generator.
"""
from pathlib import Path
import argparse,json
R=Path(__file__).resolve().parent

def tree(w,start,n):
 if n==1:return f'(covered_single {w} {start} fastCert{w}_{start} fastCase{w}_{start})'
 a=n//2;b=n-a
 return f'(covered_append {w} {start} {a} {b}\n  {tree(w,start,a)}\n  {tree(w,start+a,b)})'

def blocks(w,items):
 if len(items)==1:return f'coverage_{items[0]["module"]}'
 a=len(items)//2;left=items[:a];right=items[a:]
 s=items[0]['start'];n=sum(x['count'] for x in left);m=sum(x['count'] for x in right)
 return f'(covered_append {w} {s} {n} {m}\n  {blocks(w,left)}\n  {blocks(w,right)})'

if __name__=='__main__':
 ap=argparse.ArgumentParser();ap.add_argument('weight',type=int,choices=[10,11]);a=ap.parse_args()
 items=[x for x in json.loads((R/'kernel-chunk-plan.json').read_text())['modules'] if x['weight']==a.weight]
 w=a.weight
 lines=[f'import Catalog{w}','import CoverageCore','set_option maxHeartbeats 0','set_option maxRecDepth 1000000','namespace KernelCatalog']
 for x in items:
  lines+=[f'theorem coverage_{x["module"]} : Covered {w} {x["start"]} {x["count"]} :=\n  '+tree(w,x['start'],x['count'])]
 n=sum(x['count'] for x in items)
 lines+=[f'theorem complete_coverage{w} : Covered {w} 0 {n} :=\n  '+blocks(w,items),f'#print axioms complete_coverage{w}','end KernelCatalog']
 (R/f'Coverage{w}.lean').write_text('\n\n'.join(lines)+'\n')
 print({'weight':w,'cases':n,'blocks':len(items)})
