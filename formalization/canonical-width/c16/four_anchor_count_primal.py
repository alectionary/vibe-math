"""Recover candidate feature directions from a count-only LP ray; exact reprice."""
from pathlib import Path
from fractions import Fraction
import argparse,gzip,hashlib,json,time
import highspy
from four_anchor_full_partner import FourAnchorOracle,LAYOUT
import numpy as np
from scipy.optimize import linprog
from scipy.sparse import coo_matrix,save_npz
from verify_four_anchor_full_partner import target,features
from verify_full_partner_basis_oracle import rebuild_domain
from verify_algebraic_model import physical
ROOT=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def main():
    ap=argparse.ArgumentParser();ap.add_argument('--anchors',type=int,nargs=4,required=True);ap.add_argument('--point',type=Path,required=True);ap.add_argument('--prefix',type=Path,required=True);a=ap.parse_args();start=time.monotonic();out=Path(str(a.prefix)+'.json');assert not out.exists();X,Z,_=physical();tar=target(a.point,a.anchors);rows=[];cols=[];data=[];ur=[];uc=[];ud=[];rhs=list(tar);metadata=[]
    for m in range(16):
        for k,v in enumerate(features(m,[])[:11]):
            if v:rows.append(k);cols.append(m);data.append(v)
    variables=[('lambda',m,-1) for m in range(16)];ubrow=0
    for m in range(16):
        selected=sorted(a.anchors[i] for i in range(4) if m>>i&1);domain=rebuild_domain(X,Z,selected,128);assert domain['status']=='FULL_PARTNER_BASIS_DOMAIN'
        buckets=[domain['zero']]+domain['bins'];r0=len(rhs);rhs.extend([Fraction(0)]*len(buckets))
        for k,A in enumerate(buckets):
            rows.append(r0+k);cols.append(m);data.append(-(128-len(selected)) if k==0 else -1)
            for j in A:
                v=len(variables);variables.append(('y',m,j));rows.extend([11+j,r0+k]);cols.extend([v,v]);data.extend([1,1])
                for i in range(4):
                    if m>>i&1:rows.append(731+720*i+j);cols.append(v);data.append(1)
                if k==0:ur.extend([ubrow,ubrow]);uc.extend([v,m]);ud.extend([1,-1]);ubrow+=1
        metadata.append({'mask':m,'zero_count':len(domain['zero']),'owner_counts':list(map(len,domain['bins']))})
    E=coo_matrix((np.array(data,dtype=np.int64),(rows,cols)),shape=(len(rhs),len(variables))).tocsr();U=coo_matrix((np.array(ud,dtype=np.int64),(ur,uc)),shape=(ubrow,len(variables))).tocsr();bb=np.array(list(map(float,rhs)))
    paths=['four_anchor_count_primal.py','four_anchor_full_partner.py','full_partner_basis_oracle.py','verify_four_anchor_full_partner.py','verify_full_partner_basis_oracle.py','verify_algebraic_model.py','physical-pool-source.json','pools/xcoords.txt','pools/zcoords.txt','moment-resumption-results/symmetry-bridge-independent.json'];hashes={p:sha(ROOT/p) for p in paths};frozen={'status':'FROZEN_BEFORE_COUNT_RAY_AND_EXACT_SUPPORT','source_C16_answered':False,'point_sha256':sha(a.point),'source_hashes':hashes,'anchors':a.anchors,'seconds':60,'variables':len(variables),'equalities':E.shape[0],'inequalities':U.shape[0],'source_domains':metadata,'scope':'Shared16-pattern masses, exact owner-bin counts, zero-pool count, eligibility and0<=y<=lambda. Zero-matroid rank inequalities omitted. Floating feasibility alone is not exact membership.'};fp=Path(str(a.prefix)+'.frozen.json');assert not fp.exists();fp.write_text(json.dumps(frozen,indent=2)+'\n')
    before=time.monotonic();H=highspy.Highs()
    for name,value in [('output_flag',False),('threads',1),('solver','simplex'),('presolve','off'),('time_limit',60.0),('primal_feasibility_tolerance',1e-9),('dual_feasibility_tolerance',1e-9)]:
        assert H.setOptionValue(name,value)==highspy.HighsStatus.kOk
    assert H.addVars(len(variables),np.zeros(len(variables)),np.ones(len(variables)))==highspy.HighsStatus.kOk
    assert H.addRows(E.shape[0],bb,bb,E.nnz,E.indptr.astype(np.int32),E.indices.astype(np.int32),E.data.astype(float))==highspy.HighsStatus.kOk
    assert H.addRows(U.shape[0],np.full(U.shape[0],-highspy.kHighsInf),np.zeros(U.shape[0]),U.nnz,U.indptr.astype(np.int32),U.indices.astype(np.int32),U.data.astype(float))==highspy.HighsStatus.kOk
    H.run();status=H.getModelStatus();solution=H.getSolution();assert status==highspy.HighsModelStatus.kOptimal,str(status);x=np.array(solution.col_value);assert min(x)>=-1e-9
    np.savez_compressed(str(a.prefix)+'.npz',x=x,variables=np.array(variables,dtype=str),rhs=np.array(list(map(str,rhs))),lambda_masses=x[:16]);save_npz(str(a.prefix)+'.equalities.npz',E);save_npz(str(a.prefix)+'.inequalities.npz',U)
    result={**frozen,'status':'NUMERICAL_COUNT_EXTENSION_FEASIBLE_PRESOLVE_OFF','solver_status':str(status),'solver_seconds':time.monotonic()-before,'max_equality_residual':float(max(abs(E@x-bb))),'max_inequality_violation':float(max(0,max(U@x))),'minimum_variable':float(min(x)),'positive_variables':int(sum(x>0)),'frozen_sha256':sha(fp),'elapsed_seconds':time.monotonic()-start,'scope':'Presolveoff feasible numerical primal contradicts earlierpresolveinfeasibilitystatus; exactrecoverystillrequired. No cut orrankmembershipclaim.'};assert all(sha(ROOT/p)==v for p,v in hashes.items());out.write_text(json.dumps(result,indent=2)+'\n');print(json.dumps({k:v for k,v in result.items() if k not in ('source_hashes','source_domains')}),flush=True)
if __name__=='__main__':main()
