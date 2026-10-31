#!/usr/bin/env python3
"""Independent all-mask acceptance of a1512-feature anchored basis inequality.

No producer feature, native backend, or support routine is imported. Physical
rank and contraction-prefix inequalities use the independent low-pivot consumer.
Every allowed phase mask and both fixed-anchor states are checked explicitly.
"""
from pathlib import Path
from fractions import Fraction
from collections import Counter
import argparse,gzip,hashlib,json,random,time
from verify_algebraic_model import physical
from verify_full_partner_basis_oracle import dimension
from verify_full_partner_anchor_basis_oracle import domain,check,feature_controls
from verify_full_partner_projection import weights,local_score,compile_row,coord,move,translation_controls
from verify_projected_profile_moment_rows import point_vector

ROOT=Path(__file__).resolve().parent
FEATURES=1512
LAYOUT='old775; q_a; q_a*P[16]; q_a*Q[45,16].ravel(C)'
def sha(path):return hashlib.sha256(Path(path).read_bytes()).hexdigest()
def read(path):
    raw=Path(path).read_bytes();return json.loads(gzip.decompress(raw) if str(path).endswith('.gz') else raw)


def row(c,bound,orbit,anchor):
    assert len(c)==FEATURES and 0<=anchor<720 and anchor%16==0
    terms,rhs=compile_row(c[:775],bound,orbit);terms=Counter(terms);a=anchor//16
    terms[a]+=c[775]
    for t in range(16):terms[coord('T',t,a,orbit)]+=c[776+t]
    for j in range(45):
        for h in range(16):terms[coord('S',h,a,j)]+=c[792+16*j+h]
    return dict(sorted((j,Fraction(v)) for j,v in terms.items() if v)),rhs


def target(owner,orbit,anchor):
    def at(side,h,i,j):
        if h>8:h,i,j=16-h,j,i
        return owner[45+(0 if side=='S' else 9*2025)+2025*h+45*i+j]
    a=anchor//16
    return [Fraction(1),16*owner[orbit]]+[16*at('S',h,orbit,orbit) for h in range(1,9)]+[16*owner[j] for j in range(45)]+[16*at('T',h,orbit,j) for j in range(45) for h in range(16)]+[owner[a]]+[at('T',t,a,orbit) for t in range(16)]+[at('S',h,a,j) for j in range(45) for h in range(16)]


def literal_features(mask, selected, anchor):
    p=[int(mask>>t&1) for t in range(16)];chosen=set(selected);q=[[int(16*j+t in chosen) for t in range(16)] for j in range(45)];qa=int(anchor in chosen)
    return [1,sum(p)]+[sum(p[t]*p[(t+h)%16] for t in range(16)) for h in range(1,9)]+[sum(v) for v in q]+[sum(p[t]*q[j][(t+h)%16] for t in range(16)) for j in range(45) for h in range(16)]+[qa]+[qa*v for v in p]+[qa*v for v in sum(q,[])]


def controls(orbit=32,anchor=80):
    rng=random.Random(202610300747);count=0
    cs=[[0]*FEATURES for _ in range(4)]
    cs[0][775]=3;cs[1][776+15]=-7;cs[1][792+anchor]=5;cs[2][792+16*44+15]=11;cs[2][792+8]=13
    cs[3]=[(7*i+3)%19-9 for i in range(FEATURES)]
    for probability in (0.,.03,.2,.5,1.):
        pools=[[[int(rng.random()<probability) for t in range(16)] for j in range(45)] for s in range(2)]
        def moment(side,h,i,j):return Fraction(sum(pools[s][i][t]*pools[s^(side=='T')][j][(t+h)%16] for s in range(2) for t in range(16)),32)
        owner=[Fraction(sum(pools[s][j][t] for s in range(2) for t in range(16)),32) for j in range(45)]+[moment(side,h,i,j) for side in 'ST' for h in range(9) for i in range(45) for j in range(45)]
        averaged=[0]*FEATURES
        for s in range(2):
            for rotation in range(16):
                mask=sum(pools[s][orbit][(t-rotation)%16]<<t for t in range(16));selected=[16*j+t for j in range(45) for t in range(16) if pools[1-s][j][(t-rotation)%16]]
                f=literal_features(mask,selected,anchor);averaged=[x+y for x,y in zip(averaged,f)];state=anchor in selected
                for c in cs:
                    w=[v+int(state)*c[792+j] for j,v in enumerate(weights(mask,c[:775]))]
                    local=local_score(mask,c[:775])+int(state)*(c[775]+sum(c[776+t] for t in range(16) if mask>>t&1))
                    assert sum(x*y for x,y in zip(c,f))==local+sum(w[j] for j in selected)
        features=target(owner,orbit,anchor);assert list(map(lambda v:Fraction(v,32),averaged))==features
        for c in cs:
            terms,rhs=row(c,Fraction(7,3),orbit,anchor)
            assert sum(v*owner[j] for j,v in terms.items())-rhs==sum(x*y for x,y in zip(c,features))-Fraction(7,3)
            count+=1
    return {'status':'PASS','literal32_action_feature_equalities':5*FEATURES,'coefficient_and_constant_checks':count,'separate_extra_feature_controls':feature_controls()}


