"""Replay frozen inputs after the completion-shortcut repair; retain history."""
from pathlib import Path
import datetime,json
import run_search as rs
import independent_verify as iv
R=Path(__file__).resolve().parent
def main():
    tests=json.loads((R/'search-regression-tests.json').read_text());assert tests['status']=='PASS'
    xs=[json.loads(s) for s in (R/'fresh-results.jsonl').read_text().splitlines()]
    out=[]
    with (R/'fresh-corrected-results.jsonl').open('w') as f:
        for x in xs:
            y={k:v for k,v in x.items() if k not in ['search','seconds_total','verified_counterexample','independent_dense']}
            if y['criterion_eligible']:
                old=x['search'];y['search']=rs.search(x,old['bound'],old['node_limit'])
                if y['search']['witness']:
                    y['independent_dense']=iv.verify(x['E'],x['L'],y['search']['witness']);y['verified_counterexample']=True
            out.append(y);f.write(json.dumps(y)+'\n');f.flush()
            print(json.dumps({'phase':'fresh','id':x['id'],'search':y.get('search'),'verified_counterexample':y.get('verified_counterexample',False)}),flush=True)
            if y.get('verified_counterexample'):break
    summary={'status':'PASS','frozen_count':len(xs),'tested_count':len(out),'verified_counterexamples':sum(x.get('verified_counterexample',False) for x in out),
             'stop':'verified_counterexample' if out[-1].get('verified_counterexample') else 'completed_frozen_sample','same_frozen_matrices_bounds_and_caps':True,
             'checked_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'scope':'Corrected exact finite search; external C++ arithmetic, not a Lean quantum lower certificate.'}
    (R/'fresh-corrected-summary.json').write_text(json.dumps(summary,indent=2)+'\n');print(json.dumps(summary),flush=True)
    x=next(x for x in xs if x['id']=='fresh-L13-0');s=rs.search(x,13,100000000)
    result={'source_candidate':x,'search':s,'corrected_replay':True,'verified_counterexample_to_strengthened_criterion':bool(s['witness'])}
    if s['witness']:result['independent_dense']=iv.verify(x['E'],13,s['witness'])
    (R/'intermediate-corrected.json').write_text(json.dumps(result,indent=2)+'\n');print(json.dumps({'phase':'intermediate','search':s}),flush=True)
if __name__=='__main__':main()
