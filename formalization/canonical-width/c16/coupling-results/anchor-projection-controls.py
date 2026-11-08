#!/usr/bin/env python3
"""Positive/negative integration fixtures; deliberately not scientific points."""
from pathlib import Path
from fractions import Fraction
import copy,gzip,hashlib,json,os,subprocess,sys,time
import numpy as np
ROOT=Path(__file__).resolve().parents[1];sys.path.insert(0,str(ROOT))
from full_partner_anchor_native import NativeAnchorBatch,STATUS
from verify_projected_profile_moment_rows import point_vector
import verify_anchor_partner_projection as consumer

def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def read(p):
 raw=Path(p).read_bytes();return json.loads(gzip.decompress(raw) if str(p).endswith('.gz') else raw)
def write(p,x):
 assert not p.exists(),p
 b=(json.dumps(x,separators=(',',':'))+'\n').encode();p.write_bytes(gzip.compress(b,mtime=0) if str(p).endswith('.gz') else b)
def run(bank,name,point):
 out=ROOT/f'coupling-results/anchor-projection-control-{name}-independent.json';assert not out.exists()
 t=time.monotonic();p=subprocess.run([sys.executable,str(ROOT/'verify_anchor_partner_projection.py'),'--bank',str(bank),'--point',str(point),'--output',str(out)],cwd=ROOT,capture_output=True,text=True,env={**os.environ,'PYTHONDONTWRITEBYTECODE':'1','OPENBLAS_NUM_THREADS':'1','OMP_NUM_THREADS':'1'})
 log=ROOT/f'coupling-results/anchor-projection-control-{name}.log';assert not log.exists();log.write_text(p.stdout+p.stderr)
 return {'returncode':p.returncode,'seconds':time.monotonic()-t,'log':str(log.relative_to(ROOT)),'log_sha256':sha(log),'output':str(out.relative_to(ROOT)),'output_exists':out.exists()},out

