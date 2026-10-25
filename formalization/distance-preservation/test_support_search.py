"""Independent full-word oracle for small periodic CSS search inputs."""
from pathlib import Path
import datetime, hashlib, json, random, subprocess
R=Path(__file__).resolve().parent
def run(cols, rows, L, bound, binary='support_search'):
    m=max(1,max(cols,default=0).bit_length());n=len(cols)
    lines=[' '.join(map(str,[n,m,len(rows),L,bound,1000000]))]
    lines+=[' '.join(str(x>>(64*i)&((1<<64)-1)) for i in range(5)) for x in cols]
    lines+=[' '.join(str(x>>(64*i)&((1<<64)-1)) for i in range(10)) for x in rows]
    return json.loads(subprocess.check_output([str(R/binary)],input='\n'.join(lines)+'\n',text=True))
def shift(v,L,n):
    out=0
    for j in range(n):
        if v>>j&1:out|=1<<(j//L*L+(j%L+1)%L)
    return out
def orbit(v,L,n):
    out=[]
    for _ in range(L):out.append(v);v=shift(v,L,n)
    return out
def span(rows):
    words={0}
    for r in rows:words|={x^r for x in words}
    return words
def main():
    regression=run([1,1,2,4],[],1,3)
    assert regression['witness']==[0,1] and not regression['budget_exhausted']
    rng=random.Random(202610250513);tested=0;instances=[]
    for k in range(180):
        L=[1,2,3][k%3];n=L*rng.randint(1,12//L)
        checks=[]
        for _ in range(rng.randint(0,min(4,n))):checks+=orbit(rng.randrange(1<<n),L,n)
        kernel=[v for v in range(1<<n) if all((v&r).bit_count()%2==0 for r in checks)]
        rows=[]
        for _ in range(rng.randint(0,4)):rows+=orbit(rng.choice(kernel),L,n)
        stabs=span(rows);logical=[v for v in kernel if v not in stabs]
        d=min((v.bit_count() for v in logical),default=n+1)
        cols=[sum(((r>>j)&1)<<i for i,r in enumerate(checks)) for j in range(n)]
        for bound in range(1,n+1):
            x=run(cols,rows,L,bound);w=x['witness'];assert not x['budget_exhausted']
            assert bool(w)==(d<=bound),(k,L,n,d,bound,x)
            if w:
                assert len(w)==len(set(w)) and len(w)<=bound
                v=sum(1<<j for j in w);assert v in kernel and v not in stabs
            tested+=1
        instances.append({'L':L,'n':n,'distance':d if logical else None,'kernel_size':len(kernel),'stabilizer_size':len(stabs)})
    out={'status':'PASS','checked_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'seed':202610250513,
         'regression':regression,'independent_oracle':'Enumerate every binary word; compute stabilizer span by explicit XOR closure. Translation-invariant checks and stabilizers; all bounds1..n.',
         'instances':instances,'bound_comparisons':tested,'cpp_sha256':hashlib.sha256((R/'support_search.cpp').read_bytes()).hexdigest()}
    (R/'search-regression-tests.json').write_text(json.dumps(out,indent=2)+'\n');print(json.dumps({k:v for k,v in out.items() if k!='instances'}),flush=True)
if __name__=='__main__':main()
