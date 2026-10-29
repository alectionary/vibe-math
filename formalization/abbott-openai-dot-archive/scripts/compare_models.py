#!/usr/bin/env python3
"""Combine fitted reconstruction and published values without equating estimators."""
from pathlib import Path
import csv,json
from published_checks import MODELS
ROOT=Path(__file__).resolve().parents[1]
def main():
 records=json.loads((ROOT/'outputs/sem_fits.json').read_text())['models']
 rows=[]
 for r in records:
  name='external' if r['model']=='refined' and r['external'] else r['model'];p=MODELS[name]
  rows.append({'model':name,'published_page':p['page'],'published_n':308,'reconstruction_n':296,'published_df':p['df'],'reconstruction_df':r['df'],'published_MLR_chi_square':p['chi2'],'published_scale':p['scale'],'published_product_chi_square_times_scale':p['chi2']*p['scale'],'reconstruction_ML_chi_square':r['chi_square_ML'],'published_MLR_CFI':p['cfi'],'reconstruction_ML_CFI':r['CFI_ML'],'published_MLR_RMSEA':p['rmsea'],'reconstruction_ML_RMSEA':r['RMSEA_ML'],'published_SRMR':p['srmr'],'reconstruction_core_SRMR':r['SRMR'],'verdict':'partial','reason':'Rounded n296 summary ML is not n308 participant-data MLR/FIML; only covariance structure and broad patterns compared.'})
 with (ROOT/'outputs/model_comparison.csv').open('w') as f:
  w=csv.DictWriter(f,fieldnames=list(rows[0]));w.writeheader();w.writerows(rows)
 ref=next(r for r in records if r['model']=='refined' and r['external'])
 rankings=[]
 for r in records:
  if r['external'] and r['model']!='refined':
   rankings.append({'model':r['model'],'published_delta_AIC':MODELS[r['model']]['aic']-MODELS['saturated']['aic'],'reconstruction_profiled_delta_AIC_n296':r['AIC_relative_same_observables']-ref['AIC_relative_same_observables'],'verdict':'partial','reason':'Preference retained under unrestricted observed-auxiliary profile approximation; original latent residual parameterization not certified.'})
 with (ROOT/'outputs/model_ranking.csv').open('w') as f:
  w=csv.DictWriter(f,fieldnames=list(rankings[0]));w.writeheader();w.writerows(rankings)
 print(json.dumps(rankings,indent=2))
if __name__=='__main__':main()
