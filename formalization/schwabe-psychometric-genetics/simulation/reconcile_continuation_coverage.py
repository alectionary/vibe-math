"""Additive operational ledger. Does not change frozen scientific adjudications."""
import csv,json,hashlib,collections
from pathlib import Path
root=Path(__file__).resolve().parents[1]
inputs=['coverage-v3.csv','outputs/chapter6-saved-target-assessment.json','handoff/generator-summary-scientific-evidence.json','handoff/generator-alpha-sensitivity-scientific-evidence.json','provenance/continuous-moderator-identification-independent-review.json']
hashes={p:hashlib.sha256((root/p).read_bytes()).hexdigest() for p in inputs}
rows=list(csv.DictReader((root/inputs[0]).open()));assessment={c['id']:c for c in json.load((root/inputs[1]).open())['claims']}
history_fields=['attempted','attempted_evidence','outstanding_scope','remaining_work','next_action','resource_basis','next_evidence']
fields=list(rows[0])+['continuation_evidence','continuation_scope']+['prior_'+k for k in history_fields]
def preserve(r):
 for k in history_fields:r['prior_'+k]=r[k]
for r in rows:
 for k in history_fields:r['prior_'+k]=''
 r['continuation_evidence']='';r['continuation_scope']='No new claim-specific completed work in this continuation; prior exact-target status retained.'
 if r['claim_id'] in assessment:
  c=assessment[r['claim_id']];r['continuation_evidence']='outputs/chapter6-saved-target-assessment.json;provenance/chapter6-saved-target-integration-review.json';r['continuation_scope']=c['outstanding_scope']
  if c['descriptive_analysis_complete']:
   preserve(r)
   r['attempted']=r['attempted_evidence']='Full saved96,000-fit grid descriptively assessed without newfits or tests; see '+r['continuation_evidence']
   r['outstanding_scope']=r['remaining_work']=c['outstanding_scope']
   r['work_status']='attempted-incomplete';r['exact_target_work_status']='attempted-incomplete';r['attempt_kind']='completed full-grid descriptive assessment; unresolved full scientific proposition';r['next_action']=c['next_action']
 if r['reconciliation_rule']=='generator_summary_pending':
  preserve(r)
  r['attempted']=r['attempted_evidence']='Completed2650response datasets across19source-relevantconditions in131.334s, same2650regenerated for raw/standardizedalpha in100.317s;194generationvalidationchecks andindependent numericalreview; zero posterior fits.'
  r['outstanding_scope']=r['remaining_work']='Exact quoted source descriptor remains unresolved: illustrative dataset/seed, item-bank calibration policy and alpha aggregation/subset are unreported or unrecovered. Planned response-generation and formula diagnostics are complete.'
  r['resource_basis']='Generation pilot.923s; fullgeneration131.334s; pairedformula sensitivity100.317s. No posterior-production cost is needed for these completed descriptor checks.'
  r['next_evidence']='Original illustrative responses/seeds, item difficulty bank and raw/standardized alpha computation/aggregation definition.'
  r['work_status']='completed-attempt';r['exact_target_work_status']='completed-under-declared-reconstruction';r['attempt_kind']='Fixed full relevant response-generation grid plus paired raw/standardized-alpha diagnostic; zero posterior fits';r['continuation_evidence']='handoff/generator-summary-scientific-evidence.json;handoff/generator-alpha-sensitivity-scientific-evidence.json';r['continuation_scope']='Nine descriptor claims assessed using2650generation-onlydatasets across19conditions; same2650regenerated for alpha sensitivity, not extra independentreplicates. Source unknown illustrative seed/calibration/aggregation means exact source descriptor remains scientifically notestablished.';r['next_action']='Obtain original item-bank/seeds and definition of quoted alpha aggregation for exact source comparison; retain complete conditional generator assessment.'
 if r['claim_id'] in ['C5-1.logvariance-identification','C5-1.one-likelihood-maximum']:
  r['continuation_evidence']='provenance/continuous-moderator-identification-check.json;provenance/continuous-moderator-identification-independent-review.json';r['continuation_scope']='Reviewed conditional population injectivity extended to rich disjoint moderator supports. No finite-sample likelihood uniqueness result or empirical calibration validation; no Lean requirement substituted for ordinary proof.'
assert len(rows)==996 and len({r['claim_id'] for r in rows})==996
original=list(csv.DictReader((root/'coverage-v3.csv').open()));assert [(r['claim_id'],r['scientific_status']) for r in rows]==[(r['claim_id'],r['scientific_status']) for r in original]
p=root/'coverage-v4.csv'
with p.open('w',newline='')as f:
 w=csv.DictWriter(f,fieldnames=fields,lineterminator='\n');w.writeheader();w.writerows(rows)
x={'input_sha256':hashes,'output_sha256':hashlib.sha256(p.read_bytes()).hexdigest(),'script_sha256':hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),'rows':996,'scientific_statuses_unchanged':True,'work_status_counts':dict(collections.Counter(r['work_status'] for r in rows)),'exact_target_work_status_counts':dict(collections.Counter(r['exact_target_work_status'] for r in rows)),'limit':'Dependent source records, not independent experiments or success fractions.391exact targets remainpending including355source-count aggregate rows; pilot/gate work doesnotcomplete those aggregates. Current centered diagnostic is not incorporated until terminal independent review. Original broad source claims and reviewed paper remainunchanged.','current_vs_historical_fields':'Changed30rows update currentattempted/outstandingfields; originals preserved inprior_*columns. Scientific statuses/status_reason remain frozen packet adjudications, not a newscientificdecision.',
'background_and_nonclaims':'Excluded in full19-section source-reading audit, outside996adjudicated rows. Cited background/restated conclusions/future proposals not new original experiments.'}
(root/'provenance/coverage-v4-reconciliation.json').write_text(json.dumps(x,indent=2)+'\n');print(json.dumps(x['work_status_counts']));print(json.dumps(x['exact_target_work_status_counts']))
