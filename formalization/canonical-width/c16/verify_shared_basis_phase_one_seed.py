#!/usr/bin/env python3
"""Independent feasible artificial-slack seed; no shared master has been solved."""
import os
assert os.getpriority(os.PRIO_PROCESS,0)==19
for key in ('OPENBLAS_NUM_THREADS','OMP_NUM_THREADS','MKL_NUM_THREADS','VECLIB_MAXIMUM_THREADS','NUMEXPR_NUM_THREADS','BLIS_NUM_THREADS'):
    os.environ[key]='1'
from pathlib import Path
from fractions import Fraction as Q
import argparse,copy,gzip,hashlib,json,time
from verify_algebraic_model import physical
from verify_two_sided_full_basis_oracle import domains,check_sector

ROOT=Path(__file__).resolve().parent
def sha(path):return hashlib.sha256(Path(path).read_bytes()).hexdigest()
def read(path):
    p=Path(path);raw=p.read_bytes();return json.loads(gzip.decompress(raw) if p.suffix=='.gz' else raw)

def context(d):
    assert d['status']=='EXACT_SHARED_BASIS_PHASE_ONE_SEED_REQUIRES_REPLAY'
    for key in ('endpoint','endpoint_receipt','parent_receipt'):assert sha(d[key])==d[key+'_sha256']
    c=read(d['endpoint']);r=read(d['endpoint_receipt']);parent=read(d['parent_receipt'])
    assert r['status']=='PASS_EXACT_LITERAL_OWNER_K22_CAPACITY_ALLOCATION'
    assert r['consumer_sha256']==sha(ROOT/'verify_owner_k22_capacity_endpoint.py')
    assert r['certificate_sha256']==d['endpoint_sha256']
    assert r['parent_receipt_sha256']==d['parent_receipt_sha256']
    assert parent['status']=='PASS_EXACT_LITERAL_OWNER_FLOW_CAPACITY_JOINT_ALLOCATION'
    assert parent['consumer_sha256']==sha(ROOT/'verify_owner_capacity_joint_literal.py')
    assert c['point_sha256']==r['point_sha256']=='4945dd10a5ec76c54311466ab0594b0c7b8fc2071eab4ae9a783a87143baad8f'
    for p,h in c['source_bindings'].items():assert sha(p)==h
    for p,h in d['source_hashes'].items():assert sha(ROOT/p)==h
    assert d['parent_exact_parameters']==c['exact_parameters'] and len(c['exact_parameters'])==22513
    assert d['parent_exact_allocations']==c['exact_allocations'] and d['lambda_masses']==c['lambda_masses']
    masses=list(map(Q,c['lambda_masses']));assert len(masses)==16 and all(v>=0 for v in masses) and sum(masses)==1
    Y={side:[list(map(Q,row)) for row in c['exact_allocations'][side]] for side in 'XZ'}
    assert all(len(Y[side])==16 and all(len(row)==720 for row in Y[side]) for side in 'XZ')
    X,Z,_=physical();dd=domains(X,Z,[80,512],[186,433]);return masses,Y,X,Z,dd

def replay(d,data):
    masses,Y,X,Z,dd=data;seen=set();total=Q(0);sector={side:Q(0) for side in 'XZ'};prefixes=0;coordinates=0
    for b in d['blocks']:
        side,m=b['side'],b['mask'];assert side in 'XZ' and type(m)is int and 0<=m<16
        assert (side,m) not in seen;seen.add((side,m));mass=masses[m]
        assert Q(b['mass'])==Q(b['weight'])==mass>0 and dd[m]['feasible']
        y=Y[side][m];assert all(0<=v<=mass for v in y) and sum(y)==128*mass
        indices=b['indices'];score,np=check_sector(X if side=='X' else Z,128,dd[m][side],y,indices);prefixes+=np
        assert score==Q(b['weighted_score']);chosen=set(indices)
        plus=list(map(Q,b['positive_slack']));minus=list(map(Q,b['negative_slack']))
        assert len(plus)==len(minus)==720 and all(v>=0 for v in plus+minus)
        for j in range(720):
            value=mass*int(j in chosen);residual=y[j]-value
            assert plus[j]==max(residual,0) and minus[j]==max(-residual,0)
            assert value+plus[j]-minus[j]==y[j];coordinates+=1
        L1=sum(plus)+sum(minus)
        assert sum(plus)==sum(minus) and L1==Q(b['L1'])==256*mass-2*score
        assert L1>=0;total+=L1;sector[side]+=L1
    zero=[]
    for b in d['zero_blocks']:
        side,m=b['side'],b['mask'];assert side in 'XZ' and type(m)is int and 0<=m<16
        assert (side,m) not in seen;seen.add((side,m));assert Q(b['mass'])==masses[m]==0
        assert all(v==0 for v in Y[side][m]);coordinates+=720;zero.append((side,m))
    assert seen=={(side,m) for side in 'XZ' for m in range(16)}
    assert len(d['blocks'])==22 and len(zero)==10 and coordinates==23040
    assert total==Q(d['total_L1']) and 0<=total<=512
    assert all(sector[side]==Q(d['sector_L1'][side]) for side in 'XZ')
    return dict(positive_domain_bases_checked=22,zero_domain_blocks_checked=10,exact_link_coordinates=coordinates,
                physical_signed_prefix_ranks_checked=prefixes,exact_total_artificial_L1=str(total),
                sector_L1={side:str(v) for side,v in sector.items()},single_basis_L1_minimum_verified=True,
                parent_parameter_strings_preserved=22513,parent_allocation_strings_preserved=23040)

def main():
    ap=argparse.ArgumentParser();ap.add_argument('--certificate',type=Path,required=True);ap.add_argument('--output',type=Path,required=True);a=ap.parse_args()
    start=time.monotonic();assert not a.output.exists();d=read(a.certificate);data=context(d);out=replay(d,data);rejected=[]
    for label in ('false_mass','nonbasis','wrong_slack','false_L1','missing_zero_block'):
        bad=copy.deepcopy(d)
        if label=='false_mass':bad['blocks'][0]['weight']='0'
        elif label=='nonbasis':bad['blocks'][0]['indices'].pop()
        elif label=='wrong_slack':bad['blocks'][0]['positive_slack'][0]=str(Q(bad['blocks'][0]['positive_slack'][0])+1)
        elif label=='false_L1':bad['total_L1']=str(Q(bad['total_L1'])+1)
        else:bad['zero_blocks'].pop()
        try:replay(bad,data)
        except (AssertionError,ValueError):rejected.append(label)
        else:raise AssertionError(label)
    out.update(status='PASS_EXACT_SHARED_BASIS_PHASE_ONE_SEED',certificate_sha256=sha(a.certificate),
               consumer_sha256=sha(__file__),endpoint_sha256=d['endpoint_sha256'],endpoint_receipt_sha256=d['endpoint_receipt_sha256'],
               parent_receipt_sha256=d['parent_receipt_sha256'],source_hashes=d['source_hashes'],corruptions_rejected=rejected,
               shared_master_built=False,shared_master_solved=False,full_basis_membership_claimed=False,
               source_C16_answered=False,full_source_frame=False,nice=19,threads=1,elapsed_seconds=time.monotonic()-start,
               scope='Exact feasible artificial-slack start for a proposed shared basis master; positive slack is not membership.')
    a.output.write_text(json.dumps(out,indent=2)+'\n');print(json.dumps({k:v for k,v in out.items() if k!='source_hashes'}),flush=True)
if __name__=='__main__':main()
