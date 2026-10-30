#!/usr/bin/env python3
"""Direct compressed selected-anchor source-profile containment supplement."""
from pathlib import Path
import gzip,hashlib,json,sys,time
ROOT=Path(__file__).resolve().parents[1];sys.path.insert(0,str(ROOT))
from verify_algebraic_model import physical
from verify_word_subspace_rank import dimension

def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def main():
 start=time.monotonic();rp=ROOT/'coupling-results/word-subspace-minimized-independent.json';r=json.loads(rp.read_text());X,Z,_=physical();cores=[v['certificate']['mandatory_opposite'] for v in r['records']]
 assert all(dimension(Z[i] for i in J)==len(J) for J in cores)
 matches=[];inventory=[];queries=0;certificates=0
 for orbit in range(45):
  p=ROOT/f'algebraic-results/conditional-capacity/case-{orbit:02d}.json.gz';d=json.loads(gzip.decompress(p.read_bytes()));assert d['conditioned_on_X_index']==16*orbit and d.get('selected_quotient_sector','X')=='X';assert all(x['complete'] for x in d['records']);records={x['orbit']:x for x in d['records']}
  count=sum(len(x['minimal_bad_certificates']) for x in d['records']);certificates+=count
  for n,J in enumerate(cores):
   for anchor in J:
    if anchor//16!=orbit:continue
    phase=anchor%16;shifted=[16*(i//16)+(i%16-phase)%16 for i in J if i!=anchor]
    for j in {i//16 for i in shifted}:
     mask=sum(1<<(i%16) for i in shifted if i//16==j);queries+=1
     for k,c in enumerate(records[j]['minimal_bad_certificates']):
      if c['mask']&mask==c['mask']:matches.append(dict(core_record=n,anchor=anchor,profile_orbit=j,certificate_index=k,mask=c['mask']))
  inventory.append(dict(path=str(p.relative_to(ROOT)),sha256=sha(p),minimal_bad_certificates=count))
 out=dict(status='PASS',source_C16_answered=False,parent_receipt_sha256=sha(rp),source_sha256=sha(Path(__file__)),source_hashes={name:sha(ROOT/name) for name in ['physical-pool-source.json','pools/xcoords.txt','pools/zcoords.txt']},selected_anchor_profile_inventory=inventory,profile_containment_queries=queries,minimal_bad_certificates_inventoried=certificates,profile_subsumers=matches,all_minimized_cores_physically_independent=True,
          other_compressed_bank_scope='All pure physical-circuit/rank-containment restrictions are passed because each minimized core is physically independent. Opposite-sector selected-anchor profiles require a selected event in both sectors, and absent-anchor profiles include absence; neither is a pure-positive same-sector clause subsumer. Signature circuits are not used. This supplements explicit clause-bank syntactic containment, not logical implication by all constraints.',elapsed_seconds=time.monotonic()-start)
 path=ROOT/'coupling-results/word-subspace-minimized-bank-supplement.json';assert not path.exists();path.write_text(json.dumps(out,indent=2)+'\n');print({k:v for k,v in out.items() if k not in ['selected_anchor_profile_inventory','source_hashes']})
if __name__=='__main__':main()
