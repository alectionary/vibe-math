#!/usr/bin/env python3
"""Replay the corrected partner-domain search, retaining logs and provenance."""
import argparse
from concurrent.futures import ThreadPoolExecutor, as_completed
import hashlib
from itertools import combinations
import json
import os
from math import prod
from pathlib import Path
import subprocess
from datetime import datetime,timezone

ROOT=Path(__file__).resolve().parent


def rotate(v,h):
    return ((v<<h)|(v>>(16-h)))&65535 if h else v


def masks_for(omitted):
    return sorted({min(rotate(sum(1<<p for p in bits),h) for h in range(16))
                   for bits in combinations(range(16),omitted)})


def check_log(path,Z,omitted):
    lines=path.read_text().splitlines()
    summary=[line for line in lines if line.startswith('SUMMARY ')]
    if len(summary)!=1: raise ValueError(f'{path}: missing unique summary')
    fields=summary[0].split()[1:]
    data={key:float(value) if key=='seconds' else int(value)
          for key,value in zip(fields[::2],fields[1::2])}
    assert data['omitted']==omitted
    kept=65535^omitted
    domains={p:[j for j,z in enumerate(Z) if ((z>>64)&kept)==1<<p]
             for p in range(16) if kept>>p&1}
    seen={}
    for line in lines:
        if line.startswith('domain '):
            parts=line.split();p=int(parts[1]);size=int(parts[3]);ids=list(map(int,parts[5:]))
            assert len(ids)==size and ids==domains[p]
            seen[p]=ids
    assert seen==domains
    assert data['total']==prod(len(v) for v in domains.values())
    data['outcome']=lines[-1]
    if data['outcome']=='NO_FRAME':
        assert data['covered']==data['total'] and data['full']==data['dead'] and data['capped']==0
    elif data['outcome']=='INCOMPLETE':
        assert data['covered']==data['total'] and data['full']==data['dead']+data['capped']
        assert data['capped']>0
    elif data['outcome']!='RANK_SCAN_ONLY' and not any(l.startswith('FOUND ') for l in lines):
        raise ValueError(f'{path}: unrecognized outcome')
    return data


def main():
    ap=argparse.ArgumentParser()
    ap.add_argument('--binary',type=Path,required=True)
    ap.add_argument('--omitted',type=int,required=True,choices=range(1,16))
    ap.add_argument('--cap',type=int,default=1000000)
    ap.add_argument('--workers',type=int,default=4)
    ap.add_argument('--output',type=Path,required=True)
    ap.add_argument('--source',type=Path,default=ROOT/'seed4_exact.cpp')
    ap.add_argument('--dependency',type=Path,action='append',default=[])
    ap.add_argument('--masks',type=int,nargs='+')
    ap.add_argument('--stop-file',type=Path)
    ap.add_argument('--deadline-utc')
    ap.add_argument('--exact-monomials',action='store_true')
    args=ap.parse_args()
    binary=args.binary.resolve();args.output.mkdir(parents=True,exist_ok=True)
    Z=[int(s,16) for s in (ROOT/'pools/zcoords.txt').read_text().split()]
    masks=masks_for(args.omitted)
    if args.masks:
        assert set(args.masks)<=set(masks)
        masks=sorted(set(args.masks))
    deadline=datetime.fromisoformat(args.deadline_utc.replace('Z','+00:00')) if args.deadline_utc else None
    def stopped():
        return (args.stop_file and args.stop_file.exists()) or (deadline and datetime.now(timezone.utc)>=deadline)
    inputs=[binary,args.source.resolve(),ROOT/'seed4_fifteen.cpp',ROOT/'pools/xcoords.txt',ROOT/'pools/zcoords.txt']
    inputs.extend(p.resolve() for p in args.dependency)
    manifest={'omitted_count':args.omitted,'node_cap':args.cap,'exact_monomials':args.exact_monomials,'expected_masks':masks,'runner_pid':os.getpid(),
              'sha256':{str(p):hashlib.sha256(p.read_bytes()).hexdigest() for p in inputs},'results':[]}
    def run(mask):
        path=args.output/f'seed4-{16-args.omitted}-{mask}.log'
        if stopped():return {'omitted':mask,'outcome':'NOT_STARTED','log':path.name}
        command=[str(binary),str(ROOT/'pools/xcoords.txt'),str(ROOT/'pools/zcoords.txt'),str(mask),str(args.cap)]
        if args.exact_monomials:command.append('--exact-monomials')
        with path.open('w') as out,path.with_suffix('.err').open('w') as err:
            process=subprocess.Popen(command,stdout=out,stderr=err)
            while True:
                try:code=process.wait(timeout=1);break
                except subprocess.TimeoutExpired:
                    if stopped():
                        process.terminate()
                        try:code=process.wait(timeout=3)
                        except subprocess.TimeoutExpired:process.kill();code=process.wait()
                        return {'omitted':mask,'outcome':'INTERRUPTED','returncode':code,'log':path.name}
        data=check_log(path,Z,mask);data['returncode']=code;data['log']=path.name
        return data
    with ThreadPoolExecutor(max_workers=args.workers) as pool:
        for future in as_completed([pool.submit(run,m) for m in masks]):
            data=future.result();manifest['results'].append(data)
            manifest['results'].sort(key=lambda r:r['omitted'])
            (args.output/'manifest.json').write_text(json.dumps(manifest,indent=2)+'\n')
            print(json.dumps(data),flush=True)
    assert {d['omitted'] for d in manifest['results']}==set(masks)
    print(('NO_FRAME_WITH_EXACT_MONOMIAL_COUNT' if args.exact_monomials else 'NO_FRAME_IN_THIS_MONOMIAL_CASE') if all(d['outcome']=='NO_FRAME' for d in manifest['results'])
          else 'CASE_UNRESOLVED')


if __name__=='__main__':main()
