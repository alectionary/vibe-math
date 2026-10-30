import hashlib,json,os,pathlib,subprocess,time
from fractions import Fraction as Q
assert os.getpriority(os.PRIO_PROCESS,0)==19
os.environ.update(OPENBLAS_NUM_THREADS='1',OMP_NUM_THREADS='1',MKL_NUM_THREADS='1',VECLIB_MAXIMUM_THREADS='1',DYLD_LIBRARY_PATH='/opt/homebrew/opt/gmp/lib:/private/tmp/c16-soplex-8.1.0-20261030/mpfr/4.2.2/lib')
OUT=pathlib.Path(__file__).resolve().parent
BIN='/private/tmp/c16-soplex-8.1.0-20261030/soplex/8.1.0/bin/soplex'
cases={
'fraction-feasible': 'Minimize\n obj: 0 x + 0 y\nSubject To\n ratio: 1/3 x + 2/7 y = 5/11\n fix: y = 1/13\nBounds\n x free\n y free\nEnd\n',
'fraction-infeasible': 'Minimize\n obj: 0 x\nSubject To\n lo: x >= 2/3\n hi: x <= 1/3\nBounds\n x free\nEnd\n',
'tiny-gap-infeasible': 'Minimize\n obj: 0 x\nSubject To\n lo: x >= 1/3\n hi: x <= 3002399751580330/9007199254740991\nBounds\n x free\nEnd\n',
'free-negative-feasible': 'Minimize\n obj: 0 x + 0 y\nSubject To\n a: x - 1/7 y = -2/3\n b: y = 3/11\nBounds\n x free\n y free\nEnd\n',
}
records=[]
for name,lp in cases.items():
    path=OUT/(name+'.lp');path.write_text(lp)
    args=[BIN,'--readmode=1','--solvemode=2','--int:syncmode=1','--int:checkmode=2','-f0','-o0','-s0','-t15',f'-X={OUT/name}.primal',f'-Y={OUT/name}.dual',f'--writebas={OUT/name}.bas',f'--writefile={OUT/name}.roundtrip.lp',str(path)]
    start=time.monotonic();p=subprocess.run(args,text=True,capture_output=True,timeout=20)
    (OUT/(name+'.log')).write_text(p.stdout+p.stderr)
    records.append(dict(name=name,command=args,exitcode=p.returncode,elapsed_seconds=time.monotonic()-start))
    print(name,p.returncode,(p.stdout+p.stderr)[-1800:],flush=True)
(OUT/'tiny-run-manifest.json').write_text(json.dumps(dict(priority=os.getpriority(os.PRIO_PROCESS,0),binary=BIN,binary_sha256=hashlib.sha256(pathlib.Path(BIN).read_bytes()).hexdigest(),runs=records),indent=2)+'\n')
