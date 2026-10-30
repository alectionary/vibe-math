"""Independent physical/sparse-matrix audit of a frozen prefix extension.

No producer feature, domain, elimination, or matrix routine is imported.
This validates necessity of its rows; numerical LP status proves nothing here.
"""
from pathlib import Path
from fractions import Fraction
import argparse,gzip,json,hashlib,time
import numpy as np
from scipy.sparse import coo_matrix,load_npz
from verify_algebraic_model import physical
from verify_full_partner_basis_oracle import rebuild_domain,dimension,extend
from verify_full_partner_projection import point_data,literal_features,weights,turn,move
ROOT=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def read(p):
    b=Path(p).read_bytes();return json.loads(gzip.decompress(b) if str(p).endswith('.gz') else b)
def main():
    ap=argparse.ArgumentParser();ap.add_argument('--prefix',type=Path,required=True);ap.add_argument('--point',type=Path,required=True);ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();assert not a.output.exists();start=time.monotonic()
    p=lambda s:Path(str(a.prefix)+s);frozen=read(p('.frozen.json'));report=read(p('.json'));assert report['frozen_sha256']==sha(p('.frozen.json')) and frozen['point_sha256']==sha(a.point)
    assert all(sha(ROOT/q)==v for q,v in frozen['source_hashes'].items());E=load_npz(p('.equalities.npz'));U=load_npz(p('.inequalities.npz'));rankrows=read(p('.rank-rows.json.gz'));masks=frozen['representatives'];owner,target=point_data(a.point,32)
    X,Z,A=physical();assert X==[int(v,16) for v in (ROOT/'pools/xcoords.txt').read_text().split()] and Z==[int(v,16) for v in (ROOT/'pools/zcoords.txt').read_text().split()]
    symmetry=read(ROOT/'moment-resumption-results/symmetry-bridge-independent.json');assert symmetry['status']=='PASS' and all(sha(ROOT/q)==v for q,v in symmetry['pool_sha256'].items())
    symmetry_ranks=[dimension([x|(z<<128) for x,z in zip(X,Z)]),dimension([X[i]|(X[move(i,1)]<<128) for i in range(720)]),dimension([Z[i]|(Z[move(i,1)]<<128) for i in range(720)])];assert symmetry_ranks==[128]*3
    assert all((A[i]>>j&1)==(A[j]>>i&1)==(A[move(i,1)]>>move(j,1)&1) for i in range(720) for j in range(720))
    profiles=read(ROOT/'algebraic-results/orbit-rank-profiles.json.gz');profile=next(r for r in profiles['records'] if r['orbit']==32);phase=X[512:528];assert dimension(phase)==16;pairprofiles=[sum(((x&z).bit_count()%2)<<h for h,x in enumerate(phase)) for z in Z];bad=bytearray(65536)
    for cert in profile['minimal_bad_certificates']:
        m=cert['mask'];w=int(cert['annihilator_hex'],16);assert 0<w<1<<128;bad[m]=1
        if cert['kind']=='zero_rank':
            chosen=[phase[h] for h in range(16) if m>>h&1];assert dimension(chosen+[w])==len(chosen)+1;assert all(t&m for z,t in zip(Z,pairprofiles) if (z&w).bit_count()%2)
        else:assert cert['kind']=='missing_private' and all((t&m).bit_count()>1 for z,t in zip(Z,pairprofiles) if (z&w).bit_count()%2)
    for m in range(65536):
        if not bad[m]:
            bits=m
            while bits:
                bit=bits&-bits;bits-=bit
                if bad[m^bit]:bad[m]=1;break
    allowed=[m for m in range(65536) if not bad[m]];reps=sorted({min(turn(m,h) for h in range(16)) for m in allowed});assert len(allowed)==4597 and reps==masks and len(masks)==291
    bank=read(ROOT/'coupling-results/native775-witness9-gauge-rounded.json.gz');receipt=read(ROOT/'coupling-results/native775-witness9-gauge-rounded-independent.json');assert receipt['status']=='PASS' and receipt['bank_sha256']==sha(ROOT/'coupling-results/native775-witness9-gauge-rounded.json.gz');directions=[bank['cuts'][i]['coefficients'] for i in frozen['rank_cut_indices']]
    er=[];ec=[];ed=[];ur=[];uc=[];ud=[];variables=[('lambda',m,-1) for m in masks];rhs=list(target);ni=0;ri=0;lookup={};source_prefix_checks=0;expected_rmeta=[]
    for mid,m in enumerate(masks):
        f=literal_features(m,[])
        for k,v in enumerate(f[:10]):
            if v:er.append(k);ec.append(mid);ed.append(v)
        selected=[512+h for h in range(16) if m>>h&1];d=rebuild_domain(X,Z,selected,128);assert d['status']=='FULL_PARTNER_BASIS_DOMAIN';r=128-len(selected);buckets=[d['zero']]+d['bins'];base=len(rhs);rhs.extend([Fraction(0)]*len(buckets));indices={}
        for bi,bucket in enumerate(buckets):
            er.append(base+bi);ec.append(mid);ed.append(-r if bi==0 else -1)
            for j in bucket:
                vi=len(variables);variables.append(('y',m,j));indices[j]=vi;lookup[m,j]=vi;jo,b=divmod(j,16);er.extend([10+jo,base+bi]);ec.extend([vi,vi]);ed.extend([1,1])
                for h in range(16):
                    if m>>((b-h)%16)&1:er.append(55+16*jo+h);ec.append(vi);ed.append(1)
                if bi==0:ur.extend([ni,ni]);uc.extend([vi,mid]);ud.extend([1,-1]);ni+=1
        seen=set()
        for ci,c in enumerate(directions):
            w=weights(m,c);order=sorted(d['zero'],key=lambda j:(-w[j],j));rows={};prefix=[]
            for pos,j in enumerate(order):
                prefix.append(j);extend(rows,Z[j]);rr=len(rows);source_prefix_checks+=1
                if pos+1<len(order) and w[j]==w[order[pos+1]]:continue
                if rr==len(prefix) or rr==r:continue
                key=tuple(sorted(prefix))
                if key in seen:continue
                seen.add(key);assert rr==dimension(Z[j] for j in key)
                record={'mask':m,'direction':ci,'prefix':list(key),'rank':rr,'matrix_row':ni};expected_rmeta.append(record)
                ur.extend([ni]*(len(key)+1));uc.extend([mid]+[indices[j] for j in key]);ud.extend([-rr]+[1]*len(key));ni+=1
    Ee=coo_matrix((np.array(ed,dtype=np.int64),(er,ec)),shape=(len(rhs),len(variables))).tocsr();Ue=coo_matrix((np.array(ud,dtype=np.int64),(ur,uc)),shape=(ni,len(variables))).tocsr();assert E.shape==Ee.shape and U.shape==Ue.shape and (E-Ee).nnz==(U-Ue).nnz==0;assert rankrows==expected_rmeta
    # Literal lifted physical vertices check both feature semantics and every
    # local owner/cardinality/prefix row, including nontrivial mask stabilizers.
    vr=[];vc=[];vv=[];expected=[]
    for mid,m in enumerate(masks):
        B=bank['cuts'][0]['support_records'][mid]['selected_Z_indices'];assert len(B)==len(set(B))==128 and dimension(Z[j] for j in B)==128;vr.append(mid);vc.append(mid);vv.append(1)
        for j in B:vr.append(lookup[m,j]);vc.append(mid);vv.append(1)
        expected.append(literal_features(m,B))
    vertices=coo_matrix((vv,(vr,vc)),shape=(len(variables),len(masks))).tocsr();image=E@vertices;assert np.array_equal(image[:775].toarray(),np.array(expected).T) and image[775:].nnz==0;res=U@vertices;assert res.data.max(initial=0)<=0
    # Rotation controls use actual columns, not an assumed class multiplicity.
    rotation_checks=0
    for mid in range(0,len(masks),19):
        m=masks[mid];B=bank['cuts'][0]['support_records'][mid]['selected_Z_indices'];f=literal_features(m,B)
        for h in range(16):assert literal_features(turn(m,h),[move(j,h) for j in B])==f;rotation_checks+=775
    result={'status':'PASS_NECESSARY_PREFIX_EXTENSION_FORMULATION_AND_MATRICES','source_C16_answered':False,'projected_membership_proved':False,'solver_status_observed':report['solver_status'],'producer_sha256':sha(ROOT/'full_partner_prefix_extension.py'),'consumer_sha256':sha(Path(__file__)),'point_sha256':sha(a.point),'frozen_sha256':sha(p('.frozen.json')),'source_hashes':frozen['source_hashes'],'matrix_sha256':{str(p(s)):sha(p(s)) for s in ('.equalities.npz','.inequalities.npz','.rank-rows.json.gz')},'variables':len(variables),'equalities':E.shape[0],'inequalities':U.shape[0],'nnz':E.nnz+U.nnz,'exact_sparse_entry_mismatches':0,'rank_prefix_rows_physically_checked':len(rankrows),'rank_prefix_elimination_checks':source_prefix_checks,'profile_bad_witnesses_physically_replayed':len(profile['minimal_bad_certificates']),'allowed_masks':len(allowed),'representatives':len(masks),'symmetry_graph_ranks':symmetry_ranks,'physical_lifted_vertices_checked':len(masks),'literal_rotation_feature_equalities':rotation_checks,'target_normalization':'factor16; class probabilities carry total class mass','elapsed_seconds':time.monotonic()-start,'scope':'All saved sparse rows independently rebuilt from physical pools; every row is source-necessary. Selected prefix inequalities do not certify the complete zero-matroid base polytopes. Numerical timeout has no feasibility or exclusion interpretation.'};a.output.write_text(json.dumps(result,indent=2)+'\n');print(json.dumps({k:v for k,v in result.items() if k not in ('source_hashes','matrix_sha256')}),flush=True)
if __name__=='__main__':main()
