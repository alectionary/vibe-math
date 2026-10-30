"""Audit source-vector illustrations; no new random simulation or model fit.
The numerical curve reconstruction is distinct from the unknown original driver.
Run from study root: python simulation/illustration_followup.py SOURCE.pdf [--render-crops]
No original 20,000 point coordinates are redistributed; only aggregate diagnostics.
"""
import argparse,datetime,hashlib,json,pathlib,subprocess,tempfile
import fitz,numpy as np
from scipy.optimize import least_squares,linprog
from scipy.special import expit,logit
p=argparse.ArgumentParser();p.add_argument('source');p.add_argument('--render-crops',action='store_true');a=p.parse_args()
source=pathlib.Path(a.source);source_hash=hashlib.sha256(source.read_bytes()).hexdigest();assert source_hash=='67dd29d98bc440b96a197a1ef1771dd3611823bceba428a1f66829ca099d7d28'
def line_box_feasibility(raw,bound):
 # For m <= 0, a line y=m*x+b intersects each coordinate box precisely
 # when |y-m*x-b| <= bound*(1-m). These are linear inequalities.
 AA=np.vstack([np.column_stack([bound-raw[:,0],-np.ones(len(raw))]),np.column_stack([raw[:,0]+bound,np.ones(len(raw))])])
 bb=np.r_[bound-raw[:,1],bound+raw[:,1]]
 return linprog([0,0],A_ub=AA,b_ub=bb,bounds=[(None,0),(None,None)],method='highs',options={'threads':1})
# Deterministic fixtures verify the geometry check independently of source figures.
assert line_box_feasibility(np.array([[0.,3.],[1.,2.],[2.,1.]]),.25).success
assert line_box_feasibility(np.array([[0.,3.],[1.,5.],[2.,1.]]),.25).status==2
pdf=fitz.open(source);D=pdf[16].get_drawings();bound=.25
# Axis-calibration fits use all visible labelled ticks, not the plot-box edges.
xt=np.array([D[i]['rect'].x0 for i in range(35,42)]);yt=np.array([D[i]['rect'].y0 for i in range(43,49)])
mx=np.polyfit(xt,np.arange(-3,4),1);my=np.polyfit(yt,np.arange(6)*.2,1)
curves=[]
for ix,b in [(33,-2.),(50,-.5)]:
 drawing=D[ix];assert len(drawing['items'])==60 and all(i[0]=='l'for i in drawing['items'])
 coords=[drawing['items'][0][1]]+[i[2]for i in drawing['items']];xy=np.array([(q.x,q.y)for q in coords]);theta=np.polyval(mx,xy[:,0]);prob=np.polyval(my,xy[:,1])
 fit=least_squares(lambda z:expit(z[0]*(theta-z[1]))-prob,[2,b]);pred=expit(2*(theta-b));unit=least_squares(lambda z:expit(theta-z[0])-prob,[b])
 keep=(prob>.05)&(prob<.95);linear=np.polyfit(theta[keep],logit(prob[keep]),1)
 vertical=np.abs(pred-prob)/abs(my[0]);unit_vertical=np.abs(unit.fun)/abs(my[0])
 curves.append({'drawing_index':ix,'vertices':len(theta),'axis_theta_range':[float(theta.min()),float(theta.max())],'nonlinear_reconstructed_a':float(fit.x[0]),'nonlinear_reconstructed_b':float(fit.x[1]),'independent_central_logit_linear_a':float(linear[0]),'independent_central_logit_linear_b':float(-linear[1]/linear[0]),'simple_candidate_a':2,'simple_candidate_b':b,'candidate_max_probability_residual':float(max(abs(pred-prob))),'candidate_max_vertical_pdf_point_residual':float(max(vertical)),'unit_slope_best_b':float(unit.x[0]),'unit_slope_max_vertical_pdf_point_residual':float(max(unit_vertical)),'candidate_within_quarter_point_geometry_bound':bool(max(vertical)<bound)})
 assert max(vertical)<bound and max(unit_vertical)>bound
