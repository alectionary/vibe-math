from pathlib import Path
import numpy as np,json,hashlib,time
W=Path(__file__).resolve().parent

def rank(rows):
 piv={}
 for row in rows:
  x=sum(int(a)<<j for j,a in enumerate(row))
  while x:
   i=x.bit_length()-1
   if i in piv:x^=piv[i]
   else:piv[i]=x;break
 return len(piv)

def model(n,S):
 A=np.zeros((n,n),dtype=np.int16)
 for c in range(n):
  for j in range(n):A[c,j]=int((c-j)%n in S)
 return A,np.concatenate([A,A.T],axis=1),np.concatenate([A,A],axis=1)
out=[]
for t in range(1,9):
 n=39*t;A,H,B=model(n,{0,1,4,6});Z=np.concatenate([A.T,A.T],axis=1)
 gram=H@H.T;word=np.zeros(2*n,dtype=np.int16);word[[0,n-5,n-4,n+1,n+5,n+6]]=1
 D=H.T@H;np.fill_diagonal(D,0)
 cf=np.fft.fft(np.array([int(i in {0,1,4,6})for i in range(n)]));eigs=np.sort(2*abs(cf)**2)[::-1];eta=float(eigs[1]);den=32-eta
 row=dict(t=t,lift=n,variables=2*n,checks=n,column_weights=sorted(set(map(int,H.sum(axis=0)))),row_weights=sorted(set(map(int,H.sum(axis=1)))),css=bool(np.all((H@H.T)%2==0)),bad_css=bool(np.all((B@Z.T)%2==0)),gram_equal=bool(np.array_equal(gram,B@B.T)),within_max=int(max(D[:n,:n].max(),D[n:,n:].max())),cross_max=int(D[:n,n:].max()),six_selected_degrees=sorted(set(map(int,H@word))),six_stopping=bool(np.all((H@word)!=1)),six_kernel=bool(np.all((H@word)%2==0)),six_left_weight=int(word[:n].sum()),hz_rows_left_weights=sorted(set(map(int,H[:,:n].sum(axis=1)))),eta_illustration=eta,zhu_bit_illustration=2*n*(8-eta)/den,zhu_parity_illustration=4*n*(14-eta)/(8*den),matrix_sha256=hashlib.sha256(H.astype('uint8').tobytes()).hexdigest())
 if t<=3:
  rr=rank(H);row.update(rank_HX=rr,encoded_qubits_diagnostic=2*n-2*rr,word_outside_rowspan=rank(np.vstack([H,word]))==rr+1)
 if t==1:row['dense_vs_fft_max_error']=float(np.max(abs(np.linalg.eigvalsh(gram.astype(float))[::-1]-eigs)))
 assert row['css']and row['bad_css']and row['gram_equal']and row['six_stopping']and row['six_kernel']
 out.append(row)
powers=[]
for gamma in [2,4,6,8]:
 n=3**gamma;S={3**i for i in range(gamma)}
 sums={}
 for a in S:
  for b in S:
   k=(a+b)%n;sums.setdefault(k,set()).add(tuple(sorted([a,b])))
 assert all(len(v)==1 for v in sums.values())
 powers.append(dict(gamma=gamma,lift=n,support=sorted(S),distinct_card=len(S),sidon=True,proved_incidence_ceiling=(2*(gamma+1)+2)//3,classical_uniform_ceiling=(gamma+1)//2+1))
j=dict(status='passed',scope='Independent integer matrices t1..8, exact binary/Gram checks and diagnostic FFT. Rank and floating-point entries are computations, not additional Lean theorem claims.',families=out,powers=powers)
(W/'crosscheck.json').write_text(json.dumps(j,indent=2)+'\n');print(json.dumps(dict(base=out[0],powers=powers),indent=2))
