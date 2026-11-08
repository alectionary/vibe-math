from pathlib import Path
import sys,hashlib,json,time
C=Path('/private/tmp/c16-coupling-clean-0826/formalization/canonical-width/c16');O=Path(__file__).resolve().parent;sys.path.insert(0,str(C))
from verify_algebraic_model import physical
from verify_full_partner_basis_oracle import dimension
from verify_sparse_quotient import SparseQuotientConsumer
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
paths=['coupling-results/word-subspace-minimized-independent.json','coupling-results/word-subspace-minimized-new-cuts.json','verify_algebraic_model.py','verify_full_partner_basis_oracle.py','verify_sparse_quotient.py','physical-pool-source.json','pools/xcoords.txt','pools/zcoords.txt']
hashes={p:sha(C/p) for p in paths};(O/'word-six-frozen.json').write_text(json.dumps({'status':'FROZEN_BEFORE_REPLAY','source_hashes':hashes,'controller_sha256':sha(__file__)},indent=2)+'\n')
t=time.monotonic();X,Z,A=physical();assert X==[int(v,16) for v in (C/'pools/xcoords.txt').read_text().split()] and Z==[int(v,16) for v in (C/'pools/zcoords.txt').read_text().split()]
assert dimension(X)==dimension(Z)==dimension(x|(z<<128) for x,z in zip(X,Z))==128
assert all((A[i]>>j&1)==(A[j]>>i&1) for i in range(720) for j in range(720))
parent=json.loads((C/paths[0]).read_text());new=json.loads((C/paths[1]).read_text());consumer=SparseQuotientConsumer(X,Z);records=[];cache={}
for row in parent['records']:
 cert=row['certificate'];consumer.check(cert);side=cert['side'];U,V=(X,Z) if side==0 else (Z,X);J=cert['mandatory_opposite'];w=int(cert['witness_hex'],16);L={0}
 for j in J:L|={ell^V[j] for ell in list(L)}
 assert dimension(V[j] for j in J)==len(J) and len(L)==1<<len(J) and w not in L
 D=[i for i,u in enumerate(U) if (u&w).bit_count()%2 and all(not (u&V[j]).bit_count()%2 for j in J)]
 assert D==cert['detecting_support'] and len(D)==cert['order']==3
 if side not in cache:
  values=[0,*V];cache[side]=(values,{v^z for i,v in enumerate(values) for z in values[i:]})
 values,pairs=cache[side];assert all(w^ell^v not in pairs for ell in L for v in values)
 records.append({'side':side,'mandatory_indices':J,'detectors':D,'mandatory_rank':len(J),'literal_span_size':len(L),'literal_no_at_most_three_source_sum_checks':len(L)*len(values),'exact_demand_lower_bound':4})
assert len(records)==6 and len(new['cuts'])==2
assert all(any(c['certificate']==r['certificate'] for r in parent['records']) for c in new['cuts'])
assert all(sha(C/p)==h for p,h in hashes.items())
out={'status':'PASS_SIX_MINIMIZED_SOURCE_CLAUSES_AND_TWO_NEW_SUBSET','source_C16_answered':False,'source_hashes':hashes,'controller_sha256':sha(__file__),'minimized_certificates_checked':6,'new_clauses_in_minimized_set':2,'records':records,'seconds':time.monotonic()-t,'scope':'Physical source clauses are reproved by independent quotient consumer and literal mandatory-span/source-pair sums; historical minimality and old-bank nonsubsumption inventory are not rerun.'}
(O/'word-six.json').write_text(json.dumps(out,indent=2)+'\n');print(json.dumps({k:v for k,v in out.items() if k not in ['source_hashes','records']}))
