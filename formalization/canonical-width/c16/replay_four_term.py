#!/usr/bin/env python3
"""Independent complete source support-four replay and literal word checks."""
from pathlib import Path
from fractions import Fraction
from collections import Counter
import argparse,gzip,hashlib,json,time
from replay_capacity_four import supports_through_four
from verify_algebraic_model import physical
from verify_four_term_small import check
from verify_sparse_gate import independent_obstruction
ROOT=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()

def witness(X,Z,J,D):
    """Solve all physical eligible equations, independently of discovery basis."""
    rows={}
    for i,x in enumerate(X):
        if any((x&Z[j]).bit_count()%2 for j in J):continue
        b=int(i in D)
        while x:
            p=(x&-x).bit_length()-1
            if p not in rows:rows[p]=(x,b);break
            r,t=rows[p];x^=r;b^=t
        if not x:assert b==0
    w=0
    for p,(x,b) in sorted(rows.items(),reverse=True):
        if (x&w).bit_count()%2!=b:w^=1<<p
    return w

def short_word(V,J,w,q):
    L={0}
    for j in J:L|={x^V[j] for x in list(L)}
    norm=lambda x:min(x^l for l in L)
    one={0:()}
    for j,z in enumerate(V):one.setdefault(norm(z),(j,))
    target=norm(w)
    if target in one:return list(one[target])
    pairs={}
    for x,ids in one.items():
        for y,js in one.items():pairs.setdefault(x^y,ids+js)
    if q>=2 and target in pairs:return list(pairs[target])
    if q>=3:
        for x,ids in one.items():
            if target^x in pairs:return list(ids+pairs[target^x])
    if q>=4:
        for x,ids in pairs.items():
            if target^x in pairs:return list(ids+pairs[target^x])
    return None

def main():
    ap=argparse.ArgumentParser();ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();start=time.monotonic()
    fp=ROOT/'transfer-results/four-term/frozen.json';gp=fp.with_name('gate.json');f=json.loads(fp.read_text());g=json.loads(gp.read_text())
    assert g['status']=='COMPLETE' and g['frozen_sha256']==sha(fp)
    for p,h in f['source_hashes'].items():assert sha(ROOT/p)==h
    cp=ROOT/f['cohort_c16_path'];assert sha(cp)==f['cohort_sha256'];cohort=json.loads(cp.read_text())['cohort'];X,Z,A=physical()
    records=[];positives=[];counts=Counter()
    for k,item in enumerate(cohort):
        J=item['ids'];supports=supports_through_four(X,Z,J);local=[];rejected=False
        for D in supports:
            counts[len(D)]+=1;w=witness(X,Z,J,D);terms=short_word(Z,J,w,len(D));r={'ids':J,'detecting_support':D,'witness_hex':hex(w),'short_word_indices':terms}
            if terms is None:
                row={'kind':'sparse_quotient_obstruction','side':0,'mandatory_opposite':J,'witness_hex':hex(w),'detecting_support':list(D),'order':len(D),'minimum_outside_basis_terms':len(D)+1,'clause':[-j-721 for j in J]}
                r['literal_certificate_check']=check(X,Z,row);r['old_complete_orders']=independent_obstruction(X,Z,0,J);assert not r['old_complete_orders'][3];positives.append(J);rejected=True
            else:
                total=w
                for j in terms:total^=Z[j]
                L={0}
                for j in J:L|={x^Z[j] for x in list(L)}
                assert total in L and len(terms)<=len(D)
            local.append(r)
        assert rejected==g['records'][k]['order4_reject'];records.extend(local)
        if k%50==0:print('FOUR REPLAY',k,dict(counts),flush=True)
    assert positives==[[416,512]] and len(cohort)==384 and dict(counts)=={4:6,3:2}
    cut=g['cuts'][0];receipt=check(X,Z,cut['certificate'])
    assert cut['indices']==positives[0] and cut['sector']==1
    # Physical pairing symmetry justifies both sector exchange and cyclic shifts.
    assert all(((X[i]&Z[j]).bit_count()%2)==((X[j]&Z[i]).bit_count()%2) for i in range(720) for j in range(720))
    rot=lambda i:16*(i//16)+(i%16+1)%16
    assert all(((X[i]&Z[j]).bit_count()%2)==((X[rot(i)]&Z[rot(j)]).bit_count()%2) for i in range(720) for j in range(720))
    point=ROOT/'algebraic-results/profile-moment-face1.json.gz';values=json.loads(gzip.decompress(point.read_bytes()))['values']
    k=45+sum(45-t for t in range(26))+6;value=Fraction(values[k]);assert value>0
    result={'status':'PASS','source_C16_answered':False,'queries':384,'queries_without_support_at_most_four':376,
            'support_counts':dict(counts),'new_forbidden_pairs':positives,'records':records,'discovery_certificate_replay':receipt,
            'physical_pairing_symmetries_checked':True,'translated_sector_clauses':32,
            'old_exact_moment_point_separated':{'path':str(point.relative_to(ROOT)),'sha256':sha(point),'coordinate':['S',0,26,32],'index':k,'value':str(value),'required_value':'0'},
            'gate_sha256':sha(gp),'elapsed_seconds':time.monotonic()-start,
            'scope':'One universal forbidden pair, with32 symmetry copies. Complete order-four screen of384 specified neighbors, exactly one strict gain over order3. Separates the previous rational moment point; no infeasibility of the strengthened relaxation or full-source conclusion.'}
    a.output.write_text(json.dumps(result,indent=2)+'\n');print({k:v for k,v in result.items() if k!='records'},flush=True)
if __name__=='__main__':main()
