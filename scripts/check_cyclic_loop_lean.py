"""Compile the complete persistence/tube proof chain in the pinned environment.

Run from any directory. Requires the project's existing mathlib dependencies;
this command changes no scientific inputs and introduces no proof shortcuts.
"""
from pathlib import Path
import json,subprocess,time,sys
ROOT=Path(__file__).resolve().parents[1]
PROJECT=ROOT/'formalization/dyadic-rank'
REPORT=ROOT/'formalization/cyclic-lifts'
MODULES=[('CyclicMergedMessages','loop-messages-dependency-check.log'),('CyclicMergedWitnesses','loop-matrix-dependency-check.log'),('CyclicDecoderPersistence','loop-persistence-lean-check.log'),('CyclicDecoderParity','loop-parity-lean-check.log'),('CyclicDecoderTubeData','loop-tube-data-check.log'),('CyclicDecoderTubeGraph','loop-tube-graph-check.log')]
for name in ['PreviousDevelopment','MinimumDevelopment','PreviousHoldout','MinimumHoldout']:
 MODULES.extend([('CyclicDecoderTubeData.'+name,'loop-data-'+name+'.log'),('CyclicDecoderTubes.'+name,'loop-proof-'+name+'.log')])
MODULES.append(('CyclicDecoderTubes','loop-all-tubes-check.log'))
REACH_MODULES=[('CyclicDecoderSensitivity','loop-sensitivity-lean-check.log'),('CyclicDecoderOriginal','loop-original-graph-check.log'),('CyclicDecoderOrbit','loop-orbit-check.log'),('CyclicDecoderReachData.Original','loop-reach-data-original.log'),('CyclicDecoderReachProofs.Original','loop-reach-proof-original.log'),('CyclicDecoderReachData.Merged','loop-reach-data-merged.log'),('CyclicDecoderReachProofs.Merged','loop-reach-proof-merged.log'),('CyclicDecoderOriginalMinimum','loop-original-minimum-graph-check.log'),('CyclicDecoderReachData.MinimumOriginal','loop-reach-data-minimum-original.log'),('CyclicDecoderReachProofs.MinimumOriginal','loop-reach-proof-minimum-original.log'),('CyclicDecoderReachData.MinimumMerged','loop-reach-data-minimum-merged.log'),('CyclicDecoderReachProofs.MinimumMerged','loop-reach-proof-minimum-merged.log'),('CyclicDecoderReachability','loop-reachability-lean-check.log'),('CyclicDecoderAudit','loop-final-axioms.log')]
REACH_ONLY='--reach-only' in sys.argv
MODULES=REACH_MODULES if REACH_ONLY else MODULES+REACH_MODULES

def run():
 results=[]
 for module,log in MODULES:
  relative=Path(*module.split('.'));target=PROJECT/'.lake/build/lib/lean'/relative.with_suffix('.olean');target.parent.mkdir(parents=True,exist_ok=True)
  command=['lake','env','lean','-j1','-o',str(target.relative_to(PROJECT)),str(relative.with_suffix('.lean'))]
  start=time.monotonic()
  print(module,'START',flush=True)
  with (REPORT/log).open('w') as output_file:process=subprocess.run(command,cwd=PROJECT,text=True,stdout=output_file,stderr=subprocess.STDOUT)
  output=(REPORT/log).read_text()
  assert process.returncode==0 and 'sorryAx' not in output and 'error:' not in output,(module,log)
  results.append(dict(module=module,status='passed',log=str((REPORT/log).relative_to(ROOT)),elapsed_seconds=time.monotonic()-start))
  print(module,'PASS',flush=True)
 (REPORT/('search/loop-reach-lean-build-results.json' if REACH_ONLY else 'search/loop-lean-build-results.json')).write_text(json.dumps(dict(status='reach_chain_passed' if REACH_ONLY else 'complete_chain_passed',modules=results),indent=2)+'\n')
if __name__=='__main__':run()
