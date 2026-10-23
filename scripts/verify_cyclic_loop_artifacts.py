"""Check the bounded-loop evidence and optionally record its artifact hashes.

This does not generate noise or rerun the scientific experiment. Use
--write-manifest only after the numerical validators and Lean builds pass.
"""
from pathlib import Path
from datetime import datetime,timezone
import hashlib,json,re,subprocess,sys
ROOT=Path(__file__).resolve().parents[1];HERE=ROOT/'formalization/cyclic-lifts';SEARCH=HERE/'search';MANIFEST=HERE/'loop-holdout-verification.json'

def sha(path):return hashlib.sha256(path.read_bytes()).hexdigest()
def read(name):return json.loads((SEARCH/name).read_text())

def verify():
 frozen=read('loop-holdout-selection.json');result=read('loop-holdout-results.json')
 assert result['independent_error_patterns']==2000000 and result['primary_decoder_executions']==4000000
 assert sha(SEARCH/'loop-holdout-selection.json')==result['selection_sha256']
 for rel,digest in frozen['sha256'].items():assert sha(ROOT/rel)==digest,rel
 validation=read('loop-holdout-validation.json');assert validation['primary_outcome_rows_reconstructed']==4000000 and validation['independent_error_patterns_regenerated']==2000000
 assert validation['independent_full_trajectory_replays']==28
 development=read('loop-development-validation.json');assert development['status']=='independent_development_checks_passed'
 assert development['sampled_interval_enclosures']==20000
 generation=read('loop-generation-validation.json')
 assert generation['status']=='all_generated_lean_sources_reproduce_byte_for_byte'
 for rel,digest in generation['sha256'].items():assert sha(ROOT/rel)==digest,rel
 tables=read('loop-lean-data-validation.json');assert tables['status']=='all_generated_balanced_lean_tables_round_trip' and tables['prefix_coordinates_checked']==224532
 builds=[read('loop-lean-build-results.json'),read('loop-reach-lean-build-results.json')]
 assert builds[1]['status']=='reach_chain_passed'
 modules={r['module']:r for build in builds for r in build['modules']}
 required=['CyclicDecoderTubes','CyclicDecoderReachability','CyclicDecoderReachProofs.Original','CyclicDecoderReachProofs.Merged','CyclicDecoderReachProofs.MinimumOriginal','CyclicDecoderReachProofs.MinimumMerged']
 assert all(name in modules for name in required)
 for name,rec in modules.items():
  assert rec['status']=='passed';output=(ROOT/rec['log']).read_text()
  assert 'error:' not in output and 'sorryAx' not in output,(name,rec['log'])
 audit=(HERE/'loop-final-axioms.log').read_text()
 assert 'error:' not in audit and 'sorryAx' not in audit
 modules['CyclicDecoderAudit']=dict(module='CyclicDecoderAudit',status='passed',log='formalization/cyclic-lifts/loop-final-axioms.log')
 allowed={'propext','Classical.choice','Quot.sound'}
 for group in re.findall(r'depends on axioms:\s*\[([^]]*)\]',audit,re.S):
  assert {name.strip() for name in group.split(',')}<=allowed,group
 for f in (ROOT/'formalization/dyadic-rank').glob('CyclicDecoder*.lean'):
  assert not re.search(r'\b(?:sorry|admit|native_decide)\b|^\s*axiom\s|skipKernelTC',f.read_text(),re.M),str(f.relative_to(ROOT))
 for directory in ['CyclicDecoderTubeData','CyclicDecoderTubes','CyclicDecoderReachData','CyclicDecoderReachProofs']:
  for f in (ROOT/'formalization/dyadic-rank'/directory).glob('*.lean'):
   assert not re.search(r'\b(?:sorry|admit|native_decide)\b|^\s*axiom\s|skipKernelTC',f.read_text(),re.M),str(f.relative_to(ROOT))
 cpp=[read('loop-reachability-validation.json'),read('loop-reachability-minimum-validation.json')]
 snapshots=sum(r['states'] for packet in cpp for r in packet['records']);assert snapshots==351
 assert all(packet['new_noise_patterns']==0 for packet in cpp)
 # Historical snapshots are verified at their own publication revisions.
 for rel,commit in [('formalization/cyclic-lifts/merged-million-verification.json','8e6efb6'),('formalization/cyclic-lifts/merged-mechanism-verification.json','4156628')]:
  packet=json.loads(subprocess.check_output(['git','show',commit+':'+rel],cwd=ROOT,text=True))
  for path,digest in packet['sha256'].items():
   raw=subprocess.check_output(['git','show',commit+':'+path],cwd=ROOT);assert hashlib.sha256(raw).hexdigest()==digest,(commit,path)
 print('Frozen inputs, all numerical validators, both Lean proof chains and historical snapshots PASS',flush=True)
 return modules,snapshots,tables

