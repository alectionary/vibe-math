#!/usr/bin/env python3
"""Labeled synthetic acceptance/rejection controls for the new generic consumer."""
from pathlib import Path
from fractions import Fraction
import copy,json,subprocess,sys,time
from full_partner_projection import read,sha,mask_universe,LAYOUT
from full_partner_safe_pricing import support_all
from full_partner_batched_weights import IntegerPhaseWeightBatch
from full_partner_basis_oracle import FullPartnerBasisOracle
from verify_full_partner_projection_generic import matrix,point_data
ROOT=Path(__file__).resolve().parent


def main():
    started=time.monotonic();prefix=ROOT/'coupling-results/full-partner-generic-control'
    out=prefix.with_suffix('.json');assert not out.exists()
    original=ROOT/'coupling-results/basis-witness5-rational.json.gz'
    point=read(original);point['values'][0]=str(Fraction(point['values'][0])+Fraction(1,16))
    point['status']='SYNTHETIC_NONFEASIBLE_CARDINALITY129_CONTROL'
    point['scope']='Deliberately violates full-basis cardinality128. This is a consumer control, never a source or moment feasibility result.'
    pp=prefix.with_name(prefix.name+'-point.json');pp.write_text(json.dumps(point,indent=2)+'\n')
    allowed,reps=mask_universe(27);oracle=FullPartnerBasisOracle()
    domains=[(m,oracle.prepare(27,m)) for m in reps];c=[0]*775;c[10:55]=[1]*45
    bound,records,_=support_all(oracle,domains,c,IntegerPhaseWeightBatch(reps));assert bound==128
    owner,target=point_data(pp,27);value=sum(a*b for a,b in zip(c,target));assert value==129
    paths=['physical-pool-source.json','pools/xcoords.txt','pools/zcoords.txt',
        'algebraic-results/orbit-rank-profiles.json.gz','algebraic-results/hulls-16-rank.json.gz',
        'verify_full_partner_projection_generic.py','control_full_partner_projection_generic.py']
    import hashlib
    bank={'status':'EXACT_SUPPORT_CUT_CANDIDATE','source_C16_answered':False,'orbit':27,
        'point_sha256':sha(pp),'feature_layout':LAYOUT,'source_hashes':{p:sha(ROOT/p) for p in paths},
        'allowed_masks':len(allowed),'representatives':reps,
        'allowed_mask_list_sha256':hashlib.sha256(json.dumps(allowed,separators=(',',':')).encode()).hexdigest(),
        'cuts':[{'coefficients':c,'upper_bound':128,'exact_target_value':'129','exact_violation':'1',
            'pricing_scale':1,'support_records':records}],
        'control_only':True,'scope':'Synthetic cardinality129 consumer positive control; not a new moment result.'}
    bp=prefix.with_name(prefix.name+'-positive.json');bp.write_text(json.dumps(bank,indent=2)+'\n')
    rp=prefix.with_name(prefix.name+'-positive-independent.json')
    consumer=ROOT/'verify_full_partner_projection_generic.py'
    def run(path,receipt):
        return subprocess.run([sys.executable,'-B',str(consumer),'--orbit','27','--certificate',str(path),
            '--point',str(pp),'--output',str(receipt)],capture_output=True,text=True)
    positive=run(bp,rp);assert positive.returncode==0,positive.stderr
    M,rhs,meta=matrix([bp],[rp]);assert M.shape==(1,36495) and rhs.tolist()==[128]
    row=M.getrow(0);assert row.indices.tolist()==list(range(45)) and row.data.tolist()==[16]*45
    badcontrols=[]
    for name in ('wrong_bound','missing_class','wrong_orbit'):
        bad=copy.deepcopy(bank)
        if name=='wrong_bound':bad['cuts'][0]['upper_bound']=127
        elif name=='missing_class':bad['cuts'][0]['support_records'].pop()
        else:bad['orbit']=32
        badpath=prefix.with_name(prefix.name+'-'+name+'.json');badpath.write_text(json.dumps(bad,indent=2)+'\n')
        result=run(badpath,prefix.with_name(prefix.name+'-'+name+'-unexpected-receipt.json'))
        assert result.returncode!=0
        badcontrols.append({'name':name,'rejected':True,'bank_sha256':sha(badpath),'returncode':result.returncode})
    from verify_full_partner_projection import matrix as old_matrix
    oldbank=ROOT/'coupling-results/full-partner-projection-wolfe-witness2.json'
    oldreceipt=ROOT/'coupling-results/full-partner-projection-wolfe-witness2-independent.json'
    genericreceipt=ROOT/'coupling-results/full-partner-generic-orbit32-regression.json'
    A,b,_=old_matrix([oldbank],[oldreceipt]);B,d,_=matrix([oldbank],[genericreceipt])
    assert (A!=B).nnz==0 and (b==d).all()
    result={'status':'PASS','source_C16_answered':False,'control_only':True,
        'consumer_sha256':sha(consumer),'control_code_sha256':sha(Path(__file__)),
        'positive_bank_sha256':sha(bp),'positive_receipt_sha256':sha(rp),
        'positive_synthetic_cardinality_target':129,'source_cardinality_bound':128,
        'generic27_row_exactly_16_sum_p_le_128':True,'generic32_row_equals_frozen_compiler':True,
        'corrupted_input_controls':badcontrols,'elapsed_seconds':time.monotonic()-started,
        'scope':'Consumer and exact integer matrix controls only; all synthetic invalid artifacts are explicitly labeled.'}
    out.write_text(json.dumps(result,indent=2)+'\n');print(json.dumps(result,indent=2))


if __name__=='__main__':main()
