"""Bounded four-anchor projection discovery with all16 exact support patterns."""
from pathlib import Path
from fractions import Fraction
import argparse,ast,datetime,gzip,hashlib,json,time
import numpy as np
from scipy.linalg import lstsq
from four_anchor_full_partner import FourAnchorOracle,column_features,moment_target,FEATURES,LAYOUT
from verify_projected_profile_moment_rows import point_vector
ROOT=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def read(p):
    b=Path(p).read_bytes();return json.loads(gzip.decompress(b) if str(p).endswith('.gz') else b)
def write(p,value):
    raw=(json.dumps(value,indent=2)+'\n').encode();Path(p).write_bytes(gzip.compress(raw,mtime=0) if str(p).endswith('.gz') else raw)
def local_imports(path,found):
    if path in found:return
    found.add(path)
    for node in ast.walk(ast.parse(path.read_text())):
        modules=([node.module] if isinstance(node,ast.ImportFrom) else [a.name for a in node.names] if isinstance(node,ast.Import) else [])
        for module in modules:
            if module:
                p=ROOT/(module.split('.')[0]+'.py')
                if p.exists():local_imports(p,found)
def main():
    ap=argparse.ArgumentParser();ap.add_argument('--anchors',type=int,nargs=4,required=True);ap.add_argument('--point',type=Path,required=True);ap.add_argument('--output',type=Path,required=True);ap.add_argument('--seconds',type=float,default=120);ap.add_argument('--max-cuts',type=int,default=2);a=ap.parse_args()
    assert 0<a.seconds<=120 and a.max_cuts>0 and not a.output.exists();start=time.monotonic();prefix=a.output.with_name(a.output.name.removesuffix('.json.gz').removesuffix('.json'))
    control=ROOT/'coupling-results/four-anchor-controls.json';assert read(control)['status']=='PASS_CONTROLS'
    target=moment_target(point_vector(a.point),a.anchors);b=np.array(list(map(float,target)));oracle=FourAnchorOracle(a.anchors);scale=1<<24
    seed=oracle.price([0]*FEATURES);features=[];masks=[];bases=[];lookup={}
    for m,f in enumerate(seed['columns']):
        if f is None:continue
        lookup[f.tobytes()]=len(features);features.append(f);masks.append(m);bases.append(np.array(seed['records'][m]['selected_Z_indices'],dtype=np.uint16))
    active=list(range(len(features)));weights=np.ones(len(active))/len(active)
    sources=set();local_imports(Path(__file__).resolve(),sources);local_imports(ROOT/'verify_four_anchor_full_partner.py',sources)
    sources.update(ROOT/p for p in ['physical-pool-source.json','pools/xcoords.txt','pools/zcoords.txt','moment-resumption-results/symmetry-bridge-independent.json']);sources.add(control)
    hashes={str(p.relative_to(ROOT)):sha(p) for p in sorted(sources)}
    frozen={'status':'FROZEN_BEFORE_FOUR_ANCHOR_WOLFE','utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'source_C16_answered':False,'point_sha256':sha(a.point),'source_hashes':hashes,'anchors':a.anchors,'selection_patterns':list(range(16)),'feature_layout':LAYOUT,'seconds':a.seconds,'pricing_scale':scale,'max_cuts':a.max_cuts,'initial_columns':len(features),'initial_weights':weights.tolist(),'metric':'raw Euclidean on3610 nonconstant features','scope':'Four fixed physical X anchors, all16 selected-subset domains. Absent anchors and remaining X completion are relaxed. No rotation reduction.'}
    fp=prefix.with_name(prefix.name+'.frozen.json');assert not fp.exists();write(fp,frozen)
    def mix(ids,w):return w@np.asarray([features[i] for i in ids],dtype=float)
    def objective(x):return .5*float(np.dot(x-b,x-b))
    def correct(ids,w):
        ids=list(ids);w=w.copy();rank=0
        for minor in range(1000):
            if time.monotonic()-start>=a.seconds:return ids,w,minor,int(rank),'TIME_LIMIT_DURING_CORRECTION'
            old=objective(mix(ids,w));V=np.asarray([features[i][1:] for i in ids],dtype=float)
            if len(ids)==1:alpha=np.ones(1)
            else:
                eta,_,rank,_=lstsq((V[1:]-V[0]).T,b[1:]-V[0],cond=1e-12,lapack_driver='gelsy');alpha=np.r_[1-eta.sum(),eta]
            assert np.all(np.isfinite(alpha))
            if alpha.min()>=-1e-11:
                w=np.maximum(alpha,0);w/=w.sum();keep=w>0;ids=[i for i,k in zip(ids,keep) if k];w=w[keep];assert objective(mix(ids,w))<=old+1e-9*max(1.,old);return ids,w,minor+1,int(rank),None
            bad=np.flatnonzero(alpha<0);ratios=w[bad]/(w[bad]-alpha[bad]);hit=int(bad[np.argmin(ratios)]);theta=float(min(ratios));assert -1e-12<=theta<=1+1e-12
            w=(1-theta)*w+theta*alpha;w[hit]=0;assert w.min()>=-1e-10;w=np.maximum(w,0);w/=w.sum();keep=w>0;ids=[i for i,k in zip(ids,keep) if k];w=w[keep];assert objective(mix(ids,w))<=old+1e-9*max(1.,old)
        return ids,w,1000,int(rank),'MINOR_CYCLE_LIMIT'
    rounds=[];cuts=[];seen=set();positive=0;reason='ROUND_LIMIT';progress=prefix.with_name(prefix.name+'.progress.json')
    for iteration in range(10000):
        if time.monotonic()-start>=a.seconds:reason='TIME_LIMIT';break
        t=time.monotonic();active,weights,minor,rank,failure=correct(active,weights);x=mix(active,weights);raw=b-x;raw[0]=0;norm=float(max(abs(raw)));rec={'round':iteration,'active_columns':len(active),'history_columns':len(features),'objective':objective(x),'max_feature_residual':norm,'correction_seconds':time.monotonic()-t,'minor_cycles':minor,'affine_rank':rank,'failure':failure};rounds.append(rec)
        if failure:reason=failure;break
        V=np.asarray([features[i] for i in active],dtype=float);stationarity=float(max(abs((V-x)@raw)));rec['stationarity_residual']=stationarity
        if stationarity>1e-7*max(1.,norm):reason='CORRAL_STATIONARITY_FAILURE';break
        if norm<=1e-10:reason='NUMERICAL_MIXTURE_REQUIRES_EXACT_RECOVERY';break
        direction=raw/norm;c=[int(np.rint(v*scale)) for v in direction];c[0]=0;t=time.monotonic();priced=oracle.price(c)
        # All16 rounded maximizers are scored using the true residual direction.
        feasible=[i for i,f in enumerate(priced['columns']) if f is not None];best=max(feasible,key=lambda i:float(direction@priced['columns'][i]));f=priced['columns'][best];record=priced['records'][best];bound=priced['upper_bound'];exact=sum(k*v for k,v in zip(c,target));gap=exact-bound;improvement=float(direction@(f-x));quantization=float(sum(abs(direction-np.array(c)/scale)))
        rec.update(pricing_seconds=time.monotonic()-t,exact_upper=bound,exact_target=str(exact),exact_gap=str(gap),scaled_gap=float(gap/scale),best_mask=best,true_gradient_vertex_improvement=improvement,quantization_advantage_bound=quantization)
        if gap>0:
            positive+=1;key=tuple(c)
            if key not in seen:
                seen.add(key);cuts.append({'round':iteration,'coefficients':c,'upper_bound':bound,'exact_target_value':str(exact),'exact_violation':str(gap),'pricing_scale':scale,'support_records':priced['records']});cuts.sort(key=lambda cut:Fraction(cut['exact_violation']),reverse=True);del cuts[a.max_cuts:]
        rec['retained_cuts']=len(cuts);print(json.dumps(rec),flush=True)
        if improvement<=1e-12:reason='NO_TRUE_GRADIENT_IMPROVEMENT_FROM_ROUNDED_PRICING';break
        key=f.tobytes();chosen=lookup.get(key)
        if chosen is None:chosen=len(features);lookup[key]=chosen;features.append(f);masks.append(best);bases.append(np.array(record['selected_Z_indices'],dtype=np.uint16))
        if chosen in active:reason='PRICED_VERTEX_ALREADY_IN_CORRAL';break
        active.append(chosen);weights=np.r_[weights,0.]
        if iteration%25==0:write(progress,{'status':'RUNNING','elapsed_seconds':time.monotonic()-start,'rounds':rounds,'retained_cut_count':len(cuts)})
    colpath=prefix.with_name(prefix.name+'.columns.npz');assert not colpath.exists();global_weights=np.zeros(len(features));global_weights[np.array(active,dtype=np.int64)]=weights
    np.savez_compressed(colpath,features=np.stack(features),masks=np.array(masks,dtype=np.uint8),selected_Z_indices=np.stack(bases),master_mixture_weights=global_weights,active_column_ids=np.array(active,dtype=np.int32))
    assert all(sha(ROOT/p)==v for p,v in hashes.items());result={**frozen,'status':'EXACT_SUPPORT_CUT_CANDIDATE' if cuts else 'NO_EXACT_SEPARATOR_FOUND','frozen_sha256':sha(fp),'cuts':cuts,'rounds':rounds,'stopping_reason':reason,'elapsed_seconds':time.monotonic()-start,'positive_proposals':positive,'history_columns':len(features),'columns_artifact':str(colpath),'columns_sha256':sha(colpath),'numeric_mixture_max_feature_residual':float(max(abs(mix(active,weights)-b)))};write(a.output,result);print({k:result[k] for k in ['status','stopping_reason','elapsed_seconds','positive_proposals','history_columns','numeric_mixture_max_feature_residual']},flush=True)
if __name__=='__main__':main()
