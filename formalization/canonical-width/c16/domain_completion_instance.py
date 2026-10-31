#!/usr/bin/env python3
"""Freeze exact128-completion subproblems for saved compact fixed points."""
from pathlib import Path
import argparse,gzip,hashlib,json
from verify_algebraic_model import physical
from verify_anchored_cover_chain import canonical
ROOT=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def main():
    p=argparse.ArgumentParser();p.add_argument('--base',type=Path,required=True);p.add_argument('--base-replay',type=Path,required=True);p.add_argument('--partial',type=Path,required=True);p.add_argument('--domain',type=Path,required=True);p.add_argument('--output',type=Path,required=True);a=p.parse_args();base=json.loads(a.base.read_text());partial=json.loads(a.partial.read_text());domain=json.loads(a.domain.read_text());R=set(map(tuple,domain['classes']));pairs=partial['partial_pairs'];assert partial['answer'] is True and partial['removed_class_tuples']==[list(c) for c in sorted(R)];X,Z,A=physical()
    for k,(i,j) in enumerate(pairs):
        assert A[i]>>j&1 and canonical(i,j) in R
        for ii,jj in pairs[:k]:assert i!=ii and j!=jj and not A[i]>>jj&1 and not A[ii]>>j&1
    from verify_anchored_cover_chain import physical as signatures
    AA,C,pos,sig=signatures();assert A==AA;forbidden=[[-i-1,-j-721] for (i,j),s in sig.items() if s and canonical(i,j) not in R];units=[[i+1] for i,j in pairs]+[[j+721] for i,j in pairs];raw=gzip.decompress((a.base.parent/base['input_file']).read_bytes());assert hashlib.sha256(raw).hexdigest()==base['input_sha256'];lines=raw.decode().splitlines();header=lines.pop(0).split();assert len(lines)==int(header[3]);extras=forbidden+units;out=(f'p cnf {header[2]} {len(lines)+len(extras)}\n'+'\n'.join(lines)+'\n'+''.join(' '.join(map(str,c))+' 0\n' for c in extras)).encode();a.output.with_suffix('.cnf.gz').write_bytes(gzip.compress(out,mtime=0));meta={'status':'FROZEN_EXACT_DOMAIN_COMPLETION_SUBPROBLEM','source_C16_answered':False,'source_full_frame_size':128,'anchor':None,'asserted_partial_pairs':pairs,'base_metadata_c16_path':str(a.base.resolve().relative_to(ROOT)),'base_metadata_sha256':sha(a.base),'base_input_sha256':base['input_sha256'],'base_replay_c16_path':str(a.base_replay.resolve().relative_to(ROOT)),'base_replay_sha256':sha(a.base_replay),'partial_metadata_c16_path':str(a.partial.resolve().relative_to(ROOT)),'partial_metadata_sha256':sha(a.partial),'domain_c16_path':str(a.domain.resolve().relative_to(ROOT)),'domain_sha256':sha(a.domain),'forbidden_nonzero_pairs':len(forbidden),'mandatory_owner_units':len(units),'variables':int(header[2]),'clauses':len(lines)+len(extras),'input_file':a.output.with_suffix('.cnf.gz').name,'input_sha256':hashlib.sha256(out).hexdigest(),'scope':'A full original source128-frame must contain the asserted pairs and use no nonzero-signature class outside this domain. SAT answers the source question after physical replay; UNSAT excludes this mandatory subset in this domain only.'};a.output.write_text(json.dumps(meta,indent=2)+'\n');print('DOMAIN FULL COMPLETION',len(pairs),'pairs',meta['variables'],meta['clauses'],flush=True)
if __name__=='__main__':main()
