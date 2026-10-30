#!/usr/bin/env python3
"""Independently count source X vectors with one owner in each saved Z basis.

Uses physical pairings and bitset intersections, never the producer inverse.
For an independent full Z basis these are exactly its dual vectors in the X
pool. Fewer than128 such vectors excludes this particular saved Z selection.
"""
from pathlib import Path
import argparse, hashlib, json, time
import numpy as np
from verify_algebraic_model import physical
from verify_full_partner_basis_oracle import dimension

ROOT=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()

def main():
    ap=argparse.ArgumentParser();ap.add_argument('--archive',type=Path,required=True);ap.add_argument('--result',type=Path,required=True);ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();start=time.monotonic()
    frozen=json.loads(a.result.with_suffix('.frozen.json').read_text());result=json.loads(a.result.read_text());exit_report=json.loads(a.result.with_suffix('.exit.json').read_text())
    assert frozen['archive_sha256']==sha(a.archive)
    assert all(sha(ROOT/p)==d for p,d in frozen['source_hashes'].items())
    assert exit_report['returncode']==0 and exit_report['timeout'] is False
    assert exit_report['result_sha256']==sha(a.result)
    scores=a.result.with_suffix('.scores.bin').read_bytes();assert exit_report['scores_sha256']==sha(a.result.with_suffix('.scores.bin'))
    X,Z,A=physical();assert len(X)==len(Z)==720 and dimension(X)==dimension(Z)==128
    bases=np.load(a.archive)['selected_Z_indices'];count=result['rows_checked'];assert len(scores)==count<=len(bases)
    assert result['input_rows']==len(bases) and result['entire_archive_checked']==(count==len(bases))
    histogram=[0]*129;best=-1;best_index=None;best_mask=None
    for index,row in enumerate(bases[:count]):
        assert len(row)==128 and all(0<=j<720 for j in row)
        mask=sum(1<<int(j) for j in row);assert mask.bit_count()==128
        hits=sum((a_row&mask).bit_count()==1 for a_row in A)
        assert hits==scores[index],('inverse/physical-degree mismatch',index,hits,scores[index])
        histogram[hits]+=1
        if hits>best:best,best_index,best_mask=hits,index,mask
        if index%50000==0:print('checked',index,'best',best,flush=True)
    assert histogram==result['histogram'] and best==result['maximum_pool_duals'] and best_index==result['best_archive_row']
    selected=list(map(int,bases[best_index]));assert selected==result['best_Z_basis'] and dimension([Z[j] for j in selected])==128
    pairs=[]
    for i,a_row in enumerate(A):
        owners=a_row&best_mask
        if owners.bit_count()==1:pairs.append([i,owners.bit_length()-1])
    assert sorted(pairs)==sorted(result['pool_pairs']) and len(pairs)==best
    assert len({j for i,j in pairs})==best
    assert all(((A[i]>>j2)&1)==int(k==l) for k,(i,j) in enumerate(pairs) for l,(i2,j2) in enumerate(pairs))
    out={'status':'PASS','source_C16_answered':False,'rows_physically_checked':count,'entire_archive_checked':count==len(bases),'maximum_source_pool_duals':best,'best_archive_row':best_index,'best_basis_rank':128,'best_partial_Gram_identity':True,'no_saved_basis_is_a_full_pool_frame':best<128,'archive_sha256':sha(a.archive),'result_sha256':sha(a.result),'scores_sha256':sha(a.result.with_suffix('.scores.bin')),'consumer_sha256':sha(Path(__file__)),'physical_dependencies':{p:sha(ROOT/p) for p in ['verify_algebraic_model.py','verify_full_partner_basis_oracle.py','verify_partial_frame.py','audit_pools.py','physical-pool-source.json','pools/xcoords.txt','pools/zcoords.txt']},'elapsed_seconds':time.monotonic()-start,'scope':'Exact screening of the saved archive only; no new global frame upper bound or source-cover reduction.'}
    a.output.write_text(json.dumps(out,indent=2)+'\n');print(out,flush=True)

if __name__=='__main__':main()
