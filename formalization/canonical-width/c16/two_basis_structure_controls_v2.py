"""Independent exact tiny controls for local zonotopes and shared-pattern need."""
from pathlib import Path
from fractions import Fraction as Q
from itertools import combinations,product
import argparse,hashlib,json,random,time
from flint import fmpq_mat,fmpq
from two_basis_structure import zonotope_normals,lambda_values,LOW,HIGH,compose_outer_cut
ROOT=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def matrix(rows):return fmpq_mat([[fmpq(Q(v).numerator,Q(v).denominator) for v in row] for row in rows])
def rank(rows):return matrix(rows).rank() if rows else 0

def exact_box_member(G,lam,b):
    """Enumerate every possible basic feasible preimage, without facet code."""
    n=len(G);q=len(b);r=rank(G)
    if rank(G+[list(b)])>r:return False
    if not r:return not any(b)
    I=[]
    for j in range(q):
        if rank([[g[k] for k in I+[j]] for g in G])>len(I):I.append(j)
        if len(I)==r:break
    for free in combinations(range(n),r):
        M=matrix([[G[j][i] for j in free] for i in I])
        if M.rank()<r:continue
        fixed=[j for j in range(n) if j not in free]
        for ends in product((0,1),repeat=len(fixed)):
            x=[Q(0)]*n
            for j,e in zip(fixed,ends):x[j]=e*lam[j]
            rhs=[b[i]-sum(x[j]*G[j][i] for j in fixed) for i in I];sol=M.solve(matrix([[v] for v in rhs]))
            for k,j in enumerate(free):x[j]=Q(str(sol[k,0]))
            if all(0<=v<=cap for v,cap in zip(x,lam)) and all(sum(x[j]*G[j][i] for j in range(n))==b[i] for i in range(q)):return True
    return False

def normal_member(data,G,lam,b):
    for normal in data['equality_normals']:
        if sum(x*y for x,y in zip(normal,b)):return False
    for normal in data['facet_normals']:
        for sign in (-1,1):
            v=[sign*x for x in normal];left=sum(x*y for x,y in zip(v,b));upper=sum(cap*max(0,sum(x*y for x,y in zip(v,g))) for cap,g in zip(lam,G))
            if left>upper:return False
    return True

def triple_interval(p,Qij,i,j,k):
    a,b,c=[p[t] for t in (i,j,k)];ab,ac,bc=Qij[i][j],Qij[i][k],Qij[j][k]
    return max(Q(0),ab+ac-a,ab+bc-b,ac+bc-c),min(ab,ac,bc,1-a-b-c+ab+ac+bc)

def psd_ldl(M):
    A=[[Q(x) for x in row] for row in M];n=len(A);piv=[]
    for k in range(n):
        p=A[k][k];assert p>=0
        if not p:assert all(A[k][j]==0 for j in range(k,n));piv.append(p);continue
        piv.append(p)
        for i in range(k+1,n):
            for j in range(k+1,n):A[i][j]-=A[i][k]*A[k][j]/p
    return piv

