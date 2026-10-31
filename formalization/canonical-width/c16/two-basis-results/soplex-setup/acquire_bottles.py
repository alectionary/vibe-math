"""Acquire only checksum-pinned official public bottles into an isolated prefix."""
import hashlib,json,os,pathlib,subprocess,tarfile,time,urllib.request
assert os.getpriority(os.PRIO_PROCESS,0)==19
OUT=pathlib.Path(__file__).resolve().parent
PREFIX=pathlib.Path('/private/tmp/c16-soplex-8.1.0-20261030')
PREFIX.mkdir(exist_ok=True)
records=[]
for package in ['soplex','mpfr']:
    raw=urllib.request.urlopen(f'https://formulae.brew.sh/api/formula/{package}.json',timeout=30).read()
    (OUT/f'{package}-formula-live.json').write_bytes(raw)
    meta=json.loads(raw); info=meta['bottle']['stable']['files']['arm64_golden_gate']
    token=json.load(urllib.request.urlopen(f'https://ghcr.io/token?service=ghcr.io&scope=repository:homebrew/core/{package}:pull',timeout=30))['token']
    req=urllib.request.Request(info['url'],headers={'Authorization':'Bearer '+token})
    with urllib.request.urlopen(req,timeout=40) as response:
        data=response.read(60_000_001)
    assert len(data)<=60_000_000
    digest=hashlib.sha256(data).hexdigest();assert digest==info['sha256']
    path=PREFIX/f'{package}.bottle.tar.gz';path.write_bytes(data)
    with tarfile.open(path) as tar:tar.extractall(PREFIX,filter='data')
    records.append(dict(package=package,version=meta['versions']['stable'],url=info['url'],sha256=digest,bytes=len(data),formula_sha256=hashlib.sha256(raw).hexdigest()))
    print(package,meta['versions']['stable'],len(data),digest,flush=True)
manifest=dict(status='OFFICIAL_BOTTLES_CHECKSUM_VERIFIED_EXTRACTED',priority=os.getpriority(os.PRIO_PROCESS,0),prefix=str(PREFIX),packages=records,scope='Isolated extraction only; no Homebrew ownership changes, build or system install')
(OUT/'bottle-manifest.json').write_text(json.dumps(manifest,indent=2)+'\n')
for path in sorted(PREFIX.glob('soplex/*/bin/soplex')):
    p=subprocess.run(['/usr/bin/otool','-L',str(path)],capture_output=True,text=True)
    (OUT/'binary-dylibs.txt').write_text(p.stdout+p.stderr)
    print(p.stdout,flush=True)
