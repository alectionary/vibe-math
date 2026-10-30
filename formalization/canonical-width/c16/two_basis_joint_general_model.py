"""Exact sparse semantic model for both sectors and all five shared high moments.

No optimization. Only structural forced/deleted coordinates are eliminated;
no face fixed at one chosen law is used. Expressions have two sparse parts:
(target_feature_coefficients, reduced_variable_coefficients). Every inequality
is expression<=0. Exact nonnegative combinations yield valid target rows once
all reduced-variable coefficients cancel.
"""
from pathlib import Path
from fractions import Fraction as Q
import gzip,hashlib,json
from verify_two_sided_full_basis_oracle import physical_source,domains,rank,target
from two_basis_structure import lambda_transform,LOW,HIGH
ROOT=Path(__file__).resolve().parent
LAYOUT='1,P[4],PP[6lex],U[X720,Z720],P_U[4,1440].ravel(C)'

def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def read(p):
 p=Path(p);return json.loads(gzip.decompress(p.read_bytes()) if p.suffix=='.gz' else p.read_bytes())
def empty():return ({},{})
def term(which,index,value=1):
 z=empty();z[which][index]=Q(value);return z

def plus(a,b,c=Q(1)):
 result=(dict(a[0]),dict(a[1]));c=Q(c)
 for side in [0,1]:
  for k,v in b[side].items():
   w=result[side].get(k,Q(0))+c*v
   if w:result[side][k]=w
   else:result[side].pop(k,None)
 return result

def scale(e,c):return plus(empty(),e,c)
def encoded(e):return [[[i,str(v)] for i,v in sorted(d.items())] for d in e]
def decoded(e):return tuple({int(i):Q(v) for i,v in part} for part in e)
def value(e,features,variables):return sum((v*features[i] for i,v in e[0].items()),Q(0))+sum((v*variables[i] for i,v in e[1].items()),Q(0))
def rref_map(A):
 """Return RREF(A), invertible row-operation matrix, and pivot columns."""
 A=[list(map(Q,row)) for row in A];T=[[Q(i==j) for j in range(5)] for i in range(5)];piv=[];row=0;n=len(A[0])
 for j in range(n):
  k=next((k for k in range(row,5) if A[k][j]),None)
  if k is None:continue
  A[k],A[row]=A[row],A[k];T[k],T[row]=T[row],T[k];v=A[row][j];A[row]=[z/v for z in A[row]];T[row]=[z/v for z in T[row]]
  for k in range(5):
   if k!=row and A[k][j]:
    v=A[k][j];A[k]=[z-v*w for z,w in zip(A[k],A[row])];T[k]=[z-v*w for z,w in zip(T[k],T[row])]
  piv.append(j);row+=1
  if row==5:break
 return A,T,piv

def status_list(dd,j):
 out=[]
 for d in dd:
  allowed=set(d['zero_forced']+d['zero_free']+[k for B in d['bins'] for k in B]);out.append(1 if j in d['forced'] else 0 if j in allowed else -1)
 return out

def bank_rows(specs,side,U,dd,xx,zz):
 rows={};sources={};bindings=[]
 for bank,receipt in specs:
  b,q=read(ROOT/bank),read(ROOT/receipt);assert q['bank_sha256']==sha(ROOT/bank);assert [b[k] for k in ['side','X_anchors','Z_anchors']]==[side,xx,zz];sources.update(b['source_hashes']);sources[bank]=sha(ROOT/bank);sources[receipt]=sha(ROOT/receipt)
  if q['status']=='PASS_COMPLETE_CONTRACTED_RANK_LE_3_GEOMETRY':
   assert q['consumer_sha256']==sha(ROOT/'two_basis_structure_verify_small_geometry.py') and q['patterns_checked']==16;rr=b['rows'];consumer='two_basis_structure_verify_small_geometry.py'
  else:
   assert q['status']=='PASS_EXACT_PHYSICAL_CONDITIONAL_CLOSED_RANK_ROWS' and q['consumer_sha256']==sha(ROOT/'two_basis_structure_verify_physical_closed_rank_bank.py');rr=b['cuts'];consumer='two_basis_structure_verify_physical_closed_rank_bank.py'
  sources[consumer]=sha(ROOT/consumer);bindings.append(dict(bank=bank,bank_sha256=sha(ROOT/bank),receipt=receipt,receipt_sha256=sha(ROOT/receipt)))
  for r in rr:
   m,F,S,k=(r[x] for x in ['mask','forced_zero_indices','indices','contraction_rank']);assert F==dd[m]['zero_forced'] and S==sorted(set(S)) and set(S)<=set(dd[m]['zero_free']);assert rank(U[j] for j in F)==len(F) and rank(U[j] for j in F+S)-len(F)==k;key=(m,tuple(F),tuple(S),k);rows[key]=dict(mask=m,forced_zero_indices=F,indices=S,contraction_rank=k)
 assert all(sha(ROOT/p)==h for p,h in sources.items())
 return [rows[k] for k in sorted(rows)],sources,bindings

