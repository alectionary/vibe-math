#!/usr/bin/env python3
"""Resume a complete exported frontier, preserving every unresolved partition."""
import argparse
from datetime import datetime,timezone
import hashlib
import heapq
import json
from pathlib import Path
import subprocess
import time


def main():
    ap=argparse.ArgumentParser();ap.add_argument('--binary',type=Path,required=True);ap.add_argument('--tasks',type=Path,required=True);ap.add_argument('--output',type=Path,required=True)
    ap.add_argument('--resume',action='store_true');ap.add_argument('--workers',type=int,default=3);ap.add_argument('--node-cap',type=int,default=1000000);ap.add_argument('--seconds-per-task',type=float,default=30);ap.add_argument('--deadline-utc',required=True);ap.add_argument('--stop-file',type=Path);args=ap.parse_args()
    root=Path(__file__).parent;args.output.mkdir(parents=True,exist_ok=True);deadline=datetime.fromisoformat(args.deadline_utc.replace('Z','+00:00'))
    records=[];queue=[];running={};counts={'nodes':0,'UNSAT':0,'expanded':0};started=time.monotonic();found=None
    manifest={'status':'RUNNING','initial_tasks':str(args.tasks),'initial_tasks_sha256':hashlib.sha256(args.tasks.read_bytes()).hexdigest(),'binary_sha256':hashlib.sha256(args.binary.read_bytes()).hexdigest(),'deadline_utc':args.deadline_utc,'workers':args.workers,'node_cap':args.node_cap,'seconds_per_task':args.seconds_per_task,'tasks':records}
    def add(line,parent):
        fields=line.split();assert fields[0]=='TASK';remaining=int(fields[1]);bound=int(fields[2]);a=int(fields[3],16);b=int(fields[4],16);n=int(fields[5]);assert remaining==128-n and len(fields)==6+2*n
        ident=len(records);path=args.output/f'{ident:08d}.task';path.write_text(line.strip()+'\n');record={'id':ident,'parent':parent,'status':'QUEUED','remaining':remaining,'remaining_seed4_cap':bound,'input':path.name};records.append(record)
        excess=a.bit_count()+b.bit_count()-2*remaining;heapq.heappush(queue,(excess,remaining,ident))
    def snapshot():
        manifest['counts']=dict(counts,queued=len(queue),running=len(running),registered=len(records));manifest['wall_seconds']=time.monotonic()-started
        tmp=args.output/'manifest.tmp';tmp.write_text(json.dumps(manifest,indent=2)+'\n');tmp.replace(args.output/'manifest.json')
    if args.resume:
        previous=json.loads((args.output/'manifest.json').read_text())
        assert previous['initial_tasks_sha256']==manifest['initial_tasks_sha256']
        assert previous['binary_sha256']==manifest['binary_sha256']
        assert previous['status']!='SAT'
        records.extend(previous['tasks'])
        counts['nodes']=sum(r.get('nodes',0) for r in records if r['status'] in ['UNSAT','EXPANDED'])
        counts['UNSAT']=sum(r['status']=='UNSAT' for r in records)
        counts['expanded']=sum(r['status']=='EXPANDED' for r in records)
        for ident,rec in enumerate(records):
            assert rec['id']==ident
            if rec['status'] not in ['UNSAT','EXPANDED']:
                fields=(args.output/rec['input']).read_text().split();remaining=int(fields[1]);a=int(fields[3],16);b=int(fields[4],16)
                rec['status']='QUEUED';heapq.heappush(queue,(a.bit_count()+b.bit_count()-2*remaining,remaining,ident))
        manifest['prior_checkpoint_sha256']=hashlib.sha256((args.output/'manifest.json').read_bytes()).hexdigest()
        manifest['prior_wall_seconds']=previous.get('wall_seconds',0)+previous.get('prior_wall_seconds',0)
        backup=args.output/f'checkpoint-{datetime.now(timezone.utc).strftime("%Y%m%dT%H%M%SZ")}.json'
        backup.write_text(json.dumps(previous,indent=2)+'\n')
    else:
        assert not (args.output/'manifest.json').exists(),'Use --resume to preserve existing work.'
        for line in args.tasks.read_text().splitlines():
            if line.strip():add(line,None)
    snapshot();last=time.monotonic()
    def stopped():return datetime.now(timezone.utc)>=deadline or (args.stop_file and args.stop_file.exists())
    while queue or running:
        if stopped():break
        while queue and len(running)<args.workers:
            _,_,ident=heapq.heappop(queue);rec=records[ident];prefix=args.output/f'{ident:08d}'
            out=prefix.with_suffix('.log').open('w');err=prefix.with_suffix('.err').open('w')
            cmd=[str(args.binary.resolve()),str(root/'pools/xcoords.txt'),str(root/'pools/zcoords.txt'),str(prefix),str(args.node_cap),str(rec['remaining_seed4_cap']),str(args.seconds_per_task),str(args.output/rec['input'])]
            proc=subprocess.Popen(cmd,stdout=out,stderr=err);rec['status']='RUNNING';running[ident]=(proc,out,err,prefix)
        finished=[]
        for ident,(proc,out,err,prefix) in list(running.items()):
            code=proc.poll()
            if code is None:continue
            out.close();err.close();finished.append(ident);rec=records[ident];rec['returncode']=code
            path=prefix.with_suffix('.json')
            if code not in [0,2,3] or not path.exists():rec['status']='ERROR';continue
            result=json.loads(path.read_text());rec['result']=path.name;rec['nodes']=result['nodes'];rec['seconds']=result['seconds'];counts['nodes']+=result['nodes']
            if result['status']=='SAT':rec['status']='SAT';found=ident;break
            if result['status']=='UNSAT':rec['status']='UNSAT';counts['UNSAT']+=1
            elif result['status']=='FRONTIER':
                lines=prefix.with_suffix('.tasks').read_text().splitlines();assert len(lines)==result['frontier_tasks']
                children=[]
                for line in lines:children.append(len(records));add(line,ident)
                rec['status']='EXPANDED';rec['children']=children;counts['expanded']+=1
            else:raise ValueError(result['status'])
        for ident in finished:running.pop(ident,None)
        if found is not None:break
        if time.monotonic()-last>=15:
            snapshot();print(json.dumps(manifest['counts']),flush=True);last=time.monotonic()
        time.sleep(.1)
    for ident,(proc,out,err,prefix) in running.items():
        proc.terminate()
        try:proc.wait(timeout=3)
        except subprocess.TimeoutExpired:proc.kill();proc.wait()
        out.close();err.close();records[ident]['status']='INTERRUPTED'
    running.clear()
    unresolved=[r['id'] for r in records if r['status'] in ['QUEUED','INTERRUPTED','ERROR','RUNNING']]
    manifest['status']='SAT' if found is not None else 'UNSAT' if not unresolved and all(r['status'] in ['UNSAT','EXPANDED'] for r in records) else 'INCOMPLETE'
    manifest['unresolved_ids']=unresolved
    if found is not None:manifest['witness_result']=records[found]['result']
    snapshot();print(json.dumps({'status':manifest['status'],'counts':manifest['counts'],'unresolved':len(unresolved)}),flush=True)


if __name__=='__main__':main()
