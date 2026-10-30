"""Structural and numerical bookkeeping checks; not independent scientific review."""
import csv,json,pathlib,sys,itertools
sys.dont_write_bytecode=True
sys.path.insert(0,str(pathlib.Path('../../.agents/skills/replication-paper/scripts').resolve()))
from contrast_checks import contrast,validate_contrast_coverage,validate_inventory
from checks import validate_ledger
rows=list(csv.DictReader(open('outputs/signed-contrasts.csv')));records=[];inventory=[]
for r in rows:
 condition=f"{r['mechanism']}/q{r['q']}/m{r['missing']}/{r['parameter']}";records.append(dict(analysis=r['metric'],condition=condition))
 c=contrast(float(r['source_deletion_minus_full']),float(r['contrast_delete_minus_full']),'SE(deletion) minus SE(full information); positive means full information has smaller estimated SE')
 inventory.append(dict(role='headline'if r['metric']=='se'and r['missing']!='0.03'else'supporting',claim='Missing-covariate precision contrast '+condition,kind='contrast',source_contrast=float(r['source_deletion_minus_full']),ours_contrast=float(r['contrast_delete_minus_full']),numerical='withheld',scope='limited',uncertainty_decision=r['band_status'],**c))
expected=[(metric,f'{mech}/q{q}/m{m}/{param}')for metric,mech,q,m,param in itertools.product(['se','path_se'],['MCAR','MAR','MNAR'],range(2,6),['0.02','0.03','0.06','0.1'],['A','C','E'])]
coverage=list(csv.DictReader(open('coverage.csv')))
report=dict(contrast_conditions=len(records),expected_conditions=len(expected),contrast_coverage_errors=validate_contrast_coverage(records,expected),signed_inventory_errors=validate_inventory(inventory),ledger_errors=validate_ledger(json.load(open('provenance/compliance.json'))),whole_dissertation_groups=len(coverage),unattempted_groups=[r['id']for r in coverage if r['status']=='pending'],invalid_statuses=[r['id']for r in coverage if r['status']not in ['pending','replicated','attempted/unresolved','blocked']],independent_review='See provenance/review.json for hash-matched independent reviews; this checker does not establish approval')
conditions=list(csv.DictReader(open('outputs/condition-summary.csv')));report['replicate_counts']=sorted(set(int(r['requested'])for r in conditions));report['nonzero_optimizer_rows']=sum(int(r['failed'])for r in conditions)
pathlib.Path('provenance/validation.json').write_text(json.dumps(report,indent=2));pathlib.Path('provenance/signed-claim-inventory.json').write_text(json.dumps(inventory,indent=2));print(json.dumps(report,indent=2))
assert not report['contrast_coverage_errors']+report['signed_inventory_errors']+report['ledger_errors']+report['invalid_statuses']
