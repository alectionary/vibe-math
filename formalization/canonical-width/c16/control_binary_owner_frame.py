#!/usr/bin/env python3
"""Exact small controls for direct owners, binary addition and the propagator."""
from pathlib import Path
from itertools import product,combinations
import argparse,hashlib,json,tempfile
from pysat.solvers import Solver
from binary_owner_frame_model import build
from owner_frame_model import binary_count
from conditional_span_oracle import ConditionalSpanOracle
def main():
    p=argparse.ArgumentParser();p.add_argument('--library',type=Path,required=True);p.add_argument('--output',type=Path,required=True);a=p.parse_args();truth_checks=0
    # Exact extension, for every input word of every count size1..10.
    for length in range(1,11):
        cnf=[];bits,n,gates=binary_count(list(range(1,length+1)),cnf,length)
        with Solver(name='cadical195',bootstrap_with=cnf) as s:
            for values in product((0,1),repeat=length):
                assumptions=[i+1 if b else -i-1 for i,b in enumerate(values)];assert s.solve(assumptions=assumptions);model=set(s.get_model());actual=sum((1<<k) for k,v in enumerate(bits) if v in model);assert actual==sum(values);truth_checks+=1
    integration=[];fixed_checks=0
    with tempfile.TemporaryDirectory(prefix='c16-owner-controls-') as temp:
        for name,V,N,expected in [('all2',[1,2,3],2,True),('nonsplit4',[4,8,13,14,15],4,False),('all4',list(range(1,16)),4,True),('canonical4',[1,2,4,8],4,True)]:
            A=[sum(((x&z).bit_count()%2)<<j for j,z in enumerate(V)) for x in V];cnf,n,details=build(V,V,A,dimension=N)
            static=[]
            for side in [0,1]:
                for i,mask in enumerate(A):
                    for j,k in combinations([j for j in range(len(V)) if mask>>j&1],2):static.append([-1-i-len(V)*side,-1-j-len(V)*(1-side),-1-k-len(V)*(1-side)])
            if len(V)<=5:
                with Solver(name='cadical195',bootstrap_with=cnf) as s:
                    for values in product((0,1),repeat=2*len(V)):
                        xi=[i for i in range(len(V)) if values[i]];zj=[j for j in range(len(V)) if values[len(V)+j]];physical=(len(xi)==len(zj)==N and all(sum(bool(A[i]>>j&1) for j in zj)==1 for i in xi) and all(sum(bool(A[i]>>j&1) for i in xi)==1 for j in zj));answer=s.solve(assumptions=[i+1 if b else -i-1 for i,b in enumerate(values)]);assert answer==physical;fixed_checks+=1
            for variant in ['baseline','span']:
                oracle=ConditionalSpanOracle(V,V,a.library,Path(temp)/(name+variant+'.jsonl'),dimension=N) if variant=='span' else None
                with Solver(name='cadical195',bootstrap_with=cnf) as s:
                    if oracle:
                        s.connect_propagator(oracle)
                        for v in range(1,2*len(V)+1):s.observe(v)
                    answer=s.solve();assert answer==expected
                    if answer:
                        true=set(s.get_model());xi=[i for i in range(len(V)) if i+1 in true];zj=[j for j in range(len(V)) if len(V)+j+1 in true];assert len(xi)==len(zj)==N
                        assert all(sum(bool(A[i]>>j&1) for j in zj)==1 for i in xi) and all(sum(bool(A[i]>>j&1) for i in xi)==1 for j in zj)
                    integration.append({'pool':name,'variant':variant,'answer':answer,'oracle_statistics':oracle.stats.copy() if oracle else None})
                if oracle:oracle.close()
    d={'status':'PASS','adder_input_truth_checks':truth_checks,'fixed_owner_extension_truth_checks':fixed_checks,'static_binary_model':True,'fixed_assignment_checks_use_static_model_without_added_matching_clauses':True,'callback_integrations':integration,'native_library_sha256':hashlib.sha256(a.library.read_bytes()).hexdigest(),'scope':'Exact small Boolean-adder and model equivalence controls, plus actual direct-owner matching/span callbacks. No C16 satisfiability conclusion.'};a.output.write_text(json.dumps(d,indent=2)+'\n');print('OWNER CONTROLS PASS',truth_checks,fixed_checks,len(integration),flush=True)
if __name__=='__main__':main()
