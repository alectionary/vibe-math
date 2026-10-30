#!/usr/bin/env python3
"""Exact independent LP replay after physical full-phase support acceptance."""
from pathlib import Path
from fractions import Fraction as Q
import argparse, copy, gzip, hashlib, json, time
from certify_profile_moment_point import layout
ROOT=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def read(p):
    raw=Path(p).read_bytes();return json.loads(gzip.decompress(raw) if str(p).endswith('.gz') else raw)

def check(payload, rows, rhs, target, tvalue):
    opt=payload['exact_relative_scale_optimum'];assert opt is not None
    x=list(map(Q,opt['unconditional_coefficients']))+[Q(opt['relative_S_scale'])]
    assert len(x)==11 and x[-1]>=0
    assert all(sum(a*b for a,b in zip(row,x))<=r for row,r in zip(rows,rhs))
    active=opt['active_rows'];lam=list(map(Q,opt['dual_weights']))
    assert len(active)==len(set(active))==len(lam)==11 and min(lam)>=0
    assert all(0<=j<len(rows) for j in active)
    assert [sum(v*rows[j][i] for v,j in zip(lam,active)) for i in range(11)]==target
    primal=sum(v*t for v,t in zip(x,target));dual=sum(v*rhs[j] for v,j in zip(lam,active))
    assert primal==dual and tvalue+primal==Q(opt['exact_violation'])
    for proposal in payload['proposals']:
        xp=list(map(Q,proposal['unconditional_coefficients']))+[Q(proposal['relative_S_scale'])]
        assert len(xp)==11 and xp[-1]>=0 and proposal['T_scale']==1
        assert all(sum(a*b for a,b in zip(row,xp))<=r for row,r in zip(rows,rhs))
        value=tvalue+sum(v*t for v,t in zip(xp,target))
        assert value==Q(proposal['exact_violation']) and value<=tvalue+primal
    return tvalue+primal

def main():
    ap=argparse.ArgumentParser();ap.add_argument('--bank',type=Path,required=True)
    ap.add_argument('--support-replay',type=Path,required=True);ap.add_argument('--point',type=Path,required=True)
    ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();start=time.monotonic()
    data=read(a.bank);fp=Path(str(a.bank)+'.frozen.json');frozen=read(fp)
    assert data['frozen_sha256']==sha(fp) and data['point_sha256']==frozen['point_sha256']==sha(a.point)
    support_path=ROOT/data['support_bank'];support=read(support_path);receipt=read(a.support_replay)
    assert receipt['status']=='PASS' and receipt['bank_sha256']==data['support_bank_sha256']==frozen['support_bank_sha256']==sha(support_path)
    assert receipt['point_sha256']==sha(a.point) and support['anchors']==data['anchors'] and support['anchor_coefficients']==data['anchor_coefficients']
    hulls=read(ROOT/'algebraic-results/hulls-16-rank.json.gz');_,index,m=layout(hulls);v=list(map(Q,read(a.point)['values']))
    feature=[Q(1),16*v[index['p',32]],*[16*v[m('S',h,32,32)] for h in range(1,9)]]
    vals=[16*(c[0]*v[index['p',j]]+sum(c[h+1]*v[m(s,h,j,32)] for h in range(16))) for (s,j),c in zip(data['anchors'],data['anchor_coefficients'])]
    target=feature+[vals[0]];tvalue=sum(vals[1:]);assert target==list(map(Q,data['targets'])) and tvalue==Q(data['T_target'])
    rows=[];rhs=[];ids=[]
    for ri,row in enumerate(support['records']):
        for bi,branch in enumerate(row['branches']):
            if branch['status']=='EXACT_FULL_PARTNER_BASIS_SUPPORT':
                rows.append(row['features']+[branch['S_score']]);rhs.append(-Q(branch['basis_score']))
                ids.append({'record':ri,'mask':row['mask'],'branch':bi,'Q_mask':branch['Q_mask']})
    assert len(rows)==data['source_branch_rows'];rows.append([0]*10+[-1]);rhs.append(Q(0));ids.append({'constraint':'alpha_nonnegative'})
    assert ids==data['constraint_row_ids'] and len(rows)==data['constraint_rows']
    optimum=check(data,rows,rhs,target,tvalue)
    rejected=0
    for mode in ('negative_scale','negative_dual','false_objective'):
        bad=copy.deepcopy(data);o=bad['exact_relative_scale_optimum']
        if mode=='negative_scale':o['relative_S_scale']='-1'
        elif mode=='negative_dual':o['dual_weights'][0]='-1'
        else:o['exact_violation']=str(Q(o['exact_violation'])+1)
        try:check(bad,rows,rhs,target,tvalue)
        except AssertionError:rejected+=1
        else:raise AssertionError('corrupted LP certificate accepted')
    out={'status':'PASS','source_C16_answered':False,'bank_sha256':sha(a.bank),'support_bank_sha256':sha(support_path),
         'support_replay_sha256':sha(a.support_replay),'point_sha256':sha(a.point),'consumer_sha256':sha(Path(__file__)),
         'exact_constraints_checked':len(rows),'exact_relative_scale_optimum':str(optimum),
         'relative_S_scale':data['exact_relative_scale_optimum']['relative_S_scale'],'corrupted_LP_certificates_rejected':rejected,
         'fixed_ratio_template_cannot_separate_candidate':optimum<=0,'seconds':time.monotonic()-start,
         'scope':'Exact optimum only for the supplied fixed T/S forms, nonnegative relative S scale and ten free profile coefficients; not general projection membership.'}
    a.output.write_text(json.dumps(out,indent=2)+'\n');print(out)
if __name__=='__main__':main()
