#!/usr/bin/env python3
"""Append a complete conditional8-bit law to an accepted zero-face LP; no solve."""
from pathlib import Path
from fractions import Fraction as Q
import argparse,hashlib,json,os,time
from owner_k22_capacity_extension import ROOT,sha,read,decode,appended_rows,pack,XX,ZZ
from export_joint_fixed_exact_lp import write_row
def main():
    assert os.getpriority(os.PRIO_PROCESS,0)==19
    for k in ('OPENBLAS_NUM_THREADS','OMP_NUM_THREADS','MKL_NUM_THREADS','VECLIB_MAXIMUM_THREADS','NUMEXPR_NUM_THREADS','BLIS_NUM_THREADS'):assert os.environ.get(k)=='1'
    ap=argparse.ArgumentParser();ap.add_argument('--prefix',required=True);a=ap.parse_args();start=time.monotonic()
    parent='two-basis-results/joint-owner-capacity-zero-face-point22.json';parent_receipt='two-basis-results/joint-owner-capacity-zero-face-point22-independent.json'
    eight='two-basis-results/global-eight-probe-point22.json';eight_receipt='two-basis-results/global-eight-probe-point22-independent.json'
    face=read(parent);pr=read(parent_receipt);gm=read(eight);gr=read(eight_receipt)
    assert face['status']=='PASS_EXACT_ZERO_FACE_LP_TEXT_ROUNDTRIP' and pr['status']=='PASS_EXACT_OWNER_CAPACITY_ZERO_FACE_REDUCTION'
    assert pr['manifest_sha256']==sha(parent) and pr['consumer_sha256']==sha('verify_owner_capacity_zero_face.py')
    assert face['mapping_sha256']==sha(face['mapping']) and face['lp_sha256']==sha(face['lp'])
    assert face['semantic_sha256']==pr['semantic_sha256']==sha(face['semantic']) and face['zero_tau_pins'] is True
    assert gm['status']=='EXACT_GLOBAL_EIGHT_PROBE_LP_REQUIRES_REPLAY' and gr['status']=='PASS_EXACT_GLOBAL_EIGHT_PROBE_LP'
    assert gr['manifest_sha256']==sha(eight) and gr['consumer_sha256']==sha('verify_global_eight_probe_law.py')
    assert gm['events']==[['X',80],['X',512],['Z',186],['Z',433],['X',614],['X',281],['Z',51],['Z',83]]
    assert len(gm['allowed_masks'])==152
    saved=read(face['semantic']);M=decode(saved['model']);mapping=read(face['mapping']);keep=mapping['retained_variables'];features=list(map(Q,saved['feature_values']))
    assert len(keep)==face['variable_count']==12623 and len(M['variables'])==face['full_variable_count']==22481
    assert saved['point_sha256']==face['point_sha256']==gm['point_sha256']==sha(saved['point'])
    sources=dict(M['source_hashes'])
    for p,h in {**mapping['source_hashes'],**gm['source_hashes']}.items():
        assert p not in sources or sources[p]==h;sources[p]=h
    for p in [parent,parent_receipt,face['mapping'],face['lp'],face['full_manifest'],face['semantic'],eight,eight_receipt,
              'verify_owner_capacity_zero_face.py','verify_global_eight_probe_law.py',Path(__file__).name,'owner_k22_capacity_extension.py','export_joint_fixed_exact_lp.py']:
        sources[p]=sha(p)
    assert all(sha(p)==h for p,h in sources.items())
    rows=appended_rows(M,gm['allowed_masks']);assert len(rows)==138
    assert sum(r['kind']=='forbidden_eight_event_atom' for r in rows)==24
    full_n=22513;reduced_n=12655;renumber={old:new for new,old in enumerate(keep)}
    renumber.update({22481+i:12623+i for i in range(32)})
    reduced=[]
    for r in rows:
        e=r['expression'];constant=sum((v*features[j] for j,v in e[0].items()),Q(0))
        coefficients={renumber[j]:v for j,v in e[1].items() if j in renumber}
        reduced.append(dict(name=r['name'],relation=r['relation'],coefficients=[[j,str(v)] for j,v in sorted(coefficients.items())],rhs=str(-constant)))
    prefix=ROOT/a.prefix;lp=Path(str(prefix)+'.lp');semantic=Path(str(prefix)+'.model.json');manifest=Path(str(prefix)+'.json')
    assert not any(p.exists() for p in [lp,semantic,manifest])
    old=(ROOT/face['lp']).read_bytes();parts=old.split(b'Bounds\n');assert len(parts)==2
    assert parts[1].split()==[v for i in range(12623) for v in [('x'+str(i)).encode(),b'free']]+[b'End']
    with lp.open('wb') as stream:stream.write(parts[0])
    with lp.open('a') as stream:
        for r in reduced:write_row(stream,r['name'],{j:Q(v) for j,v in r['coefficients']},Q(r['rhs']),r['relation'])
        stream.write('Bounds\n')
        for j in range(reduced_n):stream.write(' x'+str(j)+' free\n')
        stream.write('End\n')
    actual=lp.read_bytes();assert actual.startswith(parts[0])
    tokens=actual[len(parts[0]):].decode().split();cursor=0
    for r in reduced:
        assert tokens[cursor]==r['name']+':';cursor+=1;seen={}
        while tokens[cursor] in ('+','-'):
            v=Q(tokens[cursor+1])*(1 if tokens[cursor]=='+' else -1);name=tokens[cursor+2]
            assert name.startswith('x');j=int(name[1:]);assert 0<=j<reduced_n
            seen[j]=seen.get(j,Q(0))+v;cursor+=3
        assert tokens[cursor]==r['relation'] and Q(tokens[cursor+1])==Q(r['rhs']);cursor+=2
        assert {j:v for j,v in seen.items() if v}=={j:Q(v) for j,v in r['coefficients']}
    assert tokens[cursor]=='Bounds';cursor+=1
    for j in range(reduced_n):assert tokens[cursor:cursor+2]==['x'+str(j),'free'];cursor+=2
    assert tokens[cursor:]==['End']
    wrapper=dict(status='FROZEN_COMPLETE_EIGHT_EVENT_CAPACITY_EXTENSION',source_hashes=sources,
        parent_face_manifest=parent,parent_face_manifest_sha256=sha(parent),parent_face_receipt=parent_receipt,parent_face_receipt_sha256=sha(parent_receipt),
        parent_mapping=face['mapping'],parent_mapping_sha256=face['mapping_sha256'],parent_full_manifest=face['full_manifest'],parent_full_manifest_sha256=sha(face['full_manifest']),
        parent_semantic=face['semantic'],parent_semantic_sha256=face['semantic_sha256'],parent_lp=face['lp'],parent_lp_sha256=face['lp_sha256'],
        parent_row_prefix_sha256=hashlib.sha256(parts[0]).hexdigest(),parent_row_prefix_bytes=len(parts[0]),
        global_eight_manifest=eight,global_eight_manifest_sha256=sha(eight),global_eight_receipt=eight_receipt,global_eight_receipt_sha256=sha(eight_receipt),
        point=saved['point'],point_sha256=saved['point_sha256'],centers={'X':XX,'Z':ZZ},zero_tau_pins=True,
        parent_full_variables=22481,parent_reduced_variables=12623,full_variables=full_n,reduced_variables=reduced_n,
        new_variables=[dict(mask=m,side=s,full_index=22481+2*m+i,reduced_index=12623+2*m+i) for m in range(16) for i,s in enumerate('XZ')],
        appended_rows=[{**{k:v for k,v in r.items() if k!='expression'},'expression':pack(r['expression'])} for r in rows],reduced_appended_rows=reduced,
        retained_old_full_rows=98730,retained_old_reduced_rows=64697,old_omitted_probability_proofs_unchanged=True,
        new_zero_mass_variables_retained=True,all_sixteen_patterns=True,forbidden_eight_atom_equalities=24,
        source_C16_answered=False,solver_launched=False)
    semantic.write_text(json.dumps(wrapper,sort_keys=True,indent=2)+'\n')
    out=dict(status='PASS_EXACT_OWNER_K22_CAPACITY_LP_TEXT_ROUNDTRIP',lp=str(lp.relative_to(ROOT)),lp_sha256=sha(lp),
        semantic=str(semantic.relative_to(ROOT)),semantic_sha256=sha(semantic),source_sha256=sha(__file__),
        parent_face_manifest=parent,parent_face_manifest_sha256=sha(parent),parent_face_receipt=parent_receipt,parent_face_receipt_sha256=sha(parent_receipt),
        point_sha256=saved['point_sha256'],zero_tau_pins=True,variable_count=reduced_n,full_variable_count=full_n,
        row_count=64697+len(rows),full_row_count=98730+len(rows),appended_rows=len(rows),appended_inequalities=112,appended_equalities=26,
        nonzeros=face['nonzeros']+sum(len(r['coefficients']) for r in reduced),old_parent_rows_verbatim=True,
        source_C16_answered=False,solver_launched=False,priority=19,elapsed_seconds=time.monotonic()-start)
    manifest.write_text(json.dumps(out,sort_keys=True,indent=2)+'\n');print(out)
if __name__=='__main__':main()
