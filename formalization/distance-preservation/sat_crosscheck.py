"""Independent dense CSS-to-CNF encoding; bounded installed CaDiCaL audit.

This is external finite evidence, with no Lean encoding/certificate bridge.
"""
from pathlib import Path
import datetime,hashlib,json,random,subprocess,time
import numpy as np
import independent_verify as iv
R=Path(__file__).resolve().parent
SOLVER=Path('/Users/danabbott/.elan/toolchains/leanprover--lean4---v4.36.0-rc1/bin/cadical')
class CNF:
    def __init__(self,n):self.n=n;self.clauses=[];self.zero=self.fresh();self.clauses.append([-self.zero])
    def fresh(self):self.n+=1;return self.n
    def xor(self,a,b):
        z=self.fresh();self.clauses += [[a,b,-z],[-a,-b,-z],[a,-b,z],[-a,b,z]];return z
    def parity(self,ls):
        v=self.zero
        for x in ls:v=self.xor(v,x)
        return v
    def atmost(self,ls,k):
        # Exact recurrence c(i,j) = c(i-1,j) OR (c(i-1,j-1) AND x_i).
        prev=[-self.zero]+[self.zero]*(k+1)
        for x in ls:
            row=[-self.zero]
            for j in range(1,k+2):
                a,b=prev[j],prev[j-1];z=self.fresh()
                self.clauses += [[-a,z],[-b,-x,z],[-z,a,b],[-z,a,x]];row.append(z)
            prev=row
        self.clauses.append([-prev[k+1]])
    def dimacs(self):return f'p cnf {self.n} {len(self.clauses)}\n'+''.join(' '.join(map(str,c))+' 0\n' for c in self.clauses)
def kernel(A):
    red,piv=iv.eliminate(A);out=[]
    for j in range(A.shape[1]):
        if j in piv:continue
        v=np.zeros(A.shape[1],dtype=np.uint8);v[j]=1;v[piv]=red[:,j];out.append(v)
    return out
def separators(X,Z):
    assert not np.any(X@Z.T%2)
    basis=iv.eliminate(Z)[0];out=[];expected=X.shape[1]-len(iv.eliminate(X)[1])
    for v in kernel(X):
        new=iv.eliminate(np.vstack([basis,v]))[0]
        if len(new)>len(basis):basis=new;out.append(v)
    assert len(basis)==expected
    return out
def encode(X,Z,bound,L=1):
    n=X.shape[1];f=CNF(n)
    for row in Z:f.clauses.append([-f.parity([int(j)+1 for j in np.flatnonzero(row)])])
    ds=separators(X,Z)
    f.clauses.append([f.parity([int(j)+1 for j in np.flatnonzero(row)]) for row in ds])
    f.atmost(list(range(1,n+1)),bound)
    # A global fiber translation puts the first occupied block's chosen bit at0.
    # L=1 adds no genuine symmetry restriction. Tests also cover periodic L>1.
    roots=[]
    for a in range(0,n,L):
        s=f.fresh();roots.append(s);f.clauses.append([-s,a+1])
        f.clauses.extend([[-s,-(j+1)] for j in range(a)])
    f.clauses.append(roots)
    return f,ds
def solve(f,name,seconds):
    text=f.dimacs();path=R/'sat-inputs'/f'{name}.cnf';path.parent.mkdir(exist_ok=True);path.write_text(text)
    log=R/'sat-logs'/f'{name}.log';log.parent.mkdir(exist_ok=True)
    start=time.monotonic()
    with log.open('w') as fd:
        p=subprocess.run([str(SOLVER),'-q','-t',str(seconds),str(path)],stdout=fd,stderr=subprocess.STDOUT,timeout=seconds+10)
    body=log.read_text();status={10:'SAT',20:'UNSAT',0:'UNKNOWN'}.get(p.returncode,'ERROR')
    assert status!='ERROR',(p.returncode,body[-2000:])
    model={int(x) for line in body.splitlines() if line.startswith('v ') for x in line[2:].split() if int(x)>0}
    return {'name':name,'status':status,'returncode':p.returncode,'seconds':time.monotonic()-start,'limit_seconds':seconds,
            'variables':f.n,'clauses':len(f.clauses),'cnf_sha256':hashlib.sha256(path.read_bytes()).hexdigest(),
            'log_sha256':hashlib.sha256(log.read_bytes()).hexdigest(),'true_variables':sorted(model)}
