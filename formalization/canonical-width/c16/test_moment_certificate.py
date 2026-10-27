import json,sys,copy
from pathlib import Path
sys.path.insert(0,str(Path(__file__).resolve().parent))
from certify_moment_point import interval_pd
from verify_moment_certificate import verify
from flint import arb_mat,arb
root=Path(__file__).resolve().parent;data=json.loads(Path(sys.argv[1]).read_text());tests=[]
for name,change in [('bad_first_moment',lambda d:d['p'].__setitem__(0,'1')),('negative_pair_moment',lambda d:d['C']['1'][0].__setitem__(0,'-1'))]:
 d=copy.deepcopy(data);change(d)
 try:verify(d,root)
 except AssertionError:tests.append({'control':name,'rejected':True})
 else:raise AssertionError('Invalid certificate accepted')
try:interval_pd(arb_mat([[arb(1),arb(2)],[arb(2),arb(1)]]))
except Exception:tests.append({'control':'indefinite_PSD_block','rejected':True})
else:raise AssertionError('Indefinite block accepted')
r={'status':'PASS','mutations':tests,'positive_PSD_control':interval_pd(arb_mat([[arb(2),arb(1)],[arb(1),arb(2)]]))};Path(sys.argv[2]).write_text(json.dumps(r,indent=2)+'\n');print(json.dumps(r))
