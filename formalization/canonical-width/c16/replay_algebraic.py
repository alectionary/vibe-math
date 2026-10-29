#!/usr/bin/env python3
"""Bounded independent replay of the frozen six-hour algebraic evidence.

Run from a clean checkout with the scientific Python environment, a DRAT-trim
binary and the pinned official cake_xlrup executable. No new source-problem search is run; tiny encoding controls may use SAT.
"""
from pathlib import Path
import argparse,hashlib,json,subprocess,sys,time
ROOT=Path(__file__).resolve().parent;R=ROOT/'algebraic-results'
def main():
 ap=argparse.ArgumentParser();ap.add_argument('--drat-trim',type=Path,required=True);ap.add_argument('--xlrup-checker',type=Path,required=True);ap.add_argument('--profile-binary',type=Path);ap.add_argument('--output',type=Path,required=True);ap.add_argument('--skip-cover',action='store_true');ap.add_argument('--skip-cohort',action='store_true');a=ap.parse_args();start=time.monotonic();folder=a.output.parent;folder.mkdir(parents=True,exist_ok=True);records=[]
 def run(name,script,args=(),limit=240,extra_output=True,nested=False):
  subfolder=folder/name if nested else folder;subfolder.mkdir(parents=True,exist_ok=True);out=subfolder/('summary.json' if nested else name+'.json');cmd=[sys.executable,str(ROOT/script),*map(str,args)]+(['--output',str(out)] if extra_output else []);t=time.monotonic();r=subprocess.run(cmd,capture_output=True,text=True,timeout=limit);(folder/(name+'.log')).write_text(r.stdout+r.stderr);assert r.returncode==0,(name,r.returncode,r.stdout[-1000:],r.stderr[-1000:]);data=json.loads(out.read_text()) if extra_output else {'status':'PASS'};assert str(data['status']).startswith('PASS'),(name,data.get('status'));record={'name':name,'status':'PASS','elapsed_seconds':time.monotonic()-t,'command':cmd,'report_sha256':hashlib.sha256(out.read_bytes()).hexdigest() if extra_output else None};records.append(record);a.output.write_text(json.dumps({'status':'RUNNING','records':records},indent=2)+'\n');print('REPLAY PASS',name,round(record['elapsed_seconds'],2),flush=True);return data
 run('prefix-counter-controls','verify_prefix_counter.py')
 run('physical88','verify_partial_frame.py',[ROOT/'partial-frame-88.json'],extra_output=False)
 for domain in ['control','hard']:
  for suffix in ['', '-amo']:run(f'formal-{domain}{suffix}','verify_algebraic_model.py',['--domain',R/(domain+'.json'),'--certificate',R/f'quadratic-{domain}{suffix}.json'])
 run('affine-degree-cutters','verify_affine_degree_cutters.py')
 run('inverse-linear-all428','verify_conditional_spans.py',['--survey',R/'span-survey.json'],limit=420)
 for suffix in ['', '-triples']:run('inverse-flats'+suffix,'verify_inverse_flat_cuts.py',['--certificate',R/f'inverse-flats{suffix}.json.gz'])
 run('phase-unconditioned','verify_orbit_rank_profiles.py',['--certificate',R/'orbit-rank-profiles.json'])
 for name in ['anchor48','xonly-48','xonly-192']:
  run('quotient-'+name,'verify_anchor_quotient.py',['--metadata',R/f'{name}-quotient.json'])
  run('phase-'+name,'verify_orbit_rank_profiles.py',['--certificate',R/f'{name}-rank-profiles.json','--quotient-metadata',R/f'{name}-quotient.json'])
 run('anchor-profile-comparison','compare_anchor_profiles.py')
 run('profile-hulls','verify_profile_hulls.py',['--profiles',R/'orbit-rank-profiles.json','--hulls',*[R/f'hulls-{P}-{mode}.json.gz' for P in [8,16] for mode in ['basic','rank']]])
 run('exact-basic-point-strengthening','verify_exact_capacity_strengthening.py',limit=300)
 run('characteristic-two-guard','verify_symmetry_characteristic_guard.py')
 run('halfturn-added-clauses','verify_halfturn_profiles.py',['--base',R/'halfturn-baseline.cnf','--cnf',R/'halfturn-profiles.cnf','--profiles',R/'orbit-rank-profiles.json','--replay',R/'orbit-rank-profiles-independent.json'])
 for name in ['xnf','coverage','profiles','conditioned-profiles']:run('full-anchor-'+name,'verify_full_anchor_model.py',['--metadata',R/f'full-anchor-{name}.json'])
 if a.profile_binary:run('quotient-literal-controls','profile_quotient_controls.py',['--binary',a.profile_binary])
 if not a.skip_cohort:
  for stem in ['conditional-capacity','conditional-cross-capacity']:
   cohort=run(stem+'-all45','verify_conditional_capacity_cohort.py',['--cohort',R/(stem+'/cohort.json'),'--seconds','1500','--workers','2'],limit=1600,nested=True);frozen=json.loads((R/(stem+'/independent.json')).read_text());assert cohort['capacity_matrix']==frozen['capacity_matrix']
 run('quotient-restriction-identity','verify_quotient_restriction_identity.py',['--original',R/'orbit-rank-profiles.json','--cohort',R/'conditional-cross-capacity/cohort.json'])
 run('small-original-rank-cuts','small_conditional_rank_cuts.py',['--cohort',R/'conditional-capacity/cohort.json','--replay',R/'conditional-capacity/independent.json','--certificate',R/'small-conditional-original.json.gz','--verify-only'])
 run('full-anchor-short-clauses','verify_appended_small_rank_cuts.py',['--metadata',R/'full-anchor-small-rank.json'])
 run('fractional-cover-lower-bound','fractional_cover_packing.py',['--certificate',R/'fractional-cover-packing.json','--verify-only'])
 run('hard-original-DRAT','verify_conditional_drat.py',['--domain',R/'hard.json','--metadata',R/'hard-cadical.json','--drat-trim',a.drat_trim])
 run('weighted-conditional-separation','conditional_hull_separation.py',['--point',R/'profile-moment-rational.json.gz','--attempt',R/'conditional-hulls-all.json.gz','--hulls',R/'hulls-16-rank.json.gz','--x-cohort',R/'conditional-capacity/cohort.json','--z-cohort',R/'conditional-cross-capacity/cohort.json','--certificate',R/'conditional-facets-round1.json','--verify-only'])
 run('exact-profile-second-point','certify_profile_moment_point.py',['--hulls',R/'hulls-16-rank.json.gz','--capacities',R/'orbit-rank-profiles-independent.json','--conditional',R/'conditional-capacity/independent.json','--conditional-cross',R/'conditional-cross-capacity/independent.json','--weighted-cuts',R/'conditional-facets-round1-independent.json','--certificate',R/'profile-moment-face1.json.gz','--verify-only'])
 run('all-conditional-local-hulls','conditional_profile_hull_witness.py',['--point',R/'profile-moment-face1.json.gz','--x-cohort',R/'conditional-capacity/cohort.json','--z-cohort',R/'conditional-cross-capacity/cohort.json','--x-replay',R/'conditional-capacity/independent.json','--z-replay',R/'conditional-cross-capacity/independent.json','--hulls',R/'hulls-16-rank.json.gz','--anchors','45','--workers','2','--seconds','900','--certificate',R/'conditional-hulls-face1.json.gz','--verify-only'],limit=1000)
 run('all-anchor-absent-original-hulls','conditional_profile_hull_witness.py',['--point',R/'profile-moment-face1.json.gz','--condition-value','0','--unconditional-profiles',R/'orbit-rank-profiles.json','--x-cohort',R/'conditional-capacity/cohort.json','--z-cohort',R/'conditional-cross-capacity/cohort.json','--x-replay',R/'conditional-capacity/independent.json','--z-replay',R/'conditional-cross-capacity/independent.json','--hulls',R/'hulls-16-rank.json.gz','--anchors','45','--workers','2','--seconds','900','--certificate',R/'conditional-hulls-absent.json.gz','--verify-only'],limit=1000)
 run('deleted336-original-witnesses','verify_orbit_rank_profiles.py',['--certificate',R/'absent336-Z-profiles.json.gz','--absent-X-index','336'])
 run('deleted336-mask-comparison','verify_absent_profile_comparison.py',['--original',R/'orbit-rank-profiles.json','--deleted',R/'absent336-Z-profiles.json.gz'])
 run('deleted336-local-hulls','absent_profile_hull_pilot.py',['--point',R/'profile-moment-face1.json.gz','--profile',R/'absent336-Z-profiles.json.gz','--hulls',R/'hulls-16-rank.json.gz','--certificate',R/'absent336-hulls.json.gz','--verify-only'])
 for stem,proof in [('hard-native',R/'hard-native-trimmed.xlrup.xz'),('hard-native-compact',R/'hard-native-compact.xlrup.xz')]:run(stem,'verify_conditional_native.py',['--domain',R/'hard.json','--metadata',R/(stem+'.cnf.json'),'--proof',proof,'--checker',a.xlrup_checker])
 rational=R/'profile-moment-rational-independent.json'
 if rational.exists() and json.loads(rational.read_text()).get('status')=='PASS':run('exact-profile-relaxation','certify_profile_moment_point.py',['--hulls',R/'hulls-16-rank.json.gz','--capacities',R/'orbit-rank-profiles-independent.json','--conditional',R/'conditional-capacity/independent.json','--certificate',R/'profile-moment-rational.json.gz','--verify-only'],limit=420)
 if not a.skip_cover:run('final-cover','verify_cover_exchanges.py',['--chain',R/'exchange/chain.json','--drat-trim',a.drat_trim],limit=1800)
 result={'status':'PASS','source_C16_answered':False,'records':records,'source_commit':subprocess.check_output(['git','rev-parse','HEAD'],cwd=ROOT,text=True).strip(),'dirty_checkout':bool(subprocess.check_output(['git','status','--porcelain'],cwd=ROOT,text=True).strip()),'elapsed_seconds':time.monotonic()-start,'cover_replayed':not a.skip_cover,'conditional_cohort_replayed':not a.skip_cohort,'scope':'Independent exact consumers only; bounded solver UNKNOWN and numerical feasible experiments remain unresolved. Prior physical-pool completeness and source-to-width bridge remain separately pinned dependencies.'};a.output.write_text(json.dumps(result,indent=2)+'\n');print('ALGEBRAIC REPLAY PASS',len(records),'checks',round(result['elapsed_seconds'],2),flush=True)
if __name__=='__main__':main()
