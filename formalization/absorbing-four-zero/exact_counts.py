"""Independent full-incidence checks of the classical and cyclic Pasch formulas."""
from pathlib import Path
import itertools,json,hashlib,collections,importlib.util
R=Path(__file__).resolve().parent
prior_source=R/'prior/first-block/research.py'
if not prior_source.exists(): prior_source=R.parent/'absorbing42/research.py'
spec=importlib.util.spec_from_file_location('prior',prior_source);p=importlib.util.module_from_spec(spec);spec.loader.exec_module(p)

def kernel_collision(cols):
 masks=[sum(1<<r for r in c) for c in cols];assert len(set(masks))==len(masks)
 pairs=collections.Counter(masks[u]^masks[v] for u,v in itertools.combinations(range(len(cols)),2))
 total=sum(x*(x-1)//2 for x in pairs.values());assert total%3==0
 return total//3,dict(pair_count=sum(pairs.values()),syndrome_values=len(pairs),pair_collisions=total)

def root_energy(cols,N=1,P=None):
 cols,rows,owner=p.check_graph(cols);adj=[set().union(*(rows[c] for c in col))-{v} for v,col in enumerate(cols)]
 total=0;roots=0;terms=[]
 roots_to_check=range(len(cols)) if N==1 else [a*N for a in range(P)]
 for u in roots_to_check:
  for v in adj[u]:
   W=(adj[u]&adj[v])-{u,v}
   W={w for w in W if not(cols[u]&cols[v]&cols[w])}
   d=collections.Counter(c for w in W for c in cols[w]);B=cols[u]|cols[v]
   E=sum(k*k for k in d.values());F=sum(d[c]**2 for c in B);t=len(W)
   local=E-F-t
   direct=sum(bool((cols[w]&cols[z])-B) for w,z in itertools.permutations(W,2))
   assert local==direct>=0 and len(W)<=4
   total+=local;roots+=1
   terms.append(dict(u=u,v=v,t=t,energy=E,root_check_energy=F,local=local))
 assert N*total%24==0
 return N*total//24,dict(normalized_roots=roots,lift_size=N,local_sum=total,formula='N/24 * sum(E(W)-F(W)-t)')

def walsh_macwilliams(cols,m):
 assert m<=13
 masks=[sum(1<<r for r in c) for c in cols];n=len(masks);dist=collections.Counter()
 for y in range(1<<m):dist[sum((y&a).bit_count()%2 for a in masks)]+=1
 def K4(w):return sum((-1)**j*__import__('math').comb(w,j)*__import__('math').comb(n-w,4-j) for j in range(5) if j<=w and 4-j<=n-w)
 x=sum(k*K4(w) for w,k in dist.items());assert x%(1<<m)==0
 moment=sum(k*(n-2*w)**4 for w,k in dist.items());assert moment%(1<<m)==0
 q=moment//(1<<m)-3*n*n+2*n;assert q%24==0
 assert q//24==x//(1<<m)
 return x//(1<<m),dict(binary_check_messages=1<<m,weight_four_macwilliams=True,fourth_moment_identity=True)

def main():
 A=p.sts13();B=p.trade13(A);records=[]
 small=[('STS13-prior',A),('STS13-prior-trade',B)]
 fano=sorted({tuple(sorted([x,y,x^y])) for x,y in itertools.combinations(range(1,8),2)})
 # Relabel to contiguous check coordinates for binary Walsh messages.
 small.append(('Fano7',[tuple(x-1 for x in c) for c in fano]))
 pts=[(x,y) for x in range(3) for y in range(3)]
 affine=sorted({tuple(sorted(((x+t*a)%3)*3+(y+t*b)%3 for t in range(3))) for x,y in pts for a,b in pts if (a,b)!=(0,0)})
 small.append(('Affine9',affine))
 for name,cols in small:
  direct,_=p.direct_counts(cols);k,kr=kernel_collision(cols);e,er=root_energy(cols);w,wr=walsh_macwilliams(cols,max(max(c) for c in cols)+1)
  assert direct.get(0,0)==k==e==w
  records.append(dict(name=name,n=len(cols),N40=k,induced_support_enumeration=True,collision=kr,root=er,MacWilliams=wr))
 q=[]
 for name,base in [('STS13-prior',A),('STS13-prior-trade',B)]:
  sockets,cols=p.qc_ghp(base);k,kr=kernel_collision(cols);e,er=root_energy(cols,7,len(sockets));full,_=root_energy(cols)
  assert k==e==full
  expected=7*next(x['N40'] for x in records if x['name']==name)+13*7
  assert k==expected
  q.append(dict(name=name+'-QC-GHP',n=len(cols),checks=91,N40=k,collision=kr,normalized_root=er,full_root_verified=True,pure_fiber_written_identity=expected))
 gram=lambda base:[[sum(r in c and s in c for c in base) for s in range(13)] for r in range(13)]
 assert gram(A)==gram(B)==[[6 if r==s else 1 for s in range(13)] for r in range(13)]
 r=dict(evidence='exact_finite_computation',classical_consumers=records,source_consumers=q,
  equal_base_integer_Gram=True,equal_full_evaluated_complex_M_by_block_identity=True,
  source_credit='STS(13) trade already credited to Jiang et al., arXiv:2605.13690v1 Appendix F.1 in the first block; not a new classical witness.',
  scope='Exact support counts and identities, not a quantum-distance or decoder-performance claim.',
  script_sha256=hashlib.sha256(Path(__file__).read_bytes()).hexdigest())
 (R/'exact-counts.json').write_text(json.dumps(r,indent=2)+'\n');print(json.dumps(r),flush=True)
if __name__=='__main__':main()
