#!/usr/bin/env python3
"""Bounded1512-feature Wolfe projection with exact native anchored pricing.

Only the best priced vertex enters the saved history at each round. All5782
feasible branches are repriced and exported for each retained candidate cut.
No small numerical residual is accepted as membership; cut acceptance belongs
to the independent all-mask consumer.
"""
from pathlib import Path
from fractions import Fraction
import argparse,ast,datetime,gzip,hashlib,json,math,time
import numpy as np
from scipy.linalg import lstsq
from full_partner_anchor_native import NativeAnchorBatch,STATUS
from full_partner_projection import mask_universe
from full_partner_projection_features import rotate
from anchor_partner_projection_features import FEATURES,LAYOUT,column_features,moment_target
from verify_projected_profile_moment_rows import point_vector
from verify_full_partner_basis_oracle import dimension

ROOT=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def read(p):
    raw=Path(p).read_bytes();return json.loads(gzip.decompress(raw) if str(p).endswith('.gz') else raw)
def write(p,value):
    raw=(json.dumps(value,indent=2)+'\n').encode();Path(p).write_bytes(gzip.compress(raw,mtime=0) if str(p).endswith('.gz') else raw)
def local_imports(path,found):
    if path in found:return
    found.add(path)
    for node in ast.walk(ast.parse(path.read_text())):
        modules=([node.module] if isinstance(node,ast.ImportFrom) else [a.name for a in node.names] if isinstance(node,ast.Import) else [])
        for module in modules:
            if module:
                candidate=ROOT/(module.split('.')[0]+'.py')
                if candidate.exists():local_imports(candidate,found)


