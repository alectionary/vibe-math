"""Recheck this artifact with the pinned Lean/mathlib environment.

Use --project PATH to an existing Lake project with the pinned mathlib dependency,
or run lake update in this directory and omit --project. All checks are kernel
proofs; no native_decide, external axioms, or prebuilt research .oleans are used.
"""
import argparse, hashlib, json, os, re, subprocess, time
from pathlib import Path
ROOT=Path(__file__).resolve().parent
MODULES=['FourColumnClassification','GlobalCounting','OrderedRoots','PairEnergy',
 'PairFormulaCore','FourCompletions','PairRootBridge','CyclicNormalization','FiniteFourier','SocketFourier','SocketIncidence','CyclicFourierCount','GramCounterexample12','FanoBlock','ProjectionObstruction',
 'SmallQuantumData','FastQuantumData','QuantumConstruction','HGPIncidence','HGPPatterns',
 'HGPCounts','HGPGramObstruction','HGPCSS','HGPSpectral','SocketCompletion',
 'CompletionBridge','IncidenceEquivalence','QuantumReindex','AbsorbingFourTwo']

def main():
 parser=argparse.ArgumentParser(description=__doc__)
 parser.add_argument('--project',type=Path,default=None)
 parser.add_argument('modules',nargs='*')
 args=parser.parse_args()
 project=args.project or ROOT
 assert (project/'lean-toolchain').read_text().strip()==(ROOT/'lean-toolchain').read_text().strip(),'Lean toolchain mismatch'
 dependency=json.loads((project/'lake-manifest.json').read_text())
 mathlib=next(p for p in dependency['packages'] if p['name']=='mathlib')
 assert mathlib['rev']=='5f7b4198d22a9c82e1c698a379334fe128095c82','Mathlib revision mismatch'
 paths=subprocess.check_output(['lake','env','printenv','LEAN_PATH'],cwd=project,text=True).strip()
 lean=subprocess.check_output(['lake','env','which','lean'],cwd=project,text=True).strip()
 env=dict(os.environ,LEAN_PATH=str(ROOT)+':'+paths)
 records=[]
 defaults=MODULES
 manifest=ROOT/'verification.json'
 expected={}
 if manifest.exists():
  entries=json.loads(manifest.read_text())['lean_modules']
  defaults=[r['module'] for r in entries]
  expected={r['module']:r['source_sha256'] for r in entries}
 for module in args.modules or defaults:
  module=module.removesuffix('.lean')
  source=ROOT/(module+'.lean')
  before=hashlib.sha256(source.read_bytes()).hexdigest()
  if module in expected:assert before==expected[module],('Source differs from checked artifact',module)
  command=[lean,'-R',str(ROOT),'-M','6000','-o',str(source.with_suffix('.olean')),str(source)]
  start=time.monotonic()
  with source.with_suffix('.log').open('w') as log:
   result=subprocess.run(command,cwd=ROOT,env=env,stdout=log,stderr=subprocess.STDOUT)
  record=dict(module=module,exit_code=result.returncode,seconds=time.monotonic()-start,
   sha256=hashlib.sha256(source.read_bytes()).hexdigest())
  assert record['sha256']==before,('Source changed during check',module)
  if result.returncode==0:
   body=source.with_suffix('.log').read_text()
   assert 'sorryAx' not in body,('Incomplete proof',module)
   for match in re.finditer(r'depends on axioms: \[([^\]]*)\]',body):
    assert {x.strip() for x in match.group(1).split(',') if x.strip()} <= {'propext','Classical.choice','Quot.sound'},('Unexpected axiom',module)
  records.append(record)
  print(module,'exit',result.returncode,'seconds',round(record['seconds'],2),flush=True)
  if result.returncode:
   print(source.with_suffix('.log').read_text()[-6000:])
   break
 (ROOT/'recheck-results.json').write_text(json.dumps(records,indent=2)+'\n')
 raise SystemExit(any(r['exit_code'] for r in records))
if __name__=='__main__':main()
