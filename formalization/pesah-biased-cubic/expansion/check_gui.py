"""Exercise original Flask backend using an explicit modern-runtime reconstruction."""
import sys,pathlib,runpy,json,os
import numpy as np
np.product=np.prod
source=pathlib.Path(sys.argv[1]);sys.path.insert(0,str(source));os.chdir(source)
gui=runpy.run_path(str(source/'gui3d.py'),run_name='replication_gui');app=gui['app'];client=app.test_client();records=[]
for code in ['cubic','rhombic']:
 for L in [2,4]:
  response=client.post('/stabilizer-matrix',json={'L':L,'code_name':code});obj=response.get_json(force=True);Hx=np.asarray(obj['Hx']);Hz=np.asarray(obj['Hz']);assert response.status_code==200;assert not np.any(Hx@Hz.T%2)
  records.append(dict(action='stabilizer-matrix',code=code,L=L,status=response.status_code,Hx_shape=list(Hx.shape),Hz_shape=list(Hz.shape),commutes=True))
  for deformation in [False,True]:
   for noise in ['Pure X','Pure Z','Depolarizing']:
    syndrome=np.zeros(len(Hx)+len(Hz),int).tolist();response=client.post('/decode',json={'syndrome':syndrome,'L':L,'p':.04,'deformed':deformation,'max_bp_iter':10,'decoder':'bp','error_model':noise,'code_name':code})
    records.append(dict(action='decode-zero',code=code,L=L,deformed=deformation,noise=noise,status=response.status_code,body=response.get_json(force=True)))
pathlib.Path(sys.argv[2]).write_text(json.dumps(dict(records=records,limits='Backend API only; zero-syndrome cases do not establish noisy-decoding performance or browser rendering. Original source loaded without editing; NumPy product alias restored. Modern matching installed but these requests use BP-OSD.'),indent=2)+'\n');print([(r['action'],r['status']) for r in records])
