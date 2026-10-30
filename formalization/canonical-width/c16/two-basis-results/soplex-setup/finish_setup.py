import hashlib,json,os,pathlib,subprocess,sys
from fractions import Fraction as Q
assert os.getpriority(os.PRIO_PROCESS,0)==19
OUT=pathlib.Path(__file__).resolve().parent
ROOT=OUT.parents[1];sys.path.insert(0,str(ROOT))
from read_soplex_exact_output import read_named_rational
BIN=pathlib.Path('/private/tmp/c16-soplex-8.1.0-20261030/soplex/8.1.0/bin/soplex')
os.environ.update(OPENBLAS_NUM_THREADS='1',OMP_NUM_THREADS='1',MKL_NUM_THREADS='1',VECLIB_MAXIMUM_THREADS='1',DYLD_LIBRARY_PATH='/opt/homebrew/opt/gmp/lib:/private/tmp/c16-soplex-8.1.0-20261030/mpfr/4.2.2/lib')
version=subprocess.run([str(BIN),'--version'],capture_output=True,text=True,timeout=10)
(OUT/'version.txt').write_text(version.stdout+version.stderr)
base=[str(BIN),'--readmode=1','--solvemode=2','--int:syncmode=1','--int:checkmode=2','-f0','-o0','-s0','-t10']
D=(1<<100)+267
(OUT/'hundred-bit.lp').write_text(f'Minimize\n obj: 0 x\nSubject To\n a: 1/{D} x = 2/7\nBounds\n x free\nEnd\n')
(OUT/'zero.lp').write_text('Minimize\n obj: 0 x\nSubject To\n a: x = 0\nBounds\n x free\nEnd\n')
checks=[]
for name,source,extra,expected in [
    ('basis-reuse','fraction-feasible',[f'--readbas={OUT}/fraction-feasible.bas'],dict(x=Q(1299,1001),y=Q(1,13))),
    ('hundred-bit','hundred-bit',[],dict(x=Q(2*D,7))),
    ('zero','zero',[],dict(x=Q(0)))]:
    args=base+extra+[f'-X={OUT}/{name}.primal',str(OUT/(source+'.lp'))]
    result=subprocess.run(args,capture_output=True,text=True,timeout=15)
    (OUT/(name+'.log')).write_text(result.stdout+result.stderr)
    actual=read_named_rational(OUT/(name+'.primal'),expected)
    assert result.returncode==0 and actual==expected
    assert 'SoPlex status       : problem is solved [optimal]' in result.stdout
    checks.append(dict(name=name,command=args,values={k:str(v) for k,v in actual.items()}))
paths=[BIN,pathlib.Path('/opt/homebrew/opt/gmp/lib/libgmp.10.dylib'),pathlib.Path('/opt/homebrew/opt/gmp/lib/libgmpxx.4.dylib'),pathlib.Path('/private/tmp/c16-soplex-8.1.0-20261030/mpfr/4.2.2/lib/libmpfr.6.dylib')]
receipt=dict(status='PASS_SOPLEX_SETUP_AND_SUPPLEMENTAL_EXACT_CONTROLS',priority=os.getpriority(os.PRIO_PROCESS,0),checks=checks,binary=str(BIN),environment={k:os.environ[k] for k in ['OPENBLAS_NUM_THREADS','OMP_NUM_THREADS','MKL_NUM_THREADS','VECLIB_MAXIMUM_THREADS','DYLD_LIBRARY_PATH']},runtime_files={str(p):hashlib.sha256(p.read_bytes()).hexdigest() for p in paths},tiny_receipt_sha256=hashlib.sha256((OUT/'tiny-independent.json').read_bytes()).hexdigest(),source_model_solved=False)
(OUT/'setup-ready.json').write_text(json.dumps(receipt,indent=2)+'\n')
print(json.dumps(receipt,indent=2))
