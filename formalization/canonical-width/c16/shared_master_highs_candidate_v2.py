#!/usr/bin/env python3
"""One same-model floating candidate extraction; no optimizer status is proof."""
import os
assert os.getpriority(os.PRIO_PROCESS,0)==19
THREADS=('OPENBLAS_NUM_THREADS','OMP_NUM_THREADS','MKL_NUM_THREADS','VECLIB_MAXIMUM_THREADS','NUMEXPR_NUM_THREADS','BLIS_NUM_THREADS')
assert all(os.environ.get(k)=='1' for k in THREADS)
from pathlib import Path
from fractions import Fraction as Q
import argparse,datetime,gzip,hashlib,importlib.metadata,json,math,signal,subprocess,sys,time
import numpy as np
import highspy
import psutil
from verify_shared_master_common import resolve,read,sha,expected_rows,numeric,objective
from verify_shared_master_preparation import context
ROOT=Path(__file__).resolve().parent
DEADLINE=datetime.datetime(2026,10,30,22,56,tzinfo=datetime.timezone.utc).timestamp()
def write(p,obj):
    p=resolve(p);assert not p.exists();p.parent.mkdir(parents=True,exist_ok=True)
    data=(json.dumps(obj,separators=(',',':'),allow_nan=False)+'\n').encode()
    p.write_bytes(gzip.compress(data,mtime=0) if p.suffix=='.gz' else data)
def make_lp(arr,names):
    lp=highspy.HighsLp();lp.num_col_=len(arr['col_cost']);lp.num_row_=len(arr['row_lower'])
    lp.col_cost_=arr['col_cost'];lp.col_lower_=arr['col_lower'];lp.col_upper_=arr['col_upper']
    lp.row_lower_=arr['row_lower'];lp.row_upper_=arr['row_upper']
    lp.col_names_=names['variable_names'];lp.row_names_=names['row_names']
    lp.a_matrix_.format_=highspy.MatrixFormat.kRowwise
    lp.a_matrix_.start_=arr['row_start'];lp.a_matrix_.index_=arr['indices'];lp.a_matrix_.value_=arr['values']
    return lp
def highs(lp,seconds,seed,log=None):
    h=highspy.Highs()
    options=dict(threads=1,parallel='off',solver='simplex',simplex_strategy=4,presolve='on',time_limit=float(seconds))
    if log is None:options['output_flag']=False
    else:options['log_file']=str(resolve(log))
    for k,v in options.items():assert h.setOptionValue(k,v)==highspy.HighsStatus.kOk,(k,v)
    assert h.passModel(lp)==highspy.HighsStatus.kOk
    warm=h.setSolution(len(seed),np.arange(len(seed),dtype=np.int32),np.asarray(seed,dtype=np.float64))
    assert warm==highspy.HighsStatus.kOk,warm
    return h,options
def tiny():
    names=dict(variable_names=['x'+str(i) for i in range(4)],row_names=['parent','mass','link','n1','n2','n3'])
    arr=dict(col_cost=np.array([0.,0.,1.,1.]),col_lower=np.full(4,-np.inf),col_upper=np.full(4,np.inf),
        row_lower=np.array([.5,1.,0.,-np.inf,-np.inf,-np.inf]),row_upper=np.array([.5,1.,0.,0.,0.,0.]),
        row_start=np.array([0,1,2,6,7,8,9],dtype=np.int64),indices=np.array([0,1,0,1,2,3,1,2,3],dtype=np.int32),
        values=np.array([1.,1.,-1.,1.,1.,-1.,-1.,-1.,-1.]))
    h,opt=highs(make_lp(arr,names),5,[.5,1.,0.,.5]);h.run();s=h.getSolution()
    assert s.value_valid and s.dual_valid
    x=list(map(lambda v:Q.from_float(float(v)),s.col_value));pi=list(map(lambda v:Q.from_float(float(v)),s.row_dual))
    assert x==[Q(1,2),1,0,Q(1,2)] and all(v<=0 for v in pi[3:])
    station=[Q(0)]*4
    for i in range(6):
        for k in range(arr['row_start'][i],arr['row_start'][i+1]):station[arr['indices'][k]]+=Q.from_float(float(arr['values'][k]))*pi[i]
    assert station==[0,0,1,1] and pi[0]/2+pi[1]==Q(1,2)
    return dict(status='PASS_NUMERIC_API_TINY_EXACT_BINARY_PRIMAL_DUAL_REQUIRES_REVIEW',
        primal=list(map(str,x)),dual=list(map(str,pi)),objective='1/2',setSolution_accepted=True,
        all_original_stationarity=True,highs_version=h.version(),options=opt)
