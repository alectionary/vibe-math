"""Single authorized exact LP run with frozen inputs and external limits."""
import argparse,hashlib,json,os,pathlib,re,signal,subprocess,time
ROOT=pathlib.Path(__file__).resolve().parent
def sha(path):return hashlib.sha256(pathlib.Path(path).read_bytes()).hexdigest()
def read(path):return json.loads(pathlib.Path(path).read_text())
def main():
    ap=argparse.ArgumentParser();ap.add_argument('--manifest',type=pathlib.Path,required=True);ap.add_argument('--output-prefix',type=pathlib.Path,required=True);a=ap.parse_args()
    assert os.getpriority(os.PRIO_PROCESS,0)==19
    os.environ.update(OPENBLAS_NUM_THREADS='1',OMP_NUM_THREADS='1',MKL_NUM_THREADS='1',VECLIB_MAXIMUM_THREADS='1')
    setup=ROOT/'two-basis-results/soplex-setup/setup-ready.json';sr=read(setup)
    assert sr['status']=='PASS_SOPLEX_SETUP_AND_SUPPLEMENTAL_EXACT_CONTROLS'
    tiny=ROOT/'two-basis-results/soplex-setup/tiny-independent.json'
    assert sha(tiny)==sr['tiny_receipt_sha256']
    assert read(tiny)['status']=='PASS_TINY_EXACT_SOPLEX_PRIMAL_FARKAS_CONTROLS'
    for p,h in sr['runtime_files'].items():assert sha(p)==h
    os.environ['DYLD_LIBRARY_PATH']=sr['environment']['DYLD_LIBRARY_PATH']
    m=read(a.manifest);assert m['status']=='PASS_EXACT_LP_FRACTION_TEXT_ROUNDTRIP'
    assert m['input_rows_are_original_semantic_rows_without_positive_integer_scaling']
    assert m['variable_count']==7943 and m['row_count']==35918
    for p,h in [(m['lp'],m['lp_sha256']),(m['semantic'],m['semantic_sha256']),(m['integer_manifest'],m['integer_manifest_sha256'])]:assert sha(ROOT/p)==h
    assert sha(ROOT/'export_joint_fixed_fraction_lp.py')==m['source_sha256']
    prefix=a.output_prefix.resolve();prefix.parent.mkdir(exist_ok=True)
    suffixes=['.frozen.json','.log','.json','.primal','.dual','.bas','.rss.jsonl']
    assert all(not pathlib.Path(str(prefix)+s).exists() for s in suffixes)
    command=[sr['binary'],'--readmode=1','--solvemode=2','--int:syncmode=1','--int:checkmode=2','-f0','-o0','-s0','-t120',f'-X={prefix}.primal',f'-Y={prefix}.dual',f'--writebas={prefix}.bas',str((ROOT/m['lp']).resolve())]
    frozen=dict(status='FROZEN_SINGLE_EXACT_SOPLEX_TRIAL',command=command,input_manifest=str(a.manifest),input_manifest_sha256=sha(a.manifest),input_lp_sha256=m['lp_sha256'],semantic_sha256=m['semantic_sha256'],setup_receipt_sha256=sha(setup),tiny_receipt_sha256=sha(tiny),runner_sha256=sha(__file__),runtime_files=sr['runtime_files'],environment={k:os.environ[k] for k in sr['environment']},internal_seconds=120,external_seconds=150,soft_rss_bytes=2*1024**3,priority=19,no_automatic_retry=True,scope='Exact feasibility of fixed-lambda listed-row allocation model; no artificial margin; not global target or source-frame feasibility')
    pathlib.Path(str(prefix)+'.frozen.json').write_text(json.dumps(frozen,indent=2)+'\n')
    start=time.monotonic();maximum_rss=0;stop=None;samples=0
    with open(str(prefix)+'.log','w') as log,open(str(prefix)+'.rss.jsonl','w') as rsslog:
        p=subprocess.Popen(command,stdout=log,stderr=subprocess.STDOUT,env=os.environ.copy(),start_new_session=True)
        assert os.getpriority(os.PRIO_PROCESS,p.pid)==19
        print('START',p.pid,'priority',os.getpriority(os.PRIO_PROCESS,p.pid),flush=True)
        while p.poll() is None:
            elapsed=time.monotonic()-start
            q=subprocess.run(['/bin/ps','-o','rss=','-p',str(p.pid)],capture_output=True,text=True,timeout=3)
            if q.stdout.strip():
                rss=int(q.stdout.strip())*1024;maximum_rss=max(maximum_rss,rss);samples+=1
                rsslog.write(json.dumps(dict(elapsed_seconds=elapsed,rss_bytes=rss))+'\n');rsslog.flush()
                if rss>2*1024**3:stop='SOFT_RSS_LIMIT'
            if elapsed>=150:stop='EXTERNAL_WALL_LIMIT'
            if stop:
                os.killpg(p.pid,signal.SIGTERM)
                try:p.wait(timeout=3)
                except subprocess.TimeoutExpired:os.killpg(p.pid,signal.SIGKILL);p.wait()
                break
            time.sleep(.5)
    elapsed=time.monotonic()-start
    text=pathlib.Path(str(prefix)+'.log').read_text()
    found=re.findall(r'^SoPlex status\s*:\s*(.+)$',text,re.M)
    status=found[-1] if found else None
    outputs={s:dict(path=str(prefix)+s,sha256=sha(str(prefix)+s),bytes=pathlib.Path(str(prefix)+s).stat().st_size) for s in ['.log','.primal','.dual','.bas','.rss.jsonl'] if pathlib.Path(str(prefix)+s).is_file()}
    out=dict(status='SOPLEX_CANDIDATE_REQUIRES_INDEPENDENT_SEMANTIC_REPLAY' if stop is None and status in ['problem is solved [optimal]','problem is solved [infeasible]'] else 'BOUNDED_SOPLEX_TRIAL_INCONCLUSIVE',reported_solver_status=status,exitcode=p.returncode,external_stop=stop,elapsed_seconds=elapsed,maximum_sampled_rss_bytes=maximum_rss,rss_samples=samples,frozen_sha256=sha(str(prefix)+'.frozen.json'),outputs=outputs,source_question_answered=False,independent_certificate_accepted=False)
    pathlib.Path(str(prefix)+'.json').write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(out,indent=2),flush=True)
if __name__=='__main__':main()
