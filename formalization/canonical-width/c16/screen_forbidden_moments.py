#!/usr/bin/env python3
"""Exact degree-two consequences of previously checked forbidden source patterns.

For a forbidden m-set J, conditioning on any a in J gives
sum_{b in J-a} E[x_a x_b] <= (m-2) E[x_a].
This is a source implication, not an assumption of independent selections.
"""
from pathlib import Path
from fractions import Fraction
import argparse,gzip,hashlib,json,time
from certify_profile_moment_point import layout
ROOT=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def main():
    ap=argparse.ArgumentParser();ap.add_argument('--point',type=Path,required=True);ap.add_argument('--bank',type=Path,nargs='+',required=True);ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();a.point=a.point.resolve();a.bank=[p.resolve() for p in a.bank];start=time.monotonic()
    hull=ROOT/'algebraic-results/hulls-16-rank.json.gz';names,index,m=layout(json.loads(gzip.decompress(hull.read_bytes())));v=list(map(Fraction,json.loads(gzip.decompress(a.point.read_bytes()))['values']))
    violations=[];tested=0;seen=set();minimum=None
    for bp in a.bank:
        for k,c in enumerate(json.loads(bp.read_text())['cuts']):
            assert c['kind'] in ('universal_sparse_quotient','universal_sparse_quotient_four');J=c['indices'];assert len(J)>=2
            for anchor in J:
                terms=tuple(sorted(m('S',(b-anchor)%16,anchor//16,b//16) for b in J if b!=anchor));key=(index['p',anchor//16],len(J)-2,terms)
                if key in seen:continue
                seen.add(key);tested+=1;slack=(len(J)-2)*v[key[0]]-sum(v[t] for t in terms)
                minimum=slack if minimum is None else min(minimum,slack)
                if slack<0:violations.append({'bank':str(bp.relative_to(ROOT)),'bank_index':k,'ids':J,'anchor':anchor,'terms':terms,'p_index':key[0],'bound':key[1],'exact_slack':str(slack)})
    violations.sort(key=lambda r:Fraction(r['exact_slack']))
    # Exhaustively verify the Boolean implication for all subset sizes occurring.
    sizes={len(c['indices']) for bp in a.bank for c in json.loads(bp.read_text())['cuts']}
    controls=0
    for n in sizes:
        for mask in range((1<<n)-1):
            for i in range(n):
                lhs=sum(((mask>>i)&1)*((mask>>j)&1) for j in range(n) if j!=i)
                assert lhs<=(n-2)*((mask>>i)&1);controls+=1
    result={'status':'PASS','source_C16_answered':False,'point':str(a.point.relative_to(ROOT)),'point_sha256':sha(a.point),
            'bank_hashes':{str(p.relative_to(ROOT)):sha(p) for p in a.bank},'distinct_conditioned_moment_inequalities':tested,
            'violated_inequalities':len(violations),'minimum_exact_slack':str(minimum),'violations':violations,
            'literal_boolean_implication_controls':controls,'elapsed_seconds':time.monotonic()-start,
            'scope':'Exact screening of valid conditioned second-moment inequalities from the specified already checked universal source patterns. This script binds the bank but does not recheck its source certificates. Violating a saved point does not prove relaxation infeasibility.'}
    a.output.write_text(json.dumps(result,indent=2)+'\n');print({k:v for k,v in result.items() if k!='violations'},flush=True)
if __name__=='__main__':main()