def main():
 start=time.monotonic();out=ROOT/'coupling-results/anchor-projection-control-integration.json';assert not out.exists()
 baseline=ROOT/'coupling-results/witness2-rational.json.gz';owner=point_vector(baseline);oldsum=sum(owner[:45]);delta=Fraction(129,16)-oldsum;owner[0]+=delta;owner[45]=owner[0]
 point=ROOT/'coupling-results/anchor-projection-control-SYNTHETIC-NOT-FEASIBLE-point.json.gz'
 write(point,dict(status='SYNTHETIC_INTEGRATION_FIXTURE_NOT_A_FEASIBLE_MOMENT_POINT',source_C16_answered=False,baseline_sha256=sha(baseline),modifications={'p0_delta':str(delta),'S0_0_0_set_to_p0':True},deliberate_violation='16*sum(p)=129 instead of128',owner_vector=list(map(str,owner))))
 assert point_vector(point)==owner and 16*sum(owner[:45])==129
 native_receipt=ROOT/'coupling-results/anchor-native-matched-accepted.json';native_frozen=ROOT/'coupling-results/anchor-native-matched-accepted.frozen.json';native_arrays=ROOT/'coupling-results/anchor-native-matched-accepted.npz';library=ROOT/'coupling-results/anchor-native-accepted.dylib'
 accepted=read(native_receipt);frozen=read(native_frozen);assert accepted['status']=='PASS_MATCHED_EXACT_NATIVE_GATE' and accepted['native_library_sha256']==sha(library)
 assert all(sha(ROOT/p)==h for p,h in accepted['source_hashes'].items())
 masks=frozen['masks'];batch=NativeAnchorBatch(masks,80,library=library);c=[0]*1512;c[10:55]=[1]*45;priced=batch.price(c);saved=np.load(native_arrays)
 assert np.array_equal(priced['bases'],saved['bases'][0]) and np.array_equal(batch.status,saved['status']) and np.all(priced['values']==128) and np.all(priced['full_values']==128)
 excluded=[dict(mask=masks[q//2],selected=bool(q%2),status=STATUS[int(code)]) for q,code in enumerate(batch.status) if code]
 records=[dict(mask=mask,selected=state,basis=list(map(int,priced['bases'][i])),support_value=128,full_value=128) for i,(mask,state) in enumerate(batch.branches)]
 assert len(masks)==4597 and len(records)==5782 and len(excluded)==3412
 sources=set(accepted['source_hashes'])|{'algebraic-results/orbit-rank-profiles.json.gz','verify_anchor_partner_projection.py','anchor_partner_projection_features.py','verify_projected_profile_moment_rows.py','coupling-results/anchor-native-matched-accepted.json','coupling-results/anchor-native-matched-accepted.frozen.json','coupling-results/anchor-native-matched-accepted.npz','coupling-results/anchor-native-accepted.dylib','coupling-results/anchor-projection-controls.py'}
 bank=dict(status='EXACT_ANCHORED_SUPPORT_CUT_CANDIDATE',synthetic_control=True,source_C16_answered=False,scope='Integration fixture only: valid physical count inequality tested against a deliberately infeasible synthetic point. Not a scientific separating result.',orbit=32,anchor=80,feature_layout=consumer.LAYOUT,point_sha256=sha(point),source_hashes={p:sha(ROOT/p) for p in sorted(sources)},allowed_masks=4597,mask_list=masks,feasible_branches=len(records),excluded_branches=excluded,cuts=[dict(coefficients=c,upper_bound=128,exact_target_value='129',exact_violation='1',support_records=records)])
 positive=ROOT/'coupling-results/anchor-projection-control-count-cut.json.gz';write(positive,bank)
 positive_run,receipt=run(positive,'positive',point);assert positive_run['returncode']==0 and positive_run['output_exists'],positive_run
 replay=read(receipt);assert replay['status']=='PASS' and replay['results'][0]['exact_violation']=='1'
 M,rhs,meta=consumer.matrix([positive],[receipt]);assert M.shape==(1,36495) and M.nnz==45 and list(M.indices)==list(range(45)) and list(M.data)==[16]*45 and rhs.tolist()==[128]
 assert sum(int(v)*owner[int(j)] for j,v in zip(M.indices,M.data))-int(rhs[0])==1
 print('POSITIVE COUNT CUT AND GUARDED MATRIX PASS',positive_run['seconds'],flush=True)
 mutations={
  'corrupt-bound':lambda b:b['cuts'][0].update(upper_bound=127,exact_violation='2'),
  'missing-branch':lambda b:b['cuts'][0]['support_records'].pop(),
  'wrong-anchor-phase':lambda b:b.update(anchor=81),
  'wrong-normalization':lambda b:b['cuts'][0].update(coefficients=[16*v for v in c],exact_target_value='2064',exact_violation='1936'),
 }
 negatives={}
 for name,mutate in mutations.items():
  b=copy.deepcopy(bank);mutate(b);path=ROOT/f'coupling-results/anchor-projection-control-{name}.json.gz';write(path,b)
  result,_=run(path,name,point);assert result['returncode']!=0 and not result['output_exists'],(name,result)
  try:consumer.matrix([path],[receipt])
  except AssertionError:guard=True
  else:raise AssertionError(f'matrix accepted changed bank {name}')
  result.update(bank_sha256=sha(path),guarded_matrix_rejected_stale_receipt=guard);negatives[name]=result;print('EXPECTED REJECTION',name,result['seconds'],flush=True)
 # A receipt cannot silently replace the factor16 or relax the right-hand side.
 receipt_controls={}
 for name,edit in [('row-factor',lambda r:r['results'][0]['compiled_owner_row'][0].__setitem__(1,'1')),('rhs',lambda r:r['results'][0].__setitem__('owner_rhs','129')),('consumer-hash',lambda r:r.__setitem__('consumer_sha256','0'*64)),('source-hash',lambda r:r['source_hashes'].__setitem__('pools/xcoords.txt','0'*64)),('dependency-hash',lambda r:r['dependencies'].__setitem__('audit_pools.py','0'*64))]:
  altered=copy.deepcopy(replay);edit(altered);path=ROOT/f'coupling-results/anchor-projection-control-bad-receipt-{name}.json';write(path,altered)
  try:consumer.matrix([positive],[path])
  except AssertionError:receipt_controls[name]={'rejected':True,'sha256':sha(path)}
  else:raise AssertionError(f'matrix accepted {name}')
 assert all(sha(ROOT/p)==h for p,h in bank['source_hashes'].items())
 result=dict(status='PASS_SYNTHETIC_ANCHOR_PROJECTION_INTEGRATION_CONTROLS',source_C16_answered=False,synthetic_point_explicitly_infeasible=True,script_sha256=sha(Path(__file__)),consumer_sha256=sha(ROOT/'verify_anchor_partner_projection.py'),positive_bank_sha256=sha(positive),positive_point_sha256=sha(point),positive_receipt_sha256=sha(receipt),positive_run=positive_run,allowed_masks=4597,anchor_branches=9194,feasible_branches=5782,excluded_branches=3412,all_support_basis_values=128,exact_target=129,exact_violation=1,matrix={'shape':list(M.shape),'nnz':M.nnz,'p_columns':list(map(int,M.indices)),'coefficients':list(map(int,M.data)),'rhs':rhs.tolist(),'exact_synthetic_residual':'1'},consumer_corruption_controls=negatives,matrix_receipt_controls=receipt_controls,source_hashes=bank['source_hashes'],elapsed_seconds=time.monotonic()-start,scope='Positive consumer and guarded-matrix path only. This synthetic point violates fixed basis count and is not a feasible scientific moment witness. All branch supports independently replayed from physical vectors; no new source obstruction or cover reduction.')
 write(out,result);print(json.dumps({k:v for k,v in result.items() if k not in ('source_hashes','matrix','consumer_corruption_controls','matrix_receipt_controls')}),flush=True)

if __name__=='__main__':main()
