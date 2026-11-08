#!/usr/bin/env python3
"""Direct physical consumer of compact-witness rank obstructions."""
from pathlib import Path
import argparse,hashlib,json,time
from verify_algebraic_model import physical
ROOT=Path(__file__).resolve().parent
def echelon(values):
    out={}
    for value in values:
        while value:
            p=(value&-value).bit_length()-1
            if p not in out:out[p]=value;break
            value^=out[p]
    return out
def contains(value,span):
    while value:
        p=(value&-value).bit_length()-1
        if p not in span:return False
        value^=span[p]
    return True
def check(U,V,ids,w):
    assert ids and len(ids)==len(set(ids)) and 0<w<1<<128
    B=echelon(U[i] for i in ids);assert len(B)==len(ids) and not contains(w,B)
    assert all(not (w&v).bit_count()%2 for v in V if all(not (U[i]&v).bit_count()%2 for i in ids))
def main():
    ap=argparse.ArgumentParser();ap.add_argument('--certificate',type=Path,required=True);ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();start=time.monotonic();X,Z,A=physical();data=json.loads(a.certificate.read_text());records=data['records'];assert len(records)==24;hist={};patterns=set()
    for row in records:
        p=ROOT/row['metadata_file'];assert hashlib.sha256(p.read_bytes()).hexdigest()==row['metadata_sha256'];meta=json.loads(p.read_text());assert meta['answer'] is True and row['pairs']==meta['partial_pairs'] and row['case']==meta['case']
        assert any(s['bad'] for s in row['sides'])
        for r in row['sides']:
            side=r['sector'];U,V=(X,Z) if side==0 else (Z,X);ids=[pair[side] for pair in row['pairs']];zero=[v for v in V if all(not (U[i]&v).bit_count()%2 for i in ids)];rank=len(echelon(zero));assert rank==r['zero_rank'] and 128-len(ids)==r['required_zero_rank'] and r['bad']==(rank<128-len(ids))
            if r['bad']:assert set(r['core_indices'])<=set(ids);check(U,V,r['core_indices'],int(r['annihilator'],16))
    for cut in data['cuts']:
        side=cut['sector'];U,V=(X,Z) if side==0 else (Z,X);ids=cut['indices'];assert cut['kind']=='z_zero' and cut['clause']==[-i-1 for i in ids];check(U,V,ids,int(cut['annihilator'],16));hist[len(ids)]=hist.get(len(ids),0)+1
        for phase in range(16):patterns.add(tuple(sorted(16*(i//16)+(i%16+phase)%16 for i in ids)))
    try:check(X,Z,data['cuts'][0]['indices'],0)
    except AssertionError:pass
    else:raise AssertionError('zero accepted')
    result={'status':'PASS','source_C16_answered':False,'saved_rank_SAT_witnesses':len(records),'witnesses_proved_not_full_frame_extendible':24,'direct_rank_certificates':len(data['cuts']),'core_cardinalities':hist,'translated_index_patterns':len(patterns),'physical_symmetry_transfer':'common cyclic shift and sector exchange; follows from physical source automorphisms','zero_witness_rejected':True,'certificate_sha256':hashlib.sha256(a.certificate.read_bytes()).hexdigest(),'elapsed_seconds':time.monotonic()-start,'scope':'Nonextendibility of these fixed partial witnesses only. Their anchor classes and existence of alternative witnesses remain unresolved.'};a.output.write_text(json.dumps(result,indent=2)+'\n');print(result,flush=True)
if __name__=='__main__':main()
