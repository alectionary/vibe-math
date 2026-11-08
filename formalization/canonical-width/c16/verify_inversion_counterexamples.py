#!/usr/bin/env python3
"""Literal controls against unjustified product-basis and residue reductions."""
from itertools import combinations
import argparse,json
from pathlib import Path

def rank(values):
 span={0}
 for v in values:span|={u^v for u in list(span)}
 return (len(span)-1).bit_length()
def f4mul(a,b):
 p=0
 for i in range(2):
  for j in range(2):
   if a>>i&1 and b>>j&1:p^=1<<(i+j)
 if p&4:p^=7
 return p

def determinant(v):
 w=[v>>(2*i)&3 for i in range(4)];return f4mul(w[0],w[3])^f4mul(w[1],w[2])
def tracepair(x,y):return sum((f4mul(x>>(2*i)&3,y>>(2*i)&3)>>1)&1 for i in range(4))%2

def main():
 ap=argparse.ArgumentParser();ap.add_argument('--output',type=Path,required=True);args=ap.parse_args()
 X=[85,13,153,187,144,14,208,5];Z=[112,11,14,16,238,17,176,102]
 assert all(v and determinant(v)==0 for v in X+Z);assert all(tracepair(x,z)==(i==j) for i,x in enumerate(X) for j,z in enumerate(Z))
 def line(v,left):
  w=[v>>(2*i)&3 for i in range(4)];pairs=[(w[0],w[1]),(w[2],w[3])] if left else [(w[0],w[2]),(w[1],w[3])];a,b=next((a,b) for a,b in pairs if a or b)
  return (1,f4mul(b,f4mul(a,a))) if a else (0,1)
 occupancy=max(sum(line(v,left)==ell for v in X) for left in [False,True] for ell in [(1,0),(1,1),(1,2),(1,3),(0,1)]);assert occupancy==3
 frame=[1,26,4,74,242,42,248,138];pool=frame+[2,37,8,133,241,21,244,69]
 shift=lambda v:sum((((v>>(2*i))&1)<<(2*i+1))|(((v>>(2*i+1))&1)<<(2*i)) for i in range(4))
 assert len(set(pool))==16 and all(shift(v)!=v and shift(v) in pool for v in pool)
 assert all((x&z).bit_count()%2==(i==j) for i,x in enumerate(frame) for j,z in enumerate(frame))
 residue=sorted({sum((((v>>(2*i))^(v>>(2*i+1)))&1)<<i for i in range(4)) for v in pool});assert residue==[1,2,7,11] and rank(residue)==4
 matrix=[[(x&z).bit_count()%2 for z in residue] for x in residue];assert all(sum(row)==3 for row in matrix)
 best=0;pair_witness=None
 for k in range(1,5):
  for I in combinations(range(4),k):
   for J in combinations(range(4),k):
    if all(sum(matrix[i][j] for j in J)==1 for i in I) and all(sum(matrix[i][j] for i in I)==1 for j in J):best=max(best,k);pair_witness=(I,J)
 assert best==2
 result={'status':'PASS','trace_product_counterexample':{'dimension':8,'X':X,'Z':Z,'maximum_common_factor_ruling_occupancy':3,'refuted_statement':'Every full binary trace-dual rank-one frame has half of its X basis in a common left or right factor line.'},'cyclic_descent_counterexample':{'period':2,'module_rank':4,'full_frame':frame,'common_pool':pool,'residue_pool':residue,'residue_Gram':matrix,'maximum_residue_pairs':2,'refuted_statement':'A full primitive binary canonical frame in a free orthogonal cyclic common pool always descends to a full residue frame.','source_specific_tensor_hypotheses_verified':False},'canonical_C16_question_answered':False};args.output.write_text(json.dumps(result,indent=2)+'\n');print(json.dumps({'status':'PASS','generic_reductions_refuted':2,'source_question_answered':False}))

if __name__=='__main__':main()
