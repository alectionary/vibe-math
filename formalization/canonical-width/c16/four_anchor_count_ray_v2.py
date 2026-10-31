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
    paths=['four_anchor_count_ray_v2.py','four_anchor_full_partner.py','full_partner_basis_oracle.py','verify_four_anchor_full_partner.py','verify_full_partner_basis_oracle.py','verify_algebraic_model.py','physical-pool-source.json','pools/xcoords.txt','pools/zcoords.txt','moment-resumption-results/symmetry-bridge-independent.json'];hashes={p:sha(ROOT/p) for p in paths};frozen={'status':'FROZEN_BEFORE_COUNT_RAY_AND_EXACT_SUPPORT','source_C16_answered':False,'point_sha256':sha(a.point),'source_hashes':hashes,'anchors':a.anchors,'seconds':60,'variables':len(variables),'equalities':E.shape[0],'inequalities':U.shape[0],'source_domains':metadata,'scope':'Shared16-pattern masses, exact owner-bin counts, zero-pool count, eligibility and0<=y<=lambda. Zero-matroid rank inequalities omitted. Floating feasibility alone is not exact membership.'};fp=Path(str(a.prefix)+'.frozen.json');assert not fp.exists();fp.write_text(json.dumps(frozen,indent=2)+'\n')
    before=time.monotonic();H=highspy.Highs()
    for name,value in [('output_flag',False),('threads',1),('solver','simplex'),('presolve','off'),('time_limit',60.0),('primal_feasibility_tolerance',1e-9),('dual_feasibility_tolerance',1e-9)]:
        assert H.setOptionValue(name,value)==highspy.HighsStatus.kOk
    assert H.addVars(len(variables),np.zeros(len(variables)),np.ones(len(variables)))==highspy.HighsStatus.kOk
    assert H.addRows(E.shape[0],bb,bb,E.nnz,E.indptr.astype(np.int32),E.indices.astype(np.int32),E.data.astype(float))==highspy.HighsStatus.kOk
    assert H.addRows(U.shape[0],np.full(U.shape[0],-highspy.kHighsInf),np.zeros(U.shape[0]),U.nnz,U.indptr.astype(np.int32),U.indices.astype(np.int32),U.data.astype(float))==highspy.HighsStatus.kOk
    H.run();model_status=str(H.getModelStatus());ray_status,exists,ray=H.getDualRay();assert exists,(model_status,str(ray_status));ray=np.array(ray);np.savez_compressed(str(a.prefix)+'.ray.npz',ray=ray,rhs=np.array(list(map(str,rhs))))
    numerical_seconds=time.monotonic()-before;O=FourAnchorOracle(a.anchors);cuts=[];tests=[];seen=set()
    for sign in (1,-1):
        direction=sign*ray[:3611].copy();direction[0]=0;direction/=max(abs(direction))
        for scale in (1,2,4,8,16,64,256,4096,65536,1048576):
            c=[int(np.rint(v*scale)) for v in direction];key=tuple(c)
            if key in seen:continue
            seen.add(key);priced=O.price(c);exact=sum(v*t for v,t in zip(c,tar));gap=exact-priced['upper_bound'];count_bounds=[]
            for m,d in enumerate(O.domains):
                if d['status']!='FULL_PARTNER_BASIS_DOMAIN':continue
                w=[c[11+j]+sum(c[731+720*i+j] for i in range(4) if m>>i&1) for j in range(720)]
                local=sum(v*f for v,f in zip(c[:11],features(m,[])[:11]));count_bounds.append(local+sum(max(w[j] for j in A) for A in d['owner_bins'])+sum(sorted((w[j] for j in d['zero_indices']),reverse=True)[:d['zero_basis_required']]))
            countH=max(count_bounds);test={'sign':sign,'scale':scale,'exact_target':str(exact),'full_basis_upper':priced['upper_bound'],'exact_gap':str(gap),'count_only_upper':countH,'count_only_gap':str(exact-countH),'nonzero_coefficients':sum(v!=0 for v in c)};tests.append(test);print(test,flush=True)
            if gap>0:cuts.append({'coefficients':c,'upper_bound':priced['upper_bound'],'exact_target_value':str(exact),'exact_violation':str(gap),'pricing_scale':scale,'support_records':priced['records'],'attribution':test})
    assert all(sha(ROOT/p)==v for p,v in hashes.items());bank={**frozen,'feature_layout':LAYOUT,'selection_patterns':list(range(16)),'status':'EXACT_SUPPORT_CUT_CANDIDATE' if cuts else 'NO_EXACT_RAY_SEPARATOR','frozen_sha256':sha(fp),'cuts':cuts,'solver_model_status':model_status,'solver_seconds':numerical_seconds,'tests':tests,'elapsed_seconds':time.monotonic()-start,'scope':'HiGHS infeasibility ray is discovery only. Each integer direction is freshly bounded over all16 physical full-basis domains; exactpositive gap requires independent consumer. Count-only support separately attributes rank necessity.'};out.write_text(json.dumps(bank,indent=2)+'\n');print({'status':bank['status'],'positive_cuts':len(cuts),'elapsed_seconds':bank['elapsed_seconds']},flush=True)
if __name__=='__main__':main()
