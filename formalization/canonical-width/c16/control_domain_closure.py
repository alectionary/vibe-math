#!/usr/bin/env python3
"""Complete tiny allowed-edge domain/mandatory-set soundness controls."""
from pathlib import Path
from itertools import combinations
import argparse,json,hashlib,collections
from native_domain_forced_propagation import NativeDomainForcedPropagation
from verify_domain_closure import DomainClosureConsumer
def main():
    p=argparse.ArgumentParser();p.add_argument('--library',type=Path,required=True);p.add_argument('--output',type=Path,required=True);a=p.parse_args();V=[1,2,3];A=[sum(((x&z).bit_count()%2)<<j for j,z in enumerate(V)) for x in V];edges=[(i,j) for i in range(3) for j in range(3) if A[i]>>j&1];assert len(edges)==6;frames=[]
    for left in combinations(range(3),2):
        for right in combinations(range(3),2):
            pairs=[]
            for i in left:
                js=[j for j in right if A[i]>>j&1]
                if len(js)!=1:break
                pairs.append((i,js[0]))
            if len(pairs)==2 and len({j for i,j in pairs})==2:frames.append((set(left),set(right),set(pairs)))
    assert len(frames)==3;checks=0;positive=0;rejected=0;native_checks=0
    for mask in range(64):
        allowed=[0]*3
        for k,(i,j) in enumerate(edges):
            if mask>>k&1:allowed[i]|=1<<j
        consumer=DomainClosureConsumer(V,V,A,allowed,dimension=2);native=NativeDomainForcedPropagation(V,V,allowed,a.library,dimension=2)
        for mx in range(8):
            core=native.exclusion(mx);native_checks+=1
            if core is not None:assert not consumer.replay(core)['possible']
            for mz in range(8):
                X={i for i in range(3) if mx>>i&1};Z={j for j in range(3) if mz>>j&1};exists=any(X<=xx and Z<=zz and all(allowed[i]>>j&1 for i,j in pairs) for xx,zz,pairs in frames);res=consumer.replay(sorted(X),sorted(Z));checks+=1;positive+=exists;rejected+=not res['possible']
                if exists:assert res['possible'] and (mz!=0 or core is None)
        native.close()
    out={'status':'PASS','all_binary_dimension2_full_frames':3,'allowed_edge_domains_exhausted':64,'mandatory_domain_combinations_checked':checks,'feasible_completions_retained':positive,'necessary_propagation_rejections':rejected,'native_one_sector_queries':native_checks,'all_native_exclusions_independently_replayed':True,'native_library_sha256':hashlib.sha256(a.library.read_bytes()).hexdigest(),'source_C16_answered':False,'scope':'Exhaustive arbitrary allowed-edge restrictions and mandatory sets. Domain clauses remain conditional on their exact allowed graph.'};a.output.write_text(json.dumps(out,indent=2)+'\n');print('DOMAIN CLOSURE CONTROLS PASS',checks,positive,rejected,native_checks,flush=True)
if __name__=='__main__':main()
