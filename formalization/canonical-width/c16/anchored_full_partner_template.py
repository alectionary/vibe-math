#!/usr/bin/env python3
"""Couple one selected/absent X anchor to a whole orbit and a full Z basis.

The Z anchor forms are summed over all sixteen phases. The single X-anchor
form is multiplied by sixteen. For each phase mask P maximize over the X
anchor branch and the compatible full opposite basis. A source-symmetrized
distribution of P is invariant under rotation, so class-average bounds are
valid even though the fixed phase-zero X anchor breaks pointwise covariance.
"""
from pathlib import Path
from fractions import Fraction as Q
from collections import defaultdict
import argparse, gzip, hashlib, json, math, time
import numpy as np
from scipy.optimize import linprog
from flint import fmpq_mat
from full_partner_basis_oracle import FullPartnerBasisOracle
from conditional_profile_compatibility import ConditionalProfileCompatibility
from full_partner_projection_features import candidate_weights, column_features, rotate
from certify_profile_moment_point import layout

ROOT = Path(__file__).resolve().parent
def sha(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()
def read(path):
    p=Path(path)
    return json.loads(gzip.decompress(p.read_bytes()) if p.suffix=='.gz' else p.read_bytes())
def dump(path, data):
    raw=(json.dumps(data,indent=2)+'\n').encode()
    Path(path).write_bytes(gzip.compress(raw,mtime=0) if str(path).endswith('.gz') else raw)

def main():
    ap=argparse.ArgumentParser()
    ap.add_argument('--bank', type=Path, default=ROOT/'moment-resumption-results/common-profile32-projected-pruned.json')
    ap.add_argument('--point', type=Path, required=True)
    ap.add_argument('--output', type=Path, required=True)
    args=ap.parse_args(); start=time.monotonic()
    bank=read(args.bank); assert bank['orbit']==32 and bank['anchors'][0]==['S',13]
    assert all(s=='T' for s,o in bank['anchors'][1:])
    coefs=bank['cuts'][0]['anchor_coefficients']; sform=coefs[0]
    conditional_path=ROOT/'coupling-results/conditional-compat-orbit32.json'
    conditional_replay=ROOT/'coupling-results/conditional-compat-orbit32-independent.json'
    conditional=read(conditional_path); receipt=read(conditional_replay)
    assert receipt['status']=='PASS' and receipt['bank_sha256']==sha(conditional_path)
    tablerow=next(r for r in conditional['records'] if (r['orbit'],r['side'],r['anchor'],r['condition'])==(32,'S',13,1))
    table=ConditionalProfileCompatibility().table(32,'S',13,1)
    assert hashlib.sha256(table.tobytes()).hexdigest()==tablerow['table_sha256']
    domain_source=ROOT/'coupling-results/full-partner-orbit32.frozen.json'
    reps=read(domain_source)['representatives']
    allowed=sorted({rotate(r,h) for r in reps for h in range(16)})
    assert len(reps)==291 and len(allowed)==4597
    paths=['anchored_full_partner_template.py','full_partner_basis_oracle.py',
           'conditional_profile_compatibility.py','full_partner_projection_features.py',
           'pools/xcoords.txt','pools/zcoords.txt']
    frozen={'status':'FROZEN_BEFORE_ANCHORED_FULL_PARTNER_TEMPLATE',
            'source_C16_answered':False,'point_sha256':sha(args.point),'bank_sha256':sha(args.bank),
            'bank_path':str(args.bank.resolve().relative_to(ROOT)),
            'conditional_bank_sha256':sha(conditional_path),'conditional_replay_sha256':sha(conditional_replay),
            'domain_source_sha256':sha(domain_source),'source_hashes':{p:sha(ROOT/p) for p in paths},
            'class_average_not_representative_only':True}
    frozen_path=Path(str(args.output)+'.frozen.json');dump(frozen_path,frozen)
    tc=[0]*775
    for (_,j),cs in zip(bank['anchors'][1:],coefs[1:]):
        tc[10+j]+=cs[0]
        for h in range(16):tc[55+16*j+((-h)%16)]+=cs[h+1]
    oracle=FullPartnerBasisOracle(); rows=[]; classes=defaultdict(list)
    for position,mask in enumerate(allowed):
        weights=candidate_weights(mask,tc)
        sf=sform[0]+sum(sform[h+1] for h in range(16) if mask>>h&1)
        branches=[]
        for included in (0,1):
            if included and not table[mask]:
                branches.append({'included':1,'status':'EXCLUDED_CHECKED_CONDITIONAL_PROFILE'})
                continue
            domain=oracle.prepare(32,mask,[208] if included else [])
            support=oracle.support(domain,weights)
            rec={'included':included,'status':support['status']}
            if support['value'] is not None:
                score=support['value']+16*included*sf
                rec.update(basis_score=str(support['value']),score=str(score),
                           selected_Z_indices=list(support['selected_Z_indices']))
            branches.append(rec)
        value=max(Q(b['score']) for b in branches if 'score' in b)
        row={'mask':mask,'S_form':sf,'branches':branches,'upper':str(value)}
        rows.append(row);classes[min(rotate(mask,h) for h in range(16))].append(row)
        if position%1000==0:print({'masks':position+1,'seconds':time.monotonic()-start},flush=True)
    class_rows=[]
    for representative, members in sorted(classes.items()):
        average=sum(Q(r['upper']) for r in members)/len(members)
        class_rows.append({'representative':representative,'size':len(members),
                           'features':list(column_features(representative,())[:10]),'average_upper':str(average)})
    hulls=read(ROOT/'algebraic-results/hulls-16-rank.json.gz');_,index,m=layout(hulls)
    point=list(map(Q,read(args.point)['values']))
    targets=[Q(1),16*point[index['p',32]],*[16*point[m('S',h,32,32)] for h in range(1,9)]]
    fixed=16*sum(c[0]*point[index['p',j]]+sum(c[h+1]*point[m(s,h,j,32)] for h in range(16))
                  for (s,j),c in zip(bank['anchors'],coefs))
    A=np.array([r['features'] for r in class_rows],dtype=float)
    rhs=[-Q(r['average_upper']) for r in class_rows]
    lp=linprog(-np.array(list(map(float,targets))),A_ub=A,b_ub=list(map(float,rhs)),
               bounds=[(None,None)]*10,method='highs')
    proposals=[]; exact_optimum=None
    def save(u,origin):
        u=list(map(Q,u))
        correction=max(sum(c*f for c,f in zip(u,r['features']))+Q(r['average_upper']) for r in class_rows)
        u[0]-=correction
        gap=fixed+sum(c*t for c,t in zip(u,targets))
        denominator=math.lcm(*(x.denominator for x in u))
        proposals.append({'origin':origin,'unconditional_coefficients':list(map(str,u)),
                          'exact_violation':str(gap),'normalization':16,
                          'integer_scale':denominator,'corrected_constant':str(correction)})
    save([16*c for c in bank['cuts'][0]['unconditional_coefficients']], 'original_form_exact_constant_tightening')
    if lp.success:
        for denominator in (1,16,256,4096):
            save([Q(round(float(x)*denominator),denominator) for x in lp.x], 'rounded_LP_exactly_corrected')
        candidates=[j for j,v in enumerate(lp.ineqlin.marginals) if abs(v)>1e-8]
        candidates += [j for j,v in enumerate(lp.ineqlin.residual) if abs(v)<1e-7 and j not in candidates]
        active=[]
        for j in candidates:
            if np.linalg.matrix_rank(A[active+[j]],tol=1e-9)>len(active):active.append(j)
            if len(active)==10:break
        if len(active)==10:
            B=fmpq_mat([[int(x) for x in A[j]] for j in active])
            u=[Q(str(x)) for x in B.solve(fmpq_mat([[str(rhs[j])] for j in active])).entries()]
            lam=[Q(str(x)) for x in B.transpose().solve(fmpq_mat([[str(x)] for x in targets])).entries()]
            valid=all(sum(c*f for c,f in zip(u,r['features']))<=b for r,b in zip(class_rows,rhs)) and min(lam)>=0
            if valid:
                assert sum(c*t for c,t in zip(u,targets))==sum(l*rhs[j] for l,j in zip(lam,active))
                exact_optimum={'unconditional_coefficients':list(map(str,u)), 'active_rows':active,
                               'dual_weights':list(map(str,lam)),
                               'exact_violation':str(fixed+sum(c*t for c,t in zip(u,targets)))}
                save(u,'exact_primal_dual_feature_optimum')
    out={'status':'CANDIDATE_REQUIRES_INDEPENDENT_REPLAY','source_C16_answered':False,
         'orbit':32,'anchors':bank['anchors'],'anchor_coefficients':coefs,
         'point_sha256':sha(args.point),'point_path':str(args.point.resolve().relative_to(ROOT)),
         'frozen_sha256':sha(frozen_path),'mask_rows':rows,'class_rows':class_rows,
         'target_features':list(map(str,targets)),'fixed_anchor_target':str(fixed),
         'LP_status':int(lp.status),'LP_message':lp.message,'proposals':proposals,
         'exact_feature_optimum':exact_optimum,'seconds':time.monotonic()-start,
         'scope':'One X-anchor branch, whole orbit, complete opposite-basis necessity; remaining X dual completion is relaxed. A positive candidate requires independent acceptance.'}
    dump(args.output,out)
    print({'status':out['status'],'best_gap':str(max(Q(p['exact_violation']) for p in proposals)),
           'exact_feature_optimum':exact_optimum,'seconds':out['seconds']},flush=True)

if __name__=='__main__':main()
