#!/usr/bin/env python3
"""Check the frozen inversion results, optionally including external DRAT replay."""
import argparse,gzip,hashlib,json,subprocess,sys,tempfile
from pathlib import Path
from quotient_inverse_model import fold
from subgroup_frame import encode
from verify_pool_inverse_structure import verify

ROOT=Path(__file__).parent;DATA=ROOT/'inversion-results'
def cnf_bytes(X,Z,target,coverage):
 patterns=[[(x&z).bit_count()%2 for z in Z] for x in X]
 clauses,n=encode(patterns,target,coverage=coverage)
 return (f'p cnf {n} {len(clauses)}\n'+''.join(' '.join(map(str,c))+' 0\n' for c in clauses)).encode()
def main():
 ap=argparse.ArgumentParser();ap.add_argument('--output',type=Path,required=True);ap.add_argument('--drat-trim',type=Path);args=ap.parse_args();checks={}
 manifest=json.loads((DATA/'manifest.json').read_text())
 for path,want in manifest['SHA256'].items():assert hashlib.sha256((ROOT/path).read_bytes()).hexdigest()==want,path
 checks['frozen_file_hashes']=len(manifest['SHA256'])
 certificate=json.loads((DATA/'normal-form.json').read_text());checks['normal_form']=verify(certificate,ROOT)
 X=[int(v,16) for v in (ROOT/'pools/xcoords.txt').read_text().split()];Z=[int(v,16) for v in (ROOT/'pools/zcoords.txt').read_text().split()]
 tri=json.loads((DATA/'triangular-support.json').read_text());I=tri['X_indices'];J=tri['Z_indices'];assert len(set(I))==len(set(J))==128
 minor=[[(X[i]&Z[j]).bit_count()%2 for j in J] for i in I];assert all(minor[i][i]==1 and not any(minor[i][:i]) for i in range(128));assert sum(map(sum,minor))==464;checks['triangular_support_minor']=128
 for name,j,target in [('quotient1',1,8),('quotient1-seven',1,7),('quotient2',2,16)]:
  XX=sorted({fold(v,j) for v in X});ZZ=sorted({fold(v,j) for v in Z});raw=cnf_bytes(XX,ZZ,target,target==8*j);assert raw==gzip.decompress((DATA/(name+'.cnf.gz')).read_bytes())
  meta=json.loads((DATA/(name+'.json')).read_text());assert hashlib.sha256(raw).hexdigest()==meta['CNF_SHA256']
  if 'pairs' in meta:
   pairs=meta['pairs'];assert len(pairs)==target and all(x in XX and z in ZZ for x,z in pairs);assert all((x&z).bit_count()%2==(a==b) for a,(x,_) in enumerate(pairs) for b,(_,z) in enumerate(pairs))
 checks['regenerated_source_quotient_CNFs']=3;checks['residue_seven_pair_witness']='PASS'
 # These controls have source-independent factor dictionaries over R2.
 for name in ['cartesian-descent-control','cartesian-maximal-control']:
  d=json.loads((DATA/(name+'.json')).read_text());raw=gzip.decompress((DATA/(name+'.cnf.gz')).read_bytes());XX=d['X'];ZZ=d['Z']
  assert any(raw==cnf_bytes(XX,ZZ,8,coverage) for coverage in [False,True]),name
 checks['regenerated_small_Cartesian_CNFs']=2
 with tempfile.TemporaryDirectory(prefix='c16-inversion-replay-') as td:
  tmp=Path(td)
  for script,extra in [('test_pool_inverse_structure.py',[str(DATA/'normal-form.json')]),('verify_inversion_counterexamples.py',[]),('test_inverse_identity.py',[])]:
   out=tmp/(script+'.json');proc=subprocess.run([sys.executable,str(ROOT/script),*extra,'--output',str(out)],capture_output=True,text=True,timeout=60);assert proc.returncode==0,(script,proc.stdout,proc.stderr);checks[script]=json.loads(out.read_text())
  if args.drat_trim:
   proved=[]
   for name in ['quotient1','cartesian-descent-control','cartesian-maximal-control']:
    cnf=tmp/(name+'.cnf');proof=tmp/(name+'.drat');cnf.write_bytes(gzip.decompress((DATA/(name+'.cnf.gz')).read_bytes()));proof.write_bytes(gzip.decompress((DATA/(name+'.drat.gz')).read_bytes()))
    proc=subprocess.run([str(args.drat_trim),str(cnf),str(proof)],capture_output=True,text=True,timeout=60);assert proc.returncode==0 and 's VERIFIED' in proc.stdout,(name,proc.stdout,proc.stderr);proved.append(name)
   checks['DRAT_rechecks']=proved
  else:checks['DRAT_rechecks']='NOT_REQUESTED; prior checked proof logs retained'
 result={'status':'PASS','canonical_target_answered':False,'canonical_entry_delta':0,'eligible_target_delta':0,'completed_Lean_target_delta':0,'checks':checks};args.output.write_text(json.dumps(result,indent=2)+'\n');print(json.dumps({'status':'PASS','files':checks['frozen_file_hashes'],'DRAT':checks['DRAT_rechecks'],'canonical_target_answered':False}))
if __name__=='__main__':main()