# Marker centres are recoverable even when circles overplot. Exactly10k perpanel.
D=pdf[118].get_drawings();panels=[]
for scenario,ids,xids,yids,xvalues,yvalues in [(1,range(33,10033),range(10034,10038),range(10039,10043),[-2,0,2,4],[-2,0,2,4]),(2,range(10044,20044),range(20045,20051),range(20052,20056),[-2,-1,0,1,2,3],[-2,0,2,4])]:
 shapes=[D[i]for i in ids];assert all(len(d['items'])==4 and all(z[0]=='c'for z in d['items'])for d in shapes)
 raw=np.array([[(d['rect'].x0+d['rect'].x1)/2,(d['rect'].y0+d['rect'].y1)/2]for d in shapes])
 tx=np.array([D[i]['rect'].x0 for i in xids]);ty=np.array([D[i]['rect'].y0 for i in yids]);cx=np.polyfit(tx,xvalues,1);cy=np.polyfit(ty,yvalues,1)
 A=np.polyval(cx,raw[:,0]);P=np.polyval(cy,raw[:,1]);E=P-A
 # Compare independently obtained circle centres (Bezier endpoints vs boundingboxes).
 anchor=np.array([[d['items'][0][4].x,d['items'][0][1].y]for d in shapes])
 anchor_delta=float(np.max(abs(anchor-raw)))
 # Axis-endpoint calibration is a separate check against using all tick labels.
 ex=np.polyfit(tx[[0,-1]],[xvalues[0],xvalues[-1]],1);ey=np.polyfit(ty[[0,-1]],[yvalues[0],yvalues[-1]],1)
 endpointE=np.polyval(ey,raw[:,1])-np.polyval(ex,raw[:,0])
 # Could any negatively sloped line intersect every +/-0.25pt marker-centre box?
 # Nonnegative lines cannot fit the left/right extreme boxes of this descendingplot.
 left,right=raw[np.argmin(raw[:,0])],raw[np.argmax(raw[:,0])]
 assert left[0]+bound<right[0]-bound and left[1]-bound>right[1]+bound
 feasibility=line_box_feasibility(raw,bound)
 geometric_check={'negative_line_through_all_quarter_point_boxes_feasible':bool(feasibility.success),'nonnegative_slopes_excluded_by_disjoint_extreme_boxes':True,'solver_status':int(feasibility.status),'solver_message':feasibility.message,'scope':'Coordinate-box feasibility, not a statistical test. Rejects perfect affine collinearity after conservative coordinate perturbations when infeasible.'}
 sdE=float(np.std(E,ddof=1));errorbound=bound*(abs(cx[0])+abs(cy[0]));sd_error_bound=errorbound*np.sqrt(len(raw)/(len(raw)-1))
 residual_variance_box_envelope=[max(0,sdE-sd_error_bound)**2,(sdE+sd_error_bound)**2]
 _,_,vv=np.linalg.svd(raw-raw.mean(0),full_matrices=False);orthogonal=np.abs((raw-raw.mean(0))@vv[-1]);uncertain=np.sqrt(2)*bound
 panels.append({'scenario':scenario,'markers':len(raw),'drawing_indices':[ids.start,ids.stop-1],'x_axis_tick_values':xvalues,'y_axis_tick_values':yvalues,'genetic_mean':float(A.mean()),'phenotypic_mean':float(P.mean()),'genetic_sample_variance':float(np.var(A,ddof=1)),'phenotypic_sample_variance':float(np.var(P,ddof=1)),'residual_P_minus_A_sample_variance':float(np.var(E,ddof=1)),'sample_covariance_A_E':float(np.cov(A,E)[0,1]),'sample_correlation_A_P':float(np.corrcoef(A,P)[0,1]),'sample_variance_ratio_A_over_P':float(np.var(A,ddof=1)/np.var(P,ddof=1)),'maximum_distance_from_best_affine_line_pdf_points':float(orthogonal.max()),'markers_beyond_sqrt2_times_quarter_point_from_best_affine_line':int(sum(orthogonal>uncertain)),'max_bbox_vs_bezier_anchor_center_difference_pdf_points':anchor_delta,'endpoint_axis_calibration_residual_variance':float(np.var(endpointE,ddof=1)),'all_tick_vs_endpoint_residual_variance_difference':float(abs(np.var(E,ddof=1)-np.var(endpointE,ddof=1))),'residual_variance_coordinate_box_envelope_fixed_axes':residual_variance_box_envelope,'marker_geometry_check':geometric_check,'raw_marker_coordinates_written':False})
 assert len(raw)==10000
