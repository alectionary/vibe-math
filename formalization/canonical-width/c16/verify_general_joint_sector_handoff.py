#!/usr/bin/env python3
"""Independent exact-array provenance from an accepted general joint primal.

The children retain an explicitly narrower rank-only schema. This bridge
neither drops the parent proof nor credits child consumers with its star rows.
"""
import os
assert os.getpriority(os.PRIO_PROCESS,0)==19
for _key in ('OPENBLAS_NUM_THREADS','OMP_NUM_THREADS','MKL_NUM_THREADS','VECLIB_MAXIMUM_THREADS','NUMEXPR_NUM_THREADS','BLIS_NUM_THREADS'):
    assert os.environ.get(_key)=='1'
from pathlib import Path
from fractions import Fraction as Q
import argparse,copy,gzip,hashlib,json,time
ROOT=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256((ROOT/p).read_bytes()).hexdigest()
def read(p):
    p=ROOT/p;b=p.read_bytes();return json.loads(gzip.decompress(b) if p.suffix=='.gz' else b)
def rk(r):return r['mask'],tuple(r['forced_zero_indices']),tuple(r['indices']),r['contraction_rank']
def payload(c,f,joint,M,accepted,side):
    assert c['rounding_performed'] is False and f['side']==side
    assert f['lambda_masses']==joint['lambda_masses']
    assert f['X_anchors']==M['X_anchors'] and f['Z_anchors']==M['Z_anchors']
    y=c['exact_allocations'];assert y==joint['exact_allocations'][side]
    assert len(y)==16 and all(len(row)==720 for row in y)
    assert all(type(v)is str and str(Q(v))==v for row in y for v in row)
    ranks={rk(r) for r in f['rank_rows']};parent={rk(r) for r in M['sectors'][side]['rank_rows']}
    assert len(ranks)==len(f['rank_rows']) and ranks<=parent
    ps=dict(rank_rows=accepted['rank_rows_checked'],star_rows=accepted['star_rows_checked'],zero_tau_pins=True,finite_listed_relaxation_only=True)
    assert f['parent_scope']==c['parent_scope']==ps
    child=f['child_scope'];assert child==c['child_scope']
    assert child['rank_rows']==len(ranks)==c['prior_rank_row_count']
    assert child['star_rows']==0 and child['narrower_than_parent'] is True
    assert len(ranks)<accepted['rank_rows_checked'] and accepted['star_rows_checked']>0
    return 16*720

def main():
    ap=argparse.ArgumentParser()
    for name in ('joint','joint-receipt','sector-prefix','output'):ap.add_argument('--'+name,type=Path,required=True)
    a=ap.parse_args();assert not a.output.exists();start=time.monotonic()
    j,r=read(a.joint),read(a.joint_receipt)
    assert j['status']=='EXACT_GENERAL_JOINT_ALLOCATION_REQUIRES_REPLAY'
    assert r['status']=='PASS_EXACT_LITERAL_GENERAL_JOINT_ALLOCATION'
    assert r['certificate_sha256']==sha(a.joint)
    assert r['consumer_sha256']==sha('verify_joint_general_literal.py')
    assert j['zero_tau_pins'] is r['zero_tau_pins'] is True
    assert j['point_sha256']==r['point_sha256']==sha(j['point'])
    manifest=read(j['manifest']);semantic=read(manifest['semantic']);M=semantic['model']
    assert j['manifest_sha256']==r['manifest_sha256']==sha(j['manifest'])
    assert j['semantic_sha256']==r['semantic_sha256']==sha(manifest['semantic'])
    assert semantic['zero_tau_pins'] is True and M['point_sha256']==r['point_sha256']
    for p,h in {**r['source_hashes'],**r['dependencies'],**j['source_bindings']}.items():assert sha(p)==h
    paths=[a.joint,a.joint_receipt,Path(j['manifest']),Path(manifest['semantic']),Path(__file__).name,'verify_joint_general_literal.py','verify_two_basis_rank_closed_allocation.py']
    counts={};child_counts={};rejected=[]
    for side in ('X','Z'):
        stem=str(a.sector_prefix)+'-'+side
        cp,fp,rp=[Path(stem+s) for s in ('.json.gz','.frozen.json','-independent.json')]
        c,f,cr=read(cp),read(fp),read(rp)
        assert c['status']=='EXACT_DIRECT_COUNT_ALLOCATION_REQUIRES_REPLAY'
        assert f['status']=='FROZEN_EXACT_SECTOR_EXTRACTION_FROM_GENERAL_JOINT'
        assert c['frozen_sha256']==cr['frozen_sha256']==sha(fp)
        for key,path in [('joint_certificate',a.joint),('joint_receipt',a.joint_receipt),('joint_manifest',Path(j['manifest'])),('joint_semantic',Path(manifest['semantic']))]:
            assert (ROOT/f[key]).resolve()==(ROOT/path).resolve()
            assert f[key+'_sha256']==sha(path)
            if key in ('joint_certificate','joint_receipt'):assert c[key+'_sha256']==sha(path)
            relative=str((ROOT/path).resolve().relative_to(ROOT));assert f['source_hashes'][relative]==sha(path)
        assert cr['status']=='PASS_EXACT_DIRECT_COUNT_AND_LISTED_RANK_ROWS'
        assert cr['certificate_sha256']==sha(cp)
        assert cr['consumer_sha256']==sha('verify_two_basis_rank_closed_allocation.py')
        assert cr['point_sha256']==f['point_sha256']==j['point_sha256']
        for p,h in f['source_hashes'].items():assert sha(p)==h
        counts[side]=payload(c,f,j,M,r,side);child_counts[side]=f['child_scope']['rank_rows']
        assert cr['listed_rank_rows_count']==child_counts[side]
        paths.extend([cp,fp,rp])
        if side=='X':
            for label in ('changed-rational-string','changed-law','rounded-flag','extra-child-rank'):
                badc=copy.deepcopy(c);badf=copy.deepcopy(f)
                if label=='changed-rational-string':badc['exact_allocations'][0][0]=str(Q(badc['exact_allocations'][0][0])+1)
                elif label=='changed-law':badf['lambda_masses'][0]=str(Q(badf['lambda_masses'][0])+1)
                elif label=='rounded-flag':badc['rounding_performed']=True
                else:badf['rank_rows'][0]['contraction_rank']+=1000
                try:payload(badc,badf,j,M,r,side)
                except AssertionError:rejected.append(label)
                else:raise AssertionError(('accepted provenance mutant',label))
    result=dict(status='PASS_EXACT_GENERAL_JOINT_TO_SECTOR_HANDOFF',
                joint_certificate_sha256=sha(a.joint),joint_receipt_sha256=sha(a.joint_receipt),
                point_sha256=j['point_sha256'],zero_tau_pins=True,
                literal_rational_strings_compared=counts,rounding_performed=False,
                parent_rank_rows=r['rank_rows_checked'],parent_star_rows=r['star_rows_checked'],
                child_rank_rows=child_counts,child_star_rows=0,child_scope_strictly_narrower=True,
                source_hashes={str(p):sha(p) for p in paths},consumer_sha256=sha(Path(__file__).name),
                corruptions_rejected=rejected,priority=19,elapsed_seconds=time.monotonic()-start,
                source_C16_answered=False,all_subset_rank_membership_proved=False,
                scope='Exact unchanged arrays from the independently accepted pinned joint primal; children prove only their narrower listed-rank scope. Parent star/rank proof remains separately bound.')
    a.output.write_text(json.dumps(result,sort_keys=True,indent=2)+'\n');print(json.dumps(result),flush=True)

if __name__=='__main__':main()
