#!/usr/bin/env python3
"""Recheck saved witnesses and input provenance without rerunning a solver."""
import argparse,hashlib,json,pathlib
from solve import BASE,check,read
HERE=pathlib.Path(__file__).resolve().parent
parser=argparse.ArgumentParser();parser.add_argument('--directory',default='outputs');parser.add_argument('--require-gate',action='store_true');args=parser.parse_args()
p=json.loads((HERE/'provenance.json').read_text())
for name,digest in p['sha256'].items():assert hashlib.sha256((BASE/name).read_bytes()).hexdigest()==digest,name
expected={'test-real-blocks01':43046721,'test-real-blocks23':0,'test-planted1-A':1,'test-planted1-B':1,'test-planted1-C':1,'test-real-quarter':0}
out=HERE/args.directory
marker=out/'tests-passed.json'
gate=marker.exists() and json.loads(marker.read_text()).get('all_passed') is True
for name,n in expected.items():
    file=out/f'{name}.json'
    if not file.exists():gate=False;continue
    r=json.loads(file.read_text())
    gate &= r['status']=='COMPLETE' and r['frames_found']==n
for file in sorted(out.glob('*.json')):
    r=json.loads(file.read_text())
    if 'frame' not in r:continue
    if r['frame'] is not None:
        x,z=read(r['pools']);check(x,z,r['frame'],r['class'],32 if r['class'].startswith('blocks') else 128)
    print(file.name,r['status'],r['frames_found'])
print('Input hashes and saved witnesses verified. Known-answer gate:', 'PASSED' if gate else 'NOT PASSED')
print('Negative decisions still rely on recorded solver/counting runs.')
if args.require_gate:assert gate,'Required known-answer gate has not passed'