def candidates():
 files=set(subprocess.check_output(['git','diff','--name-only'],cwd=ROOT,text=True).splitlines())
 files.update(subprocess.check_output(['git','ls-files','--others','--exclude-standard'],cwd=ROOT,text=True).splitlines())
 allowed=[]
 for rel in files:
  owned=rel in ['README.md','PUBLICATION-STATUS.md','RESEARCH-LESSONS.md','formalization/cyclic-lifts/README.md'] or rel.startswith(('formalization/cyclic-lifts/LOOP-','formalization/cyclic-lifts/loop-','formalization/cyclic-lifts/search/loop','formalization/cyclic-lifts/search/develop_loop_','formalization/cyclic-lifts/search/generate_loop_','formalization/cyclic-lifts/search/report_loop_','formalization/dyadic-rank/CyclicDecoder','scripts/check_cyclic_loop_','scripts/validate_cyclic_loop_','scripts/verify_cyclic_loop_'))
  if owned and ROOT/rel!=MANIFEST and rel!='formalization/cyclic-lifts/loop-artifact-checks.log':allowed.append(rel)
 return sorted(allowed)

def content_checks(paths):
 for rel in paths:
  p=ROOT/rel;source=p.read_text()
  assert not re.search(r'/(?:Users|home)/|[A-Za-z0-9._%+-]+@(?:gmail|outlook|icloud)\.com',source,re.I),rel
  if p.suffix=='.py':compile(source,rel,'exec')
  if p.suffix=='.json':json.loads(source)
 for rel in ['formalization/cyclic-lifts/LOOP-HOLDOUT.md','formalization/cyclic-lifts/LOOP-DEVELOPMENT-PROTOCOL.md','formalization/cyclic-lifts/LOOP-HOLDOUT-PROTOCOL.md']:
  p=ROOT/rel
  for link in re.findall(r'\]\(([^)]+)\)',p.read_text()):
   if '://' not in link and not link.startswith('#'):
    target=p.parent/link.split('#')[0]
    if target==MANIFEST and '--write-manifest' in sys.argv:continue
    assert target.exists(),(rel,link)
 subprocess.run(['git','diff','--check'],cwd=ROOT,check=True)
 print('Artifact syntax, privacy, local links and whitespace PASS',flush=True)

def run():
 modules,snapshots,tables=verify()
 if '--write-manifest' in sys.argv:
  paths=candidates();content_checks(paths)
  out=dict(checked_at_utc=datetime.now(timezone.utc).isoformat(),status='frozen_holdout_and_complete_mathematical_decoder_certificates_verified',publication='included_in_repository_commit',previous_public_commit=subprocess.check_output(['git','rev-parse','HEAD'],cwd=ROOT,text=True).strip(),research_window=dict(started_at_utc='2026-10-23T20:15:30Z',deadline_utc='2026-10-23T22:15:30Z'),independent_fresh_error_patterns=2000000,primary_decoder_executions=4000000,trials_per_code=1000000,p=.04,decoder_parameters=dict(alpha_thousandths=800,maximum_iterations=100,integer_scale=1048576,message_cap=52428800,prior=3332431),lean_toolchain=(ROOT/'formalization/dyadic-rank/lean-toolchain').read_text().strip(),seeds=read('loop-holdout-results.json')['seeds'],frozen_candidates=3,complete_interval_tubes=4,complete_from_prior_comparisons=2,cpp_full_state_snapshots=snapshots,independent_heldout_full_trajectory_replays=28,generated_lean_numeric_entries_round_tripped=tables['numeric_entries_checked'],new_completed_inventory_targets=0,scope='Two fixed code/representation comparisons. Lean checks mathematical updates, finite persistence, exact prefixes and stopping certificates. C++ execution and sampling remain independently checked implementation bridges. Persistent-check coverage is limited; no isolated absorbing-count cause or universal predictor is established.',proof_checks=[dict(module=m,status='passed',log=r['log']) for m,r in modules.items()],checks=['all frozen scientific input hashes unchanged','four million outcomes, two million noise patterns, contrasts and detector summaries independently reconstructed','28 retained trajectories independently replayed; all 351 full C++ q/R states for complete examples match direct Python equations','all generated balanced Lean tables round-trip to reference states','all mathematical proof modules compile with no admitted proofs or native-decision shortcut','historical manifests verified at original publication revisions','syntax, JSON, privacy, links and git whitespace checks pass'],sha256={rel:sha(ROOT/rel) for rel in paths})
  MANIFEST.write_text(json.dumps(out,indent=2)+'\n');print('Verification manifest written',flush=True)
 else:
  packet=json.loads(MANIFEST.read_text());content_checks(packet['sha256'])
  for rel,digest in packet['sha256'].items():assert sha(ROOT/rel)==digest,rel
  print('All manifest artifact hashes PASS',flush=True)
if __name__=='__main__':run()
