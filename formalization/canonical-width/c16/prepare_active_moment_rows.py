#!/usr/bin/env python3
"""Select violated necessary rows; selection never establishes feasibility."""
from pathlib import Path
import argparse,hashlib,json,time
import numpy as np
from physical_circuit_moment_matrix import matrix as circuit_matrix
from physical_legacy_linear_moments import build as legacy_matrix
ROOT=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def main():
 ap=argparse.ArgumentParser();ap.add_argument('--candidate',type=Path,required=True);ap.add_argument('--parent',type=Path);ap.add_argument('--tolerance',type=float,default=1e-5);ap.add_argument('--max-new-per-family',type=int,default=500);ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();start=time.monotonic();bank=ROOT/'moment-resumption-results/physical-rank-moment-bank.json';d=json.loads(bank.read_text());C,_,_=circuit_matrix(d['physical_circuits']);L,rhs,_,_,_=legacy_matrix(d['mapping']);v=np.load(a.candidate);x=np.concatenate([v['p']]+[v[f'{s}{h}'].ravel() for s in 'ST' for h in range(9)]);old=json.loads(a.parent.read_text()) if a.parent else {};active={};stats={}
 for key,M,b in [('circuit',C,0),('legacy',L,np.array(rhs))]:
  residual=M@x-b;prior=set(old.get('active_indices',{}).get(key,[]));new=[int(i) for i in np.argsort(-residual) if residual[i]>a.tolerance and int(i) not in prior][:a.max_new_per_family];active[key]=sorted(prior|set(new));stats[key]={'total_rows':M.shape[0],'above_tolerance':int(np.sum(residual>a.tolerance)),'maximum_violation':float(residual.max(initial=0)),'new_rows':len(new),'retained_rows':len(prior),'active_rows':len(active[key])}
 files=['physical_circuit_moment_matrix.py','physical_legacy_linear_moments.py','moment-resumption-results/physical-rank-moment-bank.json'];out={'status':'VALID_ROW_SUBSET_SELECTED','source_C16_answered':False,'candidate_sha256':sha(a.candidate),'parent_sha256':sha(a.parent) if a.parent else None,'tolerance':a.tolerance,'max_new_per_family':a.max_new_per_family,'active_indices':active,'statistics':stats,'source_hashes':{p:sha(ROOT/p) for p in files},'elapsed_seconds':time.monotonic()-start,'scope':'A subset of previously justified necessary circuit and legacy linear rows. All ownership rows and full local profile weights remain in the model. No full-family feasibility follows from a numerical screen.'};a.output.write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(stats),flush=True)
if __name__=='__main__':main()
