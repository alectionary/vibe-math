import sys,json,itertools,time
from pathlib import Path
ROOT=Path(__file__).parent
sys.path.insert(0,str(ROOT))
from inflate_inverse_lift import mm,transpose,inv,adjoint,rowcol,smul,sadd,sinverse,sunit,rotate_s,ONE,ZERO
source=json.load(open(ROOT/'inversion-results/normal-form.json'));q=source['dictionary'];A=[[tuple(s) for s in v] for v in q['X_left_dictionary']];B=[[tuple(s) for s in v] for v in q['X_right_factors']];C=[[tuple(s) for s in v] for v in q['Z_left_factors']];D=[[tuple(s) for s in v] for v in q['Z_right_dictionary']]
def tau(s,k,conj):
 a,b=s
 if conj:a^=b
 return tuple(sum((w>>h&1)<<((k*h)%16) for h in range(16)) for w in [a,b])
def tv(v,k,conj):return [tau(s,k,conj) for s in v]
def apply(M,v):return [rowcol(r,v) for r in M]
def scale(s,v):return [smul(s,x) for x in v]
def det(v,w):return sadd(smul(v[0],w[1]),smul(v[1],w[0]))
def ratio(v,w):
 j=next(j for j,s in enumerate(w) if sunit(s));r=smul(v[j],sinverse(w[j]));return r if sunit(r) and scale(r,w)==v else None
def mono(s):return s[1]==0 and s[0]!=0 and s[0]&(s[0]-1)==0
def projective_frame(U):
 M=transpose(U[:2]);coordinates=apply(inv(M),U[2]);assert all(map(sunit,coordinates));return transpose([scale(s,v) for s,v in zip(coordinates,U[:2])])
def thin_maps(V,k,conj):
 W=[tv(v,k,conj) for v in V];base=projective_frame([W[j] for j in [0,3,4]]);out=[]
 for images in itertools.permutations(range(5),3):
  if not all(sunit(det(V[i],V[j])) for i,j in itertools.combinations(images,2)):continue
  H=mm(projective_frame([V[j] for j in images]),inv(base));perm=[];scalars=[]
  for w in W:
   v=apply(H,w);hits=[(j,ratio(v,z)) for j,z in enumerate(V)];hits=[(j,r) for j,r in hits if r is not None]
   if len(hits)!=1:break
   j,r=hits[0];perm.append(j);scalars.append(r)
  if len(perm)!=5 or len(set(perm))!=5:continue
  alpha=scalars[0]
  if not all(mono(smul(r,sinverse(alpha))) for r in scalars):continue
  H=[[smul(sinverse(alpha),s) for s in row] for row in H];out.append((H,perm))
 return out

def thick_maps(M,V,k,conj):
 W=[apply(M,tv(v,k,conj)) for v in V];options=[]
 for v in V:
  alpha=ratio(W[0],v)
  if alpha is None:continue
  perm=[];phases=[]
  for w in W:
   hits=[(j,r) for j,z in enumerate(V) if (r:=ratio(w,z)) is not None and mono(smul(r,sinverse(alpha)))]
   if len(hits)!=1:break
   j,r=hits[0];perm.append(j);phases.append(smul(r,sinverse(alpha))[0].bit_length()-1)
  if len(perm)==len(V) and len(set(perm))==len(V):options.append((alpha,perm,phases))
 return options
out=[];diagnostic=[];start=time.monotonic()
for k in [1,3,5,7,9,11,13,15]:
 for conj in [False,True]:
  rights=thin_maps(B,k,conj);lefts=thin_maps(C,k,conj);diagnostic.append({'power':k,'conjugate':conj,'thin_maps':[len(rights),len(lefts)]})
  for H,bperm in rights:
   for sigma,dperm,dp in thick_maps(inv(adjoint(H)),D,k,conj):
    for J,cperm in lefts:
     G=inv(adjoint(J))
     for rho,aperm,ap in thick_maps(G,A,k,conj):
      # Correct the right transform by rho^-1; the dual right factor gains rho*.
      if not mono(smul(tau(rho,15,False),sigma)):continue
      HH=[[smul(sinverse(rho),s) for s in row] for row in H]
      out.append({'power':k,'field_conjugation':conj,'G':G,'H':HH,'X_thin_permutation':bperm,'Z_thin_permutation':cperm,'X_thick_permutation':aperm,'Z_thick_permutation':dperm})
      print('FOUND',k,conj,bperm,cperm,flush=True)
r={'status':'BOUNDED_FACTOR_AUTOMORPHISM_ENUMERATION','automorphisms':out,'diagnostics':diagnostic,'seconds':time.monotonic()-start,'source_C16_answered':False};Path(sys.argv[1]).write_text(json.dumps(r,indent=2)+'\n');print(json.dumps({'count':len(out),'seconds':r['seconds']}),flush=True)
