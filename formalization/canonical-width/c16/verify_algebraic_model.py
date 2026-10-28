#!/usr/bin/env python3
"""Independent physical binding and degree-two certificate/moment replay.

No discovery encoder, C++ elimination, SAT solver or numerical library used.
Positive formal moments certify ONLY the explicitly specified low-degree row
span has no contradiction; they need not be moments of a feasible matching.
"""
from pathlib import Path
import argparse,hashlib,json,time
from verify_partial_frame import mask,shift
from audit_pools import exchange
ROOT=Path(__file__).resolve().parent

def physical():
 source=json.loads((ROOT/'physical-pool-source.json').read_text());Zp=[shift(mask(s),h) for s in source['Z_orbit_representatives'] for h in range(16)];Xp=list(map(exchange,Zp));beta=lambda x,z:(x&z).bit_count()%2
 seeds={s:[shift(mask(seed[s]),h) for seed in source['canonical_seeds'] for h in range(16)] for s in ['X','Z']};assert all(beta(x,z)==(i==j) for i,x in enumerate(seeds['X']) for j,z in enumerate(seeds['Z']))
 X=[sum(beta(x,z)<<i for i,z in enumerate(seeds['Z'])) for x in Xp];Z=[sum(beta(x,z)<<i for i,x in enumerate(seeds['X'])) for z in Zp];A=[sum(beta(x,z)<<j for j,z in enumerate(Zp)) for x in Xp];assert all(beta(X[i],Z[j])==bool(A[i]>>j&1) for i in range(720) for j in range(720));return X,Z,A

