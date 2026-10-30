"""Evidence-backed first-page checks; manuscript meaning still needs human/agent review."""
from pathlib import Path
from decimal import Decimal
import hashlib,json,re
R=Path(__file__).resolve().parents[1]
load=lambda p:json.loads((R/p).read_text())
precision=Decimal('0.1');rounding_allowance=precision/2+precision/2
x=load('results/analysis.json');rh=load('expansion/rhombic-Z-pure-analysis.json');sw=load('expansion/threshold-comparisons.json')
xours=100*next(c['ours'] for c in x['comparisons'] if c['claim']=='deformed minus undeformed threshold')
rhours=100*rh['thresholds_and_D_minus_U'][2]
swours=100*next(c['ours'] for c in sw['rows'] if c['family']=='sweep-depolarizing' and c['quantity']=='D-U')
assert all(f['success'] and not f['boundary'] for f in x['fits']+rh['fits'])
assert rh['bootstrap']['failed']==0 and rh['bootstrap']['boundaries']==0
assert 'withheld' in next(c['conditional_band']['inference'] for c in sw['rows'] if c['family']=='sweep-depolarizing' and c['quantity']=='D-U')
def magnitude(source,ours,reliable):
 if not reliable or source is None or ours is None:return 'not established'
 delta=abs(Decimal(str(ours)))-abs(Decimal(str(source)))
 return 'same' if abs(delta)<=rounding_allowance else 'larger' if delta>0 else 'smaller'
rows=[]
for key,source,ours,reliable,expected,evidence in [
 ('cubic-Z-BP-OSD',None,None,False,'not established','expansion/pure-z-analysis.json'),
 ('cubic-X-BP-OSD',4.5,xours,True,'larger','results/analysis.json'),
 ('rhombic-Z-BP-OSD',-21.9,rhours,True,'smaller','expansion/rhombic-Z-pure-analysis.json'),
 ('cubic-depolarizing-Sweep-Match',0.3,swours,False,'not established','expansion/threshold-comparisons.json')]:
 label=magnitude(source,ours,reliable);assert label==expected
 direction='not established' if source is None or ours is None else 'same' if source*ours>0 else 'reversed point estimate'
 rows.append(dict(claim_id=key,source_signed_effect_pp=source,ours_signed_effect_pp=ours,source_effect_relation='lower bound >14.3 from displayed endpoint values' if source is None else 'point contrast of rounded endpoints',signed_direction=direction,magnitude_comparison=label,point_estimate_eligible_for_magnitude_label=reliable,evidence=evidence,evidence_sha256=hashlib.sha256((R/evidence).read_bytes()).hexdigest(),population_magnitude_comparison='not established: original uncertainty unknown; conditional reconstruction only',withholding_reason=('deformed estimate unresolved' if key=='cubic-Z-BP-OSD' else 'bootstrap/model instability and historical-engine departure' if not reliable else None)))
s=(R/'paper/expanded-manuscript.tex').read_text();abstract=s.split('\\begin{abstract}',1)[1].split('\\end{abstract}',1)[0]
assert '\\citet{pesah2021}' in abstract and 'Master of Research' in abstract
assert 'Tailoring 3D topological codes and decoders to biased noise' in abstract
assert all(z in abstract for z in ['21.7\\%','36\\%','21.908\\%','Table 3.1'])
assert abstract.index('21.7') < abstract.index('21.908')
firsttable=s.split('\\section{Introduction}',1)[0];assert 'Effect magnitude' in firsttable and 'Unresolved' in firsttable and 'No match' not in firsttable
assert '0.10 pp' in firsttable and 'point-estimate labels' in firsttable and 'Reversed point estimate' in firsttable
out=dict(source_identity=dict(author='Arthur Pesah',year=2021,title='Tailoring 3D topological codes and decoders to biased noise',degree='Master of Research',institution='University College London',supervisor='Dan Browne',submitted='2021-09-01',bibtex_key='pesah2021',metadata_locator='titlepage1,visuallychecked',source_url='https://github.com/artix41/artix41.github.io/blob/b4f401e0c12b44be4c69318e0015f70d8a3d3f98/assets/pdf/master-thesis-ucl.pdf',source_sha256='f08f3ede0cfbd5411ca20cc223d5bed079fa9aefd1484805ba80cfc1360a4ea0'),source_headline=dict(statement='Hadamard deformation combined with BP-OSD increases cubic-code threshold under strongly Z-biased noise.',abstract_locator='p3:approximately22percent to greaterthan36percent',comparison_locator='Table3.1p48:pureZ21.7percent undeformed and greaterthan36percent deformed;captioncallsdeformedvalueimprecise',claim_type='reported numerical improvement; deformed endpoint is a lower-bound report, not a precise point estimate'),comparison_rule=dict(estimand='deformed minus undeformed physical-error threshold',units='percentage points',positive_meaning='deformation improves tolerance',magnitude='absolute value of signed effect, compared separately from direction',source_endpoint_rounding_pp=str(precision),same_magnitude_tolerance_pp=str(rounding_allowance),same_rule='abs(abs(ours)-abs(source))<=0.10pp, inclusive conservative rounding allowance',tolerance_justification='Two source endpoints each rounded to0.1pp contribute up to0.05pp each. Derived from printed precision, not tuned to observed effects.',same_is_not='statistical equivalence, confidence-interval overlap, or established population equality',withhold='Unresolved effect or unreliable fitted estimate; retain diagnostic sign separately'),rows=rows,checks=dict(numerical_labels=True,abstract_source_identity_and_citation=True,source_headline_before_ours=True,unresolved_verdict_not_no_match=True),review_limit='Structural/text checks do not verify source interpretation or rendered readability; separate source and rendered review required.')
(R/'paper/first-page-evidence.json').write_text(json.dumps(out,indent=2)+'\n');print(json.dumps({'effects':rows,'errors':[]},indent=2))
