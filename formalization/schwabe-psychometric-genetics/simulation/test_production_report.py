"""Baseline-only builder fixtures; no new production outcomes or baseline writes."""
import importlib.util, json, pathlib, subprocess, tempfile
root=pathlib.Path('.').resolve()
# Load only independent fixture construction, stopping before its first test call.
source=(root/'simulation/test_production_analysis.py').read_text().split("run('preserved20repbaseline_numeric_and_inventory'")[0]
fixture={};exec(compile(source,'independent-baseline-fixture','exec'),fixture)
spec=importlib.util.spec_from_file_location('builder',root/'simulation/build_production_report.py')
b=importlib.util.module_from_spec(spec);spec.loader.exec_module(b)
checks=[]
with tempfile.TemporaryDirectory(prefix='schwabe-report-fixture-') as td:
 p=pathlib.Path(td);fixture['write'](p/'reports',fixture['records'],fixture['rows'],fixture['counts'])
 fixture['a'].analyze(p/'reports',p/'analysis',root/'outputs/source-figure-values.csv',root/'production/analysis-plan.json')
 fixture['baseline'](json.loads((p/'analysis/summary.json').read_text()),p/'analysis')
 manifest=b.build(p/'analysis',p/'paper');m=manifest['numeric_macros']
 assert (m['CompletedFits'],m['ValidFits'],m['InvalidFits'],m['FailedSlots'])==('1920','1920','0','0')
 assert (m['CompletedMinRep'],m['CompletedMaxRep'])==('20','20')
 assert (m['VarianceOutside'],m['PathOutside'],m['PositiveBands'],m['BiasReversals'])==('191','0','104','23')
 checks.append('Preserved baseline counts, repetitions and 23 point reversals match')
 assert len((p/'paper/production-reversals.tex').read_text().split('Bias MAR'))==24
 assert float(m['AvarianceOurs'])!=float(m['ApathOurs'])
 assert m['HbiasGeneratingTruth']=='0.5'
 checks.append('Variance/path distinction and residual h2 truth preserved')
 assert all(b.sha(p/'analysis'/name)==value for name,value in manifest['input_sha256'].items())
 checks.append('Input hashes match exact frozen analyzer files')
 try: b.build(p/'analysis',p/'paper')
 except ValueError: pass
 else: raise AssertionError('Overwrite was allowed')
 checks.append('Existing generated outputs protected')
 # Compile only temporary tables; no main manuscript paths touched.
 tex=r'\documentclass{article}\usepackage[margin=.6in]{geometry}\usepackage{longtable,booktabs}\begin{document}'+'\n'
 for name in manifest['output_sha256']:
  tex+='\\input{'+name+'}\n'
 tex+=r'\end{document}';(p/'paper/check.tex').write_text(tex)
 subprocess.run(['pdflatex','-interaction=nonstopmode','-halt-on-error','check.tex'],cwd=p/'paper',check=True,stdout=subprocess.DEVNULL)
 checks.append('All generated LaTeX compiles in temporary document')
print(json.dumps({'status':'passed','checks':checks,'scope':'Preserved baseline and temporary files only'},indent=2))