def test():
    rng=random.Random(202610250518);records=[]
    for i in range(36):
        L=[1,2,3][i%3];n=L*rng.randint(1,9//L)
        def orbit(v):
            out=[]
            for _ in range(L):
                out.append(v.copy());v=np.concatenate([np.roll(v[b:b+L],1) for b in range(0,n,L)])
            return out
        checks=[]
        for _ in range(rng.randint(0,3)):checks+=orbit(np.array([rng.randrange(2) for _ in range(n)],dtype=np.uint8))
        Z=np.array(checks,dtype=np.uint8).reshape(-1,n)
        words=[np.array([v>>j&1 for j in range(n)],dtype=np.uint8) for v in range(1<<n)]
        cycles=[v for v in words if not np.any(Z@v%2)];rows=[]
        for _ in range(rng.randint(0,3)):rows+=orbit(rng.choice(cycles))
        X=np.array(rows,dtype=np.uint8).reshape(-1,n);rx=len(iv.eliminate(X)[1])
        logical=[v for v in cycles if len(iv.eliminate(np.vstack([X,v]))[1])>rx]
        d=min((int(v.sum()) for v in logical),default=n+1)
        for b in sorted({1,max(1,d-1),min(n,d),n}):
            f,_=encode(X,Z,b,L);res=solve(f,f'test-{i}-{b}',10)
            assert res['status']==('SAT' if d<=b else 'UNSAT'),(i,L,n,d,b,res)
            if res['status']=='SAT':
                w=np.array([j+1 in res['true_variables'] for j in range(n)],dtype=np.uint8)
                assert int(w.sum())<=b and not np.any(Z@w%2) and len(iv.eliminate(np.vstack([X,w]))[1])>rx
            records.append({k:v for k,v in res.items() if k!='true_variables'})
    report={'status':'PASS','seed':202610250518,'cases':len(records),'scope':'All binary words and augmented ranks provide the independent small-case oracle. Periodic inputs test translation symmetry.',
            'records':records,'solver_version':subprocess.check_output([str(SOLVER),'--version'],text=True).strip(),'solver_sha256':hashlib.sha256(SOLVER.read_bytes()).hexdigest()}
    (R/'sat-regression-tests.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps({k:v for k,v in report.items() if k!='records'}),flush=True)
def main():
    test();saved=json.loads((R/'intermediate-corrected.json').read_text());c=saved['source_candidate'];L=c['L']
    C,X,Z=iv.expand(c['E'],L)
    # Upper witness is fixed independently of this solver; pin it to test the CNF.
    upper=json.loads((R/'independent-intermediate.json').read_text())['nontrivial_quantum_support']
    f,ds=encode(X,Z,14,1)
    f.clauses.extend([[j+1] if j in upper else [-(j+1)] for j in range(25*L)])
    sanity=solve(f,'L13-known-upper14',30);assert sanity['status']=='SAT'
    f,ds=encode(X,Z,13,L);res=solve(f,'L13-weight-atmost13',900)
    support=[j for j in range(25*L) if j+1 in res['true_variables']]
    dense=iv.verify(c['E'],L,support) if res['status']=='SAT' else None
    regression=json.loads((R/'sat-regression-tests.json').read_text())
    out={'E':c['E'],'L':L,'quantum_sector':'X','dimension_quotient':len(ds),'known_upper_sanity':sanity,'bounded_search':res,'independent_witness_check':dense,
         'solver_version':regression['solver_version'],'solver_sha256':regression['solver_sha256'],'regression_record':'sat-regression-tests.json',
         'scope':'External SAT computation with tested dense encoding and symmetry. No Lean CNF soundness bridge or checked UNSAT certificate.',
         'finished_utc':datetime.datetime.now(datetime.timezone.utc).isoformat()}
    (R/'sat-crosscheck.json').write_text(json.dumps(out,indent=2)+'\n');print(json.dumps({'phase':'L13-crosscheck','status':res['status'],'seconds':res['seconds']}),flush=True)
if __name__=='__main__':main()
