"""Exact zero-face reduction of a pinned, independently checked owner model.

Each omitted probability has explicit original-row lower/upper proofs. The
full semantic model is immutable, and endpoint acceptance uses its full rows.
"""
from pathlib import Path
from fractions import Fraction as Q
import argparse, json, os, time
from two_basis_owner_star_capacity import ROOT, sha, read, decode, empty, term, plus
from export_owner_star_capacity_lp import semantic_rows
from export_joint_general_exact_lp import replay_text
from export_joint_fixed_exact_lp import write_row


def reduction(model, features, pinned):
    assert pinned is True
    rows = list(semantic_rows(model, features, pinned))
    names = [k+str(i) for k,i,_,_,_ in rows]
    lookup = {name: row for name,row in zip(names,rows)}
    assert len(lookup) == len(rows)
    boxes = {(d['side'],d['mask'],d['index'],d['bound']):'inequalities'+str(i)
             for i,d in enumerate(model['inequalities']) if d['kind']=='box'}
    bounds = {(d['mask'],d['edge'],d['bound']):'inequalities'+str(i)
              for i,d in enumerate(model['inequalities']) if d['kind']=='owner_flow_bound'}
    meta = model['owner_flow_extension']
    pair_ids = {tuple(pair):i for i,pair in enumerate(meta['physical_pairs'])}
    tau = [i for i,v in enumerate(model['variables']) if v['kind']=='tau']
    assert len(tau)==5
    zero_masks = []
    for m,e in enumerate(model['lambda_expressions']):
        assert set(e[1]) <= set(tau)
        constant = sum((v*features[j] for j,v in e[0].items()),Q(0))
        assert constant >= 0
        if constant == 0: zero_masks.append(m)
    eliminated = []
    for i,v in enumerate(model['variables']):
        if v['kind']=='tau':
            eliminated.append(dict(variable=i,reason='explicit_zero_tau_pin',pin='zero_tau'+str(i)))
            continue
        low=up=None; mass=None; reason=None
        if v['kind']=='allocation' and v['mask'] in zero_masks:
            side,m,j = v['side'],v['mask'],v['index']
            assert model['sectors'][side]['allocations'][m][j] == term(1,i)
            low=[[boxes[side,m,j,'lower'],'1']]
            up=[[boxes[side,m,j,'upper'],'1']]
            mass=model['lambda_expressions'][m];reason='zero_pattern_mass_allocation'
        elif v['kind']=='owner_joint':
            m,x,z=v['mask'],v['X_index'],v['Z_index'];edge=pair_ids[x,z]
            low=[[bounds[m,edge,'nonnegative'],'1']]
            if (m,edge,'structural_zero') in bounds:
                up=[[bounds[m,edge,'structural_zero'],'1']]
                mass=empty();reason='explicit_structural_zero'
            elif m in zero_masks:
                up=[[bounds[m,edge,'X_upper'],'1'],[boxes['X',m,x,'upper'],'1']]
                mass=model['lambda_expressions'][m];reason='zero_pattern_mass_joint'
        if up is None: continue
        def combine(proof):
            out=empty()
            for name,w in proof:
                assert lookup[name][2]=='<=' and Q(w)>=0
                out=plus(out,lookup[name][3],Q(w))
            return out
        assert combine(low)==term(1,i,-1)
        assert combine(up)==plus(term(1,i),mass,-1)
        assert set(mass[1]) <= set(tau)
        assert sum((v*features[j] for j,v in mass[0].items()),Q(0))==0
        eliminated.append(dict(variable=i,reason=reason,lower=low,upper=up,
                               zero_mass_mask=v['mask'] if mass!=empty() else None))
    omitted={r['variable'] for r in eliminated}
    retained=[i for i in range(len(model['variables'])) if i not in omitted]
    renumber={old:new for new,old in enumerate(retained)}
    reduced=[];dropped=[]
    for name,(kind,index,relation,e,constant) in zip(names,rows):
        coefficients={renumber[j]:c for j,c in e[1].items() if j in renumber}
        if not coefficients:
            assert constant==0 if relation=='=' else constant<=0, (name,str(constant))
            dropped.append(dict(name=name,relation=relation,constant=str(constant)))
        else: reduced.append((name,relation,coefficients,-constant))
    return rows,retained,eliminated,reduced,dropped,zero_masks


