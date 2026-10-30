import argparse,hashlib,json,time,math,concurrent.futures
from pathlib import Path
import numpy as np
import stim,pymatching
from circuits import bolza,planar

ROOT=Path(__file__).parent
def no_correction_exact(dem,k):
    chars=np.ones(1<<k)
    for ins in dem.flattened():
        if ins.type!='error':continue
        mask=0
        for t in ins.targets_copy():
            if t.is_logical_observable_id():mask^=1<<t.val
        if mask:
            p=ins.args_copy()[0]
            for a in range(1<<k):
                if (a&mask).bit_count()%2:chars[a]*=1-2*p
    return float(1-chars.mean())

def run(job):
    family,basis,p,subrounds,shots,source=job
    key=f'{family}_{basis}_p{p:.10g}_s{subrounds}_n{shots}'
    dest=ROOT/'results'/f'{key}.json'
    if dest.exists():return key+' cached'
    start=time.monotonic()
    c=bolza(source,int(family[1]),basis,p,subrounds) if family[0]=='b' else planar(int(family[1]),basis,p,subrounds,noise_model='EM3_v3' if family[0]=='q' else 'EM3_v2')
    seed=int.from_bytes(hashlib.sha256(key.encode()).digest()[:8],'little')
    dem=c.detector_error_model(decompose_errors=True)
    matching=pymatching.Matching.from_detector_error_model(dem)
    sampler=c.compile_detector_sampler(seed=seed)
    failures=uncorrected=0;per=np.zeros(c.num_observables,dtype=np.int64)
    for start_shot in range(0,shots,8192):
        det,obs=sampler.sample(min(8192,shots-start_shot),separate_observables=True)
        pred=matching.decode_batch(det);err=pred!=obs
        failures+=int(np.any(err,axis=1).sum());uncorrected+=int(np.any(obs,axis=1).sum());per+=err.sum(axis=0)
    row=dict(key=key,family=family,basis=basis,p=p,subrounds=subrounds,shots=shots,failures=failures,
        uncorrected_failures=uncorrected,observable_failures=per.tolist(),seed=seed,
        no_correction_exact=no_correction_exact(dem,c.num_observables),distance=len(c.shortest_graphlike_error()),
        circuit_sha256=hashlib.sha256(str(c).encode()).hexdigest(),elapsed_seconds=time.monotonic()-start,
        physical_qubits=(16*int(family[1])**2 if family[0]=='b' else 6*int(family[1])**2),
        simulation_qubits=c.num_qubits,num_detectors=c.num_detectors)
    (ROOT/'circuits').mkdir(exist_ok=True)
    if p==.001:(ROOT/'circuits'/f'{family}_{basis}_s{subrounds}.stim').write_text(str(c))
    temp=dest.with_suffix('.tmp');temp.write_text(json.dumps(row,indent=2)+'\n');temp.replace(dest)
    return key+f' {failures}/{shots} {row["elapsed_seconds"]:.2f}s'

def main():
    ap=argparse.ArgumentParser();ap.add_argument('--source',required=True);ap.add_argument('--shots',type=int,default=100000);ap.add_argument('--workers',type=int,default=2);a=ap.parse_args()
    (ROOT/'results').mkdir(exist_ok=True)
    jobs=[]
    for subrounds in [48,96]:
        for family in ['b1','p2','b2','p3','p4','q2','q3','q4']:
            points=[10**(-3+i/10) for i in range(16)] if subrounds==48 and family in ['b1','p2','q2'] else [.001,.002,.005,.01,.02]
            for p in points:
                for basis in (['X','Z'] if family[0]=='b' else ['H','V']):jobs.append((family,basis,p,subrounds,a.shots,a.source))
    with concurrent.futures.ProcessPoolExecutor(max_workers=a.workers) as pool:
        for s in pool.map(run,jobs):print(s,flush=True)

if __name__=='__main__':main()
