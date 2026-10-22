"""Render planning estimates separately from measured formalization coverage."""
import pathlib,json,collections,html
R=pathlib.Path(__file__).resolve().parent.parent;D=R/'planning';load=lambda n:json.loads((D/n).read_text())
rows=load('difficulty-estimates.json');scale=load('difficulty-scale.json');sources=load('difficulty-sources.json');eligible=[r for r in rows if r['eligible_in_coverage_inventory']]
counts=lambda key,rs:dict(collections.Counter(str(r[key]['score']) if r[key] else 'formulation_required' for r in rs))
summary=dict(checked_on='2026-10-21',inventory_entries=len(rows),eligible_targets=len(eligible),scored_entries=sum(r['specification'] is not None for r in rows),formulation_or_historical_holds=sum(r['gate'] is not None for r in rows),eligible_specification_tiers=counts('specification',eligible),eligible_conditional_proof_tiers=counts('proof_transfer_given_complete_proof',eligible),all_specification_tiers=counts('specification',rows),all_conditional_proof_tiers=counts('proof_transfer_given_complete_proof',rows),research_resolution_time_estimates_provided=0,estimate_confidence='low',scope='Historical planning pass before the dyadic pilot; current measured coverage is in literature/open-problem-summary.json.',basis='Family-based planning priors, source-statement inspection and bounded library inspection; no timed implementation.',new_lean_statements_created=0,new_lean_proofs_created=0)
(D/'difficulty-summary.json').write_text(json.dumps(summary,indent=2)+'\n')
s=f'''# Lean formalization and proof difficulty estimates

The finite graph and binary-matrix questions offer the clearest starting points. Specialized geometry, support varieties, knot theory and nonlinear PDEs require much larger foundations. All **{len(rows)} inventory entries** have an assessment, but **{summary['formulation_or_historical_holds']} directions or historical/formulation holds** do not yet identify a proof task precise enough to schedule. [Searchable estimates](difficulty.html) · [Per-question data](difficulty-estimates.json) · [Open-problem inventory](../literature/OPEN-PROBLEMS.md).

These are **low-confidence planning estimates**, dated October 21, 2026. They are family-based priors with selected question-specific adjustments, not measurements from implementing each target. A dependency spike can move a target by a full tier or more. Ratings assume one experienced Lean developer who understands the relevant mathematics and can use existing tools; they do not estimate a beginner's learning time or predict the effect of future automation.

These estimates precede the [dyadic rank pilot](../formalization/dyadic-rank/README.md). Its complete general Lean proof is recorded in the current coverage inventory; the estimates below have not been recalibrated from that implementation.

## Three different difficulties

**Writing a faithful statement** includes necessary definitions and an audit of its quantifiers, ambient objects and hypotheses. Merely declaring undefined predicates, assuming the conclusion as an axiom, using `sorry`, or substituting an easier algebraic surrogate does not meet this stage. Proving all supporting mathematical theory is not required merely to state a conjecture.

**Transferring a complete mathematical proof into Lean** includes missing supporting lemmas, a successful build, and review of axioms and the specification. Its estimate assumes that a correct, complete proof resolving the exact target has already been supplied. It is an estimate of additional work after the statement setup; shared foundations must not be charged again for every related question. A short argument invoking deep unavailable theory can be expensive to transfer.

**Discovering a proof or counterexample** is original mathematics. Its time to completion is left **unestimated for every open target**. A problem may be false, already resolved elsewhere, or much harder than its short statement suggests. The relative research-obstacle labels below express where exploration appears feasible; they are not probabilities of success or promises of a solution. The literature audit did not establish current open status for every target.

## Effort scale

The two effort columns use different bands because stating a problem and checking a supplied proof are different tasks. Person-days/weeks/months describe one expert's effort, not an elapsed deadline. The ranges are rough scenarios, not statistical confidence intervals or lower/upper bounds.

| Tier | Label | Faithful statement and definitions | Additional proof transfer given a complete proof |
| --- | --- | --- | --- |
'''
for k,v in scale.items():s+=f"| {k} | {v['label']} | {v['spec']} | {v['proof']} |\n"
s+='''
Research-obstacle level **3** denotes a concrete finite/constructive target where small-instance experiments or a specific missing lemma may help; **4** denotes a substantial specialized theorem, classification or algorithmic improvement; **5** denotes a major analytic or foundational challenge. The numbers are ordinal judgments. No target here is assigned a known short proof merely because finite instances can be checked.

## Distribution across the 74 tracked targets

'''
s+='| Tier | Statement setup | Conditional proof transfer |\n| --- | ---: | ---: |\n'
for k in ['1','2','3','4','5','formulation_required']:
 label='Needs formulation first' if k=='formulation_required' else k+' — '+scale[k]['label']
 s+=f"| {label} | {summary['eligible_specification_tiers'].get(k,0)} | {summary['eligible_conditional_proof_tiers'].get(k,0)} |\n"