def prepare(point,bank_specs):
 X,Z,_=physical_source();xx,zz=[80,512],[186,433];ds=domains(X,Z,xx,zz);features=target(point,xx,zz);assert len(features)==7211;L,C=lambda_transform();variables=[dict(kind='tau',mask=m) for m in HIGH];lam=[]
 for m in range(16):lam.append(({i:Q(v) for i,v in enumerate(L[m]) if v},{i:Q(v) for i,v in enumerate(C[m]) if v}))
 sectors={};eq=[];ub=[dict(kind='lambda_nonnegative',mask=m) for m in range(16)];sources={};bindings={};cache={};local_controls=0
 for side,U in [('X',X),('Z',Z)]:
  dd=[d[side] for d in ds];assert all(d['feasible'] for d in dd);E=[[None]*720 for _ in range(16)];residual=[];stats=[];off=720*int(side=='Z');start=len(variables)
  for j in range(720):
   ss=status_list(dd,j);F=[m for m in range(16) if ss[m]==0];key=tuple(F)
   if key not in cache:
    A=[[Q(1 if i==0 else (m>>(i-1))&1) for m in F] for i in range(5)];RR,T,piv=rref_map(A);assert all(RR[i][j]==sum(T[i][k]*A[k][j] for k in range(5)) for i in range(5) for j in range(len(F)));cache[key]=(RR,T,piv)
   RR,T,piv=cache[key];free=[k for k in range(len(F)) if k not in piv];rhs=[]
   for i in range(5):
    fidx=11+off+j if i==0 else 1451+1440*(i-1)+off+j;e=term(0,fidx)
    for m in range(16):
     if ss[m]==1 and (i==0 or m>>(i-1)&1):e=plus(e,lam[m],-1)
    rhs.append(e)
   transformed=[]
   for i in range(5):
    e=empty()
    for k in range(5):e=plus(e,rhs[k],T[i][k])
    transformed.append(e)
   for m,s in enumerate(ss):
    if s==-1:E[m][j]=empty()
    elif s==1:E[m][j]=lam[m]
   for k in free:
    E[F[k]][j]=term(1,len(variables));variables.append(dict(kind='allocation',side=side,index=j,mask=F[k]))
   for i,k in enumerate(piv):
    e=transformed[i]
    for q in free:e=plus(e,E[F[q]][j],-RR[i][q])
    E[F[k]][j]=e
   for i in range(len(piv),5):
    assert not any(RR[i]);residual.append(transformed[i]);eq.append(dict(kind='local_consistency',side=side,local_index=len(residual)-1,index=j,moment=i))
   # Exact symbolic round-trip, including target coefficients and shared tau.
   for i in range(5):
    e=empty()
    for m in range(16):
     if i==0 or m>>(i-1)&1:e=plus(e,E[m][j])
    fidx=11+off+j if i==0 else 1451+1440*(i-1)+off+j;e=plus(e,term(0,fidx),-1)
    if len(piv)==5:assert e==empty()
    else:assert not e[1] # Only source-valid target identities remain for own anchors.
    local_controls+=1
   stats.append(dict(index=j,free_pattern_count=len(F),local_moment_rank=len(piv),local_variables=len(free),pivot_patterns=[F[k] for k in piv]))
  rr,src,bound=bank_rows(bank_specs[side],side,U,dd,xx,zz);sources.update(src);bindings[side]=bound
  sectors[side]=dict(allocations=E,local_consistency=residual,local_metadata=stats,rank_rows=rr,local_variable_count=len(variables)-start,domains=[dict(zero_forced=d['zero_forced'],zero_free=d['zero_free'],zero_required=d['zero_required'],bins=d['bins'],forced=d['forced'],absent=d['absent']) for d in dd])
  for m,d in enumerate(dd):
   eq.append(dict(kind='zero_bucket',side=side,mask=m))
   for k in range(len(d['bins'])):eq.append(dict(kind='owner_bucket',side=side,mask=m,owner=k))
   for j in range(720):
    for bound in ['lower','upper']:ub.append(dict(kind='box',side=side,mask=m,index=j,bound=bound))
  for k in range(len(rr)):ub.append(dict(kind='rank',side=side,rank_index=k))
 for p in ['two_basis_joint_general_model.py','two_basis_structure.py','verify_two_sided_full_basis_oracle.py','verify_algebraic_model.py','physical-pool-source.json','pools/xcoords.txt','pools/zcoords.txt']:sources[p]=sha(ROOT/p)
 sources[str(point)]=sha(point);assert len(variables)==13393 and [sectors[s]['local_variable_count'] for s in 'XZ']==[6938,6450]
 return dict(status='FROZEN_GENERAL_SHARED_LAW_ALLOCATION_MODEL',feature_layout=LAYOUT,feature_count=7211,point_path=str(point),point_sha256=sha(point),X_anchors=xx,Z_anchors=zz,high_masks=HIGH,variables=variables,lambda_expressions=lam,sectors=sectors,equalities=eq,inequalities=ub,source_hashes=sources,rank_bank_bindings=bindings,structural_only_elimination=True,fixed_law_faces_used=False,symbolic_feature_roundtrip_checks=local_controls,lp_run=False,source_C16_answered=False),features

