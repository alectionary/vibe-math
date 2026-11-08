#!/usr/bin/env python3
"""Exact fixed-allocation owner-star flow candidates, with symbolic cuts.

The independent consumer owns acceptance. A failure rejects the supplied
lambda/y allocation only; neither the shared law nor the source is excluded.
"""
from pathlib import Path
from fractions import Fraction as Q
from collections import Counter,deque
import argparse,gzip,hashlib,json,math,time

ROOT=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def read(p):
    p=Path(p);b=p.read_bytes();return json.loads(gzip.decompress(b)if p.suffix=='.gz'else b)
def frozen_path(p):return p.with_name(p.name.removesuffix('.json.gz').removesuffix('.json')+'.frozen.json')
def coord(x,z):
    i,j=x//16,z//16;h=(z-x)%16
    if h>8:h,i,j=16-h,j,i
    if h in(0,8)and i>j:i,j=j,i
    return 18270+2025*h+45*i+j


def maxflow(rows,cols,upper,deadline=None):
    """Exact nonnegative integer transportation; feasible flow or mincut."""
    R,C=len(rows),len(cols);assert sum(rows)==sum(cols)
    assert all(type(x)is int and x>=0 for x in rows+cols)and all(type(x)is int and x>=0 for row in upper for x in row)
    n=R+C+2;s=n-2;t=n-1;g=[[]for _ in range(n)]
    def edge(a,b,c):
        at=len(g[a]);g[a].append([b,len(g[b]),c,c]);g[b].append([a,at,0,0]);return at
    for i,c in enumerate(rows):edge(s,i,c)
    references=[]
    for i in range(R):references.append([edge(i,R+j,upper[i][j])for j in range(C)])
    for j,c in enumerate(cols):edge(R+j,t,c)
    value=0;total=sum(rows)
    while value<total:
        if deadline is not None and time.monotonic()>deadline:raise TimeoutError('exact flow cohort deadline')
        level=[-1]*n;level[s]=0;q=deque([s])
        while q:
            v=q.popleft()
            for u,rev,c,original in g[v]:
                if c and level[u]<0:level[u]=level[v]+1;q.append(u)
        if level[t]<0:break
        it=[0]*n
        def dfs(v,f):
            if v==t:return f
            while it[v]<len(g[v]):
                e=g[v][it[v]];u,rev,c,_=e
                if c and level[u]==level[v]+1:
                    pushed=dfs(u,min(f,c))
                    if pushed:e[2]-=pushed;g[u][rev][2]+=pushed;return pushed
                it[v]+=1
            return 0
        while value<total:
            pushed=dfs(s,total-value)
            if not pushed:break
            value+=pushed
    flow=[[g[i][references[i][j]][3]-g[i][references[i][j]][2]for j in range(C)]for i in range(R)]
    reached={s};q=deque([s])
    while q:
        v=q.popleft()
        for u,rev,c,original in g[v]:
            if c and u not in reached:reached.add(u);q.append(u)
    return dict(feasible=value==total,value=value,flow=flow,row_subset=[i for i in range(R)if i in reached],column_subset=[j for j in range(C)if R+j in reached])


def bounded_flow(rows,cols,lower,upper,deadline=None):
    R,C=len(rows),len(cols);assert len(lower)==len(upper)==R and all(len(r)==C for r in lower+upper)
    for m in range(R):
        for j in range(C):
            if lower[m][j]>upper[m][j]:return dict(kind='edge_lower_above_upper',row=m,column=j)
    dr=[rows[m]-sum(lower[m])for m in range(R)]
    for m,v in enumerate(dr):
        if v<0:return dict(kind='negative_row_residual',row=m)
    bc=[cols[j]-sum(lower[m][j]for m in range(R))for j in range(C)]
    for j,v in enumerate(bc):
        if v<0:return dict(kind='negative_column_residual',column=j)
    assert sum(dr)==sum(bc)
    flow=maxflow(dr,bc,[[upper[m][j]-lower[m][j]for j in range(C)]for m in range(R)],deadline)
    if flow['feasible']:
        return dict(kind='feasible',flow=[[flow['flow'][m][j]+lower[m][j]for j in range(C)]for m in range(R)])
    return dict(kind='deficient_min_cut',row_subset=flow['row_subset'],column_subset=flow['column_subset'])


