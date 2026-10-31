"""Additive scientific handoff; reads saved evidence only. No model execution."""
import copy,csv,hashlib,json,pathlib,collections
ROOT=pathlib.Path(__file__).resolve().parents[1]
def read(p): return json.loads((ROOT/p).read_text())
def sha(p): return hashlib.sha256((ROOT/p).read_bytes()).hexdigest()
def write(p,d): (ROOT/p).write_text(json.dumps(d,indent=2,ensure_ascii=False)+'\n')
base=read('handoff/evidence-packet.json'); packet=copy.deepcopy(base)
inputs={}
def evidence(path,keys=None):
 inputs[path]=sha(path); d=read(path)
 if keys is not None: d={k:d[k] for k in keys if k in d}
 return d
# Scientific material only. Raw review/workflow records are not writer inputs.
scientific={}
scientific['scientific-compliance']=evidence('handoff/continuation-scientific-compliance.json')
for name in ['generator-summary','generator-alpha-sensitivity','jags-centered','jags-gate']:
 path=f'handoff/{name}-scientific-evidence.json'
 scientific[name]=evidence(path)
 scientific[name].pop('execution',None)
 scientific[name].pop('sources',None)
 scientific[name].pop('source_files',None)
for name in ['chapter5-analytical-evidence','chapter6-analytical-evidence','narrow-analytical-evidence','scale-invariance-evidence']:
 scientific[name]=evidence('handoff/'+name+'.json')
 for key in ['inputs','input_sha256','reproduction','evidence_identity','scope','scope_notice','method']: scientific[name].pop(key,None)
saved=evidence('outputs/chapter6-saved-target-assessment.json',['analysis_policy','claims'])
for claim in saved['claims']:
 for key in ['scientific_status_changed','frozen_scientific_status','next_action']:
  claim.pop(key,None)
scientific['chapter6-saved-target-assessments']=saved
proof_specs={
 'marginal-identification-check':['canonical_result','source_assumptions_read','theorem','constructive_design_failures','remaining','scope_note'],
 'joint-item-identification-check':['canonical_result','source_context','conditional_statement','derivation','boundary_and_scope_checks'],
 'continuous-moderator-identification-check':['canonical_claims','source','model_and_assumptions','theorem','ordinary_proof','finite_likelihood_attempt_and_remaining','limits'],
 'non-gaussian-latent-moment-check':['relation_to_source_claims','source','parameter_domain','source_faithful_representation','theorem','ordinary_proof','boundaries_and_limits','interpretation'],
 'rasch-sufficiency-derivation':['kind','source_scope','canonical_claims','assumptions','proof'],
 'jags-centered-feasibility':['source','notation','unchanged_priors','direct_centered_representation','joint_target_equivalence','full_conditionals'],
}
for name,keys in proof_specs.items():
 scientific[name]=evidence('provenance/'+name+'.json',keys)
 scientific[name]['attribution']='Our conditional ordinary mathematical derivation of consequences of the source model; not a new dissertation claim, not Lean-certified, and not an empirical replication.'