s+='''
Three targets retained in the earlier coverage denominator need an additional formulation decision for project planning: weighted Horace applicability, Ganger's higher-dimensional relationship, and the scope of Bernstein inequalities. Their audit status and the 74-target denominator are preserved. Ratings change no formalization-coverage count. Method-request entries concerning non-computer-assisted proofs are outside that denominator; a computational Lean certificate alone would not answer those requests.

## Practical starting projects

| Project | First bounded milestone | Rough expert pilot effort | What remains open |
| --- | --- | --- | --- |
| Dyadic rank/support converse, L-P11-rank-converse | Define the binary dyadic matrix and certify small rank/support examples using explicit linear-algebra certificates | 1–3 person-weeks | The universal converse across all permitted dimensions |
| Graph saturation and subgraph counts, including Volk and P27 | Specify saturation and certify a tiny construction or a bounded enumeration, for example up to five vertices | 1–3 person-weeks | The general extremal formula or all-parameter classification |
| Neural-code invariants, including Geraci and P02 | Implement finite code operations and check a few examples on at most three neurons | 2–6 person-weeks | General maxima, code-isomorphism issues and the bridge to polynomial canonical forms |

The pilot bands are separate estimates for these limited milestones, not schedules for solving the corresponding open questions. The dyadic target uses ordinary rank over F_2; the neural-code Boolean-rank question uses Boolean factorization rank. They require different definitions. For the rank converse, boundary dimensions and division by two need explicit treatment before finite tests are meaningful. Subgraph copy counts also need a computable representation before automatic enumeration can certify them.

## Reuse and overlap

Related questions can share binary-matrix indexing and rank lemmas, a graph saturation/counting API, neural-code morphisms/canonical forms, or partition-incidence and measure lemmas. Existing repeated questions retain one canonical estimate. **Do not sum the individual time bands**: setup can be shared, proofs can imply subsidiary results, and research discovery can dominate every estimate. Sharing a PDE vocabulary does not make a result about a different equation or dissipation exponent a proof of the original target.

For the PDE questions, a faithful weak-solution definition is achievable before developing a full nonlinear existence theory; its statement tier is therefore generally lower than its proof tier. Existing Sobolev definitions are useful prerequisites, not evidence that the target's periodic vector-field spaces, nonlinear estimates and uniqueness theorem are already available.

## Library evidence and assumptions

The estimates use the pinned source snapshot already recorded in [audit sources](../audit/sources.json). Source files establish available prerequisites, not complete support for the target. In particular, graph copies, matrix rank, finite powersets, automata, polynomial rings and Sobolev distributions have concrete source files. Weighted projective geometry and support varieties still require object-specific bridges. [Inspected prerequisite files](difficulty-sources.json).

'''
for source in sources:s+=f"- [{source['path']}]({source['url']}).\n"
s+='\n## Per-question estimates\n\n“Hold” means define a particular theorem or validate the historical target before scheduling. Research difficulty is assessed separately from implementation effort.\n\n'
for r in rows:
 sp=r['specification'];pr=r['proof_transfer_given_complete_proof'];research=r['mathematical_research'];x='unestimated' if research['relative_obstacle_score'] is None else 'relative obstacle '+str(research['relative_obstacle_score'])+'/5; resolution time unestimated'
 s+=f"### {r['claim_id']}\n\n{r['title']}\n\n"
 if r['gate']:s+=f"**Formulation or historical hold:** {r['gate']} The shared family setup would be approximately statement tier {r['shared_family_setup']['specification_score']} and proof-transfer tier {r['shared_family_setup']['proof_transfer_score']} after a concrete target is chosen; these are not completion estimates for the current broad entry.\n\n"
 else:s+=f"**Statement:** tier {sp['score']}/5, {sp['effort_band']}. **Proof transfer if a complete proof is supplied:** tier {pr['score']}/5, {pr['effort_band']}. **Mathematical discovery:** {x}; {research['status'].replace('_',' ')}.\n\n"
 s+=r['rationale']+'\n\nFirst milestone: '+r['first_milestone']+'\n\n'
 s+=f"Reuse cluster: {r['reuse_cluster'].replace('_',' ')}. Confidence: low. [Source statement and hypotheses](../literature/OPEN-PROBLEMS.md#{r['claim_id'].lower()}).\n\n"
