"""Repeat bounded lexical discovery against the recorded pinned Lean sources."""
import pathlib,json,subprocess,sys
R=pathlib.Path(__file__).resolve().parent.parent
if len(sys.argv)!=2:raise SystemExit('Usage: python3 scripts/search_downstream_lean.py SOURCE_ROOT')
root=pathlib.Path(sys.argv[1]).resolve()
families={
'neural_codes':r'neural.?code|intersection.?complete|Ferrers|simply.?redundant',
'support_varieties':r'cohomological.?support|GCD.?graph|support.?variet',
'streaming_prediction':r'Shtarkov|turnstile|M[- ]open|bias.variance',
'quantum_dyadic':r'dyadic.?matrix|dyadic.?matrices|absorbing.?set|quasi.dyadic|Gallager',
'change_point':r'changepoint|change.point|\bGRACE\b|transition.?dictionary',
'weighted_geometry':r'weighted.?projective|Boroczky|Böröczky|SHGH|Horace',
'differential_operators':r'linearly.?simple|linear.?simplicity|sandwich.?Bernstein|Levasseur',
'fluid_pde':r'calmed|Ohmic|Kuramoto|Leray.?Hopf|Hall.MHD',
'partition_geometry':r'secluded|neighborhood.?Sperner|list.?replicab|dissection.*triang',
'privacy':r'MSSP|randomness.utility|randomness.?complexity|K.norm.?mechanism',
'saturation_games':r'saturation.?game|generalized.?saturation|saturated.*star|star.*saturated'}
rows=[]
for s in json.load(open(R/'audit/sources.json')):
 p=root/s['id'];rev=subprocess.check_output(['git','-C',str(p),'rev-parse','HEAD'],text=True).strip();assert rev==s['revision']
 for f,pat in families.items():
  c=subprocess.run(['rg','-l','-i','--glob','*.lean',pat,str(p)],capture_output=True,text=True);assert c.returncode in (0,1)
  files=sorted(str(pathlib.Path(x).relative_to(p)) for x in c.stdout.splitlines());rows.append(dict(repository=s['id'],revision=rev,family=f,regex=pat,exit_code=c.returncode,matching_files=files))
  if files:print(s['id'],f,len(files),files[:7])
(R/'literature/downstream-lean-searches.json').write_text(json.dumps(dict(checked_on='2026-10-21',scope='Pinned sources as described in ../audit/sources.json; lexical discovery only, not semantic completeness.',searches=rows),indent=2)+'\n')
