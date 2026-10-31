#!/usr/bin/env python3
"""Independent physical replay of simultaneous S-phase/full-Z-basis bounds.

Imports only established independent low-pivot/physical consumers, never the
producer or its support/feature/conditional-table routines. Every positive
S-phase subset is covered; nonpositive phases are safely omitted by deletion.
"""
from pathlib import Path
from fractions import Fraction as Q
from collections import Counter
import argparse, gzip, hashlib, json, math, random, time
from verify_algebraic_model import physical
from certify_profile_moment_point import layout
from verify_anchored_full_partner_template import dimension, domain_and_upper, check_witness, literal_weights

ROOT=Path(__file__).resolve().parent
def sha(path):return hashlib.sha256(Path(path).read_bytes()).hexdigest()
def read(path):
    raw=Path(path).read_bytes()
    return json.loads(gzip.decompress(raw) if str(path).endswith('.gz') else raw)
def turn(mask,h):
    h%=16
    return ((mask<<h)&65535)|(mask>>((16-h)%16))
def move(j,h):return 16*(j//16)+(j%16+h)%16
def feature(mask):return [1,mask.bit_count(),*[(mask&turn(mask,h)).bit_count() for h in range(1,9)]]
def forms(mask,c):
    return [c[0]+sum(c[1+(h-t)%16] for h in range(16) if mask>>h&1) for t in range(16)]

def main():
    ap=argparse.ArgumentParser();ap.add_argument('--bank',type=Path,required=True)
    ap.add_argument('--point',type=Path,required=True);ap.add_argument('--output',type=Path,required=True)
    a=ap.parse_args();start=time.monotonic();d=read(a.bank);fp=Path(str(a.bank)+'.frozen.json');frozen=read(fp)
    assert d['frozen_sha256']==sha(fp) and d['point_sha256']==frozen['point_sha256']==sha(a.point)
    assert all(sha(ROOT/p)==v for p,v in frozen['source_hashes'].items())
    parent_path=ROOT/frozen['parent_bank_path'];assert sha(parent_path)==frozen['parent_bank_sha256']
    parent=read(parent_path);anchors=d['anchors'];cs=d['anchor_coefficients']
    assert anchors==parent['anchors'] and cs==parent['cuts'][0]['anchor_coefficients']
    assert anchors[0]==['S',13] and all(s=='T' for s,o in anchors[1:]) and len(anchors)==12
    assert d['orbit']==32 and len(cs)==12 and all(len(c)==17 for c in cs)
    X,Z,A=physical()
    assert [X,Z]==[[int(v,16) for v in (ROOT/f'pools/{s}coords.txt').read_text().split()] for s in 'xz']
    assert dimension(X)==dimension(Z)==128
    symmetry=[dimension([x|(z<<128) for x,z in zip(X,Z)]),
              dimension([X[i]|(X[move(i,1)]<<128) for i in range(720)]),
              dimension([Z[i]|(Z[move(i,1)]<<128) for i in range(720)])]
    assert symmetry==[128]*3
    assert all((A[i]>>j&1)==(A[j]>>i&1)==(A[move(i,1)]>>move(j,1)&1) for i in range(720) for j in range(720))
    pp=ROOT/'algebraic-results/orbit-rank-profiles.json.gz';profiles=read(pp)
    pr=next(r for r in profiles['records'] if r['orbit']==32)
    profile_receipt=read(ROOT/'algebraic-results/orbit-rank-profiles-independent.json')
    assert profile_receipt['status']=='PASS' and profile_receipt['certificate_sha256']==hashlib.sha256(gzip.decompress(pp.read_bytes())).hexdigest()
    phaseX=X[512:528];assert dimension(phaseX)==16
    signatures=[sum(((x&z).bit_count()%2)<<h for h,x in enumerate(phaseX)) for z in Z]
    for cert in pr['minimal_bad_certificates']:
        mask=cert['mask'];w=int(cert['annihilator_hex'],16);assert 0<w<1<<128
        if cert['kind']=='zero_rank':
            chosen=[phaseX[h] for h in range(16) if mask>>h&1]
            assert dimension(chosen+[w])==len(chosen)+1
            assert all(p&mask for z,p in zip(Z,signatures) if (z&w).bit_count()%2)
        else:
            assert cert['kind']=='missing_private'
            assert all((p&mask).bit_count()>1 for z,p in zip(Z,signatures) if (z&w).bit_count()%2)
    bad=[c['mask'] for c in pr['minimal_bad_certificates']]
    allowed=[m for m in range(65536) if not any(m&b==b for b in bad)]
    representatives=sorted({min(turn(m,h) for h in range(16)) for m in allowed})
    assert len(allowed)==4597 and len(representatives)==291
    assert [r['mask'] for r in d['records']]==representatives
    cp=ROOT/'coupling-results/conditional-compat-orbit32.json';rp=ROOT/'coupling-results/conditional-compat-orbit32-independent.json'
    assert sha(cp)==frozen['conditional_bank_sha256'] and sha(rp)==frozen['conditional_replay_sha256']
    conditional=read(cp);receipt=read(rp)
    assert receipt['status']=='PASS' and receipt['bank_sha256']==sha(cp)
    assert receipt['source_hashes']==conditional['source_hashes']
    assert all(sha(ROOT/p)==v for p,v in conditional['source_hashes'].items())
    qr=next(r for r in read(ROOT/'algebraic-results/conditional-capacity/case-13.json.gz')['records'] if r['orbit']==32)
    cbad=[c['mask'] for c in qr['minimal_bad_certificates']]
    table=bytearray(65536)
    for mask in allowed:
        selected=[512+h for h in range(16) if mask>>h&1]
        table[mask]=int(not(mask&~qr['eligible_mask']) and not any(mask&b==b for b in cbad) and dimension([X[j] for j in selected]+[X[208]])==len(selected)+1)
    assert hashlib.sha256(table).hexdigest()==frozen['conditional_table_sha256'] and sum(table)==2754
    qbad=[c['mask'] for c in next(r for r in profiles['records'] if r['orbit']==13)['minimal_bad_certificates']]
    qtable=bytearray(int(not any(m&b==b for b in qbad)) for m in range(65536))
    assert d['q_profile_enforced']==frozen['q_profile_enforced']
    if d['q_profile_enforced']:assert hashlib.sha256(qtable).hexdigest()==frozen['q_profile_table_sha256']
    counts=Counter();prefixes=0;covariance=0;corruptions=0
    for row in d['records']:
        mask=row['mask'];sf=forms(mask,cs[0]);positive=[t for t,v in enumerate(sf) if v>0]
        assert sf==row['S_phase_forms'] and positive==row['positive_S_phases'] and row['features']==feature(mask)
        qlist=sorted(sum(1<<t for j,t in enumerate(positive) if bits>>j&1) for bits in range(1<<len(positive)))
        assert sorted(b['Q_mask'] for b in row['branches'])==qlist
        assert len(row['branches'])==row['subsets_to_enumerate']==1<<len(positive)
        weights=literal_weights(mask,anchors,cs);upper=[]
        for h in range(16):
            rotated=turn(mask,h);rw=literal_weights(rotated,anchors,cs);rf=forms(rotated,cs[0])
            assert all(rw[move(j,h)]==weights[j] for j in range(720))
            assert all(rf[(t+h)%16]==sf[t] for t in range(16))
            covariance+=736
        for branch in row['branches']:
            qmask=branch['Q_mask'];phases=[t for t in range(16) if qmask>>t&1]
            assert phases==branch['selected_S_phases'] and branch['S_score']==sum(sf[t] for t in phases)
            failed=[t for t in phases if not table[turn(mask,-t)]]
            counts[branch['status']]+=1
            if failed:
                assert branch['status']=='EXCLUDED_INDIVIDUAL_CONDITIONAL_PROFILE' and branch['failed_S_phases']==failed
                continue
            if d['q_profile_enforced'] and not qtable[qmask]:
                assert branch['status']=='EXCLUDED_UNCONDITIONAL_Q_PROFILE';continue
            selected=sorted([512+h for h in range(16) if mask>>h&1]+[208+t for t in phases])
            domain=domain_and_upper(X,Z,selected,weights);check_witness(Z,selected,weights,domain,branch)
            if domain['status']!='EXACT_FULL_PARTNER_BASIS_SUPPORT':continue
            exact=domain['upper']+sum(sf[t] for t in phases)
            assert Q(branch['score'])==exact;upper.append(exact);prefixes+=domain['prefix_checks']
            if not corruptions:
                for which in ('score','size'):
                    corrupted=dict(branch)
                    if which=='score':corrupted['basis_score']=str(Q(branch['basis_score'])+1)
                    else:corrupted['selected_Z_indices']=branch['selected_Z_indices'][:-1]
                    try:check_witness(Z,selected,weights,domain,corrupted)
                    except AssertionError:corruptions+=1
                    else:raise AssertionError('corrupted physical basis accepted')
        assert upper and max(upper)==Q(row['upper'])
    assert sum(counts.values())==d['positive_subsets_enumerated']==1211
    hulls=read(ROOT/'algebraic-results/hulls-16-rank.json.gz');_,index,m=layout(hulls);v=list(map(Q,read(a.point)['values']))
    targets=[Q(1),16*v[index['p',32]],*[16*v[m('S',h,32,32)] for h in range(1,9)]]
    fixed=16*sum(c[0]*v[index['p',j]]+sum(c[h+1]*v[m(s,h,j,32)] for h in range(16)) for (s,j),c in zip(anchors,cs))
    assert targets==list(map(Q,d['target_features'])) and fixed==Q(d['fixed_anchor_target'])
    # Direct literal32-action normalization of the simultaneous phase objective.
    rng=random.Random(202610300620);controls=0;wrong_factor=0
    for _ in range(12):
        masks=[[rng.getrandbits(16) for j in range(45)] for s in (0,1)]
        total=wrong=expected=0
        for sector in (0,1):
            for h in range(16):
                P=turn(masks[sector][32],h);Qmask=turn(masks[sector][13],h)
                zsel=[16*j+t for j in range(45) for t in range(16) if turn(masks[1-sector][j],h)>>t&1]
                weights=literal_weights(P,anchors,cs);svalue=sum(z for t,z in enumerate(forms(P,cs[0])) if Qmask>>t&1)
                total+=sum(weights[j] for j in zsel)+svalue
                wrong+=sum(weights[j] for j in zsel)+16*svalue
        for (side,j),c in zip(anchors,cs):
            expected+=16*c[0]*sum(masks[s][j].bit_count() for s in (0,1))
            expected+=16*sum(c[h+1]*sum((masks[s][j]&turn(masks[s if side=='S' else 1-s][32],-h)).bit_count() for s in (0,1)) for h in range(16))
        assert total==expected;controls+=1;wrong_factor+=wrong!=expected
    assert wrong_factor>0
    results=[]
    for p in d['proposals']:
        u=list(map(Q,p['unconditional_coefficients']));assert len(u)==10 and p['normalization']==16
        assert math.lcm(*(x.denominator for x in u))==p['integer_scale']
        assert max(sum(c*f for c,f in zip(u,r['features']))+Q(r['upper']) for r in d['records'])==0
        gap=fixed+sum(c*t for c,t in zip(u,targets));assert gap==Q(p['exact_violation'])
        results.append({'origin':p['origin'],'exact_violation':str(gap),'strictly_separates_candidate':gap>0})
    optimum=d['exact_feature_optimum'];optvalue=None
    if optimum:
        u=list(map(Q,optimum['unconditional_coefficients']));active=optimum['active_rows'];lam=list(map(Q,optimum['dual_weights']))
        assert len(active)==len(set(active))==len(lam)==10 and min(lam)>=0
        assert all(sum(c*f for c,f in zip(u,r['features']))+Q(r['upper'])<=0 for r in d['records'])
        assert [sum(l*d['records'][j]['features'][h] for l,j in zip(lam,active)) for h in range(10)]==targets
        primal=sum(c*t for c,t in zip(u,targets));dual=-sum(l*Q(d['records'][j]['upper']) for l,j in zip(lam,active));assert primal==dual
        optvalue=fixed+primal;assert optvalue==Q(optimum['exact_violation'])
    out={'status':'PASS','source_C16_answered':False,'bank_sha256':sha(a.bank),'frozen_sha256':sha(fp),
         'point_sha256':sha(a.point),'consumer_sha256':sha(Path(__file__)),'physical_symmetry_graph_ranks':symmetry,
         'allowed_masks_checked':len(allowed),'representatives_checked':len(representatives),'branch_counts':dict(counts),
         'branches_checked':sum(counts.values()),'exact_prefix_rank_checks':prefixes,'individual_covariance_checks':covariance,
         'literal32_action_controls':controls,'wrong_factor_controls_rejected':wrong_factor,'corrupted_supports_rejected':corruptions,
         'results':results,'exact_feature_optimum':str(optvalue) if optvalue is not None else None,
         'candidate_separated':any(r['strictly_separates_candidate'] for r in results),
         'fixed_template_cannot_separate_candidate':optvalue is not None and optvalue<=0,
         'profile_weights_fixed_in_separation':False,'seconds':time.monotonic()-start,
         'scope':'Exact whole-phase-anchor/full-opposite-basis support and template optimum only; no full source frame or global exclusion.'}
    a.output.write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(out,indent=2))

if __name__=='__main__':main()
