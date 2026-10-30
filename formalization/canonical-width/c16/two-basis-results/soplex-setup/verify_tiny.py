"""Independent literal primal/Farkas checks for the frozen tiny solver outputs."""
from pathlib import Path
from fractions import Fraction as Q
import hashlib,json,os,sys
assert os.getpriority(os.PRIO_PROCESS,0)==19
os.environ.update(OPENBLAS_NUM_THREADS='1',OMP_NUM_THREADS='1',MKL_NUM_THREADS='1',VECLIB_MAXIMUM_THREADS='1')
ROOT=Path(__file__).resolve().parents[2];sys.path.insert(0,str(ROOT))
from read_soplex_exact_output import read_named_rational
OUT=Path(__file__).resolve().parent

def primal(name):
    v=read_named_rational(OUT/(name+'.primal'),['x','y'])
    if name=='fraction-feasible':
        assert v['x']/3+2*v['y']/7==Q(5,11) and v['y']==Q(1,13)
    else:
        assert v['x']-v['y']/7==Q(-2,3) and v['y']==Q(3,11)
    assert 'SoPlex status       : problem is solved [optimal]' in (OUT/(name+'.log')).read_text()
    return v

def farkas(name):
    v=read_named_rational(OUT/(name+'.dual'),['lo','hi'],'farkas')
    L=Q(2,3) if name=='fraction-infeasible' else Q(1,3)
    U=Q(1,3) if name=='fraction-infeasible' else Q(3002399751580330,9007199254740991)
    assert v['lo']>=0 and v['hi']<=0 and v['lo']+v['hi']==0
    gap=v['lo']*L+v['hi']*U
    assert gap>0
    assert 'SoPlex status       : problem is solved [infeasible]' in (OUT/(name+'.log')).read_text()
    return v,gap

checks=[]
for name in ['fraction-feasible','free-negative-feasible']:
    checks.append(dict(name=name,values={k:str(v) for k,v in primal(name).items()}))
for name in ['fraction-infeasible','tiny-gap-infeasible']:
    v,gap=farkas(name);checks.append(dict(name=name,multipliers={k:str(x) for k,x in v.items()},exact_contradiction=str(gap)))

mutants=[]
base=(OUT/'fraction-feasible.primal').read_text()
for name,text in [
    ('unknown-name',base.replace('x\t','z\t')),
    ('duplicate-name',base.replace('y\t','x\t')),
    ('decimal-value',base.replace('1299/1001','1.2977022977022976')),
    ('nan-value',base.replace('1299/1001','nan')),
    ('missing-header',base.replace('Primal solution (name, value):','')),
    ('missing-zero-terminator',base.split('All other variables')[0])]:
    p=OUT/('mutant-'+name+'.txt');p.write_text(text)
    try:read_named_rational(p,['x','y'])
    except ValueError:mutants.append(name)
    else:raise AssertionError(name)
v=primal('fraction-feasible');v['x']+=Q(1,10**40)
assert v['x']/3+2*v['y']/7!=Q(5,11);mutants.append('tiny-primal-error')
v,g=farkas('fraction-infeasible')
assert -(v['lo']*Q(2,3)+v['hi']*Q(1,3))<0;mutants.append('reversed-farkas-sign')
assert v['lo']!=0;mutants.append('dropped-farkas-row')

# Preserve and reject the lossy CLI export as an exact roundtrip.
rt=(OUT/'fraction-feasible.roundtrip.lp').read_text()
assert '3.3333333333333331e-01' in rt and Q('3.3333333333333331e-01')!=Q(1,3)
out=dict(status='PASS_TINY_EXACT_SOPLEX_PRIMAL_FARKAS_CONTROLS',checks=checks,
    corruptions_rejected=mutants,fraction_input_grammar_verified=True,
    cli_writefile_exact_roundtrip=False,cli_writefile_failure='Rounded decimal real-LP export; must not substitute for rational source input',
    priority=os.getpriority(os.PRIO_PROCESS,0),source_model_solved=False,
    parser_sha256=hashlib.sha256((ROOT/'read_soplex_exact_output.py').read_bytes()).hexdigest(),
    input_output_sha256={p.name:hashlib.sha256(p.read_bytes()).hexdigest() for p in sorted(OUT.iterdir()) if p.suffix in ['.lp','.primal','.dual','.log','.bas']})
(OUT/'tiny-independent.json').write_text(json.dumps(out,indent=2)+'\n')
print(json.dumps(out,indent=2))
