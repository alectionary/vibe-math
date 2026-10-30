"""Synthetic adapter integrity fixtures only; no real scientific adjudication."""
import copy,importlib.util,json,pathlib,tempfile
p=pathlib.Path(__file__).with_name('build_evidence_packet.py')
s=importlib.util.spec_from_file_location('builder',p);b=importlib.util.module_from_spec(s);s.loader.exec_module(b)
validator='/tmp/schwabe-skill-v2/.agents/skills/replication-paper/scripts/stage_checks.py'
checks=[]
with tempfile.TemporaryDirectory(prefix='schwabe-packet-fixture-') as td:
 root=pathlib.Path(td);(root/'evidence.txt').write_text('SYNTHETIC TEST ONLY; no dissertation evidence or review attestation.')
 v={'value':None,'units':'fixture units','unavailable_reason':'Synthetic fixture has no empirical values'}
 source={'schema_version':1,'document_kind':'source_claim_specification','scope':'whole_dissertation',
 'replicated_work':dict(kind='dissertation',authors='SYNTHETIC FIXTURE',year='2000',title='Not a real dissertation',institution_or_venue='Fixture',identifier='fixture://test',verification_locator='Synthetic test',artifact_ids=['fixture']),
 'source_artifacts':[dict(id='fixture',path='evidence.txt',sha256=b.digest(root/'evidence.txt'))],
 'sections':[dict(id='fixture-section',locator='Synthetic only',claim_ids=['F1'],exclusion_reason='')],
 'inventory_audit':dict(reviewer='SYNTHETIC TEST, NOT A REVIEWER',source_artifact_ids=['fixture'],rationale='Fixture-only schema test, no actual inventory attestation'),
 'claims':[dict(id='F1',statement='Synthetic missing result',level='headline',source_locator='Synthetic only',artifact_ids=['fixture'],published=v,conditions='Synthetic only',contrasts=[dict(definition='B minus A',units='fixture units',positive_means='B greater',published=v,tolerance=None)],contrast_not_applicable='',source_uncertainty='Not data',source_multiplicity='Not data',limitations=['F1 synthetic fixture only'])],
 'headline_order':['F1'],'ambiguities':[],'omissions_or_explicit_limits':['Synthetic test only']}
 def write(name,value):
  path=root/name;path.write_text(json.dumps(value));return path
 source['claims'][0]['conditions']={'grid':[1,2,3],'scope':'Synthetic whole grid'}
 source['claims'][0]['parent_claim_ids']=[]
 source['claims'][0]['component_claim_ids']=[]
 source['claims'][0]['scientific_relations']={'kind':'synthetic relation preservation fixture'}
 source['claims'][0]['contrasts'][0]['conditions']={'grid_cell':2}
 sp=write('spec.json',source)
 result=dict(id='F1',ours=v,methods='Synthetic only',uncertainty='Synthetic only',multiplicity='Synthetic only',status='not_established',status_reason='No actual data',numerical='No actual data',reconstruction_scope='Fixture only',reproduction_deviation='Not available',stopping={k:'Synthetic only' for k in ['reason','attempted','untested','resource_basis','next_evidence']},limitations=['F1 no data'],artifact_ids=['fixture'],contrasts=[dict(contrast_index=0,ours=None,unavailable_reason='No synthetic result')])
 effect=dict(id='E1',claim_id='F1',contrast_index=0,estimand='B minus A',units='fixture units',positive_means='B greater',published_effect=None,ours_effect=None,estimate_status='unresolved',unresolved_reason='Synthetic missing values',display_decimals=1,tolerance=dict(kind='rounding',value=.05,decimals=1,basis='Synthetic decimal fixture only, no source precision assertion'),magnitude='not established',direction='not established',interpretation='descriptive point estimates; not equivalence',uncertainty_statement='No real evidence')
 adj=dict(claim_specification_sha256=b.digest(sp),adjudication={k:'SYNTHETIC FIXTURE ONLY' for k in ['adjudicator','adjudicated_utc','basis','scope']},claims=[result],artifacts=[],dissertation='Synthetic fixture only',synthesis='F1 not established in synthetic fixture',limitations=['F1 synthetic test only'],headline_effects=[effect])
 ap=write('adjudication.json',adj)
 packet,manifest=b.assemble(sp,ap,root,validator)
 assert packet['claims'][0]['published']==v and packet['claims'][0]['status']=='not_established'
 assert manifest['structural_validation_only']
 checks.append('Explicit unresolved fixture assembles; source values preserved')
 claim=packet['claims'][0]
 assert claim['source_conditions']==source['claims'][0]['conditions']
 assert json.loads(claim['conditions'])==claim['source_conditions']
 assert claim['scientific_relations']==source['claims'][0]['scientific_relations']
 assert claim['source_contrasts']==source['claims'][0]['contrasts']
 assert claim['contrasts'][0]['conditions']=={'grid_cell':2}
 assert packet['ambiguities']==source['ambiguities']
 checks.append('Structured conditions, scientific relations, all source contrasts and ambiguities preserved')
 for label,change in [('missing claim',lambda x:x.update(claims=[])),('source override',lambda x:x['claims'][0].update(published={'value':2})),('invented success',lambda x:x['claims'][0].update(status='replicated')),('missing tolerance',lambda x:x['headline_effects'][0].pop('tolerance')),('unsubstantiated prespecification',lambda x:x['headline_effects'][0].update(tolerance={'kind':'prespecified','value':0,'basis':'fixture'})),('missing contrast',lambda x:x['claims'][0].update(contrasts=[])),('stale specification',lambda x:x.update(claim_specification_sha256='bad'))]:
  altered=copy.deepcopy(adj);change(altered);write('adjudication.json',altered)
  try:b.assemble(sp,ap,root,validator)
  except (ValueError,KeyError):checks.append('Rejected '+label)
  else:raise AssertionError(label)
 write('adjudication.json',adj);(root/'evidence.txt').write_text('changed')
 try:b.assemble(sp,ap,root,validator)
 except ValueError:checks.append('Rejected stale artifact hash')
 else:raise AssertionError('stale artifact')
print(json.dumps({'scope':'synthetic only; no actual packet','checks':checks,'passed':True},indent=2))
