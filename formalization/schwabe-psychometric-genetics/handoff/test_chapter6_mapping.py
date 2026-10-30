"""Baseline-only mapping and adversarial tests. No live production effects."""
import copy,importlib.util,json,pathlib,tempfile
root=pathlib.Path(__file__).resolve().parents[1]
s=importlib.util.spec_from_file_location('mapper',root/'handoff/map_chapter6_results.py');m=importlib.util.module_from_spec(s);s.loader.exec_module(m)
source=(root/'simulation/test_production_analysis.py').read_text().split("run('preserved20repbaseline_numeric_and_inventory'")[0]
f={};exec(compile(source,'independent-baseline-fixture','exec'),f)
checks=[]
with tempfile.TemporaryDirectory(prefix='schwabe-map-fixture-') as td:
 p=pathlib.Path(td);f['write'](p/'reports',f['records'],f['rows'],f['counts'])
 f['a'].analyze(p/'reports',p/'analysis',root/'outputs/source-figure-values.csv',root/'production/analysis-plan.json')
 spec=root/'handoff/claim-specification.json';digest=m.snapshot_sha(m.snapshot(p/'analysis'))
 mapped=m.map_results(spec,p/'analysis',digest,fixture=True)
 assert mapped['inventory']==dict(source_claim_ids=408,source_figure_points=288,unique_primary_variance_SE_contrasts=108,unique_MAR_bias_contrasts=72)
 byid={r['claim_id']:r for r in mapped['claims']}
 assert len(byid['H6.precision-grid']['contrasts'])==108
 assert all(r['computed_value'] is None for r in byid['H6.power-assertion']['contrasts'])
 assert byid['C6-6.6.3.male']['computed_value'] is None and not byid['C6-6.6.3.male']['mappings']
 assert len(byid['C6-5.beta-recovery']['mappings'])==336
 assert len(mapped['sensitivity_SE_contrasts'])==72
 assert 'status' not in byid['H6.precision-grid']
 checks.append('All408IDs,288sourcepoints,108uniquevarianceSE,72bias cells; no empirical/power substitution')
 r=byid['C6-2.fig6.3.q2.missing0.02.A.full'];assert r['computed_value']!=r['exploratory_path_SE']['computed_value']
 checks.append('Variance/path and2%/3% sensitivity remain distinct')
 def reject(label,action):
  try:action()
  except ValueError:checks.append('Rejected '+label)
  else:raise AssertionError(label)
 reject('wrong snapshot',lambda:m.map_results(spec,p/'analysis','bad',fixture=True))
 reject('absent terminal attestation',lambda:m.map_results(spec,p/'analysis',digest))
 terminal={'state':'wall_time_cap','active_processes':0,'observed_utc':'2026-10-30T23:00:00+00:00','analysis_snapshot_sha256':digest}
 tp=p/'terminal.json'
 for label,change in [('boolean process count',{'active_processes':False}),('non-UTC observed time',{'observed_utc':'2026-10-30T23:00:00'}),('false completed target',{'state':'completed'})]:
  tp.write_text(json.dumps({**terminal,**change}));reject(label,lambda:m.map_results(spec,p/'analysis',digest,tp))
 original=json.loads(spec.read_text())
 for label,edit in [('missing source ID',lambda x:x['claims'].pop()),('wrong source method',lambda x:next(r for r in x['claims'] if r['id']=='C6-2.fig6.3.q2.missing0.02.A.full')['conditions'].update(method='deletion')),('source value mismatch',lambda x:next(r for r in x['claims'] if r['id']=='C6-2.fig6.3.q2.missing0.02.A.full')['published'].update(value=999))]:
  changed=copy.deepcopy(original);edit(changed);sp=p/'changed-spec.json';sp.write_text(json.dumps(changed));reject(label,lambda:m.map_results(sp,p/'analysis',digest,fixture=True))
 # Mutate a complete analysis row without changing length; snapshot is honestly refreshed.
 csv=p/'analysis/signed-SE-contrasts.csv';old=csv.read_text();lines=old.splitlines();lines[-1]=lines[-2];csv.write_text('\n'.join(lines)+'\n')
 reject('duplicate contrast grid',lambda:m.map_results(spec,p/'analysis',m.snapshot_sha(m.snapshot(p/'analysis')),fixture=True));csv.write_text(old)
print(json.dumps({'passed':True,'scope':'Preserved baseline/synthetic fixtures only; no actual terminal mapping','checks':checks},indent=2))
