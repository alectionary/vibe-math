#!/usr/bin/env python3
"""Independently verify positive or negative fixed-direction transfer supports.

Imports no producer feature or support routine. Prior source-controls receipts
bind physical obstruction replay; all priced bases and signed prefix bounds are
recomputed here. A negative gap only concerns the frozen one-sided relaxation.
"""
from pathlib import Path
from fractions import Fraction
import argparse,hashlib,json,time
from verify_full_partner_projection_multi_orbit import (read,sha,turn,move,weights,local_score,
    literal_features,point_data,compile_row,physical,rebuild_domain,check_support,SUPPORTED_ORBITS)
ROOT=Path(__file__).resolve().parent


def main():
    ap=argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--screen',type=Path,required=True);ap.add_argument('--point',type=Path,required=True)
    ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();assert not a.output.exists()
    started=time.monotonic();screen=read(a.screen);frozen_path=a.screen.with_suffix('.frozen.json');frozen=read(frozen_path)
    assert screen['frozen_sha256']==sha(frozen_path) and screen['point_sha256']==sha(a.point)
    assert screen['source_hashes']==frozen['source_hashes']
    assert all(sha(ROOT/p)==s for p,s in screen['source_hashes'].items())
    assert screen['orbits']==[24,23,7,4,36] and len(screen['directions'])==2
    X,Z,_=physical();profiles=read(ROOT/'algebraic-results/orbit-rank-profiles.json.gz')
    hulls=read(ROOT/'algebraic-results/hulls-16-rank.json.gz');results=[];total_prefix=total_covariance=0
    for result in screen['results']:
        orbit=result['orbit'];assert orbit in SUPPORTED_ORBITS
        path=Path(result['bank']);assert sha(path)==result['bank_sha256'];bank=read(path)
        assert bank['orbit']==orbit and bank['point_sha256']==sha(a.point) and bank['frozen_sha256']==sha(frozen_path)
        assert bank['source_hashes']==screen['source_hashes']
        control=read(ROOT/f'coupling-results/full-partner-transfer-orbit{orbit}-source-controls.json')
        assert control['status']=='PASS' and control['orbit']==orbit
        assert control['consumer_sha256']==sha(ROOT/'verify_full_partner_projection_multi_orbit.py')
        assert all(sha(ROOT/p)==s for p,s in control['source_hashes'].items())
        profile=next(r for r in profiles['records'] if r['orbit']==orbit)
        forbidden=[c['mask'] for c in profile['minimal_bad_certificates']]
        allowed=[m for m in range(65536) if not any(m & b==b for b in forbidden)]
        assert len(allowed)==bank['allowed_masks']==control['allowed_masks_independently_enumerated']
        assert len(allowed)==next(r['phase_patterns'] for r in hulls['records'] if r['orbit']==orbit)
        allowed_hash=hashlib.sha256(json.dumps(allowed,separators=(',',':')).encode()).hexdigest()
        assert allowed_hash==bank['allowed_mask_list_sha256']==control['allowed_mask_list_sha256']
        reps=sorted({min(turn(m,h) for h in range(16)) for m in allowed});assert reps==bank['representatives']
        owner,target=point_data(a.point,orbit)
        domains={m:rebuild_domain(X,Z,[16*orbit+h for h in range(16) if m>>h&1],128) for m in reps}
        assert all(d['status']=='FULL_PARTNER_BASIS_DOMAIN' for d in domains.values())
        assert len(bank['proposals'])==len(screen['directions'])
        for proposal,direction in zip(bank['proposals'],screen['directions']):
            c=proposal['coefficients'];assert c==direction['coefficients'] and len(c)==775 and all(type(v)is int for v in c)
            assert proposal['name']==direction['name'] and proposal['pricing_scale']==direction['pricing_scale']
            records={r['mask']:r for r in proposal['support_records']};assert len(records)==len(proposal['support_records'])==len(reps)
            assert set(records)==set(reps);maximum=None;prefix=covariance=0
            for mask in reps:
                record=records[mask];w=weights(mask,c);selected=[16*orbit+h for h in range(16) if mask>>h&1]
                adapted={**record,'status':'EXACT_FULL_PARTNER_BASIS_SUPPORT','value':record['support_value']}
                prefix+=check_support(Z,selected,128,domains[mask],w,adapted)
                full=local_score(mask,c)+record['support_value'];assert full==record['full_value']
                assert full==sum(x*y for x,y in zip(c,literal_features(mask,record['selected_Z_indices'])))
                maximum=full if maximum is None else max(maximum,full)
                for r in range(16):
                    wr=weights(turn(mask,r),c)
                    assert all(wr[move(j,r)]==w[j] for j in range(720))
                    assert local_score(turn(mask,r),c)==local_score(mask,c);covariance+=720
            value=sum(x*y for x,y in zip(c,target));gap=value-maximum
            assert maximum==proposal['upper_bound'] and value==Fraction(proposal['exact_target_value'])
            assert gap==Fraction(proposal['exact_violation'])
            row,rhs=compile_row(c,maximum,orbit);assert sum(v*owner[j] for j,v in row.items())-rhs==gap
            results.append({'orbit':orbit,'direction':proposal['name'],'upper_bound':maximum,
                'exact_target_value':str(value),'exact_gap':str(gap),'scaled_gap':float(gap/proposal['pricing_scale']),
                'positive':gap>0,'representative_supports':len(reps),'exact_prefix_rank_checks':prefix,
                'actual_weight_covariance_checks':covariance})
            total_prefix+=prefix;total_covariance+=covariance
        assert len(bank['cuts'])==sum(Fraction(p['exact_violation'])>0 for p in bank['proposals'])
    assert len(results)==10 and screen['positive_cuts']==sum(r['positive'] for r in results)
    out={'status':'PASS_FIXED_FUNCTIONAL_SCREEN','source_C16_answered':False,'screen_sha256':sha(a.screen),
        'frozen_sha256':sha(frozen_path),'point_sha256':sha(a.point),'consumer_sha256':sha(Path(__file__)),
        'source_hashes':screen['source_hashes'],'results':results,'positive_cuts':sum(r['positive'] for r in results),
        'total_prefix_rank_checks':total_prefix,'total_actual_weight_covariance_checks':total_covariance,
        'elapsed_seconds':time.monotonic()-started,
        'scope':'All ten fixed-direction supports independently attained and upper-bounded in the stated one-sided full-basis relaxation. Negative gaps exclude only these frozen directions for this relaxation; no membership or source-feasibility conclusion.'}
    a.output.write_text(json.dumps(out,indent=2)+'\n');print(json.dumps({k:v for k,v in out.items() if k not in ('source_hashes','results')},indent=2))


if __name__=='__main__':main()
