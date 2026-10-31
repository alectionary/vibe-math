#!/usr/bin/env python3
"""Independent sparse row algebra for the full, unpinned shared-basis master."""
from pathlib import Path
from fractions import Fraction as Q
import gzip,hashlib,json,os,io
from verify_owner_star_flow_extension import decode_model,empty,term,add
from verify_owner_star_capacity_extension import labels_and_rows
from verify_owner_k22_capacity_extension import expected_rows as k22_rows,allowed_masks
from verify_two_sided_full_basis_oracle import domains,rank,point_owner,sector_upper
from verify_algebraic_model import physical

ROOT=Path(__file__).resolve().parent
OLD_ROOTS=(Path('/private/tmp/c16-two-basis-20261030T1438/formalization/canonical-width/c16'),
           Path('/private/tmp/c16-coupling-20261030T0514/formalization/canonical-width/c16'))
THREADS=('OPENBLAS_NUM_THREADS','OMP_NUM_THREADS','MKL_NUM_THREADS','VECLIB_MAXIMUM_THREADS','NUMEXPR_NUM_THREADS','BLIS_NUM_THREADS')
def guard():
    assert os.getpriority(os.PRIO_PROCESS,0)==19
    assert all(os.environ.get(k)=='1' for k in THREADS)
def resolve(value):
    p=Path(value);assert '..' not in p.parts
    if p.is_absolute():
        for old in OLD_ROOTS:
            if p.is_relative_to(old):p=ROOT/p.relative_to(old);break
    else:p=ROOT/p
    p=p.resolve();assert p.is_relative_to(ROOT),('foreign research path',str(p))
    return p
def sha(p):return hashlib.sha256(resolve(p).read_bytes()).hexdigest()
def read(p):
    p=resolve(p);b=p.read_bytes();return json.loads(gzip.decompress(b) if p.suffix=='.gz' else b)
def bindings(d):
    for p,h in d.items():assert sha(p)==h,('changed bound source',p)
def field(d,key):
    assert sha(d[key])==d[key+'_sha256'],key
    return read(d[key])
def value(e,f,x):
    return sum((v*f[j] for j,v in e[0].items()),Q(0))+sum((v*x[j] for j,v in e[1].items()),Q(0))

def parent_context(manifest_path,receipt_path):
    manifest=read(manifest_path);receipt=read(receipt_path)
    assert manifest['status']=='PASS_EXACT_OWNER_K22_CAPACITY_LP_TEXT_ROUNDTRIP'
    assert receipt['status']=='PASS_EXACT_OWNER_K22_CAPACITY_MODEL'
    assert receipt['manifest_sha256']==sha(manifest_path)
    assert receipt['consumer_sha256']==sha('verify_owner_k22_capacity_extension.py')
    wrapper=field(manifest,'semantic')
    assert receipt['model_sha256']==manifest['semantic_sha256']
    assert wrapper['status']=='FROZEN_COMPLETE_EIGHT_EVENT_CAPACITY_EXTENSION'
    bindings(wrapper['source_hashes'])
    saved=field(wrapper,'parent_semantic');M=decode_model(saved['model'])
    assert len(M['variables'])==22481 and M['X_anchors']==[80,512] and M['Z_anchors']==[186,433]
    assert M['structural_only_elimination'] and M['fixed_law_faces_used'] is False
    assert M['high_masks']==[7,11,13,14,15]
    bindings(M['source_hashes'])
    assert saved['point_sha256']==manifest['point_sha256']==sha(saved['point'])
    f=[Q(1),*point_owner(resolve(saved['point']))]
    assert f==list(map(Q,saved['feature_values'])) and len(f)==36496
    X,Z,_=physical();dd=domains(X,Z,[80,512],[186,433])
    assert len(dd)==16 and all(d['feasible'] for d in dd)
    allowed=allowed_masks(X,Z);assert len(allowed)==152
    new=k22_rows(M,set(allowed));assert len(new)==138
    # Independent symbolic reconstruction of all138 saved extension rows.
    from verify_owner_star_flow_extension import decode
    assert len(wrapper['appended_rows'])==len(new)
    for got,want in zip(wrapper['appended_rows'],new):
        assert {k:v for k,v in got.items() if k!='expression'}=={k:v for k,v in want.items() if k!='expression'}
        assert decode(got['expression'],36496,22513)==want['expression']
    base=list(labels_and_rows(M,False))
    assert len(base)==98725 and not any(r[0]['name'].startswith('zero_tau') for r in base)
    rows=[(label['name'],e,rel) for label,rel,e in base]+[(r['name'],r['expression'],r['relation']) for r in new]
    assert len(rows)==98863 and len({r[0] for r in rows})==98863
    return dict(manifest=manifest,receipt=receipt,wrapper=wrapper,saved=saved,M=M,f=f,X=X,Z=Z,domains=dd,parent_rows=rows,allowed=allowed)

def physical_column(column,data):
    side,m,indices=column['side'],column['mask'],column['indices']
    assert side in ('X','Z') and type(m)is int and 0<=m<16
    assert isinstance(indices,list) and len(indices)==128 and all(type(j)is int and 0<=j<720 for j in indices)
    assert len(set(indices))==128
    U=data[side];d=data['domains'][m][side];selected=set(indices)
    assert set(d['forced'])<=selected and not selected.intersection(d['absent'])
    assert rank(U[j] for j in indices)==128
    assert sum(not d['signatures'][j] for j in indices)==d['zero_required']
    assert all(len(d['signatures'][j])<=1 for j in indices)
    for opposite,bucket in zip(d['opposite'],d['bins']):
        owners=[j for j in indices if d['signatures'][j]==(opposite,)]
        assert len(owners)==1 and owners[0] in bucket
    return side,m,tuple(sorted(indices))

