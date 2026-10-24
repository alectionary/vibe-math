"""Reproduce the reduced quantum witness using independent exact checks.

Python >= 3.10 and a C++17 compiler are required. The C++ consumer enumerates
all four-subsets directly from incidences; it does not use the counting theorem.
"""
import argparse,hashlib,json,re,subprocess
from itertools import combinations
from pathlib import Path
from independent import qc_matrices,bitrows,rank2,gram,connected
from research import check_graph,direct_counts,qc_ghp
from formula import cyclic_formula
ROOT=Path(__file__).resolve().parent

def main():
 parser=argparse.ArgumentParser(description=__doc__)
 parser.add_argument('--output',type=Path,default=ROOT/'fresh-check-results.json')
 parser.add_argument('--scratch',type=Path,default=ROOT/'recheck-work')
 args=parser.parse_args()
 witness=json.loads((ROOT/'cubic-matched-twelve.json').read_text())
 scratch=args.scratch;scratch.mkdir(parents=True,exist_ok=True)
 executable=scratch/'direct'
 subprocess.run(['c++','-std=c++17','-O3',str(ROOT/'direct.cpp'),'-o',str(executable)],check=True)
 results={};grams=[];masks=[]
 for name,expected in [('A',49),('B',35)]:
  base=witness[name];check_graph(base)
  assert direct_counts(base)[0][2]==expected//7
  X,Z=qc_matrices(base,7,[0,1,3]);n=len(X[0]);m=len(X)
  xr,zr=bitrows(X),bitrows(Z)
  assert all((x&z).bit_count()%2==0 for x in xr for z in zr)
  assert all(sum(row)==6 for row in X)
  cols=[sum(X[r][v]<<r for r in range(m)) for v in range(n)]
  assert all(c.bit_count()==3 for c in cols)
  assert all((c&d).bit_count()<=1 for c,d in combinations(cols,2))
  assert connected(X)
  assert (rank2(xr),rank2(zr))==(81,81)
  grams.append(gram(X))
  path=scratch/(name+'.masks')
  path.write_text(str(n)+'\n'+'\n'.join(f'{c&((1<<64)-1)} {c>>64}' for c in cols)+'\n')
  masks.append(path)
  sockets,lift=qc_ghp(base)
  assert cols==[sum(1<<r for r in c) for c in lift]
  formula=cyclic_formula(sockets,7,True)
  assert formula['N42']==expected
  results[name]=dict(n=n,k=n-rank2(xr)-rank2(zr),rankX=81,rankZ=81,
   connected=True,CSS_commutes=True,column_degree=3,row_degree=6,no_four_cycles=True,
   N42=expected,normalized_ordered_root_sum=formula['raw_sum'],
   Fourier_check_error=formula['max_fourier_error'],
   masks_sha256=hashlib.sha256(path.read_bytes()).hexdigest())
 assert grams[0]==grams[1]
 output=subprocess.check_output([str(executable),*map(str,masks)],text=True)
 lines=output.splitlines()
 assert len(lines)==2
 for name,expected,line in zip(['A','B'],[49,35],lines):
  values={k:int(v) for k,v in re.findall(r'(n|examined|N42|N40)=(\d+)',line)}
  assert values==dict(n=168,examined=32018910,N42=expected,N40=91)
  results[name]['independent_subset_enumeration']=values
 sockets=json.loads((ROOT/'source882-sockets.json').read_text())
 source=cyclic_formula(sockets,63,True)
 assert source['N42']==0 and source['number_of_roots']==210
 results['source882']={k:v for k,v in source.items() if k!='roots'}
 results['equal_integer_X_Gram']=True
 args.output.write_text(json.dumps(results,indent=2)+'\n')
 print(json.dumps(results,indent=2))
if __name__=='__main__':main()
