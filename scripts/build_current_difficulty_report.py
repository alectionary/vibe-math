"""Render current subjective planning estimates without changing coverage evidence."""
from pathlib import Path
import json,html,re
R=Path(__file__).resolve().parent.parent;D=R/'planning'
rows=json.loads((D/'current-difficulty-estimates.json').read_text());s=json.loads((D/'current-difficulty-summary.json').read_text());e=html.escape
slug=lambda x:re.sub(r'[^\w-]','',x.lower())
text='# Current per-target Lean difficulty estimates\n\nChecked October 22, 2026. Low-confidence planning priors for all 181 entries. [Recommendation, assumptions and time bands](NEXT-PROJECT.md) · [Searchable table](current-difficulty.html) · [Structured estimates](current-difficulty-estimates.json). Proof-transfer effort assumes a correct complete mathematical proof has already been supplied. No open-problem discovery completion time is estimated.\n\n'
text+='| Eligible-target tier | Statement setup | Conditional proof transfer |\n| --- | ---: | ---: |\n'
for tier in ['0','1','2','3','4','5','hold']:
 text+=f'| {"Already complete" if tier=="0" else "Formulation required" if tier=="hold" else tier} | {s["statement_tiers"].get(tier,0)} | {s["conditional_proof_tiers"].get(tier,0)} |\n'
cards=[]
for r in rows:
 def fmt(key):
  v=r[key]
  return f'Tier {v["tier"]}: {v["band"]}' if v else 'Hold: scope/formulation first'
 a=fmt('statement_setup');b=fmt('proof_transfer_given_correct_complete_proof');research='Completed target' if r['completed'] else ('Scope/formulation first' if r['gate'] else f'Relative research obstacle {r["research_obstacle"]}/5; discovery time unestimated')
 text+=f'\n### {r["target_id"]}\n\n{r["title"]}\n\n- Statement: {a}.\n- Proof transfer, given a complete proof: {b}.\n- Research: {research}. {r["research_status"]}\n\n{r["rationale"]}\n\nFirst milestone: {r["first_milestone"]}\n\n'
 if r.get('progress_note'):text+=f'Progress: {r["progress_note"]} [Checked artifact](../{r["progress_artifact"]}).\n\n'
 if r['gate']:text+=f'Gate: {r["gate"]}\n\n'
 if r.get('proof_branches'):text+=r['proof_branches']+'\n\n'
 text+=f'Basis: {r["basis"]} [Source statement and hypotheses](../literature/OPEN-PROBLEMS.md#{slug(r["target_id"])}).\n'
 search=' '.join([r['target_id'],r['title'],r['family'],r['rationale']]).lower();tier=str(r['statement_setup']['tier']) if r['statement_setup'] else 'hold'
 cards.append(f'<tr data-search="{e(search,quote=True)}" data-tier="{tier}"><td><a href="CURRENT-DIFFICULTY.md#{slug(r["target_id"])}">{e(r["target_id"])}</a><p>{e(r["title"])}</p></td><td>{e(a)}</td><td>{e(b)}</td><td>{e(research)}<p>{e(r["rationale"])}</p><p>First milestone: {e(r["first_milestone"])}</p></td></tr>')
(D/'CURRENT-DIFFICULTY.md').write_text(text)
page='''<!doctype html><html lang="en"><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>Current Lean difficulty estimates</title><style>body{font:16px/1.5 system-ui,sans-serif;margin:2rem;color:#172b3a}table{border-collapse:collapse;width:100%}td,th{border:1px solid #ccd6df;padding:.8rem;text-align:left;vertical-align:top}th{background:#eaf1f5}input,select{font:inherit;padding:.5rem}.scroll{overflow:auto}td:first-child{min-width:260px}td:last-child{min-width:320px}</style><h1>Current Lean difficulty estimates</h1><p>181 entries · 108 eligible targets · one completed Lean target. Low-confidence planning priors; proof-transfer estimates assume a supplied complete proof. Discovery completion time is unestimated.</p><p><a href="NEXT-PROJECT.md">Recommendation and assumptions</a> · <a href="CURRENT-DIFFICULTY.md">All assessments</a> · <a href="../literature/LEAN-COVERAGE.md">Actual coverage</a></p><label>Search <input id="q" placeholder="ID, topic or prerequisite"></label> <label>Statement tier <select id="tier"><option value="all">All</option><option value="0">Complete</option><option value="1">1</option><option value="2">2</option><option value="3">3</option><option value="4">4</option><option value="5">5</option><option value="hold">Hold</option></select></label><p id="count" aria-live="polite"></p><div class="scroll"><table><thead><tr><th>Target</th><th>Statement setup</th><th>Conditional proof transfer</th><th>Research and rationale</th></tr></thead><tbody>'''+''.join(cards)+'''</tbody></table></div><script>const rows=[...document.querySelectorAll('tbody tr')],q=document.querySelector('#q'),tier=document.querySelector('#tier');function filter(){let n=0;for(const r of rows){const ok=r.dataset.search.includes(q.value.toLowerCase())&&(tier.value==='all'||tier.value===r.dataset.tier);r.hidden=!ok;if(ok)n++;}document.querySelector('#count').textContent=n+' of '+rows.length+' entries shown';}q.addEventListener('input',filter);tier.addEventListener('input',filter);filter();</script></html>'''
(D/'current-difficulty.html').write_text(page)
print('Rendered',len(rows),'current difficulty assessments')
