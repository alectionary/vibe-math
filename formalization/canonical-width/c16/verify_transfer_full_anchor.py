#!/usr/bin/env python3
"""Independent scan of the full input's prefix and every new negative clause."""
from pathlib import Path
import argparse,collections,gzip,hashlib,json,time
from verify_algebraic_model import physical
from verify_sparse_quotient import SparseQuotientConsumer
ROOT=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def main():
    p=argparse.ArgumentParser();p.add_argument('--output',type=Path,required=True);a=p.parse_args();start=time.monotonic()
    path=ROOT/'transfer-results/full-anchor-instance.json';d=json.loads(path.read_text());assert d['source_full_frame_size']==128 and d['anchor']==[48,48]
    bp=ROOT/d['base_c16_path'];assert sha(bp)==d['base_metadata_sha256'];base=json.loads(bp.read_text())
    before=gzip.decompress((bp.parent/base['input_file']).read_bytes());assert hashlib.sha256(before).hexdigest()==d['base_input_sha256']==base['input_sha256']
    raw=gzip.decompress((path.parent/d['input_file']).read_bytes());assert hashlib.sha256(raw).hexdigest()==d['input_sha256']
    original=before.decode().splitlines();lines=raw.decode().splitlines();assert lines[1:len(original)]==original[1:]
    X,Z,A=physical();assert all(((A[i]>>j)&1)==((A[j]>>i)&1) for i in range(720) for j in range(720))
    moved=[16*(i//16)+(i%16+1)%16 for i in range(720)]
    assert all(((A[i]>>j)&1)==((A[moved[i]]>>moved[j])&1) for i in range(720) for j in range(720))
    sp=ROOT/d['seed_c16_path'];assert sha(sp)==d['seed_sha256'];bank=json.loads(sp.read_text())['cuts'];assert len(bank)==256
    allowed=set();consumer=SparseQuotientConsumer(X,Z)
    for cut in bank:
        c=cut['certificate'];result=consumer.check(c);assert cut['sector']==1-c['side'] and cut['indices']==c['mandatory_opposite']
        assert result==[-1-i-720*cut['sector'] for i in cut['indices']]
        for h in range(16):
            pattern=[(i//16)*16+(i%16+h)%16 for i in cut['indices']]
            for offset in [0,720]:allowed.add(tuple(sorted(-(i+offset+1) for i in pattern)))
    old={tuple(sorted(map(int,line.split()[:-1]))) for line in original[1:]};new=[]
    for line in lines[len(original):]:
        values=list(map(int,line.split()));assert values[-1]==0;clause=tuple(sorted(values[:-1]))
        assert clause in allowed and clause not in old and all(-1440<=lit<0 for lit in clause);new.append(clause)
    assert len(new)==len(set(new))==d['new_unique_clauses'] and set(new)==allowed-old
    assert lines[0]==f"p cnf {d['variables']} {d['clauses']}" and len(lines)==d['clauses']+1
    assert d['variables']==base['variables']
    rp=ROOT/d['base_clean_replay_c16_path'];assert sha(rp)==d['base_clean_replay_sha256'];receipt=json.loads(rp.read_text())
    assert receipt['status']=='PASS' and receipt['input_sha256']==d['base_input_sha256']
    result={'status':'PASS','source_C16_answered':False,'anchor':[48,48],'full_source_model':True,'projection_model':False,
            'input_sha256':d['input_sha256'],'base_input_sha256':d['base_input_sha256'],'base_prefix_byte_identical':True,
            'physical_pairings_rebuilt':518400,'new_source_certificates_checked':256,'new_negative_clauses_checked':len(new),
            'old_base_receipt_inherited':True,'base_clean_replay_sha256':sha(rp),'elapsed_seconds':time.monotonic()-start,
            'scope':'Every appended clause independently checked against actual source certificates and physical cyclic/sector symmetries. Exact old full-source prefix preserved. Earlier full-source/theory clean replay inherited; no solver conclusion.'}
    a.output.write_text(json.dumps(result,indent=2)+'\n');print(result,flush=True)
if __name__=='__main__':main()