crops=[]
for page,name,rect in [(17,'fig1-3-icc-source.png',(155,120,340,306)),(119,'fig7-1-source.png',(87,224,419,354))]:
 path=pathlib.Path('evidence')/name
 if a.render_crops:
  from PIL import Image
  with tempfile.TemporaryDirectory()as t:
   stem=str(pathlib.Path(t)/'page');subprocess.run(['pdftoppm','-f',str(page),'-singlefile','-r','600','-png',str(source),stem],check=True,stdout=subprocess.DEVNULL,stderr=subprocess.DEVNULL)
   Image.open(stem+'.png').crop(tuple(round(v*600/72)for v in rect)).save(path)
 if path.exists():crops.append({'path':str(path),'pdf_page':page,'printed_page':page-9,'crop_points':rect,'render_dpi':600,'sha256':hashlib.sha256(path.read_bytes()).hexdigest(),'rights':'Limited attributed scholarly source-figure crop; copyright remains with Schwabe (2016).'})
report={'created_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'source_sha256':source_hash,'scope':'Follow-up of existing coverage C1-2 and C7-1; no new dissertation, raw data refit, original baseline overwrite or expensive simulation.','source_locators':['Chapter1 Eq1.1 pp7-8,Figure1.3p8/PDF17','Chapter7 pp109-110,Figure7.1p110/PDF119'],'extraction_bound':{'coordinate_pdf_points':bound,'status':'Conservative figure-geometry criterion inherited from the existing quarter-point source-extraction convention; not original measurement precision or sampling uncertainty.','limits':'Good geometric fit does not prove the original simulation or estimation procedure. No numerical rounding verdict for parameters unprinted by source.'},'figure1_3':{'curves':curves,'finding':'Rendered curves are consistent with equal discrimination 2 and difficulties−2,−.5 under their labelled axes. Eq. 1.1 is unit-slope, but the caption only says equal discrimination; rescaling or illustrative estimation may explain this. No author-error conclusion.','idealized_curve_limit':'A unit-discrimination illustration at difficulties ±.5 preserves qualitative ordering but does not reconstruct these plotted source curves.','resolved':'Source-figure curve coordinates and simple logistic parameterization are recoverable; random seed is unnecessary for this geometric check.','unresolved':'Original simulated test data, item estimates, seed and plot driver remain unavailable; inferred curve parameters are not verified true generating parameters.'},'figure7_1':{'panels':panels,'finding':'Exactly 10,000 markers per panel recovered. First panel is nearly, but not exactly, noiseless: extracted sample residual variance≈.001 and correlation≈.99950. Second panel gives genetic/residual sample variances≈.505/.502 and correlation≈.70955.','theoretical_candidates':{'scenario1':{'A_variance':1,'E_variance':.001,'correlation':1/np.sqrt(1.001),'heritability':1/1.001},'scenario2':{'A_variance':.5,'E_variance':.5,'correlation':np.sqrt(.5),'heritability':.5}},'candidate_scope':'Plot-derived sample variances are not robustly known population parameters; the fixed-axis quarter-point coordinate envelope for first panel residual variance includes zero even though exact affine collinearity fails the joint coordinate-box feasibility check. Variances 1/.001 and .5/.5 are plausible generating values, not recovered original driver parameters. They are consistent with source approximate≈ statements and sample variation. No significance/equivalence conclusion.','idealized_scenario_limit':'An exact E=0 reconstruction is an idealized limit, not the actual first panel point cloud.','remaining':'Original seed/driver not recovered; repetition of the original simulation is unestablished. Source point statistics are deterministic geometric extraction, not independent replication.'},'independence':'Curve reconstruction uses nonlinear probability-space optimization and independent central-logit linearization on shared source coordinates. Marker counts and moment identities use same plot, not new empirical data.','crops':crops,'run_command':'OPENBLAS_NUM_THREADS=1 python simulation/illustration_followup.py /tmp/schwabe-thesis/thesis_I_Schwabe.pdf --render-crops','validation':{'line_box_collinear_fixture':'passed','line_box_noncollinear_fixture':'passed'},'script':'simulation/illustration_followup.py','whole_dissertation_complete':False}
pathlib.Path('provenance/illustration-followup.json').write_text(json.dumps(report,indent=2,ensure_ascii=False)+'\n');print(json.dumps({'curve_candidates':[(c['simple_candidate_a'],c['simple_candidate_b'],c['candidate_max_vertical_pdf_point_residual'])for c in curves],'panel_stats':[(x['scenario'],x['markers'],x['residual_P_minus_A_sample_variance'],x['sample_correlation_A_P'])for x in panels]},indent=2))
