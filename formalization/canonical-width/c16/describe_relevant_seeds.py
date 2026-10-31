#!/usr/bin/env python3
"""Post-comparison interpretation of exactly the frozen seed bank, no solver calls."""
from pathlib import Path
import argparse,collections,hashlib,json,time
from verify_algebraic_model import physical
from verify_anchored_cover_chain import physical as graph,canonical
from verify_mandatory_closure import ClosureConsumer
from verify_domain_closure import DomainClosureConsumer
ROOT=Path(__file__).resolve().parent

def main():
    p=argparse.ArgumentParser();p.add_argument('--output',type=Path,required=True);a=p.parse_args();start=time.monotonic();folder=ROOT/'relevant-results';sp=folder/'comparison-seed-cuts.json';seeds=json.loads(sp.read_text())['cuts'];gate=json.loads((folder/'independent-gate.json').read_text());assert hashlib.sha256(sp.read_bytes()).hexdigest()==gate['comparison_seed_sha256'];X,Z,A=physical();AA,C,pos,sig=graph();assert A==AA;R=set(map(tuple,json.loads((ROOT/'strategy-results/domain-batch-408.json').read_text())['classes']));allowed=A.copy()
    for (i,j),s in sig.items():
        if s and canonical(i,j) not in R:allowed[i]&=~(1<<j)
    full=ClosureConsumer(X,Z,A);domain=DomainClosureConsumer(X,Z,A,allowed);records=[]
    for k,cut in enumerate(seeds):
        req=[[],[]];req[cut['sector']]=cut['indices'];unrestricted=full.replay(*req);restricted=domain.replay(*req);records.append({'seed_index':k,'sector':cut['sector'],'ids':cut['indices'],'order':cut['certificate']['order'],'unrestricted_propagation':unrestricted,'restricted_propagation':restricted})
    result={'status':'PASS','source_C16_answered':False,'seed_sha256':hashlib.sha256(sp.read_bytes()).hexdigest(),'selected_patterns':len(seeds),'cardinality_counts':dict(collections.Counter(len(c['indices']) for c in seeds)),'detecting_support_counts':dict(collections.Counter(c['certificate']['order'] for c in seeds)),'accepted_by_unrestricted_propagation':sum(r['unrestricted_propagation']['possible'] for r in records),'accepted_by_restricted_propagation':sum(r['restricted_propagation']['possible'] for r in records),'physical_forced_coloop_covectors_checked':full.forced_covectors_checked+domain.forced_covectors_checked,'records':records,'elapsed_seconds':time.monotonic()-start,'scope':'Post-comparison descriptive overlap on the unchanged256 selected source-clause patterns. Existing propagation is independently replayed both unrestricted and on the exact110-class domain. The result does not alter the frozen comparison or prove a new cover.'}
    a.output.write_text(json.dumps(result,indent=2)+'\n');print({k:v for k,v in result.items() if k!='records'},flush=True)
if __name__=='__main__':main()
