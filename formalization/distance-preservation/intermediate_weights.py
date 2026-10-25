"""One separately frozen adaptive finite follow-up, not part of the104-base sample."""
from pathlib import Path
import json
import run_search
import independent_verify as iv
R=Path(__file__).resolve().parent
if __name__=='__main__':
    x=next(json.loads(s) for s in (R/'fresh-results.jsonl').read_text().splitlines() if json.loads(s)['id']=='fresh-L13-0')
    assert x['classical']['distance']==14 and x['transpose']['distance']==26
    result=run_search.search(x,13,100000000)
    out={'question':'Does this particular code have quantum distance at most13?','selection':'First L13 entry from the completed bounded104-base campaign; adaptive separate follow-up.',
         'source_candidate':x,'search':result}
    if result['witness']:
        out['independent_dense']=iv.verify(x['E'],13,result['witness'])
        out['verified_counterexample_to_strengthened_criterion']=True
    else:out['verified_counterexample_to_strengthened_criterion']=False
    (R/'intermediate-weights.json').write_text(json.dumps(out,indent=2)+'\n')
    print(json.dumps({k:v for k,v in out.items() if k not in ['source_candidate','independent_dense']}),flush=True)
