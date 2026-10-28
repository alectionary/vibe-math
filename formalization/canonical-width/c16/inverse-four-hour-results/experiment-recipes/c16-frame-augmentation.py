from pathlib import Path
import sys,json,time,itertools,random,subprocess
sys.path.insert(0,'/private/tmp/c16-four-hour-inverse-20261027T202223/formalization/canonical-width/c16')
from audit_pools import exchange
from verify_partial_frame import shift,mask
from dual_basis_cuts import rank_pivots
from inverse_block_sat import rectangular_encode
root=Path('/private/tmp/c16-four-hour-inverse-20261027T202223/formalization/canonical-width/c16');tmp=Path('/private/tmp');X=[int(v,16) for v in (root/'pools/xcoords.txt').read_text().split()];Z=[int(v,16) for v in (root/'pools/zcoords.txt').read_text().split()];physical=json.load(open(root/'physical-pool-source.json'));zp=[shift(mask(v),h) for v in physical['Z_orbit_representatives'] for h in range(16)];xp=[exchange(v) for v in zp];ix={v:i for i,v in enumerate(xp)};iz={v:i for i,v in enumerate(zp)};frame=[(ix[mask(p['X'])],iz[mask(p['Z'])]) for p in json.load(open(root/'partial-frame-88.json'))['pairs']];assert all((X[x]&Z[z]).bit_count()%2==(i==j) for i,(x,_) in enumerate(frame) for j,(_,z) in enumerate(frame));start=time.monotonic();rng=random.Random(20261027);history=[];improvements=[]
for epoch in range(3):
 n=len(frame);allbits=(1<<n)-1;ax=[sum(((x&Z[z]).bit_count()%2)<<i for i,(_,z) in enumerate(frame)) for x in X];az=[sum(((X[x]&z).bit_count()%2)<<i for i,(x,_) in enumerate(frame)) for z in Z];old=set(frame);cores={ax[i]|az[j] for i,x in enumerate(X) for j,z in enumerate(Z) if (i,j) not in old and (x&z).bit_count()%2};ordered=sorted(cores,key=lambda v:(v.bit_count(),v));hist={k:sum(v.bit_count()==k for v in cores) for k in sorted({v.bit_count() for v in cores})};print('CORES',epoch,'current',n,'minimum',ordered[0].bit_count(),'hist',hist,flush=True);candidates=[]
 chosen=ordered[:2000]
 for target in [8,12,16,24,32]:
  for _ in range(160):
   core=rng.choice(ordered[:min(1000,len(ordered))]);positions=[i for i in range(n) if not(core>>i&1)];rng.shuffle(positions)
   for i in positions[:max(0,target-core.bit_count())]:core|=1<<i
   chosen.append(core)
 for R in dict.fromkeys(chosen):
  k=R.bit_count();I=[i for i,a in enumerate(ax) if not(a&~R)];J=[j for j,a in enumerate(az) if not(a&~R)];rx=len(rank_pivots([X[i] for i in I],128));rz=len(rank_pivots([Z[j] for j in J],128));surplus=min(rx,rz)-k
  if surplus>0:
   edges=sum((X[i]&Z[j]).bit_count()%2 for i in I for j in J);candidates.append((surplus,-k,edges,R,I,J))
 print('RANK_ELIGIBLE',epoch,len(candidates),'seconds',time.monotonic()-start,flush=True);candidates.sort(reverse=True,key=lambda v:v[:3]);record={'epoch':epoch,'starting_pairs':n,'core_histogram':hist,'rank_eligible_neighborhoods':len(candidates),'tested':[]};found=False
 for surplus,negk,edges,R,I,J in candidates[:30]:
  if time.monotonic()-start>180:break
  k=-negk;target=k+1;patterns=[[(X[i]&Z[j]).bit_count()%2 for j in J] for i in I];clauses,nv=rectangular_encode(patterns,target,coverage=False);prefix=tmp/f'c16-new-augmentation-{epoch}-{len(record["tested"])}';cnf=prefix.with_suffix('.cnf');cnf.write_text(f'p cnf {nv} {len(clauses)}\n'+''.join(' '.join(map(str,c))+' 0\n' for c in clauses));log=prefix.with_suffix('.log')
  with log.open('w') as f:
   try:p=subprocess.run(['/private/tmp/c16-kissat/build/kissat','--time=3',str(cnf)],stdout=f,timeout=5);code=p.returncode
   except subprocess.TimeoutExpired:code='OWNED_PROCESS_TIME_LIMIT'
  text=log.read_text();entry={'removed_pairs':k,'candidate_pools':[len(I),len(J)],'available_rank_surplus':surplus,'edges':edges,'returncode':code};record['tested'].append(entry)
  if 's SATISFIABLE' not in text:continue
  model={int(v) for line in text.splitlines() if line.startswith('v ') for v in line[2:].split() if int(v)>0};AI=[i for a,i in enumerate(I) if a+1 in model];BJ=[j for b,j in enumerate(J) if len(I)+b+1 in model];new=[]
  for i in AI:
   mates=[j for j in BJ if (X[i]&Z[j]).bit_count()%2];assert len(mates)==1;new.append((i,mates[0]))
  assert len(new)==len(AI)==len(BJ)==target;frame=[p for t,p in enumerate(frame) if not(R>>t&1)]+new;assert len(frame)==n+1 and all((X[x]&Z[z]).bit_count()%2==(i==j) for i,(x,_) in enumerate(frame) for j,(_,z) in enumerate(frame));found=True;entry['status']='LARGER_PARTIAL_FRAME_CHECKED';improvements.append(len(frame));support=lambda v:[i for i in range(1088) if v>>i&1];result={'pairs':[{'X':support(xp[i]),'Z':support(zp[j])} for i,j in frame],'pool_pairs':frame,'method':'rank-guided induced-matching augmentation','source_C16_answered':len(frame)==128};(tmp/f'c16-new-partial-frame-{len(frame)}.json').write_text(json.dumps(result,indent=2)+'\n');print('IMPROVED',len(frame),entry,flush=True);break
 history.append(record);(tmp/'c16-new-frame-augmentation.json').write_text(json.dumps({'status':'BOUNDED_CONSTRUCTION_COMPARISON','best_pairs':len(frame),'improvements':improvements,'seconds':time.monotonic()-start,'history':history,'source_C16_answered':False},indent=2)+'\n')
 if not found:break
print('DONE',len(frame),'seconds',time.monotonic()-start,flush=True)
