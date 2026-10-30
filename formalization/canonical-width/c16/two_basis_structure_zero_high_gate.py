"""Exact independent zero-triple/quad shared-law local-box gate at a new point."""
from pathlib import Path
from fractions import Fraction as Q
import argparse,json,time
from verify_two_sided_full_basis_oracle import physical_source,target
from verify_two_basis_local_box import ROOT,sha,read,rebuild_statuses,class_normals,moment_inverse,g,SUBSETS

def main():
 ap=argparse.ArgumentParser();ap.add_argument('--point',type=Path,required=True);ap.add_argument('--geometry-reference',type=Path,required=True);ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();assert not a.output.exists();start=time.monotonic();ref=read(a.geometry_reference);xx,zz=ref['X_anchors'],ref['Z_anchors'];X,Z,bridge=physical_source();b=target(a.point,xx,zz);L,C=moment_inverse();lam=[sum(c*v for c,v in zip(row,b[:11])) for row in L];assert sum(lam)==1;assert all(sum(lam[m] for m in range(16) if m&s==s)==v for s,v in zip(SUBSETS,b[:11]+[Q(0)]*5));groups=rebuild_statuses(X,Z,xx,zz);assert len(groups)==len(ref['classes']);violations=[dict(kind='negative_pattern_mass',mask=m,value=str(l)) for m,l in enumerate(lam) if l<0];facets=equalities=checks=0
 if not violations:
  for cid,((status,indices),saved) in enumerate(zip(groups,ref['classes'])):
   assert saved['status']==list(status) and saved['indices']==indices;r,nf,ne=class_normals(status,saved);facets+=nf;equalities+=ne
   for kind,normals in [('facet',saved['facet_normals']),('equality',saved['equality_normals'])]:
    for normal in normals:
     for sign in [1,-1]:
      v=[sign*z for z in normal];h=[]
      for m in range(16):
       dot=sum(c*x for c,x in zip(v,g(m)));h.append(dot if status[m]==1 else max(0,dot) if status[m]==0 else 0)
      upper=sum(l*c for l,c in zip(lam,h));values=[sum(c*b[11+j if k==0 else 1451+1440*(k-1)+j] for k,c in enumerate(v)) for j in indices];checks+=len(indices);left=max(values)
      if left>upper:violations.append(dict(kind=kind,status_class=cid,vector=indices[values.index(left)],normal=v,pattern_support=h,exact_lhs=str(left),exact_rhs=str(upper),exact_violation=str(left-upper)))
 out=dict(status='PASS_EXACT_ZERO_HIGH_LOCALBOX_LAW' if not violations else 'EXACT_ZERO_HIGH_LAW_REJECTED',point_sha256=sha(a.point),geometry_reference_sha256=sha(a.geometry_reference),consumer_sha256=sha(__file__),dependencies={p:sha(ROOT/p) for p in ['verify_two_basis_local_box.py','verify_two_sided_full_basis_oracle.py','verify_algebraic_model.py','physical-pool-source.json','pools/xcoords.txt','pools/zcoords.txt']},X_anchors=xx,Z_anchors=zz,lambda_masses=list(map(str,lam)),high_moments=['0']*5,complete_status_classes=len(groups),independently_checked_facet_normals=facets,annihilators=equalities,literal_vector_support_checks=checks,violations=violations,source_C16_answered=False,scope='Only this zero-high shared law and individual conditional boxes. Failure is not infeasibility of the five-variable law family; success omits cardinalities/ranks.',elapsed_seconds=time.monotonic()-start);a.output.write_text(json.dumps(out,indent=2)+'\n');print({k:v for k,v in out.items() if k not in ['dependencies','lambda_masses']},flush=True)
if __name__=='__main__':main()
