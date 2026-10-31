"""Final bounded bank: archive diversity first, exact oracle coverage second."""
from shared_master_geometry_v2 import ROOT,Q,read,sha
from pathlib import Path
import gzip,json,os,time
def main():
 assert os.getpriority(os.PRIO_PROCESS,0)==19
 for k in ('OPENBLAS_NUM_THREADS','OMP_NUM_THREADS','MKL_NUM_THREADS','VECLIB_MAXIMUM_THREADS','NUMEXPR_NUM_THREADS','BLIS_NUM_THREADS'):assert os.environ[k]=='1'
 from two_sided_full_basis_oracle import TwoSidedFullBasisOracle
 from verify_algebraic_model import physical
 from verify_two_sided_full_basis_oracle import domains,check_sector
 start=time.monotonic();source=ROOT/'shared-master-results/geometry-v3.json.gz';d=read(source)
 assert sha(source)=='9ebd2edd06dd7fdd294c70d419687f4298b518694cc8e9ef87a29a984fcc9090'
 out=ROOT/'shared-master-results/geometry-v4.json.gz';assert not out.exists()
 seed=read(ROOT/'two-basis-results/shared-basis-phase-one-point22-seed.json.gz')
 keep={'accepted_phase_one_seed','zero_weight_full_domain_basis','evenly_spaced_archive_geometry'}
 old=[c for c in d['columns'] if c['origin_kind'] in keep];columns=[];summaries=[];controls=[];prefixes=0
 oracle=TwoSidedFullBasisOracle();prepared=oracle.prepare([80,512],[186,433]);X,Z,_=physical();dd=domains(X,Z,[80,512],[186,433])
 for m in range(16):
  for side in 'XZ':
   block=[c for c in old if c['side']==side and c['mask']==m];target={j for j,v in enumerate(seed['parent_exact_allocations'][side][m]) if Q(v)>0}
   covered=set().union(*(set(c['indices']) for c in block));missing=target-covered;added=0;start_index=len(columns)
   while missing and len(block)<257:
    weights=[int(j in missing) for j in range(720)];full=weights+[0]*720 if side=='X' else [0]*720+weights
    result=oracle.support_pattern(prepared[m],full)[side+'_support'];B=sorted(result['selected_indices'])
    value,n=check_sector(X if side=='X' else Z,128,dd[m][side],weights,B);prefixes+=n;gain=len(missing.intersection(B));assert value==gain
    controls.append(dict(side=side,mask=m,missing_before=sorted(missing),indices=B,exact_gain=gain))
    if not gain:break
    assert all(c['indices']!=B for c in block)
    block.append(dict(side=side,mask=m,indices=B,origin_kind='exact_missing_positive_coordinate_coverage',coverage_control_index=len(controls)-1))
    covered.update(B);missing=target-covered;added+=1
   columns.extend(block);summaries.append(dict(side=side,mask=m,column_start=start_index,column_count=len(block),
    positive_coordinates=len(target),uncovered_positive_coordinates=sorted(missing),coverage_columns_added=added))
 initial=[]
 for b in seed['blocks']:
  i=next(i for i,c in enumerate(columns) if c['side']==b['side'] and c['mask']==b['mask'] and c['indices']==sorted(b['indices']))
  initial.append([i,b['weight']])
 assert len(initial)==22 and len(columns)<=32+22*256
 d['source_hashes'].update({str(source.relative_to(ROOT)):sha(source),Path(__file__).name:sha(__file__)})
 d.update(columns=columns,blocks=summaries,initial_seed_weights=initial,coverage_controls=controls,
  selection='One original seed or zero-weight basis per domain; at most64 evenly spaced archive bases; exact positive-coordinate coverage until covered or256extras/block.',
  source_bank_sha256=sha(source),coverage_columns_added=sum(b['coverage_columns_added'] for b in summaries),
  coverage_signed_prefix_rank_checks=prefixes,physical_bases_checked=len(columns),producer_sha256=sha(__file__),elapsed_seconds=time.monotonic()-start)
 out.write_bytes(gzip.compress((json.dumps(d,indent=2)+'\n').encode(),mtime=0))
 print(json.dumps(dict(path=str(out.relative_to(ROOT)),sha256=sha(out),column_count=len(columns),new_coverage_columns=d['coverage_columns_added'],
  uncovered_positive_coordinates=sum(len(b['uncovered_positive_coordinates']) for b in summaries),seconds=d['elapsed_seconds'])))
if __name__=='__main__':main()
