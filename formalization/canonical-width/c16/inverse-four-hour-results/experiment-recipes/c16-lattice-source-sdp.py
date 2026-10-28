from pathlib import Path
import sys,json,time
import numpy as np,cvxpy as cp
from scipy.sparse import csc_matrix,coo_matrix
sys.path.insert(0,'/private/tmp/c16-four-hour-inverse-20261027T202223/formalization/canonical-width/c16')
from rectangular_moment_sdp import model,source_patterns
from moment_triangle_cuts import expression,constraint as triangle_row
from moment_circuit_cuts import model_constraint,constraint as circuit_row
from moment_integer_form_cuts import expression as form_expression,coefficients as form_row
from block_moment_dual import layout
import subprocess
root=Path('/private/tmp');source=json.load(open(root/'c16-four-hour-inverse-20261027T202223/formalization/canonical-width/c16/inversion-results/normal-form.json'));prob,p,C=model(source_patterns(source,list(range(5))),16,128,normalize_equalities=True);con=list(prob.constraints);N=90;P=16;B0=sum(C.values());rectangles=[];conditional={(c['sector'],c['thin_mask'],c['thick_mask']) for c in json.load(open(root/'c16-new-rank-SDPglobal.cuts.json'))}
for side in ['X','Z']:
 for c in json.load(open(root/f'c16-new-rank-rectangles-{side}.json')):
  S=[(0 if side=='X' else 45)+9*j+i for j in range(5) if c['thin_mask']>>j&1 for i in range(9) if c['thick_mask']>>i&1];rectangles.append({**c,'sector':side,'columns':S,'conditional':(side,c['thin_mask'],c['thick_mask']) in conditional})
K=csc_matrix((np.ones(sum(len(c['columns']) for c in rectangles)),([j for c in rectangles for j in c['columns']],[k for k,c in enumerate(rectangles) for j in c['columns']])),shape=(N,len(rectangles)));r=np.array([c['rank'] for c in rectangles],dtype=float);con.append(16*(K.T@p)<=r);selected=[k for k,c in enumerate(rectangles) if c['conditional']];con.append(B0@K[:,selected]<=cp.reshape(p,(N,1),order='C')@r[selected].reshape(1,-1));triangles=json.load(open(root/'c16-new-global-triangle-cuts.json'));con.extend(expression(c,p,C,16) for c in triangles)

