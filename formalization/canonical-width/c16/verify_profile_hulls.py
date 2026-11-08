#!/usr/bin/env python3
"""Independent completeness replay of local autocorrelation hull inputs."""
from pathlib import Path
import argparse,gzip,hashlib,json,subprocess,sys,tempfile,time
from verify_algebraic_model import physical
ROOT=Path(__file__).resolve().parent
def main():
 ap=argparse.ArgumentParser();ap.add_argument('--profiles',type=Path,required=True);ap.add_argument('--hulls',type=Path,nargs='+',required=True);ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();start=time.monotonic();raw=a.profiles.read_bytes();profile_hash=hashlib.sha256(raw).hexdigest()
 with tempfile.TemporaryDirectory(prefix='c16-profile-hull-source-') as folder:
  out=Path(folder)/'source.json';subprocess.run([sys.executable,str(ROOT/'verify_orbit_rank_profiles.py'),'--certificate',str(a.profiles),'--output',str(out)],check=True,capture_output=True,text=True,timeout=180);report=json.loads(out.read_text());assert report['status']=='PASS' and report['orbits_checked']==45 and report['certificate_sha256']==profile_hash
 X,Z,A=physical();source=json.loads(gzip.decompress(raw) if a.profiles.suffix=='.gz' else raw);hulls=[json.loads(gzip.decompress(p.read_bytes())) for p in a.hulls];checked=[0]*len(hulls);patterns=[0]*len(hulls)
 for data in hulls:assert data['source_profiles_sha256']==profile_hash and data['critical_physical_cap']==11
 for r in source['records']:
  o=r['orbit'];bad=bytearray(65536)
  for c in r['minimal_bad_certificates']:bad[c['mask']]=1
  for h in range(16):
   bit=1<<h
   for mask in range(65536):
    if mask&bit and bad[mask^bit]:bad[mask]=1
  counts=[0]*65536
  for j in range(720):counts[sum((A[16*o+h]>>j&1)<<h for h in range(16))]+=1
  for h in range(16):
   bit=1<<h
   for mask in range(65536):
    if mask&bit:counts[mask]+=counts[mask^bit]
  def basic(m):
   complement=m^65535;zero=counts[complement]
   if zero<128-m.bit_count():return False
   return all(counts[complement|(1<<h)]>zero for h in range(16) if m>>h&1)
  for j,data in enumerate(hulls):
   P=data['period'];row=data['records'][o];assert row['orbit']==o;expected={};allowed=0
   for m in range(1<<P):
    physical_mask=m if P==16 else m|(m<<8)
    if (bad[physical_mask] if data['mode']=='rank' else not basic(physical_mask)) or (o==12 and physical_mask.bit_count()>11):continue
    feature=(m.bit_count(),)+tuple((m&((m>>h)|((m&((1<<h)-1))<<(P-h)))).bit_count() for h in range(1,P//2+1));expected.setdefault(feature,m);allowed+=1
   observed={tuple(s['moments']):s['example_mask'] for s in row['shapes']};assert set(observed)==set(expected) and len(observed)==len(row['shapes']) and allowed==row['phase_patterns']
   for feature,m in observed.items():
    physical_mask=m if P==16 else m|(m<<8);assert not (bad[physical_mask] if data['mode']=='rank' else not basic(physical_mask));assert o!=12 or physical_mask.bit_count()<=11;bits=[m>>h&1 for h in range(P)];literal=(sum(bits),)+tuple(sum(bits[t]*bits[(t+h)%P] for t in range(P)) for h in range(1,P//2+1));assert literal==feature
   checked[j]+=len(observed);patterns[j]+=allowed
  if o%8==0:print('HULL PHYSICAL ORBIT',o,flush=True)
 results=[]
 for j,(path,data) in enumerate(zip(a.hulls,hulls)):
  assert checked[j]==data['shape_variables'] and patterns[j]==data['phase_patterns'];results.append({'path':path.name,'sha256':hashlib.sha256(path.read_bytes()).hexdigest(),'period':data['period'],'mode':data['mode'],'complete_autocorrelation_shapes_checked':checked[j],'complete_phase_patterns_covered':patterns[j]})
 out={'status':'PASS','source_C16_answered':False,'rank_witness_source_fully_replayed':True,'source_profiles_sha256':profile_hash,'physical_pairings_rebuilt':518400,'hulls':results,'elapsed_seconds':time.monotonic()-start,'scope':'Every unexcluded physical phase pattern appears in the local autocorrelation hull, and every saved shape has a checked example. Prior full-frame critical cap11 is an explicit reused dependency. These local necessary hulls do not assert independence between orbits or full-frame existence.'};a.output.write_text(json.dumps(out,indent=2)+'\n');print(out)
if __name__=='__main__':main()
