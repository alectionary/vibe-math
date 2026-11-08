#!/usr/bin/env python3
"""At most20 exact archive/pricing rounds or600seconds for one frozen anchor."""
import os
assert os.getpriority(os.PRIO_PROCESS,0)==19
for k in ('OPENBLAS_NUM_THREADS','OMP_NUM_THREADS','MKL_NUM_THREADS','VECLIB_MAXIMUM_THREADS','NUMEXPR_NUM_THREADS','BLIS_NUM_THREADS'):os.environ[k]='1'
os.environ['PYTHONDONTWRITEBYTECODE']='1'
from pathlib import Path
from fractions import Fraction as Q
import argparse,gzip,hashlib,json,subprocess,sys,time
import psutil
from verify_algebraic_model import physical
from verify_full_partner_projection import point_data
from verify_singleton_exchange_terminal import rank

ROOT=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def read(p):
    p=Path(p);return json.loads(gzip.decompress(p.read_bytes()) if p.suffix=='.gz' else p.read_bytes())
def write(p,d):
    p=Path(p);assert not p.exists();raw=(json.dumps(d,indent=2)+'\n').encode();p.write_bytes(gzip.compress(raw,mtime=0) if p.suffix=='.gz' else raw)
def run(args,log,seconds):
    assert seconds>0 and not Path(log).exists();t=time.monotonic()
    with open(log,'w') as stream:
        p=subprocess.Popen([sys.executable,'-B',*map(str,args)],cwd=ROOT,env=os.environ,stdout=stream,stderr=subprocess.STDOUT)
        assert psutil.Process(p.pid).nice()==19
        try:code=p.wait(timeout=seconds)
        except subprocess.TimeoutExpired:
            for child in reversed(psutil.Process(p.pid).children(recursive=True)):
                try:child.kill()
                except psutil.NoSuchProcess:pass
            p.kill();p.wait();code='EXTERNAL_STAGE_CAP'
    assert code==0,(args[0],code,log)
    return dict(source=str(args[0]),seconds=time.monotonic()-t,log=str(log),log_sha256=sha(log))
def greedy(E,Z,q,forced=None,excluded=None):
    rows={};B=[]
    order=([forced] if forced is not None else [])+[j for j in sorted(E,key=lambda j:(-q[j],j)) if j!=forced and j!=excluded]
    for j in order:
        value=Z[j]
        while value:
            bit=value.bit_length()-1
            if bit in rows:value^=rows[bit]
            else:rows[bit]=value;B.append(j);break
    return sorted(B)
def accept_cut(cut,Z,q,p,point,owner,prefix,sources):
    J=cut['indices'];r=cut['bound'];assert rank(Z[j] for j in J)==r and sum(q[j] for j in J)>r
    rows={}
    for j in J:
        v=Z[j]
        while v:
            k=v.bit_length()-1
            if k in rows:v^=rows[k]
            else:rows[k]=v;break
    closure=[]
    for j in range(720):
        v=Z[j]
        for k in sorted(rows,reverse=True):
            if v>>k&1:v^=rows[k]
        if not v:closure.append(j)
    assert rank(Z[j] for j in closure)==r
    gap=p*(sum(q[j] for j in closure)-r);assert gap>0
    closed=dict(cut,indices=closure,exact_violation=str(gap),span_closed=True,physical_pool_span_closure=True)
    bank=str(prefix)+'-global-rank-bank.json';receipt=str(prefix)+'-global-rank-bank-independent.json'
    write(bank,dict(status='CANDIDATE_RANK_CUTS',cuts=[closed],source_hashes=sources,point_sha256=sha(point),source_C16_answered=False))
    run(['verify_weighted_matroid_cuts.py','--certificate',bank,'--output',receipt],str(prefix)+'-global-rank-bank-independent.log',20)
    from conditional_matroid_moment_matrix import matrix
    M,terms=matrix([Path(bank)],[Path(receipt)]);assert M.shape==(1,36495)
    value=sum((Q(coef)*owner[j] for j,coef in terms[0]),Q(0));assert value==gap
    compiled=str(prefix)+'-global-rank-row.json';write(compiled,dict(bank=bank,bank_sha256=sha(bank),receipt=receipt,receipt_sha256=sha(receipt),terms=terms[0],rhs=0,exact_violation=str(gap),point_sha256=sha(point)))
    return dict(bank=bank,bank_sha256=sha(bank),receipt=receipt,receipt_sha256=sha(receipt),compiled=compiled,exact_violation=str(gap))

