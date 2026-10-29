#!/usr/bin/env python3
"""Bounded complete canonical pair screen by residual supports of size<=4."""
from pathlib import Path
from itertools import combinations
import argparse,collections,datetime,hashlib,json,time
from sparse_quotient_four import probe
from verify_four_term_small import check
from verify_sparse_gate import independent_obstruction
from verify_algebraic_model import physical
ROOT=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def canonical(ids):return min(tuple(sorted(16*(i//16)+(i%16+h)%16 for i in ids)) for h in range(16))
def main():
    ap=argparse.ArgumentParser();ap.add_argument('--seconds',type=float,default=1200);ap.add_argument('--output-directory',type=Path,required=True);a=ap.parse_args();a.output_directory.mkdir(exist_ok=False);start=time.monotonic()
    # Canonical distinct source pairs:8 displacements within an orbit,16 across.
    cohort=sorted({canonical((16*i,16*j+h)) for i in range(45) for j in range(i,45) for h in range(16) if i!=j or h});assert len(cohort)==16200
    f={'status':'FROZEN_BEFORE_CANONICAL_PAIR_SCREEN','utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'source_C16_answered':False,
       'seconds':a.seconds,'cohort':cohort,'source_hashes':{p:sha(ROOT/p) for p in ['pair_four_screen.py','sparse_quotient_four.py','verify_four_term_small.py','verify_sparse_gate.py']},
       'scope':'All16200 cyclic/sector orbits of distinct source pool pairs, lexicographic order. Complete support<=4 predicate on full-rank residuals; rank-deficient pairs separately reported, not silently accepted. One witness per pair, no full-frame enumeration. The known pair[416,512] motivated this exploratory extension; no held-out benchmark claim.'}
    fp=a.output_directory/'frozen.json';fp.write_text(json.dumps(f,indent=2)+'\n');X,Z,A=physical();records=[];cuts=[];stats=collections.Counter();rank_deficient=[]
    d={'status':'RUNNING','source_C16_answered':False,'frozen_sha256':sha(fp),'records':records,'cuts':cuts,'rank_deficient_pairs':rank_deficient}
    def save():
        d.update(processed=len(records),elapsed_seconds=time.monotonic()-start,statistics=dict(stats));p=a.output_directory/'screen.json';t=p.with_suffix('.tmp');t.write_text(json.dumps(d,indent=2)+'\n');t.replace(p)
    from sparse_quotient_four import span
    for k,J in enumerate(cohort):
        if time.monotonic()-start>a.seconds:d['status']='TIME_LIMIT';break
        counts=collections.Counter();found=probe(X,Z,J,cap=1,stats=counts);stats.update(counts);r={'ids':J,'order4_reject':bool(found)}
        if found:
            result=found[0];row={'kind':'sparse_quotient_obstruction','side':0,**result,'clause':[-j-721 for j in J]};r['check']=check(X,Z,row);old=independent_obstruction(X,Z,0,J);r['old_complete_orders']=old
            cuts.append({'kind':'universal_sparse_quotient_four' if row['order']==4 else 'universal_sparse_quotient','sector':1,'indices':list(J),'certificate':row})
            print('PAIR FOUND',k,J,'order',row['order'],'strict4',not old[3],flush=True)
        elif not counts:
            # An empty support list can also mean discovery delegated rank.
            rank=len(span(x for x in X if all(not (x&Z[j]).bit_count()%2 for j in J)))
            if rank<126:rank_deficient.append(list(J));r['residual_rank']=rank
        records.append(r)
        if k%100==0:save();print('PAIR SCREEN',k,'cuts',len(cuts),'sec',round(d['elapsed_seconds'],2),flush=True)
    else:d['status']='COMPLETE'
    save();print('PAIR SCREEN END',d['status'],len(records),len(cuts),flush=True)
if __name__=='__main__':main()