def row_expression(model,descriptor):
 k=descriptor['kind'];lam=model['lambda_expressions']
 if k=='lambda_nonnegative':return scale(lam[descriptor['mask']],-1)
 s=model['sectors'][descriptor['side']];E=s['allocations']
 if k=='local_consistency':return s['local_consistency'][descriptor['local_index']]
 if k=='box':
  m,j=descriptor['mask'],descriptor['index'];return scale(E[m][j],-1) if descriptor['bound']=='lower' else plus(E[m][j],lam[m],-1)
 if k=='rank':
  r=s['rank_rows'][descriptor['rank_index']];m=r['mask'];indices=r['indices'];required=r['contraction_rank']
 else:
  m=descriptor['mask'];d=s['domains'][m]
  if k=='zero_bucket':indices=d['zero_forced']+d['zero_free'];required=d['zero_required']
  else:assert k=='owner_bucket';indices=d['bins'][descriptor['owner']];required=1
 e=scale(lam[m],-required)
 for j in indices:e=plus(e,E[m][j])
 return e

def encode_model(model):
 out=dict(model);out['lambda_expressions']=[encoded(e) for e in model['lambda_expressions']];out['sectors']={}
 for side,s in model['sectors'].items():
  z=dict(s);z['allocations']=[[encoded(e) for e in row] for row in s['allocations']];z['local_consistency']=[encoded(e) for e in s['local_consistency']];out['sectors'][side]=z
 return out

def decode_model(model):
 out=dict(model);out['lambda_expressions']=[decoded(e) for e in model['lambda_expressions']];out['sectors']={}
 for side,s in model['sectors'].items():
  z=dict(s);z['allocations']=[[decoded(e) for e in row] for row in s['allocations']];z['local_consistency']=[decoded(e) for e in s['local_consistency']];out['sectors'][side]=z
 return out

def exact_combination(model,equality_multipliers,inequality_multipliers):
 """Source-valid feature inequality once all free variables cancel exactly."""
 out=empty()
 for kind,multipliers in [('equalities',equality_multipliers),('inequalities',inequality_multipliers)]:
  for i,w in multipliers:
   w=Q(w);assert kind=='equalities' or w>=0;out=plus(out,row_expression(model,model[kind][i]),w)
 assert not out[1],'Uncancelled tau/allocation variables: no target-only cut'
 return out[0] # Sum(coeff*features)<=0, separated iff exact value>0.
