#!/usr/bin/env python3
"""One exact physical signed-greedy pricing diagnostic; no column loop."""
import os
assert os.getpriority(os.PRIO_PROCESS,0)==19
for k in ('OPENBLAS_NUM_THREADS','OMP_NUM_THREADS','MKL_NUM_THREADS','VECLIB_MAXIMUM_THREADS','NUMEXPR_NUM_THREADS','BLIS_NUM_THREADS'):os.environ[k]='1'
from pathlib import Path
from fractions import Fraction as Q
import argparse,gzip,hashlib,json
from verify_algebraic_model import physical
from verify_full_partner_projection import point_data
from verify_singleton_exchange_terminal import rank

ROOT=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def read(p):
    p=Path(p);return json.loads(gzip.decompress(p.read_bytes()) if p.suffix=='.gz' else p.read_bytes())
def main():
    ap=argparse.ArgumentParser();ap.add_argument('--manifest',type=Path,required=True);ap.add_argument('--farkas-receipt',type=Path,required=True);ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();assert not a.output.exists()
    m=read(a.manifest);s=read(m['semantic']);r=read(a.farkas_receipt)
    assert r['status']=='PASS_EXACT_RESTRICTED_SINGLETON_ARCHIVE_INFEASIBILITY' and r['manifest_sha256']==sha(a.manifest)
    assert r['consumer_sha256']==sha(ROOT/'verify_singleton_archive_cg.py') and sha(m['semantic'])==r['semantic_sha256']==m['semantic_sha256']
    assert all(sha(ROOT/p)==h for p,h in s['source_hashes'].items())
    X,Z,_=physical();k=s['anchor_orbit'];owner,target=point_data(s['point'],k);p=owner[k];q=[v/(16*p) for v in target[55:]]
    E=[j for j in range(720) if (X[16*k]&Z[j]).bit_count()%2==0];assert E==s['physical_zero_ground_indices']
    w={key:Q(value) for key,value in r['proof']['multipliers'].items()};u=w.get('mass',Q(0));v={j:w.get('q'+str(j),Q(0)) for j in E}
    assert all(u+sum((v[j] for j in b),Q(0))==w.get('n'+str(i),Q(0))>=0 for i,b in enumerate(s['physical_bases']))
    target_value=u+sum((v[j]*q[j] for j in E),Q(0));assert target_value==-Q(r['proof']['exact_gap'])<0
    ordered=sorted(E,key=lambda j:(v[j],j));high={};basis=[]
    for j in ordered:
        x=Z[j]
        while x:
            b=x.bit_length()-1
            if b in high:x^=high[b]
            else:high[b]=x;basis.append(j);break
    assert len(basis)==rank(Z[j] for j in basis)==127
    minimum=sum((v[j] for j in basis),Q(0))
    # Independent low-pivot prefix ranks certify the minimum for all bases.
    low={};ranks=[]
    for j in ordered:
        x=Z[j]
        while x:
            b=x&-x
            if b in low:x^=low[b]
            else:low[b]=x;break
        ranks.append(len(low))
    assert ranks[-1]==127
    bound=v[ordered[-1]]*127+sum(((v[ordered[i]]-v[ordered[i+1]])*ranks[i] for i in range(len(ordered)-1)),Q(0))
    assert minimum==bound
    reduced=u+minimum;cut=None
    if reduced>=0:
        mass=Q(0)
        for t,j in enumerate(ordered):
            mass+=q[j]
            if mass>ranks[t]:
                J=sorted(ordered[:t+1]);rr=rank(Z[j] for j in J)
                assert rr==ranks[t]
                cut=dict(sector='T',anchor_orbit=k,mandatory_index=None,indices=J,bound=rr,exact_violation=str(p*(mass-rr)))
                break
        assert cut is not None
    out=dict(status='EXACT_SINGLETON_ARCHIVE_FARKAS_PRICING_DIAGNOSTIC',manifest=str(a.manifest),manifest_sha256=sha(a.manifest),
             farkas_receipt=str(a.farkas_receipt),farkas_receipt_sha256=sha(a.farkas_receipt),point_sha256=s['point_sha256'],
             anchor_orbit=k,constant=str(u),weights=[[j,str(v[j])] for j in E if v[j]],target_affine_value=str(target_value),
             minimum_physical_basis_weight=str(minimum),minimum_affine_value=str(reduced),
             minimizing_physical_basis=sorted(basis),independent_prefix_rank_checks=len(E),
             exact_minimum_verified=True,missing_archive_column=reduced<0,global_rank_cut_candidate=cut,
             source_hashes=s['source_hashes'],producer_sha256=sha(__file__),source_C16_answered=False,
             scope='One exact support query. A negative affine basis value refutes only the archive separator; no iterated column generation.')
    a.output.write_text(json.dumps(out,indent=2)+'\n');print(json.dumps({key:value for key,value in out.items() if key not in ('source_hashes','minimizing_physical_basis')}),flush=True)
if __name__=='__main__':main()