def shared_pattern_counterexample():
    # Six Boolean coordinates A,B,C,D,U,V.  Every one-variable-conditioned
    # sector law is a product of rank-one parallel-pair basis choices.
    t=Q(3,4);p=[Q(1,2)]*4+[Q(1,4)]*2;Qij=[[Q(0)]*6 for _ in range(6)]
    for i in range(6):Qij[i][i]=p[i]
    for i,j in combinations(range(4),2):Qij[i][j]=Qij[j][i]=Q(1,4)
    for a in (0,1):
        for u in (4,5):Qij[a][u]=Qij[u][a]=(1+t)/8
    Qij[2][4]=Qij[4][2]=(1-t)/8;Qij[2][5]=Qij[5][2]=(1+t)/8
    Qij[3][4]=Qij[4][3]=Qij[3][5]=Qij[5][3]=Q(1,8);Qij[4][5]=Qij[5][4]=Q(1,16)
    M=[[Q(1),*p]]+[[p[i],*Qij[i]] for i in range(6)];piv=psd_ldl(M);assert min(piv)>0
    intervals=[triple_interval(p,Qij,*ijk) for ijk in combinations(range(6),3)];assert all(lo<=hi for lo,hi in intervals)
    # Physical rank-six pools, two parallel copies of each coordinate.
    pool=[1<<i for i in range(6) for _ in range(2)];Xa=[0,2];Za=[4,6]
    def selections(bits,side,aux):
        A,B,C,D=bits
        pick=[A,B,1,1,aux,1] if side==0 else [1,1,C,D,1,aux]
        return [2*i+(not value) for i,value in enumerate(pick)]
    laws=[]
    for side in (0,1):
        law=[]
        for bits in product((0,1),repeat=4):
            A,B,C,D=bits
            if (A+B+C)%2==side:law.append((bits,A*B,t/8))
            for u in (0,1):law.append((bits,u,(1-t)/16*(Q(1,4) if u else Q(3,4))))
        assert sum(w for bits,u,w in law)==1
        for a in range(4):assert sum(w*bits[a] for bits,u,w in law)==p[a]
        for a,b in combinations(range(4),2):assert sum(w*bits[a]*bits[b] for bits,u,w in law)==Qij[a][b]
        aux=4+side;assert sum(w*u for bits,u,w in law)==p[aux]
        for a in range(4):assert sum(w*bits[a]*u for bits,u,w in law)==Qij[a][aux]
        for bits,u,w in law:
            B=selections(bits,side,u);assert len(B)==6 and len({pool[j] for j in B})==6
            own=Xa if side==0 else Za;offset=0 if side==0 else 2
            assert all((j in B)==bool(bits[offset+k]) for k,j in enumerate(own))
            opposite=Za if side==0 else Xa;off=2 if side==0 else 0
            for k,j in enumerate(opposite):
                if bits[off+k]:assert sum((pool[j]&pool[z]).bit_count()%2 for z in B)==1
        laws.append(law)
    # A source-valid retained-feature inequality. Its support is exactly zero.
    score=lambda A,B,C,U,V:C*V-C*U+A*U+B*U+A*V+B*V-A*B-U-2*V
    scores=[score(*bits) for bits in product((0,1),repeat=5)];assert max(scores)==0
    gap=Qij[2][5]-Qij[2][4]+Qij[0][4]+Qij[1][4]+Qij[0][5]+Qij[1][5]-Qij[0][1]-p[4]-2*p[5];assert gap==Q(1,16)>0
    # Every physical selector is constant or a bit/complement. Check all
    # singleton-conditioned marginals of the two partition-matroid bases.
    variables=[(0,False),(0,True),(1,False),(1,True),(None,True),(None,False),(None,True),(None,False),(4,False),(4,True),(None,True),(None,False),
               (None,True),(None,False),(None,True),(None,False),(2,False),(2,True),(3,False),(3,True),(None,True),(None,False),(5,False),(5,True)]
    def mean(v):
        i,flip=v
        return Q(flip) if i is None else 1-p[i] if flip else p[i]
    def pair(v,w):
        i,f=v;j,g=w
        if i is None:return Q(f)*mean(w)
        if j is None:return Q(g)*mean(v)
        return (Qij[i][j] if not f and not g else p[j]-Qij[i][j] if f and not g else p[i]-Qij[i][j] if not f and g else 1-p[i]-p[j]+Qij[i][j])
    count=0
    for event in variables:
        if not mean(event):continue
        for side in (0,1):
            q=[pair(event,v)/mean(event) for v in variables[12*side:12*(side+1)]];assert all(0<=v<=1 for v in q) and all(q[2*i]+q[2*i+1]==1 for i in range(6));count+=1
    return {'status':'EXACT_TINY_COMMON_PATTERN_COUNTEREXAMPLE','ambient_dimension':6,'parallel_pool_vectors':pool,'X_anchors':Xa,'Z_anchors':Za,'mixture_parameter':str(t),'Boolean_means':list(map(str,p)),'Boolean_pair_moments':[[str(v) for v in row] for row in Qij],'strict_PSD_LDL_pivots':list(map(str,piv)),'all_base_boolean_triples':len(intervals),'singleton_conditional_partition_basis_laws_checked':count,'separate_sector_exact_laws':[{'records':[{'pattern':sum(b<<i for i,b in enumerate(bits)),'auxiliary_bit':u,'weight':str(w)} for bits,u,w in law]} for law in laws],'separating_inequality':'CV-CU+AU+BU+AV+BV-AB-U-2V<=0','literal_binary_assignments_checked':32,'exact_gap':str(gap),'scope':'Shows separate full-basis sector laws, complete singleton-conditioned matroid rank feasibility, Boolean triples and degree-two PSD do not universally imply a common pattern law. It does not assert nonimplication of every C16-specific point15 row family; the displayed five-variable Boolean inequality may already belong to a stronger family.'}

def main():
    ap=argparse.ArgumentParser();ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();assert not a.output.exists();start=time.monotonic();rng=random.Random(20261030);tests=0;vertices=0
    cohorts=[([],2),([[0,0],[0,0]],2),([[1,2,3],[2,4,6]],3),([[1,0,1],[0,1,1],[1,1,2]],3),([[1,0],[0,1],[1,1]],2),([[1,0,0],[0,1,0],[0,0,1],[1,1,0],[1,0,1]],3),([[1,0,0,0,0],[1,1,0,0,0],[1,0,1,0,0],[1,1,1,0,0]],5)]
    for G,q in cohorts:
        data=zonotope_normals(G,q)
        for caps in ([Q(1)]*len(G),[Q(0) if i%3==0 else Q(1,2) for i in range(len(G))]):
            points=[]
            for ends in product((0,1),repeat=len(G)):
                b=[sum(cap*e*g[i] for cap,e,g in zip(caps,ends,G)) for i in range(q)];points.append(b);vertices+=1
            points.extend([[Q(rng.randrange(-2,6),2) for _ in range(q)] for _ in range(25)])
            for b in points:assert normal_member(data,G,caps,b)==exact_box_member(G,caps,b);tests+=1
    for k in range(32):
        mass=[Q(rng.randrange(1,9)) for _ in range(16)];total=sum(mass);mass=[v/total for v in mass];mu=[sum(mass[m] for m in range(16) if m&s==s) for s in range(16)];assert lambda_values([mu[s] for s in LOW],[mu[s] for s in HIGH])==mass
    rows=[{'h':[int(j==m) for j in range(16)],'feature_terms':[]} for m in range(16) if not(m&1)];normal=compose_outer_cut(rows,[1]*8);assert normal[0]==-1 and normal[1]==1 and sum(v!=0 for v in normal)==2
    rejected=False
    try:compose_outer_cut(rows[:1],[1])
    except AssertionError:rejected=True
    assert rejected
    out={'status':'PASS_EXACT_STRUCTURAL_TINY_CONTROLS','source_C16_answered':False,'consumer_sha256':sha(Path(__file__)),'helper_sha256':sha(ROOT/'two_basis_structure.py'),'exact_box_membership_comparisons':tests,'literal_box_vertices':vertices,'Möbius_controls':32,'uncancelled_high_moment_control_rejected':True,'tiny_joint_counterexample':shared_pattern_counterexample(),'elapsed_seconds':time.monotonic()-start};a.output.write_text(json.dumps(out,indent=2)+'\n');print({k:v for k,v in out.items() if k!='tiny_joint_counterexample'},flush=True)
if __name__=='__main__':main()