def matrix(banks,replays):
    import numpy as np
    from scipy.sparse import coo_matrix
    assert len(banks)==len(replays);ii=[];jj=[];vv=[];rhs=[];metadata=[]
    for path,rp in zip(banks,replays):
        bank,receipt=read(path),read(rp)
        assert receipt['status']=='PASS' and receipt['bank_sha256']==sha(path) and receipt['consumer_sha256']==sha(Path(__file__))
        assert bank['feature_layout']==LAYOUT and bank['status']=='EXACT_ANCHORED_SUPPORT_CUT_CANDIDATE'
        assert receipt['source_hashes']==bank['source_hashes'] and all(sha(ROOT/p)==v for p,v in bank['source_hashes'].items())
        assert all(sha(ROOT/p)==v for p,v in receipt['dependencies'].items())
        assert len(bank['cuts'])==len(receipt['results'])==receipt['cuts_checked']
        for k,cut in enumerate(bank['cuts']):
            terms,b=row(cut['coefficients'],cut['upper_bound'],bank['orbit'],bank['anchor'])
            r=receipt['results'][k];assert Fraction(r['exact_violation'])==Fraction(cut['exact_violation'])>0
            assert [[j,str(v)] for j,v in terms.items()]==r['compiled_owner_row'] and str(b)==r['owner_rhs']
            assert b.denominator==1 and abs(b)<1<<53
            for j,v in terms.items():assert v.denominator==1 and abs(v)<1<<53;ii.append(len(rhs));jj.append(j);vv.append(int(v))
            rhs.append(int(b));metadata.append({'certificate_sha256':sha(path),'replay_sha256':sha(rp),'cut_index':k,'orbit':bank['orbit'],'anchor':bank['anchor'],'source_necessary':True,'profile_weights_fixed':False})
    return coo_matrix((np.array(vv,dtype=np.int64),(ii,jj)),shape=(len(rhs),36495),dtype=np.int64).tocsr(),np.array(rhs,dtype=np.int64),metadata


