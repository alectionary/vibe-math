#!/usr/bin/env python3
import json,os,pathlib,signal,time
p=pathlib.Path(__file__).resolve().parent/'portfolio-resource-events.json'
r=json.loads(p.read_text())
while True:
    remaining=r['resume_at_unix']-time.time()
    if remaining<=0:break
    time.sleep(min(10,remaining))
try:
    proc=pathlib.Path('/proc')/str(r['paused_pid'])
    ticks=proc.joinpath('stat').read_text().rsplit(')',1)[1].split()[19]
    args=proc.joinpath('cmdline').read_bytes().split(b'\0')
    if ticks==r['expected_start_ticks'] and args[:3]==[b'/workspace/c16-venv/bin/python',b'-u',b'run_integrated_suite.py']:
        os.kill(r['paused_pid'],signal.SIGCONT);r['resume_status']='SIGCONT sent to verified original process'
    else:r['resume_status']='Process identity changed; no signal sent'
except (ProcessLookupError,FileNotFoundError):r['resume_status']='Process already exited'
r['actual_resume_unix']=time.time();p.write_text(json.dumps(r,indent=2)+'\n')
