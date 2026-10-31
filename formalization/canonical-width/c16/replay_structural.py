#!/usr/bin/env python3
"""Replay the frozen structural comparison without running open-ended searches."""
import argparse
import gzip
import hashlib
import json
from pathlib import Path
import subprocess
import sys
import tempfile


def main():
 ap=argparse.ArgumentParser();ap.add_argument('--drat-trim',type=Path);ap.add_argument('--output',type=Path,required=True);args=ap.parse_args();root=Path(__file__).resolve().parent;results=root/'structural-results';steps=[]
 def run(name,command,seconds=300):
  print('CHECK',name,flush=True);r=subprocess.run(command,capture_output=True,text=True,timeout=seconds);assert r.returncode==0,(name,r.stdout[-1000:],r.stderr[-1000:]);steps.append({'name':name,'status':'PASS'})
 manifest=results/'manifest.json'
 if manifest.exists():
  for item in json.loads(manifest.read_text())['files']:
   path=root.parents[2]/item['path'];assert hashlib.sha256(path.read_bytes()).hexdigest()==item['sha256'],item['path']
 with tempfile.TemporaryDirectory(prefix='c16-structural-replay-') as folder:
  temp=Path(folder);inputs=temp/'inputs';inputs.mkdir()
  for p in (results/'inputs').iterdir():
   (inputs/(p.name[:-3] if p.suffix=='.gz' else p.name)).write_bytes(gzip.decompress(p.read_bytes()) if p.suffix=='.gz' else p.read_bytes())
  certificate=temp/'moment.json';certificate.write_bytes(gzip.decompress((results/'c16-structural-sdp-certified.rational.json.gz').read_bytes()))
  py=sys.executable
  run('frozen rational moment consumer',[py,str(root/'verify_moment_certificate.py'),str(certificate),'--output',str(temp/'moment-check.json')])
  run('moment positive and negative controls',[py,str(root/'test_moment_certificate.py'),str(certificate),str(temp/'moment-controls.json')])
  run('physical88 phase-shape positive control',[py,str(root/'test_shape_marginals.py'),str(inputs),str(temp/'shape-control.json')])
  cuts=[]
  for stem in ['master-highs','master-baseline']:
   p=results/f'c16-structural-{stem}.cuts.jsonl';dest=temp/p.name;dest.write_bytes(p.read_bytes());cuts.append(str(dest))
  run('exact cut and Hall controls',[py,str(root/'verify_structural_controls.py'),str(inputs),'--cuts',*cuts,'--output',str(temp/'structural-controls.json')])
  run('frozen conditional Hall comparison',[py,str(root/'compare_owner_hall.py'),str(inputs),'--output',str(temp/'hall.json')])
  fresh=json.loads((temp/'hall.json').read_text());old=json.loads(gzip.decompress((results/'c16-structural-hall.json.gz').read_bytes()))
  assert fresh['stats']==old['stats'] and fresh['rows']==old['rows']
  run('cyclic filtration identities',[py,str(root/'cyclic_filtration_audit.py')])
  run('literal subgroup CNF controls',[py,str(root/'test_subgroup_frames.py')])
  for L in [4,8,16]:
   stem=f'c16-structural-subgroup-{L}';out=temp/(stem+'.json')
   run(f'regenerate order{L} CNF',[py,str(root/'subgroup_frame.py'),'--order',str(L),'--output',str(out),'--kissat','unused','--drat-trim','unused','--encode-only'])
   prior=json.loads((results/(stem+'.json')).read_text());assert json.loads(out.read_text())['cnf_sha256']==prior['cnf_sha256']
   assert out.with_suffix('.cnf').read_bytes()==gzip.decompress((results/(stem+'.cnf.gz')).read_bytes())
   if args.drat_trim:
    proof=temp/(stem+'.drat');proof.write_bytes(gzip.decompress((results/(stem+'.drat.gz')).read_bytes()));assert hashlib.sha256(proof.read_bytes()).hexdigest()==prior['proof_sha256']
    run(f'check order{L} DRAT',[str(args.drat_trim),str(out.with_suffix('.cnf')),str(proof)])
  result={'status':'PASS','steps':steps,'DRAT_rechecked':args.drat_trim is not None,'canonical_width_still':[16,18],'best_physical_partial_frame_pairs':88,'Lean_completion':False};args.output.write_text(json.dumps(result,indent=2)+'\n');print(json.dumps(result),flush=True)

if __name__=='__main__':main()
