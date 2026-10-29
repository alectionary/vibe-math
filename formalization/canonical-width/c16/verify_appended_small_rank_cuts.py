#!/usr/bin/env python3
"""Check appended clauses by direct physical witnesses and subset implication."""
from pathlib import Path
from itertools import combinations
import argparse,gzip,hashlib,json,time
from verify_algebraic_model import physical
from small_conditional_rank_cuts import verify
ROOT=Path(__file__).resolve().parent

def main():
 ap=argparse.ArgumentParser();ap.add_argument('--metadata',type=Path,required=True);ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();start=time.monotonic();d=json.loads(a.metadata.read_text());basepath=ROOT/d['base_metadata_c16_path'];base=json.loads(basepath.read_text());old=gzip.decompress((basepath.parent/base['input_file']).read_bytes());new=gzip.decompress((a.metadata.parent/d['input_file']).read_bytes());assert hashlib.sha256(old).hexdigest()==d['base_input_sha256']==base['input_sha256'] and hashlib.sha256(new).hexdigest()==d['input_sha256'];before=old.decode().splitlines();after=new.decode().splitlines();assert before[0].split()[2]==after[0].split()[2] and after[1:len(before)]==before[1:];tail=after[len(before):];assert len(tail)==d['added_clauses'] and int(after[0].split()[3])==int(before[0].split()[3])+len(tail);cp=ROOT/d['rank_cut_certificate_c16_path'];assert hashlib.sha256(cp.read_bytes()).hexdigest()==d['rank_cut_certificate_sha256'];cuts=json.loads(gzip.decompress(cp.read_bytes()))['cuts'];X,Z,A=physical();forbidden=set()
 for cut in cuts:
  verify(X,Z,A,cut)
  for t in range(16):forbidden.add(frozenset(16*(i//16)+(i+t)%16 for i in [cut['anchor_X_index']]+cut['other_X_indices']))
 ax,az=d['anchor'];E=[(i,j) for i in range(720) if i!=ax and not A[i]>>az&1 for j in range(720) if j!=az and not A[ax]>>j&1 and A[i]>>j&1];left=sorted({i for i,j in E});right=sorted({j for i,j in E});owner={len(E)+k+1:(0,i) for k,i in enumerate(left)};owner.update({len(E)+len(left)+k+1:(1,j) for k,j in enumerate(right)});seen=set();lengths={}
 for row in tail:
  lits=list(map(int,row.split()));assert lits.pop()==0 and all(v<0 for v in lits);pairs=[owner[-v] for v in lits];assert pairs and len(set(side for side,i in pairs))==1;side=pairs[0][0];ids={i for _,i in pairs}|{ax if side==0 else az};assert any(frozenset(S) in forbidden for size in [2,3,4] for S in combinations(sorted(ids),size));key=tuple(lits);assert key not in seen;seen.add(key);lengths[len(lits)]=lengths.get(len(lits),0)+1
 out={'status':'PASS','source_C16_answered':False,'direct_original_witnesses_replayed':len(cuts),'distinct_translated_X_nogoods':len(forbidden),'new_clauses_checked':len(tail),'clause_lengths':lengths,'base_input_sha256':base['input_sha256'],'input_sha256':d['input_sha256'],'elapsed_seconds':time.monotonic()-start,'scope':'Baseline XNF preserved byte-for-byte after its header; every appended owner clause follows from a directly checked original-coordinate full-basis rank witness, translation, sector exchange and the selected anchor. Baseline encoder correctness is a separate replay dependency.'};a.output.write_text(json.dumps(out,indent=2)+'\n');print(out,flush=True)
if __name__=='__main__':main()