def load_inputs(a):
    from verify_two_sided_full_basis_oracle import point_owner
    point=point_owner(a.point);frozen=[];certs=[];sources={}
    for side,cp,rp in [('X',a.X_allocation,a.X_receipt),('Z',a.Z_allocation,a.Z_receipt)]:
        c=read(cp);fpath=frozen_path(cp);f=read(fpath);r=read(rp)
        assert c['status']=='EXACT_DIRECT_COUNT_ALLOCATION_REQUIRES_REPLAY'
        assert r['status']=='PASS_EXACT_DIRECT_COUNT_AND_LISTED_RANK_ROWS'
        assert r['consumer_sha256']==sha(ROOT/'verify_two_basis_rank_closed_allocation.py')
        assert r['certificate_sha256']==sha(cp)and r['frozen_sha256']==c['frozen_sha256']==sha(fpath)
        assert r['point_sha256']==f['point_sha256']==sha(a.point)and f['side']==side
        assert all(sha(ROOT/p)==h for p,h in f['source_hashes'].items())
        for p in [cp,rp,fpath]:sources[str(p)]=sha(p)
        frozen.append(f);certs.append(c)
    assert frozen[0]['lambda_masses']==frozen[1]['lambda_masses']
    assert all(frozen[0][key]==frozen[1][key]for key in ['X_anchors','Z_anchors'])
    lam=list(map(Q,frozen[0]['lambda_masses']));ys=[[list(map(Q,row))for row in c['exact_allocations']]for c in certs]
    assert len(lam)==16 and sum(lam)==1 and min(lam)>=0
    assert all(len(y)==16 and all(len(row)==720 for row in y)for y in ys)
    D=math.lcm(*[v.denominator for v in lam+point+sum(ys[0],[])+sum(ys[1],[])])
    conv=lambda values:[int(v*D)for v in values]
    ilam=conv(lam);iy=[[conv(row)for row in y]for y in ys];ip=conv(point)
    for side in range(2):
        assert all(0<=iy[side][m][j]<=ilam[m]for m in range(16)for j in range(720))
        assert all(sum(iy[side][m])==128*ilam[m]for m in range(16))
        assert all(sum(iy[side][m][j]for m in range(16))==ip[j//16]for j in range(720))
    X,Z=[[int(v,16)for v in (ROOT/f'pools/{s}coords.txt').read_text().split()]for s in 'xz']
    xx,zz=frozen[0]['X_anchors'],frozen[0]['Z_anchors']
    for p in [a.point,Path(__file__),ROOT/'verify_two_sided_full_basis_oracle.py',ROOT/'verify_two_basis_rank_closed_allocation.py',ROOT/'physical-pool-source.json',ROOT/'pools/xcoords.txt',ROOT/'pools/zcoords.txt',ROOT/'moment-resumption-results/symmetry-bridge-independent.json']:
        try:key=str(p.relative_to(ROOT))
        except ValueError:key=str(p)
        sources[key]=sha(p)
    return dict(D=D,lam=ilam,y=iy,owner=ip,X=X,Z=Z,xa=xx,za=zz,source_hashes=sources)


def forbidden(data,m,x,z):
    for h,a in enumerate(data['xa']):
        if x==a and not(m>>h&1):return True
        if m>>h&1 and a!=x and (data['X'][a]&data['Z'][z]).bit_count()%2:return True
    for h,a in enumerate(data['za']):
        if z==a and not(m>>(h+2)&1):return True
        if m>>(h+2)&1 and a!=z and (data['X'][x]&data['Z'][a]).bit_count()%2:return True
    return False


def star(data,side,probe):
    X,Z=data['X'],data['Z'];near=[j for j in range(720)if ((X[probe]&Z[j])if side=='X'else(X[j]&Z[probe])).bit_count()%2]
    rows=[data['y'][int(side=='Z')][m][probe]for m in range(16)]
    cols=[data['owner'][coord(probe,j)if side=='X'else coord(j,probe)]for j in near]
    assert sum(rows)==sum(cols)
    lower=[];upper=[];lc=[];uc=[]
    for m in range(16):
        ls=[];us=[];ll=[];uu=[]
        for j in near:
            x,z=(probe,j)if side=='X'else(j,probe);vx,vz=data['y'][0][m][x],data['y'][1][m][z];v=vx+vz-data['lam'][m]
            ll.append(int(v>0));ls.append(max(0,v))
            choice='zero'if forbidden(data,m,x,z)else'X'if vx<=vz else'Z'
            uu.append(choice);us.append(0 if choice=='zero'else vx if choice=='X'else vz)
        lower.append(ls);upper.append(us);lc.append(ll);uc.append(uu)
    return near,rows,cols,lower,upper,lc,uc


def symbolic(data,side,probe,near,result,lc,uc):
    out=Counter();row=lambda m:('X'if side=='X'else'Z',m,probe)
    def endpoint(j):return (probe,j)if side=='X'else(j,probe)
    def edge(m,j,choice,w):
        x,z=endpoint(near[j])
        if choice=='lower':
            if lc[m][j]:out['X',m,x]+=w;out['Z',m,z]+=w;out['lambda',m]-=w
        elif uc[m][j]!='zero':out[uc[m][j],m,x if uc[m][j]=='X'else z]+=w
    def column(j,w):out['T',coord(*endpoint(near[j]))]+=w
    kind=result['kind']
    if kind=='edge_lower_above_upper':
        m,j=result['row'],result['column'];edge(m,j,'lower',1);edge(m,j,'upper',-1)
    elif kind=='negative_row_residual':
        m=result['row'];out[row(m)]-=1
        for j in range(len(near)):edge(m,j,'lower',1)
    elif kind=='negative_column_residual':
        j=result['column'];column(j,-1)
        for m in range(16):edge(m,j,'lower',1)
    else:
        assert kind=='deficient_min_cut';M=set(result['row_subset']);J=set(result['column_subset'])
        for m in M:out[row(m)]+=1
        for j in J:column(j,-1)
        for m in range(16):
            for j in range(len(near)):
                if m in M and j not in J:edge(m,j,'upper',-1)
                if m not in M and j in J:edge(m,j,'lower',1)
    out={k:v for k,v in sorted(out.items())if v}
    value=sum(v*(data['lam'][k[1]]if k[0]=='lambda'else data['owner'][k[1]]if k[0]=='T'else data['y'][int(k[0]=='Z')][k[1]][k[2]])for k,v in out.items());assert value>0
    cut=dict(side=side,probe=probe,kind=kind,lambda_coefficients=[],X_coefficients=[],Z_coefficients=[],T_coefficients=[],rhs=0,exact_violation=str(Q(value,data['D'])))
    for k,v in out.items():cut[k[0]+'_coefficients'].append([*k[1:],v])
    proof=dict(neighbors=near,lower_choices=lc,upper_choices=uc,forced_zero_rules='Absent endpoint, selected different X anchor pairing with Z endpoint, or selected different Z anchor pairing with X endpoint.')
    if 'row'in result:proof['row']=result['row']
    if 'column'in result:proof['column']=near[result['column']]
    if 'row_subset'in result:proof['row_subset']=result['row_subset'];proof['column_subset']=[near[j]for j in result['column_subset']]
    cut['proof']=proof;return cut


def main():
    ap=argparse.ArgumentParser()
    for name in ['point','X-allocation','X-receipt','Z-allocation','Z-receipt']:ap.add_argument('--'+name,type=Path,required=True)
    ap.add_argument('--seconds',type=float,default=300);ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();assert 0<a.seconds<=300 and not a.output.exists();start=time.monotonic();deadline=start+a.seconds
    data=load_inputs(a);fpath=a.output.with_suffix('.frozen.json');assert not fpath.exists()
    frozen=dict(status='FROZEN_CONDITIONAL_OWNER_STAR_COHORT',point=str(a.point),point_sha256=sha(a.point),X_allocation=str(a.X_allocation),X_receipt=str(a.X_receipt),Z_allocation=str(a.Z_allocation),Z_receipt=str(a.Z_receipt),X_anchors=data['xa'],Z_anchors=data['za'],source_hashes=data['source_hashes'],seconds_cap=a.seconds,probe_order='X0..719 then Z0..719',common_denominator=str(data['D']),scope='Fixed shared law and both supplied allocations. No law, global moment, source-case or source exclusion.')
    fpath.write_text(json.dumps(frozen,indent=2,sort_keys=True)+'\n');cuts=[];outcomes=[];cuttypes=Counter();done=False
    for side in ['X','Z']:
        for i in range(720):
            if time.monotonic()>deadline:done=True;break
            near,rows,cols,lower,upper,lc,uc=star(data,side,i)
            try:result=bounded_flow(rows,cols,lower,upper,deadline)
            except TimeoutError:done=True;break
            if result['kind']=='feasible':
                record=dict(side=side,probe=i,status='EXACT_STAR_FLOW',neighbors=near,flow=[[m,near[j],str(v)]for m,row in enumerate(result['flow'])for j,v in enumerate(row)if v])
            else:
                k=len(cuts);cuts.append(symbolic(data,side,i,near,result,lc,uc));cuttypes[result['kind']]+=1;record=dict(side=side,probe=i,status='EXACT_STAR_CUT_CANDIDATE',cut_index=k)
            outcomes.append(record)
        if done:break
    out=dict(status='EXACT_CONDITIONAL_OWNER_STAR_CANDIDATES',frozen_sha256=sha(fpath),producer_sha256=sha(__file__),source_hashes=data['source_hashes'],point_sha256=sha(a.point),X_anchors=data['xa'],Z_anchors=data['za'],common_denominator=str(data['D']),cuts=cuts,outcomes=outcomes,probes_checked=len(outcomes),probes_total=1440,cohort_complete=len(outcomes)==1440,cut_kinds=dict(cuttypes),seconds=time.monotonic()-start,source_C16_answered=False,global_target_nonmembership_proved=False,shared_law_nonmembership_proved=False,fixed_allocations_rejected=bool(cuts),scope=frozen['scope'])
    assert all(sha(ROOT/p)==h for p,h in data['source_hashes'].items())
    payload=(json.dumps(out,separators=(',',':'))+'\n').encode();a.output.write_bytes(gzip.compress(payload,mtime=0)if a.output.suffix=='.gz'else payload)
    print(a.output,sha(a.output),len(outcomes),'probes',len(cuts),'cuts',dict(cuttypes),out['seconds'],flush=True)
if __name__=='__main__':main()
