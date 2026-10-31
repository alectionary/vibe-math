"""Frozen20-minute point12 singleton conditional all-rank refresh."""
from pathlib import Path
from fractions import Fraction
import hashlib,json,os,subprocess,sys,time
ROOT=Path(__file__).resolve().parent
R=ROOT/'coupling-results'
POINT=R/'anchor-witness12-rational.json.gz'
EXPECTED='7230467da979f8c16cc1074cde3776c7d202af3025331ab436b16270fde4ebb4'
ORDER=[17,40]+list(range(15))+[i for i in range(45) if i not in {17,40,*range(15)}]
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def main():
    start=time.monotonic();output=R/'singleton-rank-refresh-witness12.json';fp=R/'singleton-rank-refresh-witness12.frozen.json';assert not output.exists() and not fp.exists() and sha(POINT)==EXPECTED
    scripts=['full-partner-singleton-wolfe-generic.py','full-partner-singleton-exact-wolfe-generic.py','full-partner-singleton-independent-generic.py'];sources=[R/s for s in scripts]+[Path(__file__),ROOT/'verify_weighted_matroid_cuts.py',ROOT/'verify_full_partner_projection.py',ROOT/'physical-pool-source.json',ROOT/'pools/xcoords.txt',ROOT/'pools/zcoords.txt'];hashes={str(p.relative_to(ROOT)):sha(p) for p in sources}
    gate=json.loads((R/'anchor-witness12-checks-summary.json').read_text());assert gate['status']=='PASS_LISTED_RELAXATION'
    frozen={'status':'FROZEN_45_SINGLETON_PRESENT_CONDITIONAL_RANK_REFRESH','source_C16_answered':False,'point_sha256':sha(POINT),'accepted_point_summary_sha256':sha(R/'anchor-witness12-checks-summary.json'),'source_hashes':hashes,'anchor_order':ORDER,'outer_seconds':1170,'numeric_seconds_per_anchor':12,'exact_seconds_per_anchor':8,'numeric_outer_timeout':18,'exact_outer_timeout':16,'column_cap':2000,'scope':'Present-conditioned cross-sectorT rank laws only, freshatpoint12. Noabsentconditioning, S-rank, jointprofile orsourcecompletionclaim.'};fp.write_text(json.dumps(frozen,indent=2)+'\n');summary={**frozen,'frozen_sha256':sha(fp),'status':'RUNNING','records':[]};env=dict(os.environ,PYTHONDONTWRITEBYTECODE='1',OPENBLAS_NUM_THREADS='1',OMP_NUM_THREADS='1',VECLIB_MAXIMUM_THREADS='1',MKL_NUM_THREADS='1')
    def run(script,args,log,timeout):
        before=time.monotonic()
        with log.open('w') as f:
            try:rc=subprocess.run([sys.executable,'-B',str(script),*map(str,args)],cwd=ROOT,env=env,stdout=f,stderr=subprocess.STDOUT,timeout=max(1,min(timeout,1170-(time.monotonic()-start)))).returncode
            except subprocess.TimeoutExpired:rc='OUTER_TIMEOUT'
        return rc,time.monotonic()-before
    def save(record):
        summary['records'].append(record);summary['elapsed_seconds']=time.monotonic()-start;output.write_text(json.dumps(summary,indent=2)+'\n');print(json.dumps(record),flush=True)
    for orbit in ORDER:
        if 1170-(time.monotonic()-start)<3:break
        stem=R/f'singleton-rank-refresh-witness12-o{orbit:02d}';numeric=Path(str(stem)+'-numeric.json');rc,elapsed=run(R/scripts[0],['--point',POINT,'--orbit',orbit,'--output',numeric,'--seconds',12,'--column-cap',2000],Path(str(stem)+'-numeric.log'),18);record={'anchor_orbit':orbit,'numeric_returncode':rc,'numeric_wall_seconds':elapsed}
        if rc!=0:record['status']='NUMERIC_STAGE_INCONCLUSIVE_OR_FAILED';save(record);continue
        n=json.loads(numeric.read_text());record.update(numeric_status=n['status'],numeric_path=str(numeric.relative_to(ROOT)),numeric_sha256=sha(numeric));candidate=numeric
        if n['status']=='BOUNDED_INCONCLUSIVE':
            if 1170-(time.monotonic()-start)<3:record['status']='OUTER_TIME_LIMIT_BEFORE_EXACT';save(record);break
            exact=Path(str(stem)+'-exact.json');rc,elapsed=run(R/scripts[1],['--point',POINT,'--orbit',orbit,'--seed',numeric,'--output',exact,'--seconds',8],Path(str(stem)+'-exact.log'),16);record.update(exact_returncode=rc,exact_wall_seconds=elapsed)
            if rc!=0:record['status']='EXACT_STAGE_INCONCLUSIVE_OR_FAILED';save(record);continue
            n=json.loads(exact.read_text());candidate=exact
        record.update(candidate_status=n['status'],candidate_path=str(candidate.relative_to(ROOT)),candidate_sha256=sha(candidate))
        if n['status']=='BOUNDED_INCONCLUSIVE':record['status']='BOUNDED_INCONCLUSIVE';save(record);continue
        receipt=Path(str(stem)+'-independent.json');rc,elapsed=run(R/scripts[2],['--certificate',candidate,'--point',POINT,'--output',receipt,'--negative-controls'],Path(str(stem)+'-independent.log'),15);record.update(independent_returncode=rc,independent_wall_seconds=elapsed)
        if rc!=0:record['status']='INDEPENDENT_REPLAY_FAILED';save(record);continue
        accepted=json.loads(receipt.read_text());record.update(status=accepted['status'],independent_path=str(receipt.relative_to(ROOT)),independent_sha256=sha(receipt))
        if 'approximate_lattice_scaled_error' in accepted:record['lattice_scaled_error']=accepted['approximate_lattice_scaled_error']
        if accepted['status']=='PASS_EXACT_CONDITIONAL_RANK_CUT':
            from weighted_matroid_separator import insert
            from verify_full_partner_projection import point_data
            Z=[int(v,16) for v in (ROOT/'pools/zcoords.txt').read_text().split()];old=accepted['cut'];piv={}
            for j in old['indices']:insert(piv,Z[j])
            def inside(v):
                while v:
                    bit=v.bit_length()-1
                    if bit not in piv:return False
                    v^=piv[bit]
                return True
            closed=[j for j in range(720) if inside(Z[j])];owner,target=point_data(POINT,orbit);gap=sum(target[55+j]/16 for j in closed)-len(piv)*owner[orbit];assert gap>0 and len(piv)==old['bound'];cut={**old,'indices':closed,'exact_violation':str(gap),'prefix_cardinality':len(old['indices']),'span_closed':True,'physical_pool_span_closure':True};bank={'status':'CANDIDATE_RANK_CUTS','source_C16_answered':False,'point_sha256':sha(POINT),'source_hashes':hashes,'source_candidate_sha256':sha(candidate),'source_independent_sha256':sha(receipt),'cuts':[cut],'scope':'Freshpoint12 strictconditionalT rankviolation, closedunderphysicalZspan. Boundrequiresindependentoldrankconsumer.'};bp=Path(str(stem)+'-closed-rank-bank.json');bp.write_text(json.dumps(bank,indent=2)+'\n');br=Path(str(stem)+'-closed-rank-bank-independent.json');rc,_=run(ROOT/'verify_weighted_matroid_cuts.py',['--certificate',bp,'--output',br],Path(str(stem)+'-closed-rank-bank-independent.log'),15);record.update(closed_rank_bank=str(bp.relative_to(ROOT)),closed_rank_bank_sha256=sha(bp),closed_rank_exact_violation=str(gap),closed_rank_cardinality=len(closed),closed_rank_bound=len(piv),closed_rank_replay_returncode=rc)
            if rc==0:record.update(closed_rank_replay=str(br.relative_to(ROOT)),closed_rank_replay_sha256=sha(br))
        save(record)
    passes={'PASS_ALL_SINGLETON_CONDITIONAL_Z_RANK_INEQUALITIES','PASS_EXACT_SINGLETON_CONDITIONAL_MATROID_MEMBERSHIP'};summary.update(status='BOUNDED_SINGLETON_REFRESH_COMPLETE',queried_anchors=len(summary['records']),anchors_all_rank_certified=[r['anchor_orbit'] for r in summary['records'] if r['status'] in passes],anchors_with_verified_rank_cut=[r['anchor_orbit'] for r in summary['records'] if r['status']=='PASS_EXACT_CONDITIONAL_RANK_CUT'],unqueried_anchors=[i for i in ORDER if i not in {r['anchor_orbit'] for r in summary['records']}],inconclusive_anchors=[r['anchor_orbit'] for r in summary['records'] if r['status'] not in passes|{'PASS_EXACT_CONDITIONAL_RANK_CUT'}],elapsed_seconds=time.monotonic()-start);assert all(sha(ROOT/p)==v for p,v in hashes.items());output.write_text(json.dumps(summary,indent=2)+'\n');print(json.dumps({k:v for k,v in summary.items() if k not in ('records','source_hashes')}),flush=True)
if __name__=='__main__':main()
