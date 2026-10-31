#!/usr/bin/env python3
"""Discovery-side dependency-cone trimming of text XLRUP proofs.

This is not a proof checker. Every trimmed result must pass cake_xlrup again.
Deletion steps are omitted; unsupported steps fail closed.
"""
from pathlib import Path
import argparse,hashlib,json,mmap,time
def parse(t):
 if not t or t[0]=='c':return None
 if t[0]=='d' or (t[0]=='x' and t[1]=='d') or (t[0].isdigit() and t[1]=='d'):return None
 if t[0]=='o':
  assert t[1]=='x';return ('X',int(t[2])),[],False
 if t[0]=='x':
  key=('X',int(t[1]));z=t.index('0',2);tail=t[z+1:];assert tail[-1]=='0';tail=tail[:-1]
  if 'u' in tail:
   u=tail.index('u');deps=[('X',int(v)) for v in tail[:u] if v!='0']+[('C',int(v)) for v in tail[u+1:] if v!='0']
  else:deps=[('X',int(v)) for v in tail if v!='0']
  return key,deps,False
 if t[0]=='i':
  assert t[1] in ['x','cx'];z=t.index('0',3);assert t[-1]=='0';key=('X' if t[1]=='x' else 'C',int(t[2]));deps=[('C' if t[1]=='x' else 'X',int(v)) for v in t[z+1:-1]];return key,deps,t[1]=='cx' and z==3
 assert t[0].isdigit();z=t.index('0',1);assert t[-1]=='0';return ('C',int(t[0])),[('C',int(v)) for v in t[z+1:-1]],z==1
def main():
 ap=argparse.ArgumentParser();ap.add_argument('instance',type=Path);ap.add_argument('proof',type=Path);ap.add_argument('output',type=Path);a=ap.parse_args();start=time.monotonic();originals=0
 with a.instance.open() as f:
  for line in f:
   s=line.strip()
   if s and not s.startswith(('c','p','x')):originals+=1
 needed=set();offsets=[];terminal=None;scanned=0
 with a.proof.open('rb') as file,mmap.mmap(file.fileno(),0,access=mmap.ACCESS_READ) as data:
  end=len(data)
  while end>0:
   if data[end-1:end]==b'\n':end-=1
   begin=data.rfind(b'\n',0,end)+1;line=data[begin:end];finish=end;end=begin;scanned+=1
   parsed=parse(line.decode('ascii').split())
   if parsed is None:continue
   key,deps,empty=parsed
   if terminal is None and empty:terminal=key;needed.add(key)
   if key not in needed:continue
   needed.remove(key);needed.update(deps);offsets.append((begin,finish))
  assert terminal is not None and all(kind=='C' and 1<=cid<=originals for kind,cid in needed),(terminal,len(needed))
  with a.output.open('wb') as out:
   for begin,finish in reversed(offsets):out.write(data[begin:finish]);out.write(b'\n')
 raw=a.output.read_bytes();out={'status':'TRIMMED_PROOF_CANDIDATE_REQUIRES_RECHECK','source_C16_answered':False,'input_clauses':originals,'terminal_clause':terminal,'input_proof_bytes':a.proof.stat().st_size,'output_proof_bytes':len(raw),'lines_scanned':scanned,'proof_steps_retained':len(offsets),'output_sha256':hashlib.sha256(raw).hexdigest(),'elapsed_seconds':time.monotonic()-start};a.output.with_suffix('.json').write_text(json.dumps(out,indent=2)+'\n');print(out)
if __name__=='__main__':main()