base_circuits=json.load(open(root/'c16-new-global-circuit-cuts.json'));con.append(model_constraint(base_circuits,p,C));circuits=list(base_circuits);reps=json.load(open(root/'c16-new-structured-circuits6.json'));pi,Ci,V=layout(N,P);triangle_seen={triangle_row(c,pi,Ci,16) for c in triangles};circuit_seen={circuit_row(c,pi,Ci) for c in circuits};rank_seen=set(selected);prior=np.load(root/'c16-new-integer-form-moments.npz');pv=prior['first'];cv={h:prior[f'C{h}'] for h in range(9)};cv.update({h:cv[16-h].T for h in range(9,16)});history=[];start=time.monotonic()
forms=json.load(open(root/'c16-new-combined-integer-form-cuts.json'));form_seen={form_row(c,pi,Ci,16) for c in forms};con.extend(form_expression(c,p,C,16) for c in forms)
for iteration in range(5):
 bv=sum(cv.values());violations=np.max(bv@K-pv[:,None]*r[None,:],axis=0);order=np.argsort(violations)[::-1];newr=[int(k) for k in order if violations[k]>2e-5 and k not in rank_seen][:120]
 if newr:con.append(B0@K[:,newr]<=cp.reshape(p,(N,1),order='C')@r[newr].reshape(1,-1));rank_seen.update(newr)
 input=root/'c16-new-lattice-source-triangle-input.txt';output=root/f'c16-new-lattice-source-triangle-screen-{iteration}.json'
 with input.open('w') as f:
  f.write('90 16\n'+' '.join(map(str,pv))+'\n')
  for h in range(16):f.write(' '.join(map(str,cv[h].ravel()))+'\n')
 subprocess.run([str(root/'c16-moment-triangles'),str(input),str(output),'20000'],check=True,timeout=30);screen=json.load(open(output));newt=[]
 for cut in sorted(screen['cuts'],key=lambda c:c['violation'],reverse=True):
  key=triangle_row(cut,pi,Ci,16)
  if key in triangle_seen:continue
  triangle_seen.add(key);newt.append(cut)
  if len(newt)>=800:break
 triangles.extend(newt);con.extend(expression(c,p,C,16) for c in newt)
 candidate=[];max_circuit=0
 for side in ['X','Z']:
  offset=0 if side=='X' else 45
  for S in reps[side]:
   for phase in range(16):
    value=sum(cv[(v%16+phase)%16][:,offset+v//16] for v in S)-(len(S)-1)*pv;max_circuit=max(max_circuit,float(value.max()))
    for i in np.where(value>2e-5)[0]:candidate.append({'sector':side,'circuit':S,'phase':phase,'anchor':int(i),'violation':float(value[i])})
 newc=[]
 for c in sorted(candidate,key=lambda c:c['violation'],reverse=True):
  key=circuit_row(c,pi,Ci)
  if key in circuit_seen:continue
  circuit_seen.add(key);newc.append(c)
  if len(newc)>=2000:break
 if newc:con.append(model_constraint(newc,p,C));circuits.extend(newc)
 moment_input=root/'c16-new-lattice-source-current.npz';np.savez_compressed(moment_input,first=pv,**{f'C{h}':cv[h] for h in range(9)});seed_input=root/'c16-new-lattice-source-seeds.json';seed_input.write_text(json.dumps({'cuts':forms})+'\n');pent_output=root/f'c16-new-lattice-source-pentagons-{iteration}.json';lll_output=root/f'c16-new-lattice-source-LLL-{iteration}.json'
 subprocess.run([str(root/'c16-pentagon-cuts'),str(input),str(pent_output)],check=True,timeout=30)
 subprocess.run(['/private/tmp/c16-venv/bin/python',str(root/'c16-four-hour-inverse-20261027T202223/formalization/canonical-width/c16/find_integer_form_cuts.py'),str(moment_input),'--seed-cuts',str(seed_input),'--output',str(lll_output)],check=True,timeout=60)
 candidates=json.load(open(pent_output))['cuts']+json.load(open(lll_output))['cuts'];newf=[]
 for cut in sorted(candidates,key=lambda c:c['violation'],reverse=True):
  if len(cut['events'])<3 or cut['violation']<=1e-4:continue
  key=form_row(cut,pi,Ci,16)
  if key in form_seen:continue
  form_seen.add(key);newf.append(cut)
  if len(newf)>=400:break
 forms.extend(newf);con.extend(form_expression(c,p,C,16) for c in newf)
 before={'rank':float(violations.max()),'triangle':screen['maximum_violation'],'structured_circuit':max_circuit,'integer_form':max([c['violation'] for c in candidates],default=0)}
 print('SEPARATE',iteration,'added',len(newr),len(newt),len(newc),len(newf),'violations',before,flush=True)
 if not(newr or newt or newc or newf):break
 prob=cp.Problem(cp.Minimize(0),con);prob.solve(solver='SCS',eps=2e-7,max_iters=30000,time_limit_secs=90,verbose=False)
 rec={'iteration':iteration,'status':prob.status,'conditional_rank_rectangles':len(rank_seen),'triangle_cuts':len(triangles),'circuit_cuts':len(circuits),'integer_form_cuts':len(forms),'violations_before':before,'seconds_total':time.monotonic()-start};history.append(rec);print(json.dumps(rec),flush=True)
 result={'status':prob.status,'scope':'Full arbitrary source frames retained; source binary-rank rectangles, Boolean triangles and structured circuits through6','exact_certificate':False,'source_C16_answered':False,'history':history}
 (root/'c16-new-lattice-source-SDP.json').write_text(json.dumps(result,indent=2)+'\n');(root/'c16-new-lattice-source-rankcuts.json').write_text(json.dumps([rectangles[k] for k in sorted(rank_seen)])+'\n');(root/'c16-new-lattice-source-triangles.json').write_text(json.dumps(triangles)+'\n');(root/'c16-new-lattice-source-circuits.json').write_text(json.dumps(circuits)+'\n')
 (root/'c16-new-lattice-source-integer-forms.json').write_text(json.dumps(forms)+'\n')
 if p.value is None:break
 pv=p.value;cv={h:C[h].value for h in range(16)};np.savez_compressed(root/'c16-new-lattice-source-moments.npz',first=pv,**{f'C{h}':cv[h] for h in range(9)})
