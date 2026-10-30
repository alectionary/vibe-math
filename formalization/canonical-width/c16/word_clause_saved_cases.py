#!/usr/bin/env python3
"""Read-only application of checked word clauses to saved physical matchings."""
from pathlib import Path
from collections import Counter
import argparse,gzip,hashlib,json,subprocess,time
from verify_algebraic_model import physical
from signature_cover import logical_data,canonical
from global_four_signature import expand
ROOT=Path(__file__).resolve().parent

def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def candidates(value,where=''):
 if isinstance(value,dict):
  for k,v in value.items():
   if k in ('pairs','partial_pairs','counterexample_edges') and isinstance(v,list) and v and all(isinstance(p,(list,tuple)) and len(p)>=2 and type(p[0])==type(p[1])==int and 0<=p[0]<720 and 0<=p[1]<720 for p in v):yield where+'/'+k,[(p[0],p[1]) for p in v],value.get('cut_indices'),value.get('signature_circuit_index')
   elif isinstance(v,(dict,list)):yield from candidates(v,where+'/'+k)
 elif isinstance(value,list):
  for i,v in enumerate(value):
   if isinstance(v,(dict,list)):yield from candidates(v,where+'/'+str(i))

def main():
 ap=argparse.ArgumentParser();ap.add_argument('--cuts',type=Path,default=ROOT/'coupling-results/word-subspace-minimized-new-cuts.json');ap.add_argument('--output',type=Path,required=True);args=ap.parse_args();assert not args.output.exists();start=time.monotonic()
 bank=json.loads(args.cuts.read_text());cuts=bank['cuts'];X,Z,A=physical();patterns=[]
 for k,c in enumerate(cuts):
  for h in range(16):
   J=sorted(16*(i//16)+(i%16+h)%16 for i in c['indices']);patterns.append((k,h,sum(1<<j for j in J),J))
 names=subprocess.check_output(['rg','-l','"pairs"\\s*:|"partial_pairs"\\s*:|"counterexample_edges"\\s*:','--glob','*.json'],cwd=ROOT,text=True).splitlines();names=sorted(n for n in names if not n.startswith('coupling-results/') and 'control' not in n and 'negative' not in n)
 inventory=[];hits=[];unique=set();physical_replays=set();total=0
 for name in names:
  path=ROOT/name;data=json.loads(path.read_text());count=matched=0
  for locator,pairs,oldcuts,oldcircuit in candidates(data):
   count+=1;total+=1;key=tuple(sorted(pairs));unique.add(key);selected=[sum(1<<i for i in {p[s] for p in pairs}) for s in (0,1)]
   matching=[dict(cut=k,cyclic_shift=h,sector=s,indices=J) for k,h,mask,J in patterns for s in (0,1) if selected[s]&mask==mask]
   if matching:
    if key not in physical_replays:
     assert len({x for x,z in pairs})==len({z for x,z in pairs})==len(pairs)
     for i,(x,z) in enumerate(pairs):
      assert A[x]>>z&1
      for xx,zz in pairs[:i]:assert not(A[x]>>zz&1) and not(A[xx]>>z&1)
     physical_replays.add(key)
    matched+=1;hits.append(dict(path=name,locator=locator,source_status=data.get('status'),source_anchor=data.get('anchor'),pairs=pairs,matches=matching,previous_record_cut_indices=oldcuts,previous_record_signature_circuit=oldcircuit))
  if count:inventory.append(dict(path=name,sha256=sha(path),records=count,rejected_records=matched))
 # Concrete owner-clause compilation on the saved global projection and one
 # currently retained cover case. This is a translation check, not a SAT run.
 AA,classes,E=logical_data();assert AA==A
 coverpath=ROOT/'transfer-results/cover-405.json';cover=json.loads(coverpath.read_text());retained={tuple(r['orbit_tuple']) for r in cover['cases']};assert len(retained)==405
 target=(5,11,10);assert target in retained;anchor=(80,186)
 specifications=[('global',None,None),('cover405_target_5_11_10',anchor,(set(classes)-retained)|{target})]
 compiled=[]
 for name,anchor,R in specifications:
  edges=[(i,j,s,0) for i,j,s,k in E if (R is None or classes[k] in R) and (anchor is None or (i!=anchor[0] and j!=anchor[1] and not A[i]>>anchor[1]&1 and not A[anchor[0]]>>j&1))]
  groups=[sorted({p[s] for p in edges}) for s in (0,1)];owners=[{v:len(edges)+i+1 for i,v in enumerate(groups[0])},{v:len(edges)+len(groups[0])+i+1 for i,v in enumerate(groups[1])}]
  old=set();records=[]
  for k,cut in enumerate(cuts):
   actual=expand(cut,owners,anchor);independent=set()
   for _,h,_,J in [p for p in patterns if p[0]==k]:
    for side,owner in enumerate(owners):
     missing=[j for j in J if (anchor is None or j!=anchor[side]) and j not in owner]
     if not missing:independent.add(tuple(sorted(-owner[j] for j in J if anchor is None or j!=anchor[side])))
   assert actual==independent;assert all(row and all(v<0 for v in row) for row in actual)
   records.append(dict(cut=k,owner_clauses=list(map(list,sorted(actual)))));old|=actual
  compiled.append(dict(model=name,anchor=anchor,free_edges=len(edges),owner_counts=list(map(len,owners)),unique_negative_clauses=len(old),records=records,restricted_class_count=None if R is None else len(R),solver_run=False))
 result=dict(status='PASS',source_C16_answered=False,cut_bank_sha256=sha(args.cuts),consumer_sha256=sha(Path(__file__)),source_hashes={p:sha(ROOT/p) for p in ['verify_algebraic_model.py','signature_cover.py','global_four_signature.py','physical-pool-source.json','pools/xcoords.txt','pools/zcoords.txt','transfer-results/cover-405.json']},saved_file_inventory=inventory,saved_records_scanned=total,distinct_saved_matchings=len(unique),rejected_records=len(hits),distinct_rejected_physical_matchings=len(physical_replays),hits=hits,compiled_owner_clauses=compiled,elapsed_seconds=time.monotonic()-start,
             scope='Read-only containment scan of saved source-index matching records. Every rejected matching is physically replayed. Rejection proves that partial matching cannot extend to a full source frame. Owner-clause compilations are valid extra seeds, not solver results. Cover remains405 and no full anchor is excluded.')
 args.output.write_text(json.dumps(result,indent=2)+'\n');print({k:v for k,v in result.items() if k not in ['hits','saved_file_inventory','source_hashes','compiled_owner_clauses']});print('HIT FILES',[(r['path'],r['rejected_records']) for r in inventory if r['rejected_records']]);print('COMPILED',[(r['model'],r['free_edges'],r['unique_negative_clauses']) for r in compiled])
if __name__=='__main__':main()
