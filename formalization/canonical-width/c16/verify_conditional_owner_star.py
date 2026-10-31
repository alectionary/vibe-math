#!/usr/bin/env python3
"""Independent exact replay of owner-star cuts and flow witnesses.

The producer's max-flow is tested against exhaustive tiny transportation tables;
physical cut acceptance uses only exact source bounds and its saved subsets.
"""
from pathlib import Path
from fractions import Fraction as Q
from collections import Counter
from itertools import product,combinations
from copy import deepcopy
import argparse,gzip,hashlib,json,time

ROOT=Path(__file__).resolve().parent
PASS='PASS_EXACT_CONDITIONAL_OWNER_STAR_CUTS'
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def read(p):
    p=Path(p);v=p.read_bytes();return json.loads(gzip.decompress(v)if p.suffix=='.gz'else v)
def fp(p):return p.with_name(p.name.removesuffix('.json.gz').removesuffix('.json')+'.frozen.json')
def owner(a,b):
    sa,ia,ta=a//720,a%720//16,a%16;sb,ib,tb=b//720,b%720//16,b%16;h=(tb-ta)%16
    if h>8:h,ia,ib=16-h,ib,ia
    if h in[0,8]and ia>ib:ia,ib=ib,ia
    if sa==sb and h==0 and ia==ib:return ia
    return 45+2025*h+45*ia+ib+(18225 if sa!=sb else 0)
def sparse(c):return {k:v for k,v in c.items()if v}
def add(out,row,k=1):
    for j,v in row.items():out[j]+=k*v


