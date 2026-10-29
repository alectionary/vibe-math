#!/usr/bin/env python3
"""Frozen matched compact-oracle pilot with source full-basis negative cuts."""
from pathlib import Path
from concurrent.futures import ThreadPoolExecutor,as_completed
import argparse,gzip,hashlib,json,subprocess,sys,tempfile,time
from signature_cover import logical_data,encode,canonical
from anchored_cover_chain import parity_chains
from exchange_anchored_cover import signature_amo
from rank_cover_cuts import family,clauses,violation,CUTS
ROOT=Path(__file__).resolve().parent

def raw_cnf(n,rows):return (f'p cnf {n} {len(rows)}\n'+''.join(' '.join(map(str,c))+' 0\n' for c in rows)).encode()

def main():
 ap=argparse.ArgumentParser();ap.add_argument('--chain',type=Path,required=True);ap.add_argument('--audit',type=Path,required=True);ap.add_argument('--output',type=Path,required=True);ap.add_argument('--cases',type=int,default=8);ap.add_argument('--seconds',type=float,default=25);ap.add_argument('--workers',type=int,default=2);ap.add_argument('--extra-cuts',type=Path);ap.add_argument('--offset',type=int,default=0);a=ap.parse_args();start=time.monotonic();folder=a.output.parent;folder.mkdir(exist_ok=True);A,C,E=logical_data();F=family();chain=json.loads(a.chain.read_text());R=set(map(tuple,chain['removed_case_tuples']));assert len(R)==100;by={};audit=json.loads(a.audit.read_text());sig={e[:2]:e[2] for e in E}
 for r in audit['records']:
  extra={C[i] for i in r['support_class_indices']}-R
  if r['rank_violation'] and len(extra)==1:by.setdefault(next(iter(extra)),r)
 extra_data=json.loads(a.extra_cuts.read_text()) if a.extra_cuts else None
 if extra_data:
  for k,cut in enumerate(extra_data['cuts']):
   for phase in range(16):
    ids=tuple(sorted(16*(i//16)+(i%16+phase)%16 for i in cut['indices']));F.setdefault(ids,('mixed',k,phase))
 candidates=[]
 for c,w in by.items():
  ax,az=16*c[0],16*c[1]+c[2];trial=R|{c};small=[(i,j,s,0) for i,j,s,k in E if C[k] in trial and (i,j)!=(ax,az) and i!=ax and j!=az and not A[i]>>az&1 and not A[ax]>>j&1];candidates.append((len(small),c,w,small))
 candidates.sort(key=lambda x:(x[0],x[1]));offset=a.offset;candidates=candidates[offset:offset+a.cases];assert candidates
 frozen={'status':'FROZEN_BEFORE_SOLVING','source_C16_answered':False,'parent_cover':418,'parent_chain_sha256':hashlib.sha256(a.chain.read_bytes()).hexdigest(),'audit_sha256':hashlib.sha256(a.audit.read_bytes()).hexdigest(),'rank_certificate_sha256':hashlib.sha256(CUTS.read_bytes()).hexdigest(),'per_call_wall_seconds':a.seconds,'workers':a.workers,'selection_rule':'One current retained class beyond R among the40 rejected recorded witnesses; ascending free-edge count then canonical class.','cases':[{'case':c,'free_edges':n,'old_rejected_witness':w['pairs'],'order':['baseline','rank'] if k%2==0 else ['rank','baseline']} for k,(n,c,w,small) in enumerate(candidates)]};frozen['extra_cuts_c16_path']=str(a.extra_cuts.resolve().relative_to(ROOT)) if a.extra_cuts else None;frozen['extra_cuts_sha256']=hashlib.sha256(a.extra_cuts.read_bytes()).hexdigest() if a.extra_cuts else None;(folder/'frozen-targets.json').write_text(json.dumps(frozen,indent=2)+'\n')
 def task(k,item):
  count,c,known,small=item;ax,az=16*c[0],16*c[1]+c[2];target=65535^sig[ax,az];base,n,_,events=encode(A,[0],small,with_xor=False,compress_signatures=True);n=parity_chains(base,n,events,target);n=signature_amo(base,n,small);oldset={tuple(sorted(row)) for row in base};added=[list(row) for row in clauses(small,(ax,az),F) if row not in oldset];results=[]
  for mode in frozen['cases'][k]['order']:
   rows=base+(added if mode=='rank' else []);raw=raw_cnf(n,rows);stem=folder/f'case-{k:02d}-{mode}';stem.with_suffix('.cnf.gz').write_bytes(gzip.compress(raw,mtime=0));meta={'source_C16_answered':False,'case':c,'anchor':[ax,az],'trial_removed':sorted(R|{c}),'free_target_signature':target,'free_edges':len(small),'signature_compression':True,'one_per_signature':True,'rank_strengthened':mode=='rank','rank_cut_certificate_c16_path':str(CUTS.relative_to(ROOT)),'rank_cut_certificate_sha256':frozen['rank_certificate_sha256'],'base_clauses':len(base),'appended_clauses':len(added) if mode=='rank' else 0,'variables':n,'clauses':len(rows),'cnf_file':stem.with_suffix('.cnf.gz').name,'cnf_sha256':hashlib.sha256(raw).hexdigest(),'per_call_wall_seconds':a.seconds,'answer':None,'solver':'pysat/cadical195'};t=time.monotonic()
   worker="from pysat.solvers import Solver;from pysat.formula import CNF;import sys,json;s=Solver(name='cadical195',bootstrap_with=CNF(from_file=sys.argv[1]).clauses,with_proof=True);a=s.solve();open(sys.argv[2],'w').write(json.dumps({'answer':a,'model':s.get_model() if a else None}));open(sys.argv[3],'w').write('\\n'.join(s.get_proof())+'\\n' if not a else '');s.delete()"
   with tempfile.TemporaryDirectory(prefix='c16-rank-cover-pilot-') as temp:
    ip=Path(temp)/'in.cnf';op=Path(temp)/'answer.json';pp=Path(temp)/'proof.drat';ip.write_bytes(raw)
    try:
     run=subprocess.run([sys.executable,'-c',worker,str(ip),str(op),str(pp)],capture_output=True,text=True,timeout=a.seconds,check=True);ans=json.loads(op.read_text());meta['answer']=ans['answer']
     if ans['answer']:
      model=set(ans['model']);assert all(any(lit in model for lit in row) for row in rows);pairs=[(ax,az)]+[e[:2] for j,e in enumerate(small,1) if j in model];value=0
      for j,(i,z) in enumerate(pairs):
       value^=sig[i,z]
       for ii,zz in pairs[:j]:assert i!=ii and z!=zz and not A[i]>>zz&1 and not A[ii]>>z&1
      assert value==65535
      if mode=='rank':assert violation(pairs,F) is None
      meta.update(status='SAT_REQUIRES_PHYSICAL_REPLAY',partial_pairs=pairs,model=ans['model'])
     else:
      proof=pp.read_bytes();stem.with_suffix('.drat.gz').write_bytes(gzip.compress(proof,mtime=0));meta.update(status='UNSAT_REQUIRES_SOURCE_AND_DRAT_REPLAY',proof_file=stem.with_suffix('.drat.gz').name,proof_sha256=hashlib.sha256(proof).hexdigest())
    except subprocess.TimeoutExpired:meta['status']='UNKNOWN_WALL_LIMIT'
   meta['elapsed_seconds']=time.monotonic()-t;stem.with_suffix('.json').write_text(json.dumps(meta,indent=2)+'\n');results.append({'mode':mode,'answer':meta['answer'],'metadata_file':stem.with_suffix('.json').name,'elapsed_seconds':meta['elapsed_seconds'],'appended_clauses':meta['appended_clauses']});print('MATCHED ORACLE',k,mode,meta['answer'],'seconds',round(meta['elapsed_seconds'],3),'added',meta['appended_clauses'],flush=True)
  return {'case_index':k,'case':c,'free_edges':count,'calls':results}
 records=[]
 with ThreadPoolExecutor(max_workers=a.workers) as pool:
  for f in as_completed([pool.submit(task,k,item) for k,item in enumerate(candidates)]):
   records.append(f.result());a.output.write_text(json.dumps({'status':'RUNNING','source_C16_answered':False,'records':sorted(records,key=lambda r:r['case_index'])},indent=2)+'\n')
 out={'status':'COMPARISON_COMPLETE_REQUIRES_INDEPENDENT_REPLAY','source_C16_answered':False,'parent_cover':418,'records':sorted(records,key=lambda r:r['case_index']),'elapsed_seconds':time.monotonic()-start,'scope':'Independent one-class trials relative to the same100-class omitted set. Successful removals cannot be combined without new proof. No full source-anchor exclusion or global speedup follows.'};a.output.write_text(json.dumps(out,indent=2)+'\n');print('COMPARISON COMPLETE',len(records),'pairs',round(out['elapsed_seconds'],2),flush=True)
if __name__=='__main__':main()
