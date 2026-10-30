"""Assemble v2 evidence packet from source specifications and explicit adjudications.
Never infer scientific status, prespecification, review acceptance or missing values.
The output is structural validation only; final scientific adjudication is external.
"""
import argparse
import copy
import hashlib
import importlib.util
import json
from pathlib import Path

CLAIM_FIELDS=('ours','methods','uncertainty','multiplicity','status','status_reason',
              'numerical','reconstruction_scope','reproduction_deviation','stopping')
TOP_FIELDS=('dissertation','synthesis','limitations','headline_effects')


def digest(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def read(path):
    def pairs(items):
        result={}
        for key,value in items:
            if key in result: raise ValueError('Duplicate JSON key: '+key)
            result[key]=value
        return result
    return json.loads(Path(path).read_text(),object_pairs_hook=pairs,
                      parse_constant=lambda x: (_ for _ in ()).throw(ValueError('Nonfinite JSON: '+x)))


def need_text(value,label):
    if not isinstance(value,str) or not value.strip(): raise ValueError('Explicit text required: '+label)


def unique(rows,label):
    if not isinstance(rows,list) or not rows: raise ValueError('Nonempty list required: '+label)
    index={}
    for row in rows:
        need_text(row.get('id'),label+' id')
        if row['id'] in index: raise ValueError('Duplicate '+label+' id: '+row['id'])
        index[row['id']]=row
    return index


def local(root,path):
    p=Path(path)
    if p.is_absolute(): raise ValueError('Artifact paths must be relative: '+str(path))
    p=(root/p).resolve();p.relative_to(root)
    if not p.is_file(): raise ValueError('Unavailable artifact: '+str(path))
    return p


def assemble(spec_path,adjudication_path,root,validator_path):
    root=Path(root).resolve();spec=read(spec_path);adj=read(adjudication_path)
    if spec.get('document_kind')!='source_claim_specification' or spec.get('scope')!='whole_dissertation' or spec.get('schema_version')!=1:
        raise ValueError('Expected v1 whole-dissertation source_claim_specification')
    if adj.get('claim_specification_sha256')!=digest(spec_path): raise ValueError('Stale claim specification adjudication')
    # This is recorded attribution supplied by an actual adjudicator, not an attestation generated here.
    for k in ('adjudicator','adjudicated_utc','basis','scope'):
        need_text(adj.get('adjudication',{}).get(k),'adjudication.'+k)
    sources=unique(spec['claims'],'source claim');results=unique(adj['claims'],'adjudicated claim')
    for ident,source in sources.items():
        for key in ('parent_claim_ids','component_claim_ids'):
            if key in source:
                refs=source[key]
                if not isinstance(refs,list) or len(set(refs))!=len(refs) or not set(refs)<=set(sources) or ident in refs:
                    raise ValueError(ident+': invalid source relation '+key)
        for ref in source.get('component_contrast_refs',[]):
            linked=sources.get(ref.get('claim_id'));index=ref.get('contrast_index')
            if linked is None or type(index) is not int or not 0<=index<len(linked.get('contrasts',[])):
                raise ValueError(ident+': invalid source component contrast reference')
    if set(sources)!=set(results):
        raise ValueError('Exact claim coverage required; missing='+str(sorted(set(sources)-set(results)))+'; extra='+str(sorted(set(results)-set(sources))))
    artifacts=unique(spec['source_artifacts']+adj.get('artifacts',[]),'artifact')
    artifact_rows=[]
    for ident,a in artifacts.items():
        path=local(root,a['path']);actual=digest(path)
        if a.get('sha256') is not None and a['sha256']!=actual: raise ValueError('Stale declared artifact: '+ident)
        artifact_rows.append({**copy.deepcopy(a),'id':ident,'path':a['path'],'sha256':actual})
    claims=[]
    for ident,source in sources.items():
        result=results[ident]
        # Published claims remain owned by the source inventory, not result adjudication.
        permitted={'id','artifact_ids','limitations','contrasts',*CLAIM_FIELDS}
        forbidden=set(result)-permitted
        if forbidden: raise ValueError('Adjudication cannot overwrite source fields: '+str(sorted(forbidden)))
        # Keep every source-owned field, including hierarchy and scientific relations.
        claim=copy.deepcopy(source)
        claim['source_conditions']=copy.deepcopy(source['conditions'])
        if not isinstance(claim['conditions'],str):
            claim['conditions']=json.dumps(source['conditions'],sort_keys=True,ensure_ascii=False,allow_nan=False)
        claim['source_contrasts']=copy.deepcopy(source.get('contrasts',[]))
        for k in CLAIM_FIELDS:
            if k not in result: raise ValueError(ident+': missing adjudication '+k)
            claim[k]=copy.deepcopy(result[k])
        if not isinstance(result.get('limitations'),list) or not result['limitations']:
            raise ValueError(ident+': explicit result limitations required')
        claim['limitations']=copy.deepcopy(source['limitations']+result['limitations'])
        if not isinstance(result.get('artifact_ids'),list) or not result['artifact_ids']:
            raise ValueError(ident+': explicit result evidence references required')
        claim['artifact_ids']=list(dict.fromkeys(source['artifact_ids']+result['artifact_ids']))
        source_contrasts=source.get('contrasts',[]);new=result.get('contrasts')
        if not isinstance(new,list) or len(new)!=len(source_contrasts):
            raise ValueError(ident+': every source contrast requires explicit adjudication')
        claim['contrasts']=[]
        for i,(sc,rc) in enumerate(zip(source_contrasts,new)):
            if rc.get('contrast_index')!=i or 'ours' not in rc:
                raise ValueError(ident+': ordered contrast_index and explicit ours required')
            if set(rc)-{'contrast_index','ours','unavailable_reason'}:
                raise ValueError(ident+': contrast adjudication contains unsupported source overrides')
            published=sc['published']['value']
            contrast=copy.deepcopy(sc)
            contrast.update(published=published,ours=rc['ours'])
            if published is None or rc['ours'] is None:
                reasons=[sc['published'].get('unavailable_reason',''),rc.get('unavailable_reason','')]
                contrast['unavailable_reason']='; '.join(x for x in reasons if x)
            claim['contrasts'].append(contrast)
        if not source_contrasts: claim['contrast_not_applicable']=source['contrast_not_applicable']
        claims.append(claim)
    packet={k:copy.deepcopy(adj[k]) for k in TOP_FIELDS}
    packet.update(schema_version=1,scope='whole_dissertation',artifacts=artifact_rows,claims=claims)
    for k in ('replicated_work','sections','inventory_audit','headline_order'):
        packet[k]=copy.deepcopy(spec[k])
    for k in ('ambiguities','omissions_or_explicit_limits','headline_hierarchy','source_relations'):
        if k in spec: packet[k]=copy.deepcopy(spec[k])
    # No automatic tolerance/estimate-status/labels: retain declared scientific judgment.
    for effect in packet['headline_effects']:
        if effect.get('tolerance',{}).get('kind')=='prespecified':
            ev=effect.get('tolerance_provenance')
            if not isinstance(ev,dict): raise ValueError('Prespecified tolerance requires explicit provenance')
            for k in ('recorded_utc','prespecification_scope','basis'):
                need_text(ev.get(k),'tolerance_provenance.'+k)
            refs=ev.get('artifact_ids')
            if not isinstance(refs,list) or not refs or not set(refs)<=set(artifacts):
                raise ValueError('Prespecified tolerance evidence artifacts missing')
    validator_path=Path(validator_path).resolve()
    module_spec=importlib.util.spec_from_file_location('handoff_stage_checks',validator_path)
    validator=importlib.util.module_from_spec(module_spec);module_spec.loader.exec_module(validator)
    errors=validator.packet_errors(packet,root)
    if errors: raise ValueError('Packet contract errors:\n'+'\n'.join(errors))
    manifest={'structural_validation_only':True,'scientific_adjudication':adj['adjudication'],
      'inputs':{'claim_specification':{'path':str(spec_path),'sha256':digest(spec_path)},
                'adjudication':{'path':str(adjudication_path),'sha256':digest(adjudication_path)}},
      'validator':{'path':str(validator_path),'sha256':digest(validator_path),
                   'first_page_sha256':digest(validator_path.with_name('first_page.py'))},
      'builder_sha256':digest(__file__),'mapping':'Source-owned statements/values/conditions/sections/audit preserved; exact ID-joined result adjudications; source contrast published.value mapped to numeric published; no defaults for results/status/tolerance/review.',
      'source_specification_notes':{k:spec.get(k) for k in ('ambiguities','omissions_or_explicit_limits')},
      'claim_count':len(claims),'section_count':len(packet['sections']),
      'scope':'Not a rendered manuscript review, source-fidelity certification or whole-dissertation success claim.'}
    return packet,manifest


def main():
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('--spec',required=True);p.add_argument('--adjudication',required=True)
    p.add_argument('--root',required=True);p.add_argument('--validator',required=True)
    p.add_argument('--output',required=True);p.add_argument('--dry-run',action='store_true')
    a=p.parse_args();packet,manifest=assemble(a.spec,a.adjudication,a.root,a.validator)
    if a.dry_run:
        print(json.dumps({'valid_structure':True,'claim_count':len(packet['claims']),'packet_written':False}));return
    out=Path(a.output);mp=out.with_suffix('.assembly.json')
    if out.exists() or mp.exists(): raise ValueError('Refusing to overwrite frozen packet/manifest')
    out.parent.mkdir(parents=True,exist_ok=True)
    data=json.dumps(packet,indent=2,ensure_ascii=False,allow_nan=False)+'\n'
    manifest['packet_sha256']=hashlib.sha256(data.encode()).hexdigest()
    out.write_text(data);mp.write_text(json.dumps(manifest,indent=2,allow_nan=False)+'\n')
    print(json.dumps({'packet':str(out),'sha256':manifest['packet_sha256'],'structural_validation_only':True}))

if __name__=='__main__':main()
