#!/usr/bin/env python3
"""Apply the existing rank oracle to the new compact-cover witnesses.

This is a new application of rank_oracle.zero_exclusion, not a new rank theorem.
The emitted physical annihilators are independently consumed before use.
"""
from pathlib import Path
import argparse,json,time,hashlib
from verify_algebraic_model import physical
from rank_oracle import basis,zero_exclusion
ROOT=Path(__file__).resolve().parent
def main():
    ap=argparse.ArgumentParser();ap.add_argument('--folder',type=Path,required=True);ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();start=time.monotonic();X,Z,A=physical();records=[];cuts=[];seen=set()
    for sub in [a.folder,a.folder/'remaining']:
        for p in sorted(sub.glob('case-*-rank.json')):
            d=json.loads(p.read_text())
            if d['answer'] is not True:continue
            row={'case':d['case'],'metadata_file':str(p.resolve().relative_to(ROOT)),'metadata_sha256':hashlib.sha256(p.read_bytes()).hexdigest(),'pairs':d['partial_pairs'],'sides':[]}
            for side in (0,1):
                U,V=(X,Z) if side==0 else (Z,X);ids=[pair[side] for pair in d['partial_pairs']];bits=sum(1<<i for i in ids);az=[sum(((u&v).bit_count()%2)<<i for i,u in enumerate(U)) for v in V];zero=basis(v for v,mask in zip(V,az) if not mask&bits);bad=len(zero)<128-len(ids);rec={'sector':side,'selected':len(ids),'zero_rank':len(zero),'required_zero_rank':128-len(ids),'bad':bad}
                if bad:
                    # Greedy deletion, not enumeration of all subsets.  A smaller
                    # still-deficient set yields a clause that forbids more models.
                    core=ids.copy()
                    for i in reversed(ids):
                        trial=[j for j in core if j!=i];mask=sum(1<<j for j in trial);span=basis(v for v,m in zip(V,az) if not m&mask)
                        if len(span)<128-len(trial):core=trial
                    cbits=sum(1<<i for i in core);czero=basis(v for v,m in zip(V,az) if not m&cbits)
                    cut=zero_exclusion(U,V,az,core,cbits,czero);key=(side,tuple(cut['indices']))
                    if key not in seen:seen.add(key);cuts.append({'sector':side,**cut})
                    rec['core_indices']=cut['indices'];rec['annihilator']=cut['annihilator']
                row['sides'].append(rec)
            records.append(row)
    out={'status':'CANDIDATE_REQUIRES_INDEPENDENT_REPLAY','source_C16_answered':False,'records':records,'cuts':cuts,'method':'Previously implemented zero_exclusion rank oracle, now applied to compact cover witnesses in both sectors.','elapsed_seconds':time.monotonic()-start};a.output.write_text(json.dumps(out,indent=2)+'\n');print('MIXED COHORT',len(records),'rejected',sum(any(s['bad'] for s in r['sides']) for r in records),'distinct cuts',len(cuts),flush=True)
if __name__=='__main__':main()