def main():
    ap=argparse.ArgumentParser();ap.add_argument('--initial-manifest',type=Path,required=True);ap.add_argument('--initial-receipt',type=Path,required=True);ap.add_argument('--prefix',type=Path,required=True);a=ap.parse_args();start=time.monotonic();deadline=start+600
    m=read(a.initial_manifest);ir=read(a.initial_receipt);assert ir['manifest_sha256']==sha(a.initial_manifest) and ir['status']=='PASS_EXACT_SINGLETON_ARCHIVE_LP_TEXT_AND_PHYSICAL_COLUMNS'
    assert ir['consumer_sha256']==sha(ROOT/'verify_singleton_archive_lp.py') and m['status']=='EXACT_SINGLETON_ARCHIVE_LP_REQUIRES_TEXT_REPLAY'
    s=read(m['semantic']);assert sha(m['semantic'])==m['semantic_sha256'];assert s['anchor_orbit']==40 and s['point_sha256']=='4945dd10a5ec76c54311466ab0594b0c7b8fc2071eab4ae9a783a87143baad8f'
    X,Z,_=physical();owner,target=point_data(s['point'],40);p=owner[40];q=[v/(16*p) for v in target[55:]];E=s['physical_zero_ground_indices']
    B=[list(b) for b in s['physical_bases']];initial_count=len(B);assert initial_count==3067
    covered=set(j for b in B for j in b);common=set(B[0]).intersection(*map(set,B[1:]))
    missing=[j for j in E if q[j]>0 and j not in covered];universal=[j for j in sorted(common) if q[j]<1]
    origins=[dict(kind='initial_archive',index=i) for i in range(len(B))];seen=set(map(tuple,B));seeds=[];seedcut=None
    for kind,indices in [('cover_positive',missing),('omit_nonunit_universal',universal)]:
        for j in indices:
            b=greedy(E,Z,q,forced=j if kind=='cover_positive' else None,excluded=j if kind=='omit_nonunit_universal' else None)
            assert rank(Z[t] for t in b)==len(b)
            if len(b)<127:
                assert kind=='omit_nonunit_universal';J=[t for t in E if t!=j]
                seedcut=dict(sector='T',anchor_orbit=40,mandatory_index=None,indices=J,bound=len(b));break
            assert (j in b)==(kind=='cover_positive')
            record=dict(kind=kind,index=j,basis=b,rank=127,target=str(q[j]))
            seeds.append(record)
            if tuple(b) not in seen:seen.add(tuple(b));B.append(b);origins.append(record)
        if seedcut:break
    paths=[Path(__file__),a.initial_manifest,a.initial_receipt,Path(m['semantic']),
           *[ROOT/n for n in ('export_singleton_archive_cg.py','verify_singleton_archive_cg.py','price_singleton_archive_cg.py','run_singleton_archive_cg_soplex.py','verify_singleton_exact_pricing.py')]]
    sources=dict(s['source_hashes']);sources.update({str(path.resolve().relative_to(ROOT)):sha(path) for path in paths})
    frozen=dict(status='FROZEN_BOUNDED_SINGLETON_EXACT_COLUMN_GATE',source_hashes=sources,initial_manifest_sha256=sha(a.initial_manifest),
                point_sha256=s['point_sha256'],anchor_orbit=40,maximum_rounds=20,total_seconds=600,solver_internal_seconds=60,solver_external_seconds=90,
                coverage_audit=dict(uncovered_positive=missing,universal_nonunit=universal),seed_columns=seeds,initial_columns=initial_count,seeded_columns=len(B),nice=19,threads=1)
    fp=str(a.prefix)+'.frozen.json';write(fp,frozen);records=[];stop=None;result=None
    if seedcut:result=accept_cut(seedcut,Z,q,p,s['point'],owner,a.prefix,sources);stop='EXACT_GLOBAL_RANK_CUT'
    for iteration in range(1,21):
        if stop:break
        if deadline-time.monotonic()<120:stop='TOTAL_TIME_RESERVE';break
        assert all(sha(ROOT/name)==h for name,h in sources.items())
        stem=str(a.prefix)+f'-r{iteration:02d}';column_bank=stem+'-columns.json.gz'
        write(column_bank,dict(status='FROZEN_SINGLETON_COLUMN_ARCHIVE',initial_endpoint_sha256=s['endpoint_sha256'],initial_receipt_sha256=s['endpoint_receipt_sha256'],physical_bases=B,column_origins=origins,gate_frozen=fp,gate_frozen_sha256=sha(fp)))
        r=dict(iteration=iteration,columns=len(B),column_bank=column_bank,column_bank_sha256=sha(column_bank),stages=[])
        r['stages'].append(run(['export_singleton_archive_cg.py','--endpoint',s['endpoint'],'--receipt',s['endpoint_receipt'],'--columns',column_bank,'--prefix',stem],stem+'-export.log',20))
        r['stages'].append(run(['verify_singleton_archive_cg.py','--manifest',stem+'.json','--output',stem+'-independent.json'],stem+'-independent.log',20))
        r['stages'].append(run(['run_singleton_archive_cg_soplex.py','--manifest',stem+'.json','--receipt',stem+'-independent.json','--output-prefix',stem+'-solve'],stem+'-solve-supervisor.log',min(100,deadline-time.monotonic())))
        solve=read(stem+'-solve.json');r['solver_report']=stem+'-solve.json';r['solver_status']=solve['reported_solver_status']
        if solve['external_stop'] is not None or solve['returncode']!=0:stop='BOUNDED_SOLVER_RESULT'
        elif r['solver_status']=='problem is solved [optimal]':
            receipt=stem+'-membership-independent.json'
            r['stages'].append(run(['verify_singleton_archive_cg.py','--manifest',stem+'.json','--solver-frozen',stem+'-solve.frozen.json','--primal',stem+'-solve.primal','--output',receipt],stem+'-membership-independent.log',20))
            rr=read(receipt);assert rr['status']=='PASS_EXACT_GLOBAL_SINGLETON_ARCHIVE_BASIS_MEMBERSHIP';result=dict(receipt=receipt,receipt_sha256=sha(receipt),positive_basis_count=rr['positive_basis_count']);stop='EXACT_GLOBAL_SINGLETON_MEMBERSHIP'
        elif r['solver_status']=='problem is solved [infeasible]':
            dual=stem+'-farkas-independent.json';pricing=stem+'-pricing.json';pricing_receipt=stem+'-pricing-independent.json'
            r['stages'].append(run(['verify_singleton_archive_cg.py','--manifest',stem+'.json','--solver-frozen',stem+'-solve.frozen.json','--farkas',stem+'-solve.dual','--output',dual],stem+'-farkas-independent.log',20))
            r['stages'].append(run(['price_singleton_archive_cg.py','--manifest',stem+'.json','--farkas-receipt',dual,'--output',pricing],stem+'-pricing.log',20))
            r['stages'].append(run(['verify_singleton_exact_pricing.py','--pricing',pricing,'--output',pricing_receipt],stem+'-pricing-independent.log',20))
            pr=read(pricing_receipt);assert pr['status']=='PASS_EXACT_SINGLETON_PHYSICAL_BASIS_PRICING' and pr['pricing_sha256']==sha(pricing) and pr['consumer_sha256']==sha(ROOT/'verify_singleton_exact_pricing.py')
            d=read(pricing);r.update(pricing=pricing,pricing_sha256=sha(pricing),pricing_receipt=pricing_receipt,pricing_receipt_sha256=sha(pricing_receipt),minimum_affine_value=d['minimum_affine_value'])
            if d['global_rank_cut_candidate'] is not None:
                result=accept_cut(d['global_rank_cut_candidate'],Z,q,p,s['point'],owner,a.prefix,sources);stop='EXACT_GLOBAL_RANK_CUT'
            else:
                assert d['missing_archive_column'] and Q(d['minimum_affine_value'])<0
                b=d['minimizing_physical_basis'];assert tuple(b) not in seen and set(b)<=set(E) and len(b)==rank(Z[j] for j in b)==127
                seen.add(tuple(b));B.append(b);origins.append(dict(kind='exact_farkas_pricing',pricing=pricing,pricing_sha256=sha(pricing),receipt=pricing_receipt,receipt_sha256=sha(pricing_receipt)))
        else:stop='BOUNDED_SOLVER_RESULT'
        records.append(r)
        with open(str(a.prefix)+'.progress.jsonl','a') as stream:stream.write(json.dumps(r)+'\n')
        print(json.dumps(dict(iteration=iteration,columns=r['columns'],solver_status=r['solver_status'],stop=stop)),flush=True)
    if stop is None:stop='MAXIMUM_20_ROUNDS'
    out=dict(status='BOUNDED_EXACT_SINGLETON_COLUMN_GATE_FINISHED',stop_reason=stop,result=result,records=records,
             frozen_sha256=sha(fp),elapsed_seconds=time.monotonic()-start,point_sha256=s['point_sha256'],anchor_orbit=40,
             initial_columns=initial_count,final_columns=len(B),source_C16_answered=False,no_broad_anchor_cohort=True)
    assert all(sha(ROOT/name)==h for name,h in sources.items());write(str(a.prefix)+'.json',out);print(json.dumps({k:v for k,v in out.items() if k!='records'}),flush=True)
if __name__=='__main__':main()
