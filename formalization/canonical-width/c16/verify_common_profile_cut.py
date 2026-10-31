#!/usr/bin/env python3
"""Independent physical/whole-mask replay of a common-profile functional.

No LP, producer mask closure, or producer rank routine is used. Enumerate all
65536 masks and reject a mask only by an already certified contained phase
obstruction. Bound each anchor's contribution directly, then average over all
16 rotations. Check every shape/class bound with integer arithmetic.
"""
from pathlib import Path
from fractions import Fraction
import argparse,gzip,hashlib,json,time
from certify_profile_moment_point import layout
ROOT=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def dimension(vectors):
    rows={}
    for value in vectors:
        while value:
            pivot=value.bit_length()-1
            if pivot in rows:value^=rows[pivot]
            else:rows[pivot]=value;break
    return len(rows)
def turn(x,h):return ((x<<h)&65535)|(x>>(16-h))
def profile(x):return (x.bit_count(),)+tuple((x&turn(x,h)).bit_count() for h in range(1,9))

def main():
    ap=argparse.ArgumentParser();ap.add_argument('--bank',type=Path,required=True);ap.add_argument('--point',type=Path,required=True);ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();start=time.monotonic();d=json.loads(a.bank.read_text());assert d['point_sha256']==sha(a.point);assert d['cuts']
    hull_path=ROOT/'algebraic-results/hulls-16-rank.json.gz';profile_path=ROOT/'algebraic-results/orbit-rank-profiles.json.gz';hulls=json.loads(gzip.decompress(hull_path.read_bytes()));profiles=json.loads(gzip.decompress(profile_path.read_bytes()));_,index,m=layout(hulls);v=list(map(Fraction,json.loads(gzip.decompress(a.point.read_bytes()))['values']));o=d['orbit'];hr=next(r for r in hulls['records'] if r['orbit']==o);pr=next(r for r in profiles['records'] if r['orbit']==o);bad=[r['mask'] for r in pr['minimal_bad_certificates']];shape={tuple(r['moments']):j for j,r in enumerate(hr['shapes'])};allowed=[]
    for mask in range(65536):
        if o==12 and mask.bit_count()>11:continue
        if any(mask&forbidden==forbidden for forbidden in bad):continue
        allowed.append(mask)
    assert len(allowed)==hr['phase_patterns']==d['allowed_masks'];allowed_set=set(allowed)
    X,Z=[[int(v,16) for v in (ROOT/f'pools/{s}coords.txt').read_text().split()] for s in 'xz'];results=[];pattern_checks=0;physical_rank_checks=0;rotation_checks=0
    for cut in d['cuts']:
        scores={};active=[(anchor,coef) for anchor,coef in zip(d['anchors'],cut['anchor_coefficients']) if any(coef)]
        for mask in allowed:
            phases=[h for h in range(16) if mask>>h&1];vectors=[X[16*o+h] for h in phases];score=0
            for (side,orbit),coefs in active:
                value=coefs[0]+sum(coefs[1+h] for h in phases)
                if value<=0:continue
                if side=='T':compatible=sum((Z[16*orbit]&x).bit_count()%2 for x in vectors)<=1
                elif orbit==o:compatible=bool(mask&1)
                else:compatible=dimension(vectors+[X[16*orbit]])==len(vectors)+1;physical_rank_checks+=1
                if compatible:score+=value
            scores[mask]=score;pattern_checks+=1
        minimum=None
        for mask in allowed:
            rotated=[turn(mask,h) for h in range(16)];assert all(t in allowed_set for t in rotated)
            moments=profile(mask)
            if 'shape_bounds' in cut:upper=16*cut['shape_bounds'][shape[moments]]
            else:upper=-16*sum(c*x for c,x in zip(cut['unconditional_coefficients'],(1,*moments)))
            slack=upper-sum(scores[t] for t in rotated);assert slack>=0,('class_bound_failed',mask,slack)
            minimum=slack if minimum is None else min(minimum,slack);rotation_checks+=1
        value=Fraction(0)
        for (side,orbit),coefs in zip(d['anchors'],cut['anchor_coefficients']):
            value+=coefs[0]*v[index['p',orbit]]+sum(coefs[h+1]*v[m(side,h,orbit,o)] for h in range(16))
        if 'shape_bounds' in cut:value-=sum(bound*v[index['w',o,j]] for j,bound in enumerate(cut['shape_bounds']))
        else:value+=sum(c*x for c,x in zip(cut['unconditional_coefficients'],[Fraction(1),16*v[index['p',o]],*[16*v[m('S',h,o,o)] for h in range(1,9)]]))
        assert value>0 and value==Fraction(cut['exact_violation']);assert minimum==0 # Tight class exists; lowering its upper bound is rejected.
        results.append({'exact_violation':str(value),'approximate_violation':float(value),'nonzero_anchor_rows':len(active),'minimum_integer_class_slack':minimum,'lowered_tight_bound_negative_control_rejected':True})
    result={'status':'PASS','source_C16_answered':False,'bank_sha256':sha(a.bank),'point_sha256':sha(a.point),'consumer_sha256':sha(Path(__file__)),'profile_dependency_sha256':sha(profile_path),'hull_dependency_sha256':sha(hull_path),'allowed_masks_independently_enumerated':len(allowed),'physical_rank_checks':physical_rank_checks,'pattern_score_checks':pattern_checks,'all16_rotation_class_checks':rotation_checks,'cuts_checked':len(results),'results':results,'profile_weights_fixed_in_separation':'shape_bounds' in d['cuts'][0],'elapsed_seconds':time.monotonic()-start,'scope':'Exact valid profile-coupled source moment inequality and strict rejection of this saved point. Fixed-profile rejection alone need not reject its projection to first/second moments. The original source width remains unresolved.'}
    a.output.write_text(json.dumps(result,indent=2)+'\n');print(result,flush=True)
if __name__=='__main__':main()
