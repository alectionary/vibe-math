#!/usr/bin/env python3
"""Export literal cuts and their full allowed-zero-pool span closures."""
from pathlib import Path
from fractions import Fraction as Q
import argparse, gzip, hashlib, json
from verify_two_sided_full_basis_oracle import physical_source, domains, rank

ROOT=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def read(p):
    p=Path(p);return json.loads(gzip.decompress(p.read_bytes()) if p.suffix=='.gz' else p.read_text())
def main():
    ap=argparse.ArgumentParser();ap.add_argument('--batch',type=Path,required=True);ap.add_argument('--allocation',type=Path,required=True)
    ap.add_argument('--point',type=Path,required=True);ap.add_argument('--side',choices=['X','Z'],required=True);ap.add_argument('--output',type=Path,required=True)
    a=ap.parse_args();assert not a.output.exists();batch=read(a.batch)
    assert batch['status'] in ['ALL_COHORT_ENDPOINTS_INDEPENDENTLY_REPLAYED','BOUNDED_TWO_SECTOR_GATE_STOPPED']
    batch_frozen=a.batch.with_suffix('.frozen.json');bf=read(batch_frozen);assert batch['frozen_sha256']==sha(batch_frozen)
    assert bf['point_sha256']==sha(a.point) and all(sha(ROOT/p)==h for p,h in bf['source_hashes'].items())
    allocation=read(a.allocation);afp=a.allocation.with_name(a.allocation.name.removesuffix('.json.gz')+'.frozen.json');af=read(afp)
    assert allocation['status']=='EXACT_DIRECT_COUNT_ALLOCATION_REQUIRES_REPLAY' and allocation['frozen_sha256']==sha(afp)
    assert af['point_sha256']==sha(a.point) and af['side']==a.side
    X,Z,_=physical_source();U=X if a.side=='X' else Z;xx,zz=af['X_anchors'],af['Z_anchors']
    dd=[d[a.side] for d in domains(X,Z,xx,zz)];lam=list(map(Q,af['lambda_masses']));y=[list(map(Q,row)) for row in allocation['exact_allocations']]
    sources=dict(bf['source_hashes']);sources.update(af['source_hashes'])
    for p in [Path(__file__),a.batch,batch_frozen,a.allocation,afp,a.point]:
        p=p.resolve();assert p.is_relative_to(ROOT);sources[str(p.relative_to(ROOT))]=sha(p)
    endpoints=[];cuts={}
    for record in batch['outcomes']:
        if record['side']!=a.side or record.get('independent_status')!='PASS_EXACT_PHYSICAL_SINGLE_PATTERN_RANK_VIOLATION':continue
        cp,rp=Path(record['certificate']),Path(record['receipt']);c,r=read(cp),read(rp)
        assert sha(cp)==record['certificate_sha256']==r['certificate_sha256'] and sha(rp)==record['receipt_sha256']
        assert r['status']=='PASS_EXACT_PHYSICAL_SINGLE_PATTERN_RANK_VIOLATION'
        assert r['consumer_sha256']==sha(ROOT/'two_basis_structure_verify_physical_push_early.py')
        assert r['point_sha256']==sha(a.point) and r['allocation_sha256']==sha(a.allocation) and r['side']==a.side
        fpath=cp.with_name(cp.name.removesuffix('.json.gz')+'.frozen.json');f=read(fpath)
        assert c['frozen_sha256']==r['frozen_sha256']==sha(fpath)
        assert all(sha(ROOT/p)==h for p,h in f['source_hashes'].items());sources.update(f['source_hashes'])
        for p in [cp,rp,fpath]:sources[str(p)]=sha(p)
        endpoints.append(dict(certificate=str(cp),certificate_sha256=sha(cp),receipt=str(rp),receipt_sha256=sha(rp)))
        cut=c['physical_rank_cut'];assert cut==r['endpoint']['physical_rank_cut']
        m=c['selected_mask'];F,A,rr=cut['forced_zero_indices'],cut['indices'],cut['contraction_rank']
        assert lam[m]>0 and F==dd[m]['zero_forced'] and A==sorted(set(A)) and set(A)<=set(dd[m]['zero_free'])
        assert rank(U[j] for j in F)==len(F) and rank(U[j] for j in F+A)==rr+len(F)==cut['physical_span_rank']
        left=sum(y[m][j] for j in A);bound=rr*lam[m];gap=left-bound
        assert gap>0 and gap==Q(cut['exact_raw_violation'])
        span={}
        for j in F+A:
            value=U[j]
            while value:
                pivot=value.bit_length()-1
                if pivot in span:value^=span[pivot]
                else:span[pivot]=value;break
        closed=[]
        for j in dd[m]['zero_free']:
            value=U[j]
            for pivot in sorted(span,reverse=True):
                if value>>pivot&1:value^=span[pivot]
            if not value:closed.append(j)
        assert set(A)<=set(closed) and rank(U[j] for j in F+closed)==rr+len(F)
        for S,kind in [(A,'literal'),(closed,'span_closure')]:
            lhs=sum(y[m][j] for j in S);violation=lhs-bound;assert violation>=gap>0
            key=(m,tuple(F),tuple(S),rr)
            row=dict(mask=m,forced_zero_indices=F,indices=S,contraction_rank=rr,physical_span_rank=rr+len(F),
                lambda_mass=str(lam[m]),exact_lhs=str(lhs),exact_bound=str(bound),exact_violation=str(violation),
                endpoint_certificate_sha256=sha(cp),kind=kind)
            if kind=='span_closure':row['closure_of_indices']=A
            cuts[key]=row
    assert cuts,'No accepted literal rank cut in this sector cohort'
    out=dict(status='EXACT_PHYSICAL_CONDITIONAL_CLOSED_RANK_ROWS_REQUIRE_REPLAY',side=a.side,X_anchors=xx,Z_anchors=zz,
        point_sha256=sha(a.point),allocation_path=str(a.allocation),allocation_sha256=sha(a.allocation),
        source_hashes=sources,producer_sha256=sha(__file__),endpoint_sources=endpoints,
        cuts=[cuts[k] for k in sorted(cuts)],batch_sha256=sha(a.batch),source_C16_answered=False,
        scope='Valid per-pattern contracted physical rank rows, strictly violated by the supplied allocation. No fixed-law or global-target exclusion is implied.')
    assert all(sha(ROOT/p)==h for p,h in sources.items())
    a.output.write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(dict(side=a.side,cuts=len(cuts),source_endpoints=len(endpoints),bank_sha256=sha(a.output))),flush=True)
if __name__=='__main__':main()
