"""Reproduce the smaller generalized-bicycle frequency obstruction exactly."""
import argparse,json,hashlib,subprocess
from pathlib import Path
from itertools import combinations
from independent import rank2,bitrows,gram,connected
from research import check_graph,direct_counts
from formula import cyclic_formula
ROOT=Path(__file__).resolve().parent

def columns(a,b,n):
 return [frozenset((t+x)%n for x in s) for s in [a,tuple(-x%n for x in b)] for t in range(n)]
def verify(output,scratch):
 w=json.loads((ROOT/'gb-positive-matched-witness.json').read_text());n=w['ell'];scratch.mkdir(parents=True,exist_ok=True)
 exe=scratch/'direct';subprocess.run(['c++','-std=c++17','-O3',str(ROOT/'direct.cpp'),'-o',str(exe)],check=True)
 results={};grams=[];paths=[]
 for side,expected in [('A',192),('B',72)]:
  d=w[side];a,b=d['a'],d['b'];cs=columns(a,b,n);check_graph(cs)
  zs=columns(b,a,n)
  X=[[int(r in c) for c in cs] for r in range(n)];Z=[[int(r in c) for c in zs] for r in range(n)]
  xr,zr=bitrows(X),bitrows(Z)
  assert all((x&z).bit_count()%2==0 for x in xr for z in zr)
  assert all(sum(row)==6 for row in X) and connected(X)
  assert rank2(xr)==rank2(zr)==22
  assert all(len(c&d)<=1 for c,d in combinations(cs,2))
  counts,_=direct_counts(cs);assert counts.get(2,0)==expected
  sockets=[[(0,e) for e in a],[(0,-e%n) for e in b]]
  f=cyclic_formula(sockets,n,True);assert f['N42']==expected
  # Exact difference-multiplicity key proves equality of the circulant Grams.
  differences=[sum((x-y)%n==delta for s in [a,b] for x in s for y in s) for delta in range(n)]
  grams.append(gram(X));mask=[sum(1<<r for r in c) for c in cs];path=scratch/(side+'.masks')
  path.write_text(str(len(cs))+'\n'+'\n'.join(f'{m} 0' for m in mask)+'\n');paths.append(path)
  results[side]=dict(n=48,k=4,rankX=22,rankZ=22,CSS_commutes=True,connected_X_Tanner=True,no_four_cycles=True,
   column_degree=3,row_degree=6,N42=expected,N40=counts.get(0,0),difference_multiplicities=differences,
   normalized_ordered_root_sum=f['raw_sum'],Fourier_check_error=f['max_fourier_error'])
 assert grams[0]==grams[1]
 assert results['A']['difference_multiplicities']==results['B']['difference_multiplicities']
 cpp=subprocess.check_output([str(exe),*map(str,paths)],text=True)
 assert 'N42=192 N40=0' in cpp and 'N42=72 N40=24' in cpp
 result=dict(results=results,same_full_integer_check_Gram=True,same_all_scalar_M_j=True,
  proof_of_frequency_equality='b_prime=x^2*b(x^-1) modulo x^24-1, hence equal Fourier magnitudes; a is unchanged.',
  independent_cpp_output=cpp,source_sha256=hashlib.sha256((ROOT/'gb-positive-matched-witness.json').read_bytes()).hexdigest(),
  distance_unspecified=True,search_does_not_claim_global_minimality=True)
 output.write_text(json.dumps(result,indent=2)+'\n');print(json.dumps(result,indent=2));return result

def main():
 p=argparse.ArgumentParser(description=__doc__);p.add_argument('--output',type=Path,default=ROOT/'gb48-fresh-results.json');p.add_argument('--scratch',type=Path,default=ROOT/'gb48-recheck-work');a=p.parse_args();verify(a.output,a.scratch)
if __name__=='__main__':main()
