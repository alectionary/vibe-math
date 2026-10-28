#!/usr/bin/env python3
"""Adversarial controls for the independently regenerated joint-case dual."""
import argparse
import copy
import json
from pathlib import Path
from verify_exchange_dual import ROOT, read, verify


def main():
    ap=argparse.ArgumentParser();ap.add_argument('--output',type=Path,required=True);a=ap.parse_args()
    data=read(ROOT/'overnight-results/joint034-dual-no-cap.json.gz')
    psd=read(ROOT/'overnight-results/joint034-dual.json.PSD.json.gz')
    source=read(ROOT/'inversion-results/normal-form.json')
    accepted=verify(data,psd,source)
    controls=[]
    def reject(name,d,p):
        try:verify(d,p,source)
        except (AssertionError,KeyError,IndexError,ValueError) as e:
            controls.append({'name':name,'status':'REJECTED','reason':str(e)[:160]});return
        raise AssertionError('Corruption accepted: '+name)
    d=copy.deepcopy(data)
    next(t for t in d['linear_terms'] if t['kind']=='ineq')['multiplier']=-1
    reject('negative inequality multiplier',d,psd)
    d=copy.deepcopy(data);d['linear_terms'][0]['rhs']+=3
    reject('invented source-row right hand side',d,psd)
    d=copy.deepcopy(data);d['D']['0'][0][0]+=1
    reject('changed dual matrix with stale PSD certificate',d,psd)
    d=copy.deepcopy(data);d['constant']+=1
    reject('changed constant with stale exact gap',d,psd)
    # Keep all bookkeeping consistent, so only the actual PSD arithmetic
    # can reject this matrix with a negative diagonal entry.
    from rational_cyclic_psd import matrix_hash
    d=copy.deepcopy(data);p=copy.deepcopy(psd)
    old=d['constant'];d['constant']=-d['denominator']
    d['box_gap_numerator']+=d['constant']-old
    p['source_dual_matrix_SHA256']=matrix_hash(d)
    reject('indefinite dual with matching hash and corrected gap',d,p)
    p=copy.deepcopy(psd)
    p['preconditioners'][0]=[[0]*len(p['preconditioners'][0]) for _ in p['preconditioners'][0]]
    reject('singular zero preconditioner',data,p)
    a.output.write_text(json.dumps({'status':'PASS','uncorrupted_certificate':accepted['status'],
        'rejected_corruptions':controls,'source_C16_answered':False},indent=2)+'\n')
    print(json.dumps({'status':'PASS','rejected_corruptions':len(controls)}),flush=True)


if __name__=='__main__':main()