def prepare(a):
    start=time.monotonic();prefix=a.prefix
    tiny_result=tiny();write(prefix+'.tiny.json',tiny_result)
    data,L,semantic=context(a.master_manifest,a.preparation_receipt,check_columns=False)
    d=data['manifest'];N=L['variable_count'];f=data['f'];starts=[0];indices=[];values=[];lower=[];upper=[];row_names=[]
    for name,e,rel in expected_rows(data,L):
        c,b=numeric(e,f);row_names.append(name);b=float(b);assert math.isfinite(b)
        lower.append(b if rel=='=' else -np.inf);upper.append(b)
        for j,q in sorted(c.items()):
            v=float(q);assert math.isfinite(v);indices.append(j);values.append(v)
        starts.append(len(indices))
    assert len(row_names)==d['row_count'] and len(set(row_names))==len(row_names) and len(indices)==d['nonzeros']
    cost=np.zeros(N);cost[L['plus_start']:]=1.
    arrays=dict(row_start=np.array(starts,dtype=np.int64),indices=np.array(indices,dtype=np.int32),values=np.array(values,dtype=np.float64),
        row_lower=np.array(lower),row_upper=np.array(upper),col_lower=np.full(N,-np.inf),col_upper=np.full(N,np.inf),
        col_cost=cost,seed=np.array([float(Q(v)) for v in data['seed']['exact_parameters']]))
    packet=prefix+'.npz';names=prefix+'.rows.json.gz';assert not resolve(packet).exists()
    np.savez_compressed(resolve(packet),**arrays);write(names,dict(row_names=row_names,variable_names=['x'+str(j) for j in range(N)]))
    sources={p:sha(p) for p in ['shared_master_highs_candidate.py','verify_shared_master_common.py','verify_shared_master_preparation.py']}
    manifest=dict(status='FROZEN_SHARED_MASTER_FLOAT_VIEW_REQUIRES_REPLAY',master_manifest=a.master_manifest,
        master_manifest_sha256=sha(a.master_manifest),preparation_receipt=a.preparation_receipt,preparation_receipt_sha256=sha(a.preparation_receipt),
        lp=d['lp'],lp_sha256=d['lp_sha256'],semantic_sha256=d['semantic_sha256'],point_sha256=d['point_sha256'],
        packet=packet,packet_sha256=sha(packet),names=names,names_sha256=sha(names),
        seed=d['seed'],seed_sha256=d['seed_sha256'],tiny=prefix+'.tiny.json',tiny_sha256=sha(prefix+'.tiny.json'),
        variable_count=N,row_count=len(row_names),nonzeros=len(indices),source_hashes=sources,
        conversion='Each finite coefficient/RHS/objective/seed is float(Fraction(exact)); +/-inf only for bounds. All original rows/free columns retained.',
        versions={p:importlib.metadata.version(p) for p in ['highspy','numpy','scipy']},
        nice=19,threads=1,elapsed_seconds=time.monotonic()-start,optimization_result_claimed=False)
    write(prefix+'.json',manifest);print(json.dumps({k:v for k,v in manifest.items() if k!='source_hashes'}),flush=True)
def worker(a):
    m=read(a.view_manifest);r=read(a.view_receipt)
    assert r['status']=='PASS_EXACT_TO_FLOAT_SHARED_MASTER_VIEW'
    assert r['manifest_sha256']==sha(a.view_manifest) and r['consumer_sha256']==sha('verify_shared_master_numeric_view_v2.py')
    for k in ('packet','names'):assert sha(m[k])==m[k+'_sha256']
    assert sha(m['master_manifest'])==m['master_manifest_sha256'] and all(sha(p)==h for p,h in m['source_hashes'].items())
    names=read(m['names']);arr=np.load(resolve(m['packet']));lp=make_lp(arr,names)
    seconds=min(300.,max(1.,DEADLINE-time.time()-8.))
    h,options=highs(lp,seconds,arr['seed'],a.prefix+'.highs.log')
    start=time.monotonic();h.run();s=h.getSolution();info=h.getInfo()
    finite=lambda v:all(math.isfinite(float(x)) for x in v)
    valid=bool(s.dual_valid) and len(s.row_dual)==m['row_count'] and finite(s.row_dual)
    base=dict(status='NUMERICAL_SHARED_MASTER_ROW_DUAL_CANDIDATE' if valid else 'NO_VALID_NUMERIC_SHARED_MASTER_ROW_DUAL',
        manifest=m['master_manifest'],manifest_sha256=m['master_manifest_sha256'],lp_sha256=m['lp_sha256'],
        point_sha256=m['point_sha256'],rows=m['row_count'],variables=m['variable_count'],
        view_manifest=a.view_manifest,view_manifest_sha256=sha(a.view_manifest),view_receipt=a.view_receipt,view_receipt_sha256=sha(a.view_receipt),
        frozen=a.prefix+'.frozen.json',frozen_sha256=sha(a.prefix+'.frozen.json'),
        runner_sha256=sha(__file__),solver_version=h.version(),solver_model_status=str(h.getModelStatus()),
        value_valid=bool(s.value_valid),dual_valid=bool(s.dual_valid),options=options,seconds=time.monotonic()-start,
        row_dual=[[n,repr(float(v))] for n,v in zip(names['row_names'],s.row_dual)] if valid else [],
        col_value=[repr(float(v)) for v in s.col_value] if finite(s.col_value) else [],
        col_dual=[repr(float(v)) for v in s.col_dual] if finite(s.col_dual) else [],
        row_value=[repr(float(v)) for v in s.row_value] if finite(s.row_value) else [],
        objective_value_repr=repr(float(info.objective_function_value)),
        source_hashes=m['source_hashes'],exact_optimum_claimed=False,primal_feasibility_claimed=False,
        dual_feasibility_claimed=False,source_C16_answered=False,
        scope='Named finite numerical row weights only; exact residual/source/basis-pricing acceptance is mandatory.')
    write(a.prefix+'.candidate.json.gz',base);print(json.dumps({k:base[k] for k in ['status','value_valid','dual_valid','solver_model_status','seconds']}),flush=True)