(D/'LEAN-DIFFICULTY.md').write_text(s.rstrip()+'\n')
e=html.escape;table=[]
for r in rows:
 sp=r['specification'];pr=r['proof_transfer_given_complete_proof'];m=r['mathematical_research']['relative_obstacle_score'];tier=str(sp['score']) if sp else 'hold';search=' '.join([r['claim_id'],r['title'],r['family'],r['rationale']]).lower()
 a=f"{sp['score']}/5 — {sp['effort_band']}" if sp else 'Hold: choose a precise target first';b=f"{pr['score']}/5 — {pr['effort_band']}" if pr else 'Not scheduled';c=f'{m}/5; discovery time unestimated' if m else r['mathematical_research']['status'].replace('_',' ')
 table.append(f'<tr data-tier="{tier}" data-eligible="{str(r["eligible_in_coverage_inventory"]).lower()}" data-search="{e(search,quote=True)}"><td><a href="../literature/OPEN-PROBLEMS.md#{r["claim_id"].lower()}">{e(r["claim_id"])}</a><p>{e(r["title"])}</p><small>{e(r["family"].replace("_"," "))}</small></td><td>{e(a)}</td><td>{e(b)}</td><td>{e(c)}</td><td>{e(r["rationale"])}<p><strong>First milestone:</strong> {e(r["first_milestone"])}</p>{"<p><strong>Gate:</strong> "+e(r["gate"])+"</p>" if r["gate"] else ""}</td></tr>')
page='''<!doctype html><html lang="en"><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>Lean difficulty estimates</title><style>body{font:16px/1.5 system-ui,sans-serif;background:#fafbfc;color:#172b3a;margin:2rem}a{color:#075e9e}p{max-width:1100px}small{display:block;color:#52616d}input,select{font:inherit;padding:.5rem;margin:.4rem}.notice{background:#fff6e3;border-left:4px solid #b5790f;padding:1rem}.scroll{overflow:auto}table{border-collapse:collapse;background:white;width:100%}th,td{border:1px solid #d7dfe5;padding:.8rem;vertical-align:top;text-align:left}th{background:#eaf1f5}td:first-child{min-width:280px}td:last-child{min-width:360px}</style><h1>Lean difficulty estimates</h1><p><a href="LEAN-DIFFICULTY.md">Method, time bands and full assessments</a> · <a href="difficulty-estimates.json">Structured estimates</a> · <a href="../literature/open-problems.html">Coverage inventory</a></p>'''
page+=f'<p>{len(rows)} entries · {len(eligible)} tracked targets · {summary["formulation_or_historical_holds"]} formulation/historical holds</p>'
page+='''<p class="notice">Low-confidence expert planning priors, not timed implementation results. “Proof transfer” assumes a complete correct mathematical proof has been supplied. Discovery time for every open problem is unestimated. These estimates predate the <a href="../formalization/dyadic-rank/README.md">dyadic rank pilot</a>; see the current inventory for its complete general proof. Effort bands assume an experienced Lean developer and domain knowledge; related targets share setup costs.</p><label>Search <input id="q" type="search" placeholder="Author, topic, ID or prerequisite"></label><label>Statement tier <select id="tier"><option value="all">All</option><option value="2">2 — manageable</option><option value="3">3 — substantial</option><option value="4">4 — large</option><option value="5">5 — foundational</option><option value="hold">Formulation/historical hold</option></select></label><label>Scope <select id="eligible"><option value="all">All inventory entries</option><option value="true">74 tracked targets</option><option value="false">Other directions and holds</option></select></label><p id="count" aria-live="polite"></p><div class="scroll"><table><thead><tr><th>Question</th><th>Faithful statement</th><th>Proof transfer given a complete proof</th><th>Research obstacle</th><th>Reason and first milestone</th></tr></thead><tbody>'''+''.join(table)+'''</tbody></table></div><script>const rows=[...document.querySelectorAll('tbody tr')],q=document.querySelector('#q'),tier=document.querySelector('#tier'),eligible=document.querySelector('#eligible');function filter(){let n=0;for(const r of rows){const ok=r.dataset.search.includes(q.value.toLowerCase())&&(tier.value==='all'||r.dataset.tier===tier.value)&&(eligible.value==='all'||r.dataset.eligible===eligible.value);r.hidden=!ok;if(ok)n++;}document.querySelector('#count').textContent=n+' of '+rows.length+' entries shown';}for(const x of[q,tier,eligible])x.addEventListener('input',filter);filter();</script></html>'''
(D/'difficulty.html').write_text(page)
print(json.dumps(summary,indent=2))
