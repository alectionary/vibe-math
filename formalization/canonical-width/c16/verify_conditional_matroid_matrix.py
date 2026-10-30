#!/usr/bin/env python3
"""Compare compiled rank rows with literal cyclic/sector averaging."""
from pathlib import Path
import hashlib,json,random,time
import numpy as np
from conditional_matroid_moment_matrix import matrix
ROOT=Path(__file__).resolve().parent

def main():
 start=time.monotonic();bank=ROOT/'moment-resumption-results/matroid-owner0.json';replay=ROOT/'moment-resumption-results/matroid-owner0-independent.json';d=json.loads(bank.read_text());M,rows=matrix([bank],[replay]);assert M.shape[0]==len(d['cuts']);rng=random.Random(202610300220);count=0
 for case in range(12):
  masks=[[rng.getrandbits(16) for i in range(45)] for side in range(2)]
  corr=lambda a,b,h:(a&((b>>h)|(b<<(16-h)))&65535).bit_count()
  flat=np.array([masks[0][i].bit_count()+masks[1][i].bit_count() for i in range(45)]+[sum(corr(masks[s][i],masks[s if side=='S' else 1-s][j],h) for s in (0,1)) for side in ('S','T') for h in range(9) for i in range(45) for j in range(45)],dtype=np.int64);compiled=M@flat
  for n,cut in enumerate(d['cuts']):
   literal=0
   for s in range(2):
    for phase in range(16):
     if masks[s][cut['anchor_orbit']]>>phase&1:
      sector=s if cut['sector']=='S' else 1-s;literal+=sum(masks[sector][i//16]>>((i%16+phase)%16)&1 for i in cut['indices'])-cut['bound']
   assert compiled[n]==literal;count+=1
 out={'status':'PASS','source_C16_answered':False,'coefficient_rows':M.shape[0],'matrix_nonzeros':M.nnz,'deterministic_arbitrary_selection_controls':12,'literal_32_symmetry_average_comparisons':count,'arbitrary_selections_are_not_frame_witnesses':True,'bank_sha256':hashlib.sha256(bank.read_bytes()).hexdigest(),'independent_rank_replay_sha256':hashlib.sha256(replay.read_bytes()).hexdigest(),'compiler_sha256':hashlib.sha256((ROOT/'conditional_matroid_moment_matrix.py').read_bytes()).hexdigest(),'elapsed_seconds':time.monotonic()-start};(ROOT/'moment-resumption-results/matroid-matrix-independent.json').write_text(json.dumps(out,indent=2)+'\n');print(out,flush=True)
if __name__=='__main__':main()