def main():
    ap=argparse.ArgumentParser();ap.add_argument('--bank',type=Path);ap.add_argument('--point',type=Path);ap.add_argument('--controls-only',action='store_true');ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();start=time.monotonic();control=controls()
    if a.controls_only:a.output.write_text(json.dumps(control,indent=2)+'\n');print(control);return
    bank=read(a.bank);assert bank['status']=='EXACT_ANCHORED_SUPPORT_CUT_CANDIDATE' and bank['orbit']==32 and bank['anchor']%16==0 and bank['feature_layout']==LAYOUT
    assert bank['point_sha256']==sha(a.point) and bank['cuts']
    required={'physical-pool-source.json','pools/xcoords.txt','pools/zcoords.txt','algebraic-results/orbit-rank-profiles.json.gz'};assert required<=set(bank['source_hashes'])
    assert all(sha(ROOT/p)==v for p,v in bank['source_hashes'].items())
    X,Z,A=physical();assert X==[int(v,16) for v in (ROOT/'pools/xcoords.txt').read_text().split()] and Z==[int(v,16) for v in (ROOT/'pools/zcoords.txt').read_text().split()]
    assert dimension(X)==dimension(Z)==dimension([x|(z<<128) for x,z in zip(X,Z)])==128
    assert dimension([X[i]|(X[move(i,1)]<<128) for i in range(720)])==dimension([Z[i]|(Z[move(i,1)]<<128) for i in range(720)])==128
    assert all((A[i]>>j&1)==(A[j]>>i&1)==(A[move(i,1)]>>move(j,1)&1) for i in range(720) for j in range(720))
    profile=next(r for r in read(ROOT/'algebraic-results/orbit-rank-profiles.json.gz')['records'] if r['orbit']==32);phase=X[512:528];assert dimension(phase)==16
    signatures=[sum(((x&z).bit_count()%2)<<h for h,x in enumerate(phase)) for z in Z]
    for cert in profile['minimal_bad_certificates']:
        mask=cert['mask'];w=int(cert['annihilator_hex'],16);assert 0<w<1<<128
        if cert['kind']=='zero_rank':
            vectors=[phase[h] for h in range(16) if mask>>h&1];assert dimension(vectors+[w])==len(vectors)+1
            assert all(p&mask for z,p in zip(Z,signatures) if (z&w).bit_count()%2)
        else:
            assert cert['kind']=='missing_private';assert all((p&mask).bit_count()>1 for z,p in zip(Z,signatures) if (z&w).bit_count()%2)
    bad=[c['mask'] for c in profile['minimal_bad_certificates']];allowed=[m for m in range(65536) if not any(m&b==b for b in bad)]
    assert len(allowed)==bank['allowed_masks']==4597 and allowed==bank['mask_list']
    anchor=bank['anchor'];domains={};excluded=[]
    for mask in allowed:
        selected=[512+h for h in range(16) if mask>>h&1]
        for state in (False,True):
            d=domain(X,Z,selected,anchor,state,128)
            if d['status']=='ANCHORED_FULL_PARTNER_BASIS_DOMAIN':domains[mask,state]=(selected,d)
            else:excluded.append({'mask':mask,'selected':state,'status':d['status']})
    assert excluded==bank['excluded_branches'] and len(domains)==bank['feasible_branches']
    owner=point_vector(a.point);features=target(owner,32,anchor);results=[]
    for number,cut in enumerate(bank['cuts']):
        c=cut['coefficients'];assert len(c)==FEATURES and all(type(v) is int for v in c) and type(cut['upper_bound']) is int
        records={(r['mask'],r['selected']):r for r in cut['support_records']};assert len(records)==len(cut['support_records'])==len(domains) and records.keys()==domains.keys()
        maximum=None;prefixes=0
        for (mask,state),(selected,d) in domains.items():
            r=records[mask,state];B=r['basis'];assert all(type(j) is int and 0<=j<720 for j in B)
            w=[v+int(state)*c[792+j] for j,v in enumerate(weights(mask,c[:775]))];nz=128-len(selected)
            adapted={'status':'EXACT_ANCHORED_FULL_PARTNER_BASIS_SUPPORT','selected_Z_indices':B,'zero_basis_indices':B[:nz],'owner_indices':B[nz:],'value':r['support_value']}
            prefixes+=check(Z,selected,d,w,adapted,128)
            local=local_score(mask,c[:775])+int(state)*(c[775]+sum(c[776+t] for t in range(16) if mask>>t&1));full=local+int(r['support_value'])
            assert full==r['full_value']==sum(x*y for x,y in zip(c,literal_features(mask,B,anchor)))
            maximum=full if maximum is None else max(maximum,full)
        exact=sum(x*y for x,y in zip(c,features));gap=exact-maximum;assert maximum==cut['upper_bound'] and exact==Fraction(cut['exact_target_value']) and gap==Fraction(cut['exact_violation'])>0
        terms,rhs=row(c,maximum,32,anchor);assert sum(v*owner[j] for j,v in terms.items())-rhs==gap
        results.append({'exact_target_value':str(exact),'exact_violation':str(gap),'upper_bound':maximum,'prefix_rank_checks':prefixes,'compiled_owner_row':[[j,str(v)] for j,v in terms.items()],'owner_rhs':str(rhs)})
        print('accepted cut',number,'gap',float(gap),'seconds',time.monotonic()-start,flush=True)
    deps=['verify_full_partner_anchor_basis_oracle.py','verify_full_partner_basis_oracle.py','verify_full_partner_projection.py','verify_projected_profile_moment_rows.py','verify_algebraic_model.py','verify_partial_frame.py','audit_pools.py']
    out={'status':'PASS','source_C16_answered':False,'bank_sha256':sha(a.bank),'point_sha256':sha(a.point),'consumer_sha256':sha(Path(__file__)),'source_hashes':bank['source_hashes'],'dependencies':{p:sha(ROOT/p) for p in deps},'cuts_checked':len(results),'results':results,'allowed_masks_checked':4597,'anchor_branches_checked':9194,'feasible_branches':len(domains),'excluded_branches':len(excluded),'physical_profile_witnesses':len(bad),'physical_pairing_symmetry_checks':2*720*720,'translation_controls':control,'elapsed_seconds':time.monotonic()-start,'scope':'Source-necessary1512-feature inequality over every allowed phase mask and both fixed opposite-anchor states. No full dual-frame or source-infeasibility claim.'}
    a.output.write_text(json.dumps(out,indent=2)+'\n');print({k:v for k,v in out.items() if k not in ('results','source_hashes','dependencies')},flush=True)

if __name__=='__main__':main()