def main():
    ap=argparse.ArgumentParser();ap.add_argument('--point',type=Path,required=True);ap.add_argument('--archive',type=Path,required=True);ap.add_argument('--native-replay',type=Path,required=True);ap.add_argument('--library',type=Path,default=ROOT/'coupling-results/anchor-native-accepted.dylib');ap.add_argument('--anchor',type=int,default=80);ap.add_argument('--seconds',type=float,default=300);ap.add_argument('--max-rounds',type=int,default=3000);ap.add_argument('--max-cuts',type=int,default=2);ap.add_argument('--pricing-scale',type=int,default=1<<24);ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();assert 0<a.seconds<=600 and a.max_cuts>0 and a.anchor%16==0 and not a.output.exists()
    start=time.monotonic();gate=read(a.native_replay);assert gate['status']=='PASS_MATCHED_EXACT_NATIVE_GATE' and gate['native_library_sha256']==sha(a.library)
    assert all(sha(ROOT/p)==v for p,v in gate['source_hashes'].items())
    target=moment_target(point_vector(a.point),32,a.anchor);b=np.array(list(map(float,target)));scale=a.pricing_scale
    saved=np.load(a.archive);oldweights=saved['master_mixture_weights'];assert np.min(oldweights)>=0;positive=np.flatnonzero(oldweights>0);assert len(positive)>0
    weights=np.array(oldweights[positive],dtype=float);weights/=weights.sum();features=[];masks=[];bases=[];seed_masks=saved['masks'];seed_bases=saved['selected_Z_indices']
    for order,index in enumerate(positive):
        rotation=order%16;mask=rotate(int(seed_masks[index]),rotation);chosen=[16*(int(j)//16)+(int(j)%16+rotation)%16 for j in seed_bases[index]]
        masks.append(mask);bases.append(np.array(chosen,dtype=np.uint16));features.append(np.array(column_features(mask,chosen,a.anchor),dtype=np.int16))
    assert len({f.tobytes() for f in features})==len(features)
    X,Z=[[int(v,16) for v in (ROOT/f'pools/{s}coords.txt').read_text().split()] for s in 'xz']
    for mask,B in zip(masks,bases):
        assert dimension(Z[int(j)] for j in B)==128
        signatures=[sum(((X[512+h]&Z[int(j)]).bit_count()%2)<<h for h in range(16) if mask>>h&1) for j in B]
        assert all(v.bit_count()<=1 for v in signatures)
        assert all(sum(v==1<<h for v in signatures)==1 for h in range(16) if mask>>h&1)
    allowed,_=mask_universe(32);batch=NativeAnchorBatch(allowed,anchor=a.anchor,orbit=32,library=a.library);assert batch.context is not None
    excluded=[{'mask':allowed[q//2],'selected':bool(q%2),'status':STATUS[int(code)]} for q,code in enumerate(batch.status) if code]
    active=list(range(len(features)));lookup={f.tobytes():i for i,f in enumerate(features)}
    sources=set();local_imports(Path(__file__).resolve(),sources)
    sources.update(ROOT/p for p in ['full_partner_anchor_native.cpp','physical-pool-source.json','pools/xcoords.txt','pools/zcoords.txt','algebraic-results/orbit-rank-profiles.json.gz','algebraic-results/hulls-16-rank.json.gz'])
    hashes={str(p.relative_to(ROOT)):sha(p) for p in sorted(sources)}
    frozen={'status':'FROZEN_BEFORE_ANCHORED_WOLFE','utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'source_C16_answered':False,'point_sha256':sha(a.point),'seed_archive_sha256':sha(a.archive),'native_replay_sha256':sha(a.native_replay),'native_library_sha256':sha(a.library),'source_hashes':hashes,'orbit':32,'anchor':a.anchor,'feature_layout':LAYOUT,'allowed_masks':len(allowed),'mask_list':allowed,'feasible_branches':len(batch.branches),'excluded_branches':excluded,'seconds':a.seconds,'max_rounds':a.max_rounds,'max_cuts':a.max_cuts,'pricing_scale':scale,'initial_columns':len(features),'seed_archive_column_ids':positive.tolist(),'seed_rotations':[i%16 for i in range(len(features))],'initial_numeric_weights':weights.tolist(),'all_seed_bases_physically_rank_and_owner_checked':True,'history_policy':'one best exact integer-priced vertex per iteration, plus seed; all feasible branch supports exported only for retained cuts','metric':'raw Euclidean','scope':'Bounded discovery only. All4597 masks and both anchor states priced; independent source support replay required.'}
    fp=a.output.with_name(a.output.name.removesuffix('.json.gz').removesuffix('.json')+'.frozen.json');assert not fp.exists();write(fp,frozen)
    def mix(ids,w):return w@np.asarray([features[i] for i in ids],dtype=float)
    def objective(x):return .5*float(np.dot(x-b,x-b))
    def correct(ids,w):
        ids=list(ids);w=w.copy();minor=0
        for minor in range(1000):
            if time.monotonic()-start>=a.seconds:return ids,w,minor,'TIME_LIMIT_DURING_CORRECTION'
            old=objective(mix(ids,w));V=np.asarray([features[i][1:] for i in ids],dtype=float)
            if len(ids)==1:alpha=np.ones(1);rank=0
            else:
                eta,_,rank,_=lstsq((V[1:]-V[0]).T,b[1:]-V[0],cond=1e-12,lapack_driver='gelsy')
                if rank!=len(ids)-1:return ids,w,minor,'AFFINE_RANK_FAILURE'
                alpha=np.r_[1-eta.sum(),eta]
            if alpha.min()>=-1e-11:
                w=np.maximum(alpha,0);w/=w.sum();keep=w>0;ids=[i for i,k in zip(ids,keep) if k];w=w[keep]
                assert objective(mix(ids,w))<=old+1e-9*max(1.,old)
                return ids,w,minor+1,None
            bad=np.flatnonzero(alpha<0);ratios=w[bad]/(w[bad]-alpha[bad]);hit=int(bad[np.argmin(ratios)]);theta=float(min(ratios));assert -1e-12<=theta<=1+1e-12
            w=(1-theta)*w+theta*alpha;w[hit]=0;assert w.min()>=-1e-10;w=np.maximum(w,0);w/=w.sum();keep=w>0;ids=[i for i,k in zip(ids,keep) if k];w=w[keep]
            assert objective(mix(ids,w))<=old+1e-9*max(1.,old)
        return ids,w,minor+1,'MINOR_CYCLE_LIMIT'
    rounds=[];cuts=[];seen=set();reason='ROUND_LIMIT';positive_count=0;log_path=a.output.with_name(a.output.name.removesuffix('.json.gz').removesuffix('.json')+'.progress.json')
    for iteration in range(a.max_rounds):
        if time.monotonic()-start>=a.seconds:reason='TIME_LIMIT';break
        t=time.monotonic();active,weights,minor,failure=correct(active,weights);x=mix(active,weights);raw=b-x;raw[0]=0;norm=max(abs(raw));rec={'round':iteration,'active_columns':len(active),'history_columns':len(features),'objective':objective(x),'max_feature_residual':float(max(abs(b-x))),'correction_seconds':time.monotonic()-t,'minor_cycles':minor,'failure':failure};rounds.append(rec)
        if failure:reason=failure;break
        V=np.asarray([features[i] for i in active],dtype=float);stationarity=float(max(abs((V-x)@raw)));rec['stationarity_residual']=stationarity
        if stationarity>1e-7*max(1.,norm):reason='CORRAL_STATIONARITY_FAILURE';break
        if norm<=1e-10:reason='NUMERICAL_MIXTURE_REQUIRES_EXACT_RECOVERY';break
        direction=raw/norm;c=[int(np.rint(v*scale)) for v in direction];c[0]=0;t=time.monotonic();priced=batch.price(c);full=priced['full_values'];best=int(np.argmax(full));bound=int(full[best]);mask,state=batch.branches[best];B=list(map(int,priced['bases'][best]));f=np.array(column_features(mask,B,a.anchor),dtype=np.int16)
        assert int(np.dot(np.array(c,dtype=np.int64),f.astype(np.int64)))==bound
        exact=sum(k*v for k,v in zip(c,target));gap=exact-bound;score=float(direction@f);improvement=score-float(direction@x);quantization=32*float(sum(abs(direction-np.array(c)/scale)))
        rec.update(pricing_seconds=time.monotonic()-t,backend=priced['backend'],exact_upper=bound,exact_target=str(exact),exact_gap=str(gap),scaled_gap=float(gap/scale),best_mask=mask,best_anchor_selected=state,true_gradient_vertex_improvement=improvement,quantization_bound=quantization)
        if gap>0:
            positive_count+=1;key=tuple(c)
            if key not in seen:
                seen.add(key);cuts.append({'round':iteration,'coefficients':c,'upper_bound':bound,'exact_target_value':str(exact),'exact_violation':str(gap),'pricing_scale':scale});cuts.sort(key=lambda cut:Fraction(cut['exact_violation']),reverse=True);del cuts[a.max_cuts:]
        rec['retained_cuts']=len(cuts);print(json.dumps(rec),flush=True)
        if improvement<=1e-12:reason='NO_TRUE_GRADIENT_IMPROVEMENT_FROM_ROUNDED_PRICING';break
        key=f.tobytes();chosen=lookup.get(key)
        if chosen is None:chosen=len(features);lookup[key]=chosen;features.append(f);masks.append(mask);bases.append(np.array(B,dtype=np.uint16))
        if chosen in active:reason='PRICED_VERTEX_ALREADY_IN_CORRAL';break
        active.append(chosen);weights=np.r_[weights,0.]
        if iteration%25==0:write(log_path,{'status':'RUNNING','elapsed_seconds':time.monotonic()-start,'rounds':rounds,'retained_cut_count':len(cuts),'positive_proposals':positive_count})
    pricing_done=time.monotonic()
    for cut in cuts:
        priced=batch.price(cut['coefficients']);assert max(map(int,priced['full_values']))==cut['upper_bound'];records=[]
        for index,(mask,state) in enumerate(batch.branches):records.append({'mask':mask,'selected':state,'basis':list(map(int,priced['bases'][index])),'support_value':int(priced['values'][index]),'full_value':int(priced['full_values'][index])})
        cut['support_records']=records
    colpath=a.output.with_name(a.output.name.removesuffix('.json.gz').removesuffix('.json')+'.columns.npz');global_weights=np.zeros(len(features));global_weights[np.array(active,dtype=np.int64)]=weights
    np.savez_compressed(colpath,features=np.stack(features),masks=np.array(masks,dtype=np.uint16),selected_Z_indices=np.stack(bases),master_mixture_weights=global_weights,active_column_ids=np.array(active,dtype=np.int32))
    assert all(sha(ROOT/p)==v for p,v in hashes.items())
    result={**frozen,'status':'EXACT_ANCHORED_SUPPORT_CUT_CANDIDATE' if cuts else 'NO_EXACT_ANCHORED_SEPARATOR_FOUND','frozen_sha256':sha(fp),'cuts':cuts,'rounds':rounds,'stopping_reason':reason,'search_seconds':pricing_done-start,'elapsed_seconds':time.monotonic()-start,'positive_proposals':positive_count,'history_columns':len(features),'columns_artifact':str(colpath),'columns_sha256':sha(colpath),'source_C16_answered':False}
    write(a.output,result);print({k:result[k] for k in ['status','stopping_reason','search_seconds','elapsed_seconds','positive_proposals','history_columns']},flush=True)

if __name__=='__main__':main()