# Current scientific scope supersedes dated workflow gates, without altering source records.
scientific['marginal-identification-check']['remaining']=[
 'The marginal-only proof requires equal known slopes and distinct difficulties. The separately reviewed joint-item proof extends identification to unequal known positive slopes and permits identical calibration, under its stated observation and support assumptions.',
 'Unknown calibration, separate-twin moderators, informative missingness and unavailable joint probabilities require their own identification argument.',
 'Population injectivity does not establish existence or uniqueness of finite-sample maxima, posterior unimodality, convergence or finite-sample recovery.',
 'The all-zero free-mean example shows absence of a finite maximizer, not two maxima. Ordinary proofs are available; no Lean certificate is claimed.'
]
scientific['marginal-identification-check'].pop('scope_note',None)
plan_keys=['source_designs','C5_shared_model','count_accounting','source_ambiguities','remedies','prespecified_validation','resource_pilot','provisional_cost','power_and_sufficiency','ordinary_mathematical_next_work','blocked_vs_pending']
scientific['remaining-target-method-resource-plan']=evidence('provenance/remaining-target-method-resource-plan.json',plan_keys)
scientific['remaining-target-method-resource-plan']['status']='Proposed methods and resource scenarios, not executed experiments or evidence of convergence; 3250 unique datasets and 3450 dataset-method fits are planned core source targets. Measured centered12k costs are timing anchors for a failed gate, not a feasibility guarantee.'
# Review conclusions and scientific qualifications only, never reviewer dialogue or old drafts.
reviews={
 'generator-summary-outcome-independent-review':['status','completed_datasets','completed_conditions','posterior_fits','remaining_ambiguities','limitations'],
 'generator-alpha-sensitivity-outcome-independent-review':['status','datasets_regenerated','additional_independent_datasets','posterior_fits','conditions','undefined_standardized','scientific_conclusion','limitations'],
 'jags-centered-outcome-independent-review':['status','requested_chains','completed_chains','retained_per_chain','failed_parameters','limitations'],
 'chapter6-saved-target-assessment-review':['status','target_count','complete_descriptive_assessments','direct_power_or_unequal_structure_targets_still_pending','findings'],
 'chapter6-saved-target-integration-review':['checks','interpretation'],
 'marginal-identification-independent-review':['status','limitations'],
 'joint-item-identification-independent-review':['status','limits'],
 'continuous-moderator-identification-independent-review':['status','boundaries_and_limits'],
 'non-gaussian-latent-moment-independent-review':['status','limits'],
 'compute-remedies-independent-review':['status'],
 'coverage-v4-corrected-readback-review':['result','work_status_counts','exact_target_work_status_counts'],
}
review_extracts={name:evidence('provenance/'+name+'.json',keys) for name,keys in reviews.items()}
for name in ['marginal-identification-independent-review','joint-item-identification-independent-review']:
 review_extracts[name]['status']='Accepted as an ordinary conditional identification argument under its stated assumptions. No Lean certificate or empirical replication is asserted.'
review_extracts['chapter6-saved-target-assessment-review']['status_at_assessment_stage']=review_extracts['chapter6-saved-target-assessment-review'].pop('status')
review_extracts['chapter6-saved-target-assessment-review']['current_review_status']='Descriptive signed findings subsequently independently checked in chapter6-saved-target-integration-review; no added uncertainty, equivalence or direct power inference.'
review_extracts['chapter6-saved-target-assessment-review']['subsequent_review']='chapter6-saved-target-integration-review'
coverage=list(csv.DictReader((ROOT/'coverage-v4.csv').open()))
inputs['coverage-v4.csv']=sha('coverage-v4.csv')
coverage_keys=['claim_id','source_locator','scientific_status','work_status','exact_target_work_status','attempt_kind','attempted_evidence','supporting_evidence_scope','outstanding_scope','resource_basis','next_evidence','continuation_scope']
coverage_clean=[{k:r[k] for k in coverage_keys} for r in coverage]
counts={k:dict(collections.Counter(r[k] for r in coverage)) for k in ['scientific_status','work_status','exact_target_work_status']}
for claim,row in zip(packet['claims'],coverage_clean):
 assert claim['id']==row['claim_id']
 claim['current_work']=row
