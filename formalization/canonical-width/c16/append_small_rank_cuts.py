#!/usr/bin/env python3
"""Append source-checked short conditional rank clauses to a full-anchor XNF."""
from pathlib import Path
import argparse,gzip,hashlib,json,time
from verify_algebraic_model import physical
ROOT=Path(__file__).resolve().parent

def main():
 ap=argparse.ArgumentParser();ap.add_argument('--base',type=Path,required=True);ap.add_argument('--cuts',type=Path,required=True);ap.add_argument('--replay',type=Path,required=True);ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();start=time.monotonic();meta=json.loads(a.base.read_text());raw=gzip.decompress((a.base.parent/meta['input_file']).read_bytes());assert hashlib.sha256(raw).hexdigest()==meta['input_sha256'];rep=json.loads(a.replay.read_text());assert rep['status']=='PASS' and rep['certificate_sha256']==hashlib.sha256(a.cuts.read_bytes()).hexdigest();X,Z,A=physical();ax,az=meta['anchor'];edges=[(i,j) for i in range(720) if i!=ax and not A[i]>>az&1 for j in range(720) if j!=az and not A[ax]>>j&1 and A[i]>>j&1];left=sorted({i for i,j in edges});right=sorted({j for i,j in edges});owners=[{i:len(edges)+k+1 for k,i in enumerate(left)},{j:len(edges)+len(left)+k+1 for k,j in enumerate(right)}];assert len(edges)==meta['free_edges'];cuts=json.loads(gzip.decompress(a.cuts.read_bytes()))['cuts'];clauses=set()
 for c in cuts:
  ids=[c['anchor_X_index']]+c['other_X_indices']
  for shift in range(16):
   moved=[16*(i//16)+(i+shift)%16 for i in ids]
   for side,fixed in [(0,ax),(1,az)]:
    if any(i!=fixed and i not in owners[side] for i in moved):continue
    clauses.add(tuple(sorted(-owners[side][i] for i in moved if i!=fixed)))
 lines=raw.decode().splitlines();header=lines.pop(0).split();assert header[:2]==['p','xnf'];new=sorted(clauses);out=(f'p xnf {header[2]} {int(header[3])+len(new)}\n'+'\n'.join(lines+[' '.join(map(str,c))+' 0' for c in new])+'\n').encode();a.output.with_suffix('.xnf.gz').write_bytes(gzip.compress(out,mtime=0));result={'status':'EXPORTED_FULL_ANCHOR_WITH_SMALL_RANK_CUTS','source_C16_answered':False,'anchor':meta['anchor'],'base_metadata_c16_path':str(a.base.resolve().relative_to(ROOT)),'base_input_sha256':meta['input_sha256'],'rank_cut_certificate_c16_path':str(a.cuts.resolve().relative_to(ROOT)),'rank_cut_certificate_sha256':hashlib.sha256(a.cuts.read_bytes()).hexdigest(),'added_clauses':len(new),'empty_added_clauses':sum(not c for c in new),'added_clause_lengths':{str(k):sum(len(c)==k for c in new) for k in range(5)},'variables':int(header[2]),'input_file':a.output.with_suffix('.xnf.gz').name,'input_sha256':hashlib.sha256(out).hexdigest(),'elapsed_seconds':time.monotonic()-start};a.output.write_text(json.dumps(result,indent=2)+'\n');print(result,flush=True)
if __name__=='__main__':main()
