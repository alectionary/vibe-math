"""Translate independently checked conditional rank subsets to moments."""
from pathlib import Path
from collections import Counter
import hashlib,json
from scipy.sparse import coo_matrix

def matrix(certificates,replays):
 assert len(certificates)==len(replays)
 rows=[];seen=set()
 def coord(side,h,i,j):
  if side=='S' and h==0 and i==j:return i
  if h>8:h=16-h;i,j=j,i
  if h in (0,8) and i>j:i,j=j,i
  return 45+(0 if side=='S' else 9*2025)+2025*h+45*i+j
 for path,rpath in zip(certificates,replays):
  data=json.loads(path.read_text());replay=json.loads(rpath.read_text());assert replay['status']=='PASS' and replay['certificate_sha256']==hashlib.sha256(path.read_bytes()).hexdigest() and replay['cuts_checked']==len(data['cuts'])
  for cut in data['cuts']:
   i=cut['anchor_orbit'];terms=Counter({i:-cut['bound']})
   for j in cut['indices']:terms[coord(cut['sector'],j%16,i,j//16)]+=1
   key=tuple(sorted((j,c) for j,c in terms.items() if c))
   if key not in seen:seen.add(key);rows.append(key)
 ii=[];jj=[];vv=[]
 for i,row in enumerate(rows):
  for j,v in row:ii.append(i);jj.append(j);vv.append(v)
 return coo_matrix((vv,(ii,jj)),shape=(len(rows),45+18*2025),dtype='int64').tocsr(),rows
