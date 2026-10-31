#!/usr/bin/env python3
"""Independent truth-table and literal group-average controls for new rows."""
from pathlib import Path
from fractions import Fraction
from itertools import product,combinations
import gzip,hashlib,json,random,subprocess,time
import numpy as np
from complete_boolean_triples import matrix
ROOT=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def main():
    start=time.monotonic();rng=random.Random(202610300330);out=ROOT/'moment-resumption-results'
    global_path=out/'global-four-trial.json';replay_path=out/'global-four-trial-independent.json'
    commit='a423fbe913ea02a7fa536e6994151fe65100f9d6'
    for p in (global_path,replay_path):
        relative='formalization/canonical-width/c16/'+str(p.relative_to(ROOT))
        assert hashlib.sha256(subprocess.check_output(['git','show',f'{commit}:{relative}'],cwd=ROOT)).hexdigest()==sha(p)
    allcuts=json.loads(global_path.read_text())['cuts'];selected=rng.sample(allcuts,512)
    selected.extend(c for c in allcuts if c['kind'] in ('joint_forced_propagation','joint_domain_forced_propagation','universal_sparse_quotient_four'))
    global_checks=0;boolean_checks=0;truth_checks=0
    bank=out/'consolidated-all-triples.json';BM,rhs,rows=matrix([bank]);cuts=json.loads(bank.read_text())['cuts']
    for kind in ('triangle','union'):
        for a,b,c in product((0,1),repeat=3):
            val=a*b+a*c-b*c-a if kind=='triangle' else a+b+c-a*b-a*c-b*c-1
            assert val<=0;truth_checks+=1
    # The local probe's sole cut happens to be universally Boolean valid; replay
    # all 4096 assignments, without trusting the producer's physical filtering.
    local=json.loads((out/'local-joint-consolidated.json').read_text());local_checks=0
    for cut in local['cuts']:
        for bits in product((0,1),repeat=len(cut['events'])):
            feature=[1,*bits,*(bits[i]*bits[j] for i,j in combinations(range(len(bits)),2))]
            assert sum(a*b for a,b in zip(feature,cut['coefficients']))<=0;local_checks+=1
    for case in range(4):
        masks=[[rng.getrandbits(16) for _ in range(45)] for s in (0,1)]
        def bit(side,index,shift=0,swap=0):return masks[side^swap][index//16]>>((index%16+shift)%16)&1
        def first(side,index):return sum(bit(side,index,h,s) for h in range(16) for s in (0,1))
        def pair(side,i,other,j):return sum(bit(side,i,h,s)*bit(other,j,h,s) for h in range(16) for s in (0,1))
        def folded(side,h,i,j):return pair(0,16*i,0 if side=='S' else 1,16*j+h)
        flat=np.array([first(0,16*i) for i in range(45)]+[folded(side,h,i,j) for side in 'ST' for h in range(9) for i in range(45) for j in range(45)],dtype=np.int64)
        compiled=BM@flat-32*rhs
        for k,cut in enumerate(cuts):
            literal=0
            for h in range(16):
                for swap in (0,1):
                    a,b,c=[bit(*divmod(e,720),h,swap) for e in cut['events']]
                    literal+=a*b+a*c-b*c-a if cut['kind']=='triangle' else a+b+c-a*b-a*c-b*c-1
            row,bound=__import__('complete_boolean_triples').terms(cut)
            evaluated=sum(coef*int(flat[col]) for col,coef in row)-32*bound
            assert literal==evaluated;boolean_checks+=1
        for cut in selected:
            if cut['kind'] in ('joint_forced_propagation','joint_domain_forced_propagation'):
                events=[(0,j) for j in cut['required_X']]+[(1,j) for j in cut['required_Z']]
            else:events=[(cut['sector'],j) for j in cut['indices']]
            for side,anchor in events:
                # Consumer's folded phase formula versus direct full 32-action average.
                folded_value=sum(folded('S' if side==t else 'T',(j-anchor)%16,anchor//16,j//16) for t,j in events if (t,j)!=(side,anchor))-(len(events)-2)*first(0,16*(anchor//16))
                literal=sum(bit(side,anchor,h,s)*(sum(bit(t,j,h,s) for t,j in events if (t,j)!=(side,anchor))-(len(events)-2)) for h in range(16) for s in (0,1))
                assert folded_value==literal;global_checks+=1
    # Independent interval characterization of every rational 3-variable moment
    # attainable on a small denominator grid, using all eight atom probabilities.
    interval_checks=0
    for weights in product(range(3),repeat=8):
        total=sum(weights)
        if not total:continue
        atoms=list(product((0,1),repeat=3));p=[Fraction(sum(w*x[i] for w,x in zip(weights,atoms)),total) for i in range(3)]
        ab,ac,bc=[Fraction(sum(w*x[i]*x[j] for w,x in zip(weights,atoms)),total) for i,j in ((0,1),(0,2),(1,2))]
        low=max(Fraction(0),ab+ac-p[0],ab+bc-p[1],ac+bc-p[2]);high=min(ab,ac,bc,1-sum(p)+ab+ac+bc)
        actual=Fraction(weights[-1],total);assert low<=actual<=high;interval_checks+=1
    result={'status':'PASS','source_C16_answered':False,'immutable_global_dependency_commit':commit,
            'immutable_global_artifacts_checked':2,'global_sampled_obstruction_sets':len(selected),
            'global_literal_symmetry_comparisons':global_checks,'boolean_truth_table_checks':truth_checks,
            'boolean_literal_symmetry_comparisons':boolean_checks,'local_cut_unfiltered_truth_table_checks':local_checks,
            'triple_distribution_interval_controls':interval_checks,'all_global_rows_screened_separately':213662,
            'selected_boolean_bank_sha256':sha(bank),'local_probe_sha256':sha(out/'local-joint-consolidated.json'),
            'consumer_sha256':sha(Path(__file__)),'elapsed_seconds':time.monotonic()-start,
            'scope':'Exact implementation controls and immutable dependency binding. Sampled translation checks are not an exhaustive proof over arbitrary code inputs; the identities are also derived in the report.'}
    (out/'new-moment-translations-independent.json').write_text(json.dumps(result,indent=2)+'\n');print(result,flush=True)
if __name__=='__main__':main()