def main():
    ap=argparse.ArgumentParser()
    ap.add_argument('--manifest',type=Path,required=True)
    ap.add_argument('--preparation-receipt',type=Path,required=True)
    ap.add_argument('--prefix',type=Path,required=True)
    a=ap.parse_args();start=time.monotonic()
    assert os.getpriority(os.PRIO_PROCESS,0)==19
    manifest,prep=read(a.manifest),read(a.preparation_receipt)
    assert manifest['status']=='PASS_EXACT_OWNER_FLOW_CAPACITY_LP_FRACTION_TEXT_ROUNDTRIP'
    assert prep['status']=='PASS_EXACT_COMPLETE_SELECTED_OWNER_FLOW_CAPACITY_MODEL'
    assert prep['manifest_sha256']==sha(a.manifest)
    assert prep['model_sha256']==manifest['semantic_sha256']==sha(manifest['semantic'])
    assert prep['consumer_sha256']==sha(ROOT/'verify_owner_star_capacity_extension.py')
    assert manifest['lp_sha256']==sha(manifest['lp']) and manifest['zero_tau_pins'] is True
    saved=read(manifest['semantic']);model=decode(saved['model'])
    assert all(sha(ROOT/p)==h for p,h in model['source_hashes'].items())
    features=list(map(Q,saved['feature_values']))
    rows,retained,eliminated,reduced,dropped,zero_masks=reduction(model,features,saved['zero_tau_pins'])
    lp=Path(str(a.prefix)+'.lp');mapping=Path(str(a.prefix)+'.map.json');outpath=Path(str(a.prefix)+'.json')
    assert not any(p.exists() for p in (lp,mapping,outpath))
    with lp.open('w') as stream:
        stream.write('Minimize\n obj: + 0 x0\nSubject To\n')
        for name,rel,c,rhs in reduced: write_row(stream,name,c,rhs,rel)
        stream.write('Bounds\n')
        for j in range(len(retained)):stream.write(' x'+str(j)+' free\n')
        stream.write('End\n')
    replay_text(lp,reduced,len(retained))
    data=dict(status='EXACT_ZERO_FACE_MAP_REQUIRE_INDEPENDENT_REPLAY',
              full_manifest=str(a.manifest),full_manifest_sha256=sha(a.manifest),
              full_semantic=manifest['semantic'],full_semantic_sha256=manifest['semantic_sha256'],
              preparation_receipt=str(a.preparation_receipt),preparation_receipt_sha256=sha(a.preparation_receipt),
              retained_variables=retained,eliminated=eliminated,retained_rows=[r[0] for r in reduced],
              dropped_rows=dropped,zero_masks=zero_masks,zero_tau_pins=True,
              source_hashes={p:sha(ROOT/p) for p in [Path(__file__).name,'two_basis_owner_star_capacity.py',
                'export_owner_star_capacity_lp.py','export_joint_general_exact_lp.py','export_joint_fixed_exact_lp.py']})
    mapping.write_text(json.dumps(data,indent=2)+'\n')
    out=dict(status='PASS_EXACT_ZERO_FACE_LP_TEXT_ROUNDTRIP',lp=str(lp),lp_sha256=sha(lp),
             mapping=str(mapping),mapping_sha256=sha(mapping),full_manifest=str(a.manifest),
             full_manifest_sha256=sha(a.manifest),semantic=manifest['semantic'],semantic_sha256=manifest['semantic_sha256'],
             source_sha256=sha(__file__),variable_count=len(retained),full_variable_count=len(model['variables']),
             eliminated_variables=len(eliminated),row_count=len(reduced),full_row_count=len(rows),
             dropped_constant_rows=len(dropped),nonzeros=sum(len(r[2]) for r in reduced),
             zero_tau_pins=True,zero_masks=zero_masks,point_sha256=saved['point_sha256'],
             preparation_receipt=str(a.preparation_receipt),preparation_receipt_sha256=sha(a.preparation_receipt),
             nice=19,elapsed_seconds=time.monotonic()-start,solver_run=False,source_C16_answered=False)
    outpath.write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(out,indent=2),flush=True)


if __name__=='__main__':main()
