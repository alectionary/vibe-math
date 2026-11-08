#!/usr/bin/env python3
"""Literal signed-XOR format conversion; no parity-chain expansion."""
from pathlib import Path
import argparse,gzip,hashlib,json
def main():
 ap=argparse.ArgumentParser();ap.add_argument('source',type=Path);ap.add_argument('output',type=Path);ap.add_argument('--omit-xor',action='store_true');a=ap.parse_args();raw=gzip.decompress(a.source.read_bytes());lines=raw.decode().splitlines();header=lines.pop(0).split();assert header[:2]==['p','xnf'];out=[];xors=0
 for row in lines:
  if '+' in row:
   xors+=1
   if a.omit_xor:continue
   row='x'+row.replace('+',' ')
  out.append(row)
 result=(f'p cnf {header[2]} {len(out)}\n'+'\n'.join(out)+'\n').encode();a.output.write_bytes(gzip.compress(result,mtime=0) if a.output.suffix=='.gz' else result);meta={'input_sha256':hashlib.sha256(raw).hexdigest(),'output_sha256':hashlib.sha256(result).hexdigest(),'xor_rows_seen':xors,'xor_rows_written':0 if a.omit_xor else xors,'rows':len(out),'variables':int(header[2])};a.output.with_suffix(a.output.suffix+'.json').write_text(json.dumps(meta,indent=2)+'\n');print(meta)
if __name__=='__main__':main()
