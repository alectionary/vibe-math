"""Replay all earlier standalone search records with the repaired executable."""
from pathlib import Path
import datetime, json
import run_search as rs
R=Path(__file__).resolve().parent
def main():
    outputs=[]
    for name in ['search-results.jsonl','search-through-ten.jsonl','exhaustive-representative-search.json','witness-L11-bound9.json','witness-L11-bound10.json','witness-L11-bound11.json']:
        p=R/name
        if p.suffix=='.jsonl':xs=[json.loads(s) for s in p.read_text().splitlines()]
        else:
            xs=json.loads(p.read_text())
            if isinstance(xs,dict):xs=[xs]
        results=[]
        for x in xs:
            y=rs.search(x,x['bound'],x['node_limit'],x.get('side','X'))
            results.append(y)
        dest=p.stem+'-corrected.json'
        (R/dest).write_text(json.dumps(results,indent=2)+'\n')
        summary={'original':name,'corrected':dest,'count':len(results),
                 'previous_negative':sum(not x['witness'] and not x['budget_exhausted'] for x in xs),
                 'previous_negative_now_witness':sum(not x['witness'] and not x['budget_exhausted'] and bool(y['witness']) for x,y in zip(xs,results)),
                 'corrected_no_witness_completed':sum(not y['witness'] and not y['budget_exhausted'] for y in results),
                 'corrected_budget_exhausted':sum(y['budget_exhausted'] for y in results)}
        outputs.append(summary);print(json.dumps(summary),flush=True)
    (R/'historical-corrected-summary.json').write_text(json.dumps({'checked_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'replays':outputs},indent=2)+'\n')
if __name__=='__main__':main()