def domain(data):
 X,Z,A=physical();par=lambda u,v:(u&v).bit_count()%2;eq=[(int(u,16),int(v,16)) for u,v in data['equation_uv_hex']];a,b=data['anchor'];assert A[a]>>b&1
 target=sum((par(u,v)^par(X[a],v)*par(u,Z[b]))<<k for k,(u,v) in enumerate(eq));assert target==int(data['target_hex'],16)
 sx=[sum(par(x,v)<<k for k,(u,v) in enumerate(eq)) for x in X];sz=[sum(par(u,z)<<k for k,(u,v) in enumerate(eq)) for z in Z];R=None if data['removed_classes'] is None else set(map(tuple,data['removed_classes']))
 def canon(i,j):return min((i//16,j//16,(j-i)%16),(j//16,i//16,(i-j)%16))
 E=[(i,j,sx[i]&sz[j]) for i in range(720) if i!=a and not A[i]>>b&1 for j in range(720) if j!=b and not A[a]>>j&1 and A[i]>>j&1 and sx[i]&sz[j] and (R is None or canon(i,j) in R)];assert len(E)==data['free_edges'];raw=(f'{len(E)} {len(eq)}\n{target:x}\n'+'\n'.join(f'{row:x}' for row in A)+'\n'+'\n'.join(f'{i} {j} {s:x}' for i,j,s in E)+'\n').encode();assert hashlib.sha256(raw).hexdigest()==data['input_sha256'];return A,E,target,len(eq)

def replay(A,E,t,r,d):
 n=len(E);assert d['free_edges']==n and d['equations']==r
 def compat(i,j):
  x,z,_=E[i];xx,zz,_=E[j];return i!=j and (not d.get("one_per_signature",False) or E[i][2]!=E[j][2]) and x!=xx and z!=zz and not A[x]>>zz&1 and not A[xx]>>z&1
 def mon(i,j):return i+1 if i==j else ((max(i,j)+1)<<32)|(min(i,j)+1)
 def row(code):
  if code<r:return {0 for _ in [0] if t>>code&1}|{i+1 for i,(_,_,s) in enumerate(E) if s>>code&1}
  i,k=divmod(code-r,r);assert 0<=i<n
  v={i+1} if t>>k&1 else set()
  for j,(_,_,s) in enumerate(E):
   if s>>k&1 and (j==i or compat(i,j)):
    q=mon(i,j)
    if q in v:v.remove(q)
    else:v.add(q)
  return v
 proof=d['contradiction_row_codes']
 if proof:
  assert len(proof)==len(set(proof));p=set()
  for code in proof:p.symmetric_difference_update(row(code))
  assert p=={0};return {'outcome':'QUOTIENT_POLYNOMIAL_CONTRADICTION','source_rows_checked':len(proof)}
 moments=d['formal_moment_ones'];assert len(moments)==len(set(moments));linear=set();q=[]
 for v in moments:
  if v<=n:assert v>0;linear.add(v-1)
  else:
   i=(v&((1<<32)-1))-1;j=(v>>32)-1;assert 0<=i<j<n and compat(i,j);q.append((i,j))
 value=0;Q=[0]*n
 for i in linear:value^=E[i][2];Q[i]^=E[i][2]
 assert value==t,'linear equations fail'
 for i,j in q:Q[i]^=E[j][2];Q[j]^=E[i][2]
 multipliers=d['complete_multiplier_indices'];assert len(multipliers)==len(set(multipliers))==d['complete_multipliers']
 for i in multipliers:assert 0<=i<n and Q[i]==(t if i in linear else 0),(i,Q[i])
 return {'outcome':'FORMAL_BINARY_MOMENT_FEASIBLE','linear_moments_one':len(linear),'quadratic_moments_one':len(q),'complete_multipliers_checked':len(multipliers),'all_degree_two_variable_multipliers':set(multipliers)==set(range(n)),'scope':'Feasible formal binary moments, not a compatible matching or distribution. Only the listed linear/variable-multiplied parity equations modulo Boolean and incompatibility relations are certified consistent.'}

def replay_separated(A,E,t,r,d):
 n=len(E);assert d['free_edges']==n and d['equations']==r and d['monomial_radix_bits']==16;degree=d['max_degree'];assert degree in [2,3]
 def decode(m):
  v=[]
  while m:v.append((m&65535)-1);m>>=16
  assert v==sorted(set(v)) and all(0<=i<n for i in v)
  return tuple(v)
 def enc(ids):
  value=0
  for i in sorted(set(ids),reverse=True):value=(value<<16)|(i+1)
  return value
 def compatible(ids):
  for q,i in enumerate(ids):
   x,z,si=E[i]
   for j in ids[:q]:
    xx,zz,sj=E[j]
    if x==xx or z==zz or A[x]>>zz&1 or A[xx]>>z&1 or (d.get('one_per_signature',False) and si==sj):return False
  return True
 def row(code):
  mask,k=divmod(code,r);ids=decode(mask);assert len(ids)<=degree-1 and compatible(ids)
  out={mask} if t>>k&1 else set()
  for j,(_,_,sig) in enumerate(E):
   if sig>>k&1:
    term=tuple(sorted(set(ids+(j,))))
    if compatible(term):
     m=enc(term)
     if m in out:out.remove(m)
     else:out.add(m)
  return out
 proof=d['contradiction_row_codes']
 if proof:
  assert len(proof)==len(set(proof));out=set()
  for code in proof:out.symmetric_difference_update(row(code))
  assert out=={0}
  return {'outcome':'QUOTIENT_POLYNOMIAL_CONTRADICTION','max_degree':degree,'source_rows_checked':len(proof),'scope':'Contradiction for the stated parity necessity domain and optional signature normalization. Not an original full-case exclusion when removed-class restrictions are present.'}
 assert d['status'] in ['COMPLETE_CUBIC_MOMENT_FEASIBLE','COMPLETE_QUADRATIC_MOMENT_FEASIBLE']
 moment_ids=d['formal_moment_ones'];assert len(moment_ids)==len(set(moment_ids));linear=[0]*n;quadratic={};base=0;counts=[0,0,0]
 def accum(pair,value):quadratic[pair]=quadratic.get(pair,0)^value
 for m in moment_ids:
  ids=decode(m);assert 1<=len(ids)<=degree and compatible(ids);counts[len(ids)-1]+=1
  if len(ids)==1:
   i=ids[0];base^=E[i][2];linear[i]^=t^E[i][2]
  elif len(ids)==2:
   i,j=ids;linear[i]^=E[j][2];linear[j]^=E[i][2]
   if degree==3:accum((i,j),t^E[i][2]^E[j][2])
  else:
   i,j,k=ids;accum((i,j),E[k][2]);accum((i,k),E[j][2]);accum((j,k),E[i][2])
 assert base==t and not any(linear) and not any(quadratic.values()),'global moment equation fails'
 return {'outcome':'GLOBAL_FORMAL_BINARY_MOMENT_FEASIBLE','max_degree':degree,'linear_moments_one':counts[0],'quadratic_moments_one':counts[1],'cubic_moments_one':counts[2],'all_variable_multipliers_checked':n,'all_compatible_pair_multipliers_checked_implicitly':degree==3,'scope':'Full indicated degree moment equations checked through sparse residual accumulation, including all omitted zero moments. Not a distribution or matching; this only blocks a certificate at that fixed Nullstellensatz degree.'}

def main():
 ap=argparse.ArgumentParser();ap.add_argument('--domain',type=Path,required=True);ap.add_argument('--certificate',type=Path,required=True);ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();start=time.monotonic();metadata=json.loads(a.domain.read_text());A,E,t,r=domain(metadata);d=json.loads(a.certificate.read_text());answer=(replay_separated(A,E,t,r,d) if d.get("monomial_radix_bits")==16 else replay(A,E,t,r,d))
 if d['formal_moment_ones']:
  bad=json.loads(json.dumps(d));bad['formal_moment_ones']=[]
  try:(replay_separated(A,E,t,r,bad) if d.get("monomial_radix_bits")==16 else replay(A,E,t,r,bad))
  except AssertionError:negative=True
  else:negative=False
  assert negative,'empty pseudo-moment certificate accepted'
 else:negative=None
 out={'status':'PASS','source_C16_answered':False,'physical_pairings_rebuilt':518400,'input_sha256':metadata['input_sha256'],**answer,'empty_moment_negative_control_rejected':negative,'elapsed_seconds':time.monotonic()-start};a.output.write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(out,indent=2))
if __name__=='__main__':main()
