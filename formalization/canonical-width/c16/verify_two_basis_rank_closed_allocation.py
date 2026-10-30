#!/usr/bin/env python3
"""Exact allocation/rank-row consumer; independent of allocation discovery."""
from pathlib import Path
from fractions import Fraction as Q
import argparse, copy, gzip, hashlib, json, time
from verify_two_sided_full_basis_oracle import physical_source, domains, target
from verify_two_basis_direct_allocation import check_allocation

ROOT = Path(__file__).resolve().parent
COUNT_STATUS = 'PASS_EXACT_DIRECT_PATTERN_COUNT_ALLOCATION'
RANK_STATUS = 'PASS_EXACT_DIRECT_COUNT_AND_LISTED_RANK_ROWS'

def sha(p): return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def read(p):
    p = Path(p)
    return json.loads(gzip.decompress(p.read_bytes()) if p.suffix == '.gz' else p.read_text())
def frozen_path(p):
    return p.with_name(p.name.removesuffix('.json.gz').removesuffix('.json') + '.frozen.json')
def rank(vectors):
    piv = {}
    for v in vectors:
        while v:
            k = (v & -v).bit_length() - 1
            if k in piv: v ^= piv[k]
            else: piv[k] = v; break
    return len(piv)
def geometry(row, U, dd):
    m, F, A, r = (row[k] for k in ('mask','forced_zero_indices','indices','contraction_rank'))
    assert type(m) is int and 0 <= m < 16 and dd[m]['feasible']
    assert all(type(j) is int and 0 <= j < len(U) for j in F + A)
    assert F == dd[m]['zero_forced'] and len(set(F)) == len(F)
    assert A == sorted(set(A)) and set(A) <= set(dd[m]['zero_free'])
    assert type(r) is int and r >= 0 and rank(U[j] for j in F) == len(F)
    assert rank(U[j] for j in F + A) - len(F) == r
    return m, A, r
def normalized(row):
    return {k:row[k] for k in ('mask','forced_zero_indices','indices','contraction_rank')}
def key(row): return json.dumps(normalized(row), sort_keys=True)
def data(certificate, point=None):
    c = read(certificate); fp = frozen_path(certificate); f = read(fp)
    assert c['status'] == 'EXACT_DIRECT_COUNT_ALLOCATION_REQUIRES_REPLAY'
    assert c['frozen_sha256'] == sha(fp)
    assert all(sha(ROOT/p) == h for p,h in f['source_hashes'].items())
    if point is not None: assert f['point_sha256'] == sha(point)
    X,Z,_ = physical_source(); side = f['side']; assert side in ['X','Z']
    U = X if side == 'X' else Z
    dd = [d[side] for d in domains(X,Z,f['X_anchors'],f['Z_anchors'])]
    lam = list(map(Q, f['lambda_masses']))
    y = [list(map(Q, row)) for row in c['exact_allocations']]
    return c,f,fp,U,dd,lam,y
def receipt_guard(path, certificate):
    r = read(path); assert r['certificate_sha256'] == sha(certificate)
    expected = {COUNT_STATUS:'verify_two_basis_direct_allocation.py', RANK_STATUS:Path(__file__).name}
    assert r['status'] in expected and r['consumer_sha256'] == sha(ROOT/expected[r['status']])
    return r