def layout(columns):
    n=len(columns);blocks={(s,m):[] for m in range(16) for s in 'XZ'}
    supports={(s,m,j):[] for m in range(16) for s in 'XZ' for j in range(720)}
    for k,c in enumerate(columns):
        blocks[c['side'],c['mask']].append(k)
        for j in c['indices']:supports[c['side'],c['mask'],j].append(k)
    assert all(blocks.values()),'Every free-law sector-pattern block requires an initial physical column'
    return dict(columns=columns,nB=n,weight_start=22513,plus_start=22513+n,minus_start=22513+n+23040,
                variable_count=22513+n+46080,blocks=blocks,supports=supports)
def link_index(side,m,j):return (2*m+(side=='Z'))*720+j
def expected_rows(data,L):
    for name,e,rel in data['parent_rows']:yield name,e,rel
    M=data['M'];w0=L['weight_start'];ep=L['plus_start'];em=L['minus_start']
    for m in range(16):
        for side in 'XZ':
            e=add(empty(),M['lambda_expressions'][m],-1)
            for k in L['blocks'][side,m]:e=add(e,term(1,w0+k))
            yield f'sm_mass_{side}_{m}',e,'='
    for m in range(16):
        for side in 'XZ':
            for j in range(720):
                e=add(empty(),M['sectors'][side]['allocations'][m][j],-1)
                for k in L['supports'][side,m,j]:e=add(e,term(1,w0+k))
                q=link_index(side,m,j);e=add(add(e,term(1,ep+q)),term(1,em+q),-1)
                yield f'sm_link_{side}_{m}_{j}',e,'='
    for j in range(w0,L['variable_count']):yield 'sm_nonneg_'+str(j),term(1,j,-1),'<='
def numeric(e,f):return e[1],-sum((v*f[j] for j,v in e[0].items()),Q(0))
def objective(L):return {j:Q(1) for j in range(L['plus_start'],L['variable_count'])}

class Tokens:
    def __init__(self,path,raw_text=None):
        self.stream=io.StringIO(raw_text) if raw_text is not None else resolve(path).open()
        self.iterator=(t for line in self.stream for t in line.split());self.current=next(self.iterator,None)
    def pop(self):
        t=self.current;assert t is not None,'Unexpected end of LP';self.current=next(self.iterator,None);return t
    def expect(self,t):assert self.pop()==t,('LP token mismatch',t)
    def expr(self,N):
        out={}
        while self.current in ('+','-'):
            sign=1 if self.pop()=='+' else -1;q=sign*Q(self.pop());name=self.pop()
            assert name.startswith('x') and name[1:].isdigit();j=int(name[1:]);assert 0<=j<N and j not in out
            out[j]=q
        return {j:v for j,v in out.items() if v}
def parse_lp(path,rows,f,N,cost,raw_text=None):
    t=Tokens(path,raw_text);t.expect('Minimize');t.expect('obj:');assert t.expr(N)==cost
    t.expect('Subject');t.expect('To');count=nz=equalities=0
    for name,e,rel in rows:
        t.expect(name+':');actual=t.expr(N);coeff,rhs=numeric(e,f)
        assert actual==coeff,('LP coefficient mismatch',name)
        t.expect(rel);assert Q(t.pop())==rhs,('LP RHS mismatch',name)
        count+=1;nz+=len(coeff);equalities+=rel=='='
    t.expect('Bounds')
    for j in range(N):t.expect('x'+str(j));t.expect('free')
    t.expect('End');assert t.current is None;t.stream.close()
    return dict(rows_checked=count,nonzeros_checked=nz,equalities_checked=equalities,inequalities_checked=count-equalities)

def check_primal(rows,f,values,cost):
    count=0;minimum=None
    for name,e,rel in rows:
        q=value(e,f,values)
        assert q==0 if rel=='=' else q<=0,('primal row',name,str(q))
        if rel=='<=':minimum=-q if minimum is None else min(minimum,-q)
        count+=1
    return sum((a*values[j] for j,a in cost.items()),Q(0)),count,minimum

def exact_dual(rows,f,N,cost,dual,primal_objective):
    assert len(dual)==len(rows) and set(dual)=={r[0] for r in rows}
    inequalities=[dual[name] for name,e,rel in rows if rel=='<=']
    signs=[s for s in (1,-1) if all(s*v<=0 for v in inequalities)]
    for sign in signs:
        station=[Q(0)]*N;value_total=Q(0)
        for name,e,rel in rows:
            pi=sign*dual[name]
            if not pi:continue
            coeff,rhs=numeric(e,f);value_total+=pi*rhs
            for j,v in coeff.items():station[j]+=pi*v
        if value_total!=primal_objective:continue
        if any(station[j]!=cost.get(j,Q(0)) for j in range(N)):continue
        return sign,{k:sign*v for k,v in dual.items()},value_total
    raise AssertionError('No exact min-LP dual stationarity/objective equality')