def data(bank,frozen):
    from verify_two_sided_full_basis_oracle import point_owner
    assert bank['source_hashes']==frozen['source_hashes']
    assert all(sha(ROOT/p)==h for p,h in bank['source_hashes'].items())
    point=ROOT/frozen['point'];p=point_owner(point);assert sha(point)==bank['point_sha256']==frozen['point_sha256']
    ys=[];fs=[];input_checks=0
    for side in ['X','Z']:
        cp,rp=ROOT/frozen[side+'_allocation'],ROOT/frozen[side+'_receipt'];c,r,f=read(cp),read(rp),read(fp(cp))
        assert r['status']=='PASS_EXACT_DIRECT_COUNT_AND_LISTED_RANK_ROWS'
        assert r['consumer_sha256']==sha(ROOT/'verify_two_basis_rank_geometry_allocation.py')
        assert r['certificate_sha256']==sha(cp)and r['frozen_sha256']==c['frozen_sha256']==sha(fp(cp))
        assert r['point_sha256']==f['point_sha256']==sha(point)and f['side']==side
        assert all(sha(ROOT/k)==h for k,h in f['source_hashes'].items())
        y=[list(map(Q,row))for row in c['exact_allocations']];assert len(y)==16 and all(len(row)==720 for row in y)
        ys.append(y);fs.append(f)
    assert fs[0]['lambda_masses']==fs[1]['lambda_masses'];lam=list(map(Q,fs[0]['lambda_masses']))
    assert len(lam)==16 and min(lam)>=0 and sum(lam)==1
    for k in ['X_anchors','Z_anchors']:assert fs[0][k]==fs[1][k]==bank[k]==frozen[k]
    xa,za=bank['X_anchors'],bank['Z_anchors'];aa=xa+[720+j for j in za]
    for i,a in enumerate(aa):assert sum(lam[m]for m in range(16)if m>>i&1)==p[a%720//16];input_checks+=1
    for i,j in combinations(range(4),2):assert sum(lam[m]for m in range(16)if m>>i&1 and m>>j&1)==p[owner(aa[i],aa[j])];input_checks+=1
    for s,y in enumerate(ys):
        for m,row in enumerate(y):assert min(row)>=0 and max(row)<=lam[m]and sum(row)==128*lam[m];input_checks+=722
        for j in range(720):
            assert sum(y[m][j]for m in range(16))==p[j//16];input_checks+=1
            for h,a in enumerate(aa):assert sum(y[m][j]for m in range(16)if m>>h&1)==p[owner(a,720*s+j)];input_checks+=1
        for h,a in enumerate(xa if s==0 else za):
            for m in range(16):assert y[m][a]==(lam[m]if m>>(h+2*s)&1 else 0);input_checks+=1
    X,Z=[[int(v,16)for v in (ROOT/f'pools/{s}coords.txt').read_text().split()]for s in 'xz']
    symmetry=read(ROOT/'moment-resumption-results/symmetry-bridge-independent.json')
    assert symmetry['status']=='PASS'and symmetry['consumer_sha256']==sha(ROOT/'verify_moment_symmetry_bridge.py')
    assert all(sha(ROOT/k)==h for k,h in symmetry['pool_sha256'].items())
    D=int(bank['common_denominator']);assert str(D)==bank['common_denominator']and D>0 and bank['common_denominator']==frozen['common_denominator']
    assert all((v*D).denominator==1 for v in lam+p+sum(ys[0],[])+sum(ys[1],[]))
    return dict(lam=lam,y=ys,p=p,X=X,Z=Z,xa=xa,za=za,D=D,input_checks=input_checks)


def forbidden(d,m,x,z):
    selectedX=[a for h,a in enumerate(d['xa'])if m&(1<<h)]
    selectedZ=[a for h,a in enumerate(d['za'])if m&(1<<(h+2))]
    if x in d['xa']and x not in selectedX:return True
    if z in d['za']and z not in selectedZ:return True
    return any(a!=x and (d['X'][a]&d['Z'][z]).bit_count()%2 for a in selectedX)or any(a!=z and(d['X'][x]&d['Z'][a]).bit_count()%2 for a in selectedZ)


def star(d,side,probe):
    assert side in['X','Z']and type(probe)is int and 0<=probe<720
    edge=lambda j:(probe,j)if side=='X'else(j,probe)
    near=[j for j in range(720)if(d['X'][edge(j)[0]]&d['Z'][edge(j)[1]]).bit_count()%2]
    rows=[d['y'][side=='Z'][m][probe]for m in range(16)];cols=[d['p'][owner(edge(j)[0],720+edge(j)[1])]for j in near]
    assert sum(rows)==sum(cols)
    lower=[];upper=[];lc=[];uc=[]
    for m in range(16):
        lr=[];ur=[];cl=[];cu=[]
        for j in near:
            x,z=edge(j);xx,zz=d['y'][0][m][x],d['y'][1][m][z];q=xx+zz-d['lam'][m];cl.append(int(q>0));lr.append(max(Q(0),q))
            branch='zero'if forbidden(d,m,x,z)else'X'if xx<=zz else'Z';cu.append(branch);ur.append(Q(0)if branch=='zero'else xx if branch=='X'else zz)
        lower.append(lr);upper.append(ur);lc.append(cl);uc.append(cu)
    return near,rows,cols,lower,upper,lc,uc


def expression(d,cut,near,lc,uc):
    side,i,proof=cut['side'],cut['probe'],cut['proof'];idx={j:k for k,j in enumerate(near)}
    def row(m):return {(side,m,i):1}
    def col(j):
        x,z=(i,j)if side=='X'else(j,i);return {('T',owner(x,720+z)):1}
    def bounds(m,j):
        x,z=(i,j)if side=='X'else(j,i);k=idx[j]
        lo={('X',m,x):1,('Z',m,z):1,('lambda',m):-1}if lc[m][k]else{}
        branch=uc[m][k];up={}if branch=='zero'else{(branch,m,x if branch=='X'else z):1}
        return lo,up
    result=Counter();kind=cut['kind']
    if kind=='edge_lower_above_upper':
        m,j=proof['row'],proof['column'];assert type(m)is int and 0<=m<16 and type(j)is int and j in idx
        lo,up=bounds(m,j);add(result,lo);add(result,up,-1)
    elif kind=='negative_row_residual':
        m=proof['row'];assert type(m)is int and 0<=m<16;add(result,row(m),-1)
        for j in near:add(result,bounds(m,j)[0])
    elif kind=='negative_column_residual':
        j=proof['column'];assert type(j)is int and j in idx;add(result,col(j),-1)
        for m in range(16):add(result,bounds(m,j)[0])
    else:
        assert kind=='deficient_min_cut';M,J=proof['row_subset'],proof['column_subset']
        assert M==sorted(set(M))and J==sorted(set(J))and all(type(m)is int and 0<=m<16 for m in M)and all(type(j)is int and j in idx for j in J)
        # Subtract column conservation from row conservation, then bound
        # outgoing edges above and incoming edges below. No flow code is used.
        for m in M:add(result,row(m))
        for j in J:add(result,col(j),-1)
        for m in range(16):
            for j in near:
                lo,up=bounds(m,j)
                if m in M and j not in J:add(result,up,-1)
                if m not in M and j in J:add(result,lo)
    return sparse(result)


def check_cut(d,c):
    near,rows,cols,lower,upper,lc,uc=star(d,c['side'],c['probe']);proof=c['proof']
    assert proof['neighbors']==near and proof['lower_choices']==lc and proof['upper_choices']==uc
    assert all(type(v)is int for row in proof['lower_choices']for v in row)
    actual=expression(d,c,near,lc,uc);stored={}
    for name,arity in [('lambda',2),('X',3),('Z',3),('T',2)]:
        values=c[name+'_coefficients'];assert isinstance(values,list)and values==sorted(values)
        for term in values:
            assert len(term)==arity and all(type(v)is int for v in term)and term[-1]!=0
            key=(name,*term[:-1]);assert key not in stored;stored[key]=term[-1]
    assert actual==stored and type(c['rhs'])is int and c['rhs']==0
    def value(k):return d['lam'][k[1]]if k[0]=='lambda'else d['p'][k[1]]if k[0]=='T'else d['y'][k[0]=='Z'][k[1]][k[2]]
    gap=sum(v*value(k)for k,v in actual.items());assert type(c['exact_violation'])is str and gap==Q(c['exact_violation'])and gap>0
    return gap


def check_flow(d,o):
    near,rows,cols,lower,upper,lc,uc=star(d,o['side'],o['probe']);assert o['neighbors']==near
    vals=[[Q(0)for j in near]for m in range(16)];index={j:k for k,j in enumerate(near)};seen=set()
    for m,j,n in o['flow']:
        assert type(m)is int and 0<=m<16 and type(j)is int and j in index and(m,j)not in seen;seen.add((m,j))
        assert type(n)is str and str(int(n))==n and int(n)>0;vals[m][index[j]]=Q(int(n),d['D'])
    assert all(lower[m][j]<=vals[m][j]<=upper[m][j]for m in range(16)for j in range(len(near)))
    assert [sum(row)for row in vals]==rows and[sum(vals[m][j]for m in range(16))for j in range(len(near))]==cols
    return len(seen)


def flow_controls():
    # Import only the algorithm under test, then compare with exhaustive
    # integer tables. Physical certificates above never trust this algorithm.
    from conditional_owner_star import bounded_flow
    cases=cuts=feasible=0
    intervals=[(0,0),(0,1),(1,1)]
    for box in product(intervals,repeat=4):
        lower=[[box[2*m+j][0]for j in range(2)]for m in range(2)];upper=[[box[2*m+j][1]for j in range(2)]for m in range(2)]
        possible=set()
        for v in product(*(range(l,u+1)for l,u in box)):possible.add(((v[0]+v[1],v[2]+v[3]),(v[0]+v[2],v[1]+v[3])))
        for dr in product(range(3),repeat=2):
            for dc in product(range(3),repeat=2):
                if sum(dr)!=sum(dc):continue
                r=bounded_flow(list(dr),list(dc),lower,upper);ok=(dr,dc)in possible;assert(r['kind']=='feasible')==ok;cases+=1
                if ok:
                    f=r['flow'];assert tuple(map(sum,f))==dr and tuple(sum(f[m][j]for m in range(2))for j in range(2))==dc;assert all(lower[m][j]<=f[m][j]<=upper[m][j]for m in range(2)for j in range(2));feasible+=1
                else:
                    cuts+=1;k=r['kind']
                    if k=='negative_row_residual':gap=sum(lower[r['row']])-dr[r['row']]
                    elif k=='negative_column_residual':j=r['column'];gap=sum(lower[m][j]for m in range(2))-dc[j]
                    elif k=='edge_lower_above_upper':gap=lower[r['row']][r['column']]-upper[r['row']][r['column']]
                    else:
                        assert k=='deficient_min_cut';M,J=r['row_subset'],r['column_subset'];gap=sum(dr[m]for m in M)-sum(dc[j]for j in J)-sum(upper[m][j]for m in M for j in range(2)if j not in J)+sum(lower[m][j]for m in range(2)if m not in M for j in J)
                    assert gap>0
    scale=(1<<101)+3;r=bounded_flow([scale,scale],[scale,scale],[[0,0],[0,0]],[[scale,0],[0,scale]]);assert r['flow']==[[scale,0],[0,scale]]
    bad=bounded_flow([1],[1],[[2]],[[1]]);assert bad['kind']=='edge_lower_above_upper'
    return dict(exhaustive_2_by2_bounded_transport_cases=cases,feasible=feasible,infeasible=cuts,large_non_dyadic_integer_capacity_bits=scale.bit_length(),invalid_edge_bound_checked=True)


def source_controls():
    def rank(vs):
        piv={}
        for v in vs:
            while v and v.bit_length()in piv:v^=piv[v.bit_length()]
            if v:piv[v.bit_length()]=v
        return len(piv)
    edges=frames=anchor_edges=forced_zeros=0
    for dim in[2,3]:
        pool=list(range(1,1<<dim));bases=[b for b in combinations(range(len(pool)),dim)if rank(pool[j]for j in b)==dim]
        d=dict(X=pool,Z=pool,xa=[0,1],za=[0,1])
        for xs in bases:
            for zs in bases:
                if not all(sum((pool[i]&pool[j]).bit_count()%2 for j in zs)==1 for i in xs):continue
                frames+=1;m=sum(int(a in xs)<<h for h,a in enumerate(d['xa']))+sum(int(a in zs)<<(h+2)for h,a in enumerate(d['za']))
                for x in range(len(pool)):
                    for z in range(len(pool)):
                        if not(pool[x]&pool[z]).bit_count()%2:continue
                        t=int(x in xs and z in zs);xx=int(x in xs);zz=int(z in zs);zero=forbidden(d,m,x,z)
                        assert max(0,xx+zz-1)<=t<=(0 if zero else min(xx,zz));edges+=1;forced_zeros+=zero
                        if t and(x in d['xa']or z in d['za']):anchor_edges+=1;assert not zero
    return dict(actual_tiny_dual_frames=frames,literal_owner_edge_bounds=edges,actual_anchor_owner_edges_preserved=anchor_edges,structural_zero_checks=forced_zeros)


def main():
    ap=argparse.ArgumentParser();ap.add_argument('--bank',type=Path);ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();assert not a.output.exists();start=time.monotonic();controls=flow_controls();physical=source_controls();out=dict(status='PASS_CONDITIONAL_OWNER_STAR_CONTROLS',consumer_sha256=sha(__file__),producer_sha256=sha(ROOT/'conditional_owner_star.py'),flow_controls=controls,physical_controls=physical,source_C16_answered=False,global_target_nonmembership_proved=False,shared_law_nonmembership_proved=False)
    if a.bank:
        b=read(a.bank);fpath=a.bank.with_suffix('.frozen.json');f=read(fpath);assert b['status']=='EXACT_CONDITIONAL_OWNER_STAR_CANDIDATES'and b['frozen_sha256']==sha(fpath)and b['producer_sha256']==sha(ROOT/'conditional_owner_star.py');d=data(b,f)
        gaps=[check_cut(d,c)for c in b['cuts']];flowcount=flowentries=0;used=[]
        assert b['probes_checked']==len(b['outcomes'])and b['cohort_complete']==(len(b['outcomes'])==1440)
        for k,o in enumerate(b['outcomes']):
            assert(o['side'],o['probe'])==('X'if k<720 else'Z',k%720)
            if o['status']=='EXACT_STAR_FLOW':flowentries+=check_flow(d,o);flowcount+=1
            else:
                assert o['status']=='EXACT_STAR_CUT_CANDIDATE';j=o['cut_index'];assert type(j)is int and 0<=j<len(b['cuts']);c=b['cuts'][j];assert(c['side'],c['probe'])==(o['side'],o['probe']);used.append(j)
        assert sorted(used)==list(range(len(b['cuts'])))
        rejected=[]
        if b['cuts']:
            base=b['cuts'][0]
            mutations=[('rhs',lambda c:c.update(rhs=1)),('gap',lambda c:c.update(exact_violation='0')),('coefficient',lambda c:c['lambda_coefficients'].append([0,999])),('bad_lower',lambda c:c['proof']['lower_choices'][0].__setitem__(0,2)),('bad_upper',lambda c:c['proof']['upper_choices'][0].__setitem__(0,'INVALID')),('probe',lambda c:c.update(probe=-1)),('neighbor',lambda c:c['proof']['neighbors'].append(-1))]
            for label,mutate in mutations:
                bad=deepcopy(base);mutate(bad)
                try:check_cut(d,bad)
                except(AssertionError,KeyError,IndexError,TypeError,ValueError):rejected.append(label)
                else:raise AssertionError(('corrupt star cut accepted',label))
        flow=next((o for o in b['outcomes']if o['status']=='EXACT_STAR_FLOW'and o['flow']),None)
        if flow:
            for label in ['duplicate_flow','changed_flow']:
                bad=deepcopy(flow)
                if label=='duplicate_flow':bad['flow'].append(bad['flow'][0])
                else:bad['flow'][0][2]=str(int(bad['flow'][0][2])+1)
                try:check_flow(d,bad)
                except AssertionError:rejected.append(label)
                else:raise AssertionError(('corrupt flow accepted',label))
        out.update(status=PASS,bank_sha256=sha(a.bank),frozen_sha256=sha(fpath),source_hashes=b['source_hashes'],point_sha256=b['point_sha256'],X_anchors=b['X_anchors'],Z_anchors=b['Z_anchors'],cuts_checked=len(gaps),flows_checked=flowcount,flow_positive_entries_checked=flowentries,probes_checked=len(b['outcomes']),cohort_complete=b['cohort_complete'],input_target_and_box_checks=d['input_checks'],minimum_exact_gap=str(min(gaps))if gaps else None,maximum_exact_gap=str(max(gaps))if gaps else None,cut_kinds=dict(Counter(c['kind']for c in b['cuts'])),corruptions_rejected=rejected,fixed_allocations_rejected=bool(gaps),scope='Each cut is a source-valid linear inequality in conditional lambda/y and unconditional T, and strictly rejects the supplied allocation. Each flow checks only that individual star. No fixed-law, global moment, sourcecase or source exclusion follows.')
    out['seconds']=time.monotonic()-start;a.output.write_text(json.dumps(out,indent=2,sort_keys=True)+'\n');print(a.output,sha(a.output),out['status'],out.get('cuts_checked'),out.get('flows_checked'),out['seconds'],flush=True)
if __name__=='__main__':main()
