"""Check comparison provenance and Lean audit records; not a proof of literature priority."""
from pathlib import Path
import hashlib,json,re
from urllib.parse import urlparse
R=Path(__file__).resolve().parent.parent;D=R/'formalization/cyclic-lifts'
v=json.loads((D/'prior-art-review.json').read_text())
a=v['assessment'];checks=v['comparison_checks'];sources=v['sources']
assert v['target_id']=='L-P34-girth-eight'
assert len(sources)==len({s['id'] for s in sources})==v['source_count']==7
assert {s['id'] for s in sources}=={'FOSS2004','RV2021','ZHANG2024','RDV2025','SM2021','OK2026V1','ORIGIN2026'}
assert not a['exact_combined_iff_found_verbatim'] and a['negative_finding_is_bounded_not_global']
assert not a['new_mathematical_discovery_claim_supported']
assert not a['distinct_new_proof_mechanism_claim_supported'] and not a['first_lean_formalization_established']
assert a['classical_four_six_conditions_already_published'] and a['same_lp_eight_cycle_cancellation_already_published']
assert a['same_support_mechanism_found'] and a['coverage_count_is_formalization_not_novelty']
for s in sources:
 assert urlparse(s['url']).scheme=='https' and s['authors'] and s['locator'] and s['retrieval']
 if s['local_file']:
  assert len(s['sha256'])==64
  p=R/s['local_file']
  if p.exists():assert hashlib.sha256(p.read_bytes()).hexdigest()==s['sha256'],s['id']
 else:assert s['id']=='FOSS2004' and s['sha256'] is None and 'HTTP_403' in s['retrieval']
for name,sha in v['artifact_sha256'].items():assert hashlib.sha256((R/name).read_bytes()).hexdigest()==sha,name
assert checks['exit_code']==0 and not checks['published_proofs_imported_into_lean']
assert checks['main_library_theorem_count_unchanged']==75
assert len(checks['declaration_axioms'])==3
assert all(set(x)<={'propext','Classical.choice','Quot.sound'} for x in checks['declaration_axioms'].values())
log=(D/'prior-art-checks.log').read_text();assert 'error:' not in log and 'sorryAx' not in log
printed={name:[x.strip() for x in items.split(',') if x.strip()]
 for name,items in re.findall(r"'([^']+)' depends on axioms: \[([^\]]*)\]",log)}
assert printed==checks['declaration_axioms']
source=(R/checks['source']).read_text()
assert not re.search(r'\b(sorry|admit|native_decide|sorryAx)\b',source)
assert not re.search(r'^\s*(axiom|unsafe)\b',source,re.M)
assert {'CyclicPriorArt.'+n for n in re.findall(r'^theorem\s+(\w+)',source,re.M)}==set(printed)
core=json.loads((D/'verification.json').read_text());assert core['theorem_count']==75
assert core['general_girth_eight_problem_proved'] and core['full_target_statement_formalized']
rows=json.loads((R/'literature/open-problems.json').read_text())
row=next(r for r in rows if r['id']==v['target_id'])
assert row['lean_proof_status']=='verified_complete_lean_proof'
assert row['novelty_assessment']['review']=='formalization/cyclic-lifts/prior-art-review.json'
assert row['novelty_assessment']['mathematical_conclusion']=='specialization_of_established_qc_cycle_conditions_and_lp_eight_cycle_bound'
summary=json.loads((R/'literature/open-problem-summary.json').read_text())
assert summary['eligible_verified_lean_proofs']==a['complete_lean_targets']==2
assert summary['eligible_targets']==a['eligible_targets']==108
report=(D/'PRIOR-ART-AND-PROOF-COMPARISON.md').read_text()
for href in re.findall(r'\]\(([^)]+)\)',report):
 u=urlparse(href)
 if not u.scheme and u.path:assert (D/u.path).exists(),href
print('Validated seven primary-source comparisons, three standard-axiom Lean translations, unchanged 75-theorem library and 2/108 proof coverage. Mathematical/first-formalization priority is not claimed.')
