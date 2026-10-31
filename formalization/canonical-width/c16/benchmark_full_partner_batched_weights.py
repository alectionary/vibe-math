#!/usr/bin/env python3
"""Frozen matched exactness and timing controls for batch phase weights."""
from pathlib import Path
import argparse,hashlib,json,platform,statistics,time
import numpy as np
from full_partner_batched_weights import IntegerPhaseWeightBatch,support_all_batched
from full_partner_projection import mask_universe,support_all,sha
from full_partner_projection_features import candidate_weights
from full_partner_basis_oracle import FullPartnerBasisOracle
ROOT=Path(__file__).resolve().parent


def main():
    ap=argparse.ArgumentParser(description=__doc__);ap.add_argument('--repeats',type=int,default=3)
    ap.add_argument('--output',type=Path,required=True);a=ap.parse_args()
    assert a.repeats>0 and not a.output.exists() and not a.output.with_suffix('.frozen.json').exists()
    start=time.monotonic();banks=['coupling-results/full-partner-projection-existing11T-necessary0.json',
                               'coupling-results/full-partner-projection-wolfe-witness2.json']
    cohorts=[{'name':Path(p).stem,'coefficients':json.loads((ROOT/p).read_text())['cuts'][0]['coefficients']} for p in banks]
    cohorts.append({'name':'dense_signed_control','coefficients':[0]*10+[(53*j+17)%197-98 for j in range(765)]})
    cohorts.append({'name':'large_signed_safe_control','coefficients':[0]*10+[((j%3)-1)*(1<<55) for j in range(765)]})
    allowed,reps=mask_universe(32);batch=IntegerPhaseWeightBatch(reps);oracle=FullPartnerBasisOracle()
    domains=[(m,oracle.prepare(32,m)) for m in reps]
    paths=['benchmark_full_partner_batched_weights.py','full_partner_batched_weights.py',
           'full_partner_projection.py','full_partner_projection_features.py','full_partner_basis_oracle.py',
           'algebraic-results/orbit-rank-profiles.json.gz','algebraic-results/hulls-16-rank.json.gz',
           'pools/xcoords.txt','pools/zcoords.txt',*banks]
    hashes={p:sha(ROOT/p) for p in paths}
    frozen={'status':'FROZEN_BEFORE_BATCH_WEIGHT_BENCHMARK','source_C16_answered':False,
        'source_hashes':hashes,'cohorts':cohorts,'representatives':reps,'repeats':a.repeats,
        'python':platform.python_version(),'numpy':np.__version__,
        'scope':'Exact weight/support/witness agreement and alternating-order component timings. Concurrentresearch mayrun; no fullsolver speedup is claimed.'}
    fp=a.output.with_suffix('.frozen.json');fp.write_text(json.dumps(frozen,indent=2)+'\n')
    records=[]
    for cohort in cohorts:
        c=cohort['coefficients'];old=np.asarray([candidate_weights(m,c) for m in reps],dtype=np.int64);new=batch.weights(c)
        assert np.array_equal(old,new)
        reference=support_all(oracle,domains,c);observed=support_all_batched(oracle,domains,c,batch)
        assert reference==observed
        timing={'old_weights':[],'batch_weights':[],'old_full_support':[],'batch_full_support':[]}
        for repeat in range(a.repeats):
            order=['old','batch'] if repeat%2==0 else ['batch','old']
            for mode in order:
                before=time.monotonic()
                if mode=='old':result=[candidate_weights(m,c) for m in reps]
                else:result=batch.weights(c)
                timing['old_weights' if mode=='old' else 'batch_weights'].append(time.monotonic()-before)
                assert np.array_equal(np.asarray(result,dtype=np.int64),old)
                before=time.monotonic()
                result=support_all(oracle,domains,c) if mode=='old' else support_all_batched(oracle,domains,c,batch)
                timing['old_full_support' if mode=='old' else 'batch_full_support'].append(time.monotonic()-before)
                assert result==reference
        record={'cohort':cohort['name'],'all291x720_integer_weights_equal':True,
                'all291_support_values_and128_index_witnesses_equal':True,'full_support_bound':reference[0],
                'weight_matrix_sha256':hashlib.sha256(old.tobytes(order='C')).hexdigest(),
                'timing_seconds':timing,'median_seconds':{k:statistics.median(v) for k,v in timing.items()}}
        records.append(record);print(json.dumps({k:v for k,v in record.items() if k!='timing_seconds'}),flush=True)
    rejected=[]
    for name,c in [('overflow',[0]*55+[(1<<62)]*720),('noninteger',[0]*10+[.5]*765),('wrong_length',[0]*774)]:
        try:batch.weights(c)
        except (ValueError,TypeError,OverflowError) as error:rejected.append({'case':name,'rejected':True,'reason':str(error)})
        else:raise AssertionError(name+' unexpectedlyaccepted')
    assert all(sha(ROOT/p)==digest for p,digest in hashes.items())
    out={'status':'PASS','source_C16_answered':False,'frozen_sha256':sha(fp),'source_hashes':hashes,
         'records':records,'negative_controls':rejected,'elapsed_seconds':time.monotonic()-start,
         'scope':frozen['scope']+' Independent source-cut consumer remains purePython and unchanged.'}
    a.output.write_text(json.dumps(out,indent=2)+'\n');print(json.dumps({'status':'PASS','elapsed_seconds':out['elapsed_seconds']}),flush=True)


if __name__=='__main__':main()
