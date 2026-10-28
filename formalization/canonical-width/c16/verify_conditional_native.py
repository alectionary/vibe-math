#!/usr/bin/env python3
"""Independent physical native-parity input binding and official XLRUP replay."""
from pathlib import Path
import argparse,gzip,hashlib,json,lzma,shutil,subprocess,tempfile,time
from verify_algebraic_model import domain
from verify_signature_cover import independent_cnf
def main():
 ap=argparse.ArgumentParser();ap.add_argument('--domain',type=Path,required=True);ap.add_argument('--metadata',type=Path,required=True);ap.add_argument('--proof',type=Path,required=True);ap.add_argument('--checker',type=Path,required=True);ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();start=time.monotonic();source=json.loads(a.domain.read_text());A,E,t,r=domain(source);d=json.loads(a.metadata.read_text());assert d['anchor']==source['anchor'] and d['trial_removed']==source['removed_classes'];cnf,n,_,_=independent_cnf(A,[0],[(*e,0) for e in E],False,nbits=0);lines=[' '.join(map(str,c))+' 0' for c in cnf]
 for k in range(r):
  lits=[i for i,(_,_,s) in enumerate(E,1) if s>>k&1];assert lits
  if not t>>k&1:lits[0]=-lits[0]
  lines.append('x'+' '.join(map(str,lits))+' 0')
 raw=(f'p cnf {n} {len(lines)}\n'+'\n'.join(lines)+'\n').encode();assert n==d['variables'] and len(cnf)==d['CNF_clauses'] and r==d['native_XORs'];assert hashlib.sha256(raw).hexdigest()==d['input_sha256'] and gzip.decompress((a.metadata.parent/d['input_file']).read_bytes())==raw;assert all(cnf)
 with tempfile.TemporaryDirectory(prefix='c16-native-exact-replay-') as folder:
  ip=Path(folder)/'input.cnf';pp=Path(folder)/'proof.xlrup';ip.write_bytes(raw);opener=gzip.open if a.proof.suffix=='.gz' else lzma.open if a.proof.suffix=='.xz' else open
  with opener(a.proof,'rb') as inp,pp.open('wb') as out:shutil.copyfileobj(inp,out)
  digest=hashlib.sha256()
  with pp.open('rb') as inp:
   while chunk:=inp.read(1048576):digest.update(chunk)
  run=subprocess.run([str(a.checker),'--no-binary',str(ip),str(pp)],capture_output=True,text=True,timeout=180);assert run.returncode==0 and 's VERIFIED UNSAT' in run.stdout.splitlines(),run.stdout+run.stderr
  empty=Path(folder)/'empty.xlrup';empty.write_text('');bad=subprocess.run([str(a.checker),'--no-binary',str(ip),str(empty)],capture_output=True,text=True,timeout=30);assert 's VERIFIED UNSAT' not in bad.stdout.splitlines()
 out={'status':'PASS','source_C16_answered':False,'physical_pairings_rebuilt':518400,'variables':n,'clauses':len(cnf),'native_XORs':r,'input_sha256':d['input_sha256'],'proof_uncompressed_sha256':digest.hexdigest(),'checker_binary_sha256':hashlib.sha256(a.checker.read_bytes()).hexdigest(),'checker_output':run.stdout.strip(),'empty_proof_rejected':True,'elapsed_seconds':time.monotonic()-start,'scope':'Checked old restricted1252-edge conditional parity domain, not an unrestricted original anchor exclusion. Native XOR solving is accepted only after physical input regeneration and official checker replay.'};a.output.write_text(json.dumps(out,indent=2)+'\n');print(out)
if __name__=='__main__':main()