def allocation(a):
    c,f,fp,U,dd,lam,y = data(a.certificate,a.point)
    full = target(a.point,f['X_anchors'],f['Z_anchors']); off = 720*int(f['side']=='Z')
    b = full[11+off:731+off]+[full[1451+1440*i+off+j] for i in range(4) for j in range(720)]
    assert list(map(Q,c['sector_target'])) == b
    for k,m in enumerate([0,1,2,4,8,3,5,9,6,10,12]):
        assert sum(lam[q] for q in range(16) if q&m == m) == full[k]
    checks = check_allocation(y,lam,dd,b)
    for face in f['local_face_fixes']:
        j,m,v = face['vector'],face['mask'],face['normal']; assert len(v)==5
        upper = Q(0)
        for q,d in enumerate(dd):
            dot = v[0]+sum(v[i+1] for i in range(4) if q>>i&1)
            allowed=set(d['zero_forced'])|set(d['zero_free'])|{z for bucket in d['bins'] for z in bucket}
            upper += lam[q]*(dot if j in d['forced'] else max(0,dot) if j in allowed else 0)
        assert sum(Q(v[k])*b[720*k+j] for k in range(5)) == upper
        dot=v[0]+sum(v[i+1] for i in range(4) if m>>i&1); assert dot
        assert y[m][j] == Q(face['value']) == (lam[m] if dot>0 else 0)
    inherited = {}; complete_small_geometry=False; omitted_zero_geometry_rows=0
    for spec in f.get('rank_banks',[]):
        bank,receipt=read(ROOT/spec['bank']),read(ROOT/spec['receipt'])
        assert sha(ROOT/spec['bank'])==spec['bank_sha256']==receipt['bank_sha256']
        assert sha(ROOT/spec['receipt'])==spec['receipt_sha256']
        names={'PASS_EXACT_CONTRACTED_PATTERN_RANK_CUTS':'two_basis_structure_verify_rank_screen.py',
               'PASS_EXACT_PATTERN_CONTRACTED_RANK_ROWS':['verify_two_basis_rank_allocation.py',Path(__file__).name],
               'PASS_COMPLETE_CONTRACTED_RANK_LE_3_GEOMETRY':'two_basis_structure_verify_small_geometry.py',
               'PASS_EXACT_PHYSICAL_CONDITIONAL_RANK_ROWS':'two_basis_structure_verify_physical_rank_bank.py',
               'PASS_EXACT_PHYSICAL_CONDITIONAL_CLOSED_RANK_ROWS':'two_basis_structure_verify_physical_closed_rank_bank.py'}
        assert receipt['status'] in names
        allowed=names[receipt['status']]; allowed=[allowed] if isinstance(allowed,str) else allowed
        assert receipt['consumer_sha256'] in [sha(ROOT/name) for name in allowed]
        assert all(sha(ROOT/p)==h for p,h in bank['source_hashes'].items())
        assert bank['X_anchors']==f['X_anchors'] and bank['Z_anchors']==f['Z_anchors'] and bank['side']==f['side']
        if receipt['status']=='PASS_COMPLETE_CONTRACTED_RANK_LE_3_GEOMETRY':
            assert bank['status']=='EXACT_CONTRACTED_RANK3_GEOMETRY_REQUIRES_REPLAY' and receipt['patterns_checked']==16
            complete_small_geometry=True
            for row in bank['rows']:
                if not lam[row['mask']]: omitted_zero_geometry_rows+=1
                else: inherited[key(row)] = normalized(row)
        else:
            for row in bank['cuts']: inherited[key(row)] = normalized(row)
    rows=f.get('rank_rows',[])
    if complete_small_geometry:
        assert f['zero_mass_geometry_rows_omitted']==omitted_zero_geometry_rows
    assert len(rows)==len({key(row) for row in rows}) and {key(row) for row in rows}==set(inherited)
    slacks=[]
    for row in rows:
        m,A,r=geometry(row,U,dd); slack=r*lam[m]-sum(y[m][j] for j in A)
        assert slack>=0; slacks.append(slack)
    if 'minimum_exact_rank_slack' in c and slacks: assert Q(c['minimum_exact_rank_slack'])==min(slacks)
    assert c.get('exact_rank_failures',[])==[] and c.get('prior_rank_row_count',len(rows))==len(rows)
    # Rejection tests exercise geometry and a bound independently of discovery.
    rejected=[]
    if rows:
        for label,field,value in [('rank','contraction_rank',rows[0]['contraction_rank']+1),('index','indices',[-1])]:
            bad=copy.deepcopy(rows[0]);bad[field]=value
            try: geometry(bad,U,dd)
            except AssertionError: rejected.append(label)
            else: raise AssertionError('corrupt rank geometry accepted')
    return dict(status=RANK_STATUS,certificate_sha256=sha(a.certificate),frozen_sha256=sha(fp),
        point_sha256=sha(a.point),checks=checks,anchor_moment_equalities=11,
        exact_local_face_fixes_checked=len(f['local_face_fixes']),rank_rows_checked=len(rows),listed_rank_rows_count=len(rows),
        all_subset_rank_membership_proved=False,all_contracted_rank_le_three_rows_proved=complete_small_geometry,
        minimum_exact_rank_slack=str(min(slacks)) if slacks else None,corruptions_rejected=rejected,
        full_zero_matroid_membership_proved=False,source_frame_proved=False)
