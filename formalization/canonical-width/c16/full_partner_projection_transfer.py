#!/usr/bin/env python3
"""Frozen fixed-functional transfer screen; every target orbit is freshly priced.

No orbit automorphism is assumed. The two accepted coefficient vectors only
choose discovery directions. Exact supports are recomputed on each new domain.
"""
from pathlib import Path
from fractions import Fraction
import argparse,hashlib,json,time
from full_partner_projection import read,sha,mask_universe,LAYOUT
from full_partner_safe_pricing import support_all
from full_partner_batched_weights import IntegerPhaseWeightBatch
from full_partner_basis_oracle import FullPartnerBasisOracle
from full_partner_projection_features import moment_target
from verify_projected_profile_moment_rows import point_vector
ROOT=Path(__file__).resolve().parent
ORBITS=(24,23,7,4,36)


def main():
    ap=argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--point',type=Path,required=True);ap.add_argument('--output',type=Path,required=True)
    a=ap.parse_args();assert not a.output.exists();started=time.monotonic()
    entries=[('orbit27','coupling-results/full-partner-orbit27-wolfe-witness5.json',0),
             ('orbit32','coupling-results/full-partner-projection-wolfe-strengthen-witness2.json',0)]
    inventory=read(ROOT/'coupling-results/full-partner-all-orbit-profile-inventory.json')
    directions=[];paths=['full_partner_projection_transfer.py','verify_full_partner_projection_multi_orbit.py',
        'full_partner_projection.py','full_partner_projection_features.py','full_partner_safe_pricing.py',
        'full_partner_batched_weights.py','full_partner_basis_oracle.py','verify_projected_profile_moment_rows.py',
        'projected_profile_moment_matrix.py','physical-pool-source.json','pools/xcoords.txt','pools/zcoords.txt',
        'algebraic-results/orbit-rank-profiles.json.gz','algebraic-results/hulls-16-rank.json.gz',
        'coupling-results/full-partner-all-orbit-profile-inventory.json']
    for name,relative,index in entries:
        bank=read(ROOT/relative);receipt_path=Path(relative).with_name(Path(relative).stem+'-independent.json')
        receipt=read(ROOT/receipt_path);assert receipt['status']=='PASS' and receipt['bank_sha256']==sha(ROOT/relative)
        c=bank['cuts'][index];assert Fraction(c['exact_violation'])>0
        directions.append({'name':name,'source_bank':relative,'source_bank_sha256':sha(ROOT/relative),
            'source_receipt_sha256':sha(ROOT/receipt_path),'source_cut_index':index,
            'coefficients':c['coefficients'],'pricing_scale':c['pricing_scale']})
        paths += [relative,str(receipt_path)]
    for o in ORBITS:
        path=f'coupling-results/full-partner-transfer-orbit{o}-source-controls.json';control=read(ROOT/path)
        assert control['status']=='PASS' and control['orbit']==o
        assert control['consumer_sha256']==sha(ROOT/'verify_full_partner_projection_multi_orbit.py')
        assert all(sha(ROOT/p)==s for p,s in control['source_hashes'].items());paths.append(path)
    sources={p:sha(ROOT/p) for p in paths}
    frozen={'status':'FROZEN_BEFORE_FIXED_FUNCTIONAL_TRANSFER','source_C16_answered':False,
        'point_sha256':sha(a.point),'source_hashes':sources,'orbits':list(ORBITS),'directions':directions,
        'cohort_rule':'Minimum rotation-class count for each profile cap5..9, excluding already studied27/32.',
        'orbit_profiles':[r for r in inventory['records'] if r['orbit'] in ORBITS],
        'scope':'Literal coefficient transfer only. Every new physical orbit support is recomputed; no orbit automorphism or complete separation is assumed.'}
    fp=a.output.with_suffix('.frozen.json');assert not fp.exists();fp.write_text(json.dumps(frozen,indent=2)+'\n')
    owner=point_vector(a.point);oracle=FullPartnerBasisOracle();results=[]
    for orbit in ORBITS:
        allowed,reps=mask_universe(orbit);target=moment_target(owner,orbit)
        domains=[(m,oracle.prepare(orbit,m)) for m in reps]
        assert all(d['status']=='FULL_PARTNER_BASIS_DOMAIN' for _,d in domains)
        batch=IntegerPhaseWeightBatch(reps);proposals=[];cuts=[]
        for direction in directions:
            before=time.monotonic();c=direction['coefficients'];bound,records,_=support_all(oracle,domains,c,batch)
            value=sum(x*y for x,y in zip(c,target));gap=value-bound
            proposal={**direction,'upper_bound':bound,'exact_target_value':str(value),'exact_violation':str(gap),
                'scaled_violation':float(gap/direction['pricing_scale']),'support_records':records,
                'pricing_seconds':time.monotonic()-before}
            proposals.append(proposal)
            if gap>0:cuts.append(proposal)
            print(json.dumps({'orbit':orbit,'direction':direction['name'],'exact_violation':str(gap),
                'scaled_violation':proposal['scaled_violation'],'pricing_seconds':proposal['pricing_seconds']}),flush=True)
        bank={**frozen,'status':'EXACT_SUPPORT_CUT_CANDIDATE' if cuts else 'NO_FIXED_FUNCTIONAL_SEPARATOR',
            'orbit':orbit,'feature_layout':LAYOUT,'allowed_masks':len(allowed),'representatives':reps,
            'allowed_mask_list_sha256':hashlib.sha256(json.dumps(allowed,separators=(',',':')).encode()).hexdigest(),
            'frozen_sha256':sha(fp),'proposals':proposals,'cuts':cuts}
        path=a.output.with_name(a.output.stem+f'-orbit{orbit}.json');assert not path.exists();path.write_text(json.dumps(bank,indent=2)+'\n')
        results.append({'orbit':orbit,'bank':str(path),'bank_sha256':sha(path),'cuts':len(cuts),
            'queries':[{k:p[k] for k in ('name','exact_violation','scaled_violation','pricing_seconds')} for p in proposals]})
    assert all(sha(ROOT/p)==s for p,s in sources.items())
    result={**frozen,'status':'EXACT_FIXED_FUNCTIONAL_SCREEN_REQUIRES_REPLAY','frozen_sha256':sha(fp),
        'results':results,'positive_cuts':sum(r['cuts'] for r in results),'elapsed_seconds':time.monotonic()-started,
        'scope':'Ten exact support evaluations of two frozen transferred directions on five physical orbits. Negative gaps establish no membership and rule out only these particular directions.'}
    a.output.write_text(json.dumps(result,indent=2)+'\n');print(json.dumps({'positive_cuts':result['positive_cuts'],'elapsed_seconds':result['elapsed_seconds']}))


if __name__=='__main__':main()