packet['continuation']={
 'schema_version':1,'document_kind':'additive_scientific_evidence_supplement',
 'base_packet':{'path':'handoff/evidence-packet.json','sha256':sha('handoff/evidence-packet.json')},
 'contract_commit':'a322dd8b40bba924516df55c121d147aeb0b377a',
 'scope':'Whole dissertation. Original claim adjudications and effect records are preserved. New descriptive and conditional evidence does not automatically change a scientific verdict.',
 'inventory':{'claims':len(base['claims']),'headline_claims':len(base['headline_order']),'headline_effect_rows':len(base['headline_effects']),'component_comparisons':sum(len(x.get('component_comparisons',[])) for x in base['headline_effects']),'sections':len(base['sections']),'coverage_counts':counts,'count_interpretation':'Dependent source records, never independent replications or a success fraction. 355 source-count aggregate targets remain pending.'},
 'current_coverage':coverage_clean,
 'current_evidence_precedence':{
  'rule':'Original ours/status_reason/stopping fields and scientific statuses preserve the original adjudication snapshot. For present completed work and outstanding scope, current_work and the embedded scientific evidence take precedence over dated statements that no aggregate was available. This is not a scientific-status upgrade.',
  'generator_claim_ids':[a['id'] for a in scientific['generator-summary']['source_claim_assessments']],
  'generator_scope':'All nine descriptor targets have completed generation-only assessments at the stated 100/250 dataset counts. Source formula, aggregation, calibration and exact illustrative sample remain unresolved where stated. Source-count posterior recovery/power is a different target and remains incomplete.',
  'chapter6_completed_descriptive_claim_ids':[a['id'] for a in saved['claims'] if a.get('descriptive_analysis_complete')],
  'chapter6_pending_target_ids':[a['id'] for a in saved['claims'] if not a.get('descriptive_analysis_complete')],
  'chapter6_scope':'21 descriptive assessments complete; five direct-power or unequal-structure targets remain pending. Saved point contrasts do not establish qualitative equivalence, a justified adequacy margin or direct power.'
 },
 'scientific_evidence':scientific,
 'reviewed_scientific_conclusions':review_extracts,
 'attribution_and_scope':[
 'The source-reading inventory covers all 19 sections, seven chapters and appendices A–G plus nonscientific sections. Cited background, repeated conclusions and future proposals are not original completed experiments. Preserve section exclusions and every source locator from the base inventory.',
 'Chapter 6 precision evidence concerns variance-SE deletion-minus-full contrasts; measured power requires a specified alternative, test and rejection-rate experiment and is not supplied by SE ordering.',
 '2650 generated datasets across 19 conditions comprise 14 Chapter 2 cells with 100 datasets each and five Chapter 5 cells with 250 each. The alpha sensitivity reuses these same datasets: zero additional independent datasets and zero posterior fits.',
 'Conditional population identification, fixed-parameter latent moment inversion, scale invariance and exact score-likelihood sufficiency are mathematical results under named assumptions, not broad empirical recovery, likelihood uniqueness, convergence or power results.',
 'A nonzero Chapter 2 interaction implies non-Gaussian marginal traits in the fixed-parameter hierarchy. The Gaussian item-identification theorem cannot bridge this family to observed-response identification.',
 'Original empirical inputs, calibration and source aggregation/procedural details remain unavailable where declared. Scientific nonreplication requires a feasible comparable test; an unresolved estimand or inaccessible input is not a failure to replicate.'
 ],
 'recovery_evidence_reservation':{'state':'pending_terminal_independent_review','scientific_result':None,'interpretation':'No final fixed recovery result is incorporated. The completed centered 12000-draw-per-chain experiment failed its joint gate. No interim draws establish convergence or update a source claim. A reviewed terminal scientific handoff and new packet hash are required before incorporating the recovery result.'},
 'source_hashes':inputs,
}
packet['synthesis'] += ' Additional completed evidence comprises 2650 response-generation datasets across 19 conditions, paired raw-versus-standardized alpha sensitivity on the same datasets, 21 completed descriptive assessments among 26 saved Chapter 6 targets, with five direct-power or unequal-structure targets still pending, and conditional ordinary mathematical derivations. These do not establish missing power, source-count posterior recovery, original empirical refits, or a unique finite likelihood maximum. The completed centered four-chain 12000-retained-draw diagnostic also fails its unchanged joint gate; the final recovery outcome is not incorporated.'
packet['limitations'] += [
 'C2-2.design.alpha, C2-3.alpha, C5-2.alpha.J60 and C5-2.alpha.J20: source alpha formula/aggregation/calibration remain ambiguous; rounding of reconstructed means is not an exact source-estimand verdict. Standardization does not close the floor/ceiling or J20 descriptor gaps.',
 'C6-2.SE-trend.MCAR.A and other saved-target assessments: qualitative constancy, slightness, closeness and adequacy lack justified equivalence margins. Descriptive trends cannot settle those qualifications or H6.power-assertion.',
 'C5-1.logvariance-identification and C2-1.construction: conditional ordinary proofs do not establish finite-sample maximum existence/uniqueness or observed-response identification of non-Gaussian latent moments.',
 'H2.power-grid and H2.IRT-bias-remedy: a failed centered one-dataset joint gate cannot supply source-count recovery or power; final recovery result is withheld pending terminal review.'
]
# Hash every added input as an audit artifact, not permission for writer traversal.
for i,(path,digest) in enumerate(inputs.items()): packet['artifacts'].append({'id':f'continuation-input-{i:02d}','path':path,'sha256':digest})
write('handoff/continuation-evidence-packet.json',packet)
# The writer receives only this packet, verified source, and pinned writing contracts.
contract_dir=ROOT/'handoff/continuation-writer-instructions';contract_dir.mkdir(exist_ok=True)
import subprocess
for name in ['evidence-handoff.md','first-page-contract.md']:
 data=subprocess.check_output(['git','show',f"a322dd8b40bba924516df55c121d147aeb0b377a:.agents/skills/replication-paper/references/{name}"],cwd=ROOT)
 (contract_dir/name).write_bytes(data)