def bank(a):
    c,f,fp,U,dd,lam,y=data(a.certificate);receipt=receipt_guard(a.receipt,a.certificate)
    b=read(a.bank);assert b['status']=='EXACT_PATTERN_RANK_VIOLATIONS_REQUIRE_REPLAY'
    assert b['certificate_sha256']==sha(a.certificate) and b['receipt_sha256']==sha(a.receipt)
    assert b['point_sha256']==f['point_sha256']==receipt['point_sha256']
    assert b['side']==f['side'] and b['X_anchors']==f['X_anchors'] and b['Z_anchors']==f['Z_anchors']
    assert b['frozen_sha256']==sha(a.bank.with_suffix('.frozen.json'))
    assert all(sha(ROOT/p)==h for p,h in b['source_hashes'].items())
    assert b['producer_sha256'] in [sha(ROOT/n) for n in ['screen_two_basis_allocation_ranks.py','screen_two_basis_rank_allocation.py']]
    gaps=[]
    for row in b['cuts']:
        m,A,r=geometry(row,U,dd);assert lam[m]>0
        left=sum(y[m][j] for j in A);bound=r*lam[m];gap=left-bound
        assert row['physical_span_rank']==r+len(dd[m]['zero_forced'])
        assert gap>0 and [Q(row[k]) for k in ['lambda_mass','exact_lhs','exact_bound','exact_violation']]==[lam[m],left,bound,gap]
        gaps.append(gap)
    assert gaps
    return dict(status='PASS_EXACT_PATTERN_CONTRACTED_RANK_ROWS',bank_sha256=sha(a.bank),
        certificate_sha256=sha(a.certificate),allocation_receipt_sha256=sha(a.receipt),point_sha256=f['point_sha256'],
        cuts_checked=len(gaps),violating_patterns=sorted({row['mask'] for row in b['cuts']}),
        minimum_exact_gap=str(min(gaps)),maximum_exact_gap=str(max(gaps)),
        full_zero_matroid_membership_proved=False,global_target_nonmembership_proved=False)
def main():
    ap=argparse.ArgumentParser();ap.add_argument('mode',choices=['allocation','bank'])
    ap.add_argument('--certificate',type=Path,required=True);ap.add_argument('--point',type=Path)
    ap.add_argument('--bank',type=Path);ap.add_argument('--receipt',type=Path);ap.add_argument('--output',type=Path,required=True)
    a=ap.parse_args();assert not a.output.exists();t=time.monotonic()
    if a.mode=='allocation': assert a.point; out=allocation(a)
    else: assert a.bank and a.receipt; out=bank(a)
    out.update(consumer_sha256=sha(__file__),source_C16_answered=False,
        dependencies={p:sha(ROOT/p) for p in ['verify_two_sided_full_basis_oracle.py','verify_two_basis_direct_allocation.py','physical-pool-source.json','pools/xcoords.txt','pools/zcoords.txt']},
        elapsed_seconds=time.monotonic()-t)
    a.output.write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(out),flush=True)
if __name__=='__main__':main()
