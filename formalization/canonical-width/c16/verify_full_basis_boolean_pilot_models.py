#!/usr/bin/env python3
"""Literal replay of both matchedSAT witnesses; neither is a source frame."""
from pathlib import Path
import gzip,hashlib,json,time
from verify_algebraic_model import physical
from verify_full_partner_basis_oracle import dimension
ROOT=Path(__file__).resolve().parent;D=ROOT/'coupling-results/full-basis-sourcecase32-pilot-v2'
def read(p):
 p=Path(p);return json.loads(gzip.decompress(p.read_bytes()) if p.suffix=='.gz' else p.read_bytes())
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def main():
 out=D/'models-independent.json';assert not out.exists();t=time.monotonic();f=read(D/'frozen.json.gz');controls=read(D/'bridge-controls.json');trials=read(D/'trials-summary.json');assert controls['status']=='PASS_NEW_BOOLEAN_CNF_BRIDGE_CONTROLS' and controls['frozen_sha256']==sha(D/'frozen.json.gz');X,Z,A=physical();rows=[];flat=[j for j in range(720) if j//16 in [0,1,2,15,16,17,18,19,20]];assert len(flat)==144 and dimension(Z[j] for j in flat)==64
 for arm in ['baseline','small64']:
  report=read(D/(arm+'-trial.json'));assert report['status']=='SAT_NECESSARY_MODEL_ONLY';mp=D/(arm+'-model.json.gz');assert report['model_sha256']==sha(mp);model=read(mp);assert len(set(abs(v) for v in model))==len(model);positive=set(v for v in model if v>0)
  raw=gzip.decompress((D/(arm+'.cnf.gz')).read_bytes());lines=raw.decode().splitlines();_,_,nv,nc=lines[0].split();assert len(model)==int(nv);checked=0
  for line in lines[1:]:
   clause=list(map(int,line.split()));assert clause[-1]==0;assert any((v in positive) if v>0 else (-v not in positive) for v in clause[:-1]);checked+=1
  assert checked==int(nc)
  ps=[int(v in positive) for v in f['fullP_variables']];zs=[j for j,v in enumerate(f['fullQ_variables']) if v in positive];assert len(zs)==128
  pairs=[(512,512),*[tuple(e) for i,e in enumerate(f['edges'],1) if i in positive]];assert all((A[x]>>z&1)==int(i==j) for i,(x,_) in enumerate(pairs) for j,(_,z) in enumerate(pairs));assert all(z in zs for x,z in pairs);assert all(not(512<=x<528) or ps[x-512] for x,z in pairs)
  assert all(sum(A[512+h]>>j&1 for j in zs)==1 for h,p in enumerate(ps) if p)
  c=f['coefficients'];v=c[0]+c[1]*sum(ps)+sum(c[1+h]*sum(ps[t]*ps[(t+h)%16] for t in range(16)) for h in range(1,9))+sum(c[10+j//16] for j in zs)+sum(c[55+16*(j//16)+(j%16-t)%16]*ps[t] for j in zs for t in range(16))
  if arm=='small64':assert v<=f['bound']
  rows.append({'arm':arm,'CNF_clauses_literally_checked':checked,'physical_partial_pairs':pairs,'partial_size':len(pairs),'fullP_mask':sum(p<<h for h,p in enumerate(ps)),'selected_P_count':sum(ps),'fullQ_indices':zs,'fullQ_count':128,'fullQ_rank':dimension(Z[j] for j in zs),'accepted_cut_integer_value':v,'accepted_cut_bound':f['bound'],'accepted_cut_violated':v>f['bound'],'rank64_flat_selected_count':len(set(zs)&set(flat)),'rank64_flat_violated':len(set(zs)&set(flat))>64,'model_sha256':sha(mp),'cnf_raw_sha256':hashlib.sha256(raw).hexdigest()})
 out.write_text(json.dumps({'status':'PASS_BOTH_SAT_NECESSITY_MODELS_NO_SOURCE_FRAME','source_C16_answered':False,'consumer_sha256':sha(__file__),'frozen_sha256':sha(D/'frozen.json.gz'),'bridge_controls_sha256':sha(D/'bridge-controls.json'),'trials_summary_sha256':sha(D/'trials-summary.json'),'records':rows,'source_exclusions':0,'cover':405,'seconds':time.monotonic()-t,'scope':'BothcompleteBooleanmodels satisfy their generatedCNFs. FullQrank and selectedPdegree arediagnostics; nofull128Xframe is present or asserted.'},indent=2)+'\n');print(json.dumps([{k:v for k,v in r.items() if k not in ['physical_partial_pairs','fullQ_indices']} for r in rows],indent=2))
if __name__=='__main__':main()