def supervise(a):
    m=read(a.view_manifest);r=read(a.view_receipt)
    assert r['status']=='PASS_EXACT_TO_FLOAT_SHARED_MASTER_VIEW' and r['manifest_sha256']==sha(a.view_manifest)
    prefix=a.prefix;assert all(not resolve(prefix+s).exists() for s in ['.frozen.json','.run.json','.candidate.json.gz','.stdout.log','.rss.jsonl','.highs.log'])
    cap=min(360.,DEADLINE-time.time());assert cap>20.,'Insufficient time before fixed22:56UTC stop'
    command=[sys.executable,'-B',str(Path(__file__).resolve()),'worker','--view-manifest',a.view_manifest,
             '--view-receipt',a.view_receipt,'--prefix',prefix]
    frozen=dict(status='FROZEN_SINGLE_SAME_MASTER_HIGHS_CANDIDATE_DIAGNOSTIC',command=command,
        master_manifest=m['master_manifest'],master_manifest_sha256=m['master_manifest_sha256'],lp_sha256=m['lp_sha256'],
        manifest=m['master_manifest'],manifest_sha256=m['master_manifest_sha256'],
        preparation_receipt_sha256=m['preparation_receipt_sha256'],semantic_sha256=m['semantic_sha256'],
        zero_tau_pins=False,all_sixteen_patterns=True,
        view_manifest=a.view_manifest,view_manifest_sha256=sha(a.view_manifest),view_receipt=a.view_receipt,view_receipt_sha256=sha(a.view_receipt),
        source_hashes=m['source_hashes'],runner_sha256=sha(__file__),internal_seconds=min(300.,cap-8.),external_seconds=cap,
        internal_seconds_maximum=300,external_seconds_maximum=360,
        absolute_stop_UTC='2026-10-30T22:56:00Z',sampled_rss_limit_bytes=4*1024**3,nice=19,threads=1,
        solver='simplex',simplex_strategy=4,presolve='on',exact_seed_float_start=True,no_automatic_retry=True,
        no_exact_optimizer_claim=True)
    write(prefix+'.frozen.json',frozen);start=time.monotonic();peak=0;stop=None
    with resolve(prefix+'.stdout.log').open('w') as log,resolve(prefix+'.rss.jsonl').open('w') as rsslog:
        p=subprocess.Popen(command,cwd=ROOT,env=os.environ.copy(),stdout=log,stderr=subprocess.STDOUT,start_new_session=True)
        task=psutil.Process(p.pid);assert task.nice()==19
        while p.poll() is None:
            elapsed=time.monotonic()-start
            try:rss=task.memory_info().rss
            except psutil.NoSuchProcess:break
            peak=max(peak,rss);rsslog.write(json.dumps(dict(seconds=elapsed,rss_bytes=rss))+'\n');rsslog.flush()
            if rss>4*1024**3:stop='SAMPLED_RSS_LIMIT'
            if elapsed>=cap or time.time()>=DEADLINE:stop='EXTERNAL_WALL_LIMIT'
            if stop:
                os.killpg(p.pid,signal.SIGTERM)
                try:p.wait(timeout=2)
                except subprocess.TimeoutExpired:os.killpg(p.pid,signal.SIGKILL);p.wait()
                break
            time.sleep(.5)
        p.wait()
    result=dict(status='BOUNDED_HIGHS_DIAGNOSTIC_ENDED',returncode=p.returncode,external_stop=stop,
        seconds=time.monotonic()-start,maximum_sampled_rss_bytes=peak,peak_memory_claimed=False,
        outputs={s:dict(path=prefix+s,sha256=sha(prefix+s)) for s in ['.candidate.json.gz','.stdout.log','.highs.log','.rss.jsonl','.frozen.json'] if resolve(prefix+s).exists()},
        no_exact_optimum_claim=True,source_C16_answered=False)
    write(prefix+'.run.json',result);print(json.dumps(result),flush=True)
def main():
    ap=argparse.ArgumentParser();ap.add_argument('mode',choices=['prepare','worker','run'])
    ap.add_argument('--prefix',required=True);ap.add_argument('--master-manifest');ap.add_argument('--preparation-receipt')
    ap.add_argument('--view-manifest');ap.add_argument('--view-receipt');a=ap.parse_args()
    {'prepare':prepare,'worker':worker,'run':supervise}[a.mode](a)
if __name__=='__main__':main()
