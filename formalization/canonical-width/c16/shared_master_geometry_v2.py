"""Add bounded exact physical coverage columns to the frozen archive-only bank."""
from pathlib import Path
from fractions import Fraction as Q
import gzip,hashlib,json,os,time
ROOT=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def read(p):
 p=Path(p);b=p.read_bytes();return json.loads(gzip.decompress(b) if p.suffix=='.gz' else b)
def main():
 assert os.getpriority(os.PRIO_PROCESS,0)==19
 for k in ('OPENBLAS_NUM_THREADS','OMP_NUM_THREADS','MKL_NUM_THREADS','VECLIB_MAXIMUM_THREADS','NUMEXPR_NUM_THREADS','BLIS_NUM_THREADS'):assert os.environ[k]=='1'
 from two_sided_full_basis_oracle import TwoSidedFullBasisOracle
 from verify_algebraic_model import physical
 from verify_two_sided_full_basis_oracle import domains,check_sector
 start=time.monotonic();source=ROOT/'shared-master-results/geometry-v1.json.gz';d=read(source)
 assert sha(source)=='cd1791d001e8154a70137c0737f5da62fef9cd7dcd72b0251aa6b713beb455c5'
 out=ROOT/'shared-master-results/geometry-v2.json.gz';assert not out.exists()
 seed=read(ROOT/'two-basis-results/shared-basis-phase-one-point22-seed.json.gz')
 columns=d['columns'];oracle=TwoSidedFullBasisOracle();prepared=oracle.prepare([80,512],[186,433])
 X,Z,_=physical();dd=domains(X,Z,[80,512],[186,433]);controls=[];new=0;prefixes=0
 for block in d['blocks']:
  side,m=block['side'],block['mask'];target={j for j,v in enumerate(seed['parent_exact_allocations'][side][m]) if Q(v)>0}
  covered=set().union(*(set(c['indices']) for c in columns if c['side']==side and c['mask']==m))
  missing=target-covered;attempts=0
  while missing and block['archive_extras']+attempts<96:
   weights=[int(j in missing) for j in range(720)]
   full=weights+[0]*720 if side=='X' else [0]*720+weights
   result=oracle.support_pattern(prepared[m],full)[side+'_support'];B=sorted(result['selected_indices'])
   value,n=check_sector(X if side=='X' else Z,128,dd[m][side],weights,B);prefixes+=n
   gain=len(missing.intersection(B));assert value==gain
   controls.append(dict(side=side,mask=m,missing_before=sorted(missing),indices=B,exact_gain=gain))
   if not gain:break
   assert not any(c['side']==side and c['mask']==m and c['indices']==B for c in columns)
   columns.append(dict(side=side,mask=m,indices=B,origin_kind='exact_missing_positive_coordinate_coverage',coverage_control_index=len(controls)-1))
   new+=1;attempts+=1;covered.update(B);missing=target-covered
  block['coverage_columns_added']=attempts;block['uncovered_positive_coordinates']=sorted(missing)
  block['total_columns']=sum(c['side']==side and c['mask']==m for c in columns)
  block['historical_contiguous_range_only']=True
 # Preserve the original ordering and initial indices; new columns are appended.
 for index,weight in d['initial_seed_weights']:
  c=columns[index];b=next(b for b in seed['blocks'] if b['side']==c['side'] and b['mask']==c['mask'])
  assert c['indices']==sorted(b['indices']) and Q(weight)==Q(b['weight'])
 d['source_hashes'].update({str(source.relative_to(ROOT)):sha(source),Path(__file__).name:sha(__file__)})
 d.update(columns=columns,selection=d['selection']+' Then exact maximum-coverage full bases within the same96extras budget.',
   source_bank_sha256=sha(source),coverage_controls=controls,coverage_columns_added=new,coverage_signed_prefix_rank_checks=prefixes,
   physical_bases_checked=len(columns),producer_sha256=sha(__file__),elapsed_seconds=time.monotonic()-start)
 out.write_bytes(gzip.compress((json.dumps(d,indent=2)+'\n').encode(),mtime=0))
 print(json.dumps(dict(path=str(out.relative_to(ROOT)),sha256=sha(out),column_count=len(columns),new_coverage_columns=new,
   uncovered_positive_coordinates=sum(len(b['uncovered_positive_coordinates']) for b in d['blocks']),seconds=d['elapsed_seconds'])))
if __name__=='__main__':main()
