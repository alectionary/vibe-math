from pathlib import Path
import json,gzip,subprocess,hashlib,datetime
root=Path('/private/tmp/c16-moment-clean-20261030T0241/formalization/canonical-width/c16');out=Path('/private/tmp/c16-moment-final-negative-controls');out.mkdir(exist_ok=True);source=root/'moment-resumption-results/common-profile32-projected-pruned.json';point=root/'moment-resumption-results/boolean-rational1.json.gz';original=json.loads(source.read_text());records=[]
for name in ['invalid_class_bound','false_claimed_violation','wrong_point_binding']:
 d=json.loads(json.dumps(original))
 if name=='invalid_class_bound':d['cuts'][0]['unconditional_coefficients'][0]+=1
 elif name=='false_claimed_violation':d['cuts'][0]['exact_violation']='1'
 else:d['point_sha256']='0'*64
 bad=out/(name+'.json');bad.write_text(json.dumps(d,indent=2)+'\n');cmd=['/private/tmp/c16-venv/bin/python','verify_common_profile_cut.py','--bank',str(bad),'--point',str(point),'--output',str(out/(name+'-replay.json'))]
 result=subprocess.run(cmd,cwd=root,stdout=subprocess.PIPE,stderr=subprocess.STDOUT,text=True,timeout=30);(out/(name+'.log')).write_text(result.stdout);assert result.returncode!=0 and 'AssertionError' in result.stdout
 if name=='invalid_class_bound':assert 'class_bound_failed' in result.stdout
 records.append({'control':name,'rejected':True,'exit_code':result.returncode,'log_sha256':hashlib.sha256((out/(name+'.log')).read_bytes()).hexdigest(),'corrupted_bank_sha256':hashlib.sha256(bad.read_bytes()).hexdigest()})
summary={'status':'PASS','source_C16_answered':False,'original_bank_sha256':hashlib.sha256(source.read_bytes()).hexdigest(),'scientific_commit':'2c0824788c162ab24579c7311b08f112ec9d747b','controls':records,'scope':'Deliberately corrupted certificate controls; all must be rejected. These are not valid mathematical certificates.'};(out/'summary.json').write_text(json.dumps(summary,indent=2)+'\n');print(summary)