allow=['handoff/continuation-evidence-packet.json','handoff/continuation-scientific-compliance.json','source-local/schwabe.txt','source-local/thesis_I_Schwabe.pdf','handoff/continuation-writer-instructions/evidence-handoff.md','handoff/continuation-writer-instructions/first-page-contract.md']
allow += ['handoff/evidence-packet.json','handoff/generator-summary-scientific-evidence.json','handoff/generator-alpha-sensitivity-scientific-evidence.json','handoff/jags-centered-scientific-evidence.json','handoff/jags-gate-scientific-evidence.json','handoff/chapter5-analytical-evidence.json','handoff/chapter6-analytical-evidence.json','handoff/narrow-analytical-evidence.json','handoff/scale-invariance-evidence.json','handoff/historical-diagnostic-evidence.json','handoff/scientific-availability.json','handoff/scientific-compliance.json','handoff/terminal-reproduction.md','handoff/writer-instructions/approved-preamble.tex','handoff/writer-instructions/origins.json','handoff/writer-instructions/writer-stage.md','handoff/writer-instructions/manuscript.md','handoff/writer-instructions/pdf-link-review.md','paper/references.bib','provenance/remaining-target-method-resource-plan.json','production/chapter6-v1/terminal-analysis/summary.json','production/analysis-plan.json','handoff/continuation-writer-instructions/README.md']
write('handoff/continuation-writer-allowlist.json',{'schema_version':1,'packet_sha256':sha(allow[0]),'allowed_inputs':[{'path':p,'sha256':sha(p)} for p in allow],'isolation':'Fresh writer has read the original packet and authorized scientific handoffs, not prior manuscripts. This is the union of authorized scientific/writing inputs; the writer must record actual reads separately. Only exact allowed inputs; references inside packet are evidence provenance, not authority to traverse other files. No prior manuscripts, PDFs, draft reviews, chat, logs, git history, or broad directory searches.','required_output':'New standalone manuscript in a separate output directory; preserve all 26 headlines and all 187 component comparisons; no edits to existing manuscript or packet.','pending_evidence':'Drafting from completed evidence is authorized. Terminal recovery paragraphs and final writer manifest remain pending until reviewed terminal evidence is incorporated. Rehash allowlist after any packet update.'})
# Preserve the reported exposure union and exact external pinned instructions.
exposure=ROOT/'handoff/continuation-writer-exposure.json'
if exposure.exists():
 manifest=read('handoff/continuation-writer-allowlist.json')
 external=[x['path'] for x in json.loads(exposure.read_text())['files_reported_read'] if x['path'].startswith('/tmp/')]
 manifest['authorized_external_pinned_instruction_inputs']=[{'path':p,'sha256':hashlib.sha256(pathlib.Path(p).read_bytes()).hexdigest()} for p in external]
 manifest['actual_exposure_record']='handoff/continuation-writer-exposure.json'
 write('handoff/continuation-writer-allowlist.json',manifest)
