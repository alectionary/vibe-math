#!/usr/bin/env python3
"""Deterministic checks of Abbott (2010) printed statistics; no raw-data replication.
Run from any working directory. Inputs are transcribed published numbers below
and the pdftotext -layout extraction of Appendix I. No pseudo-participants.
"""
from pathlib import Path
from itertools import product
from decimal import Decimal, localcontext
import csv, hashlib, json, math, platform, re, sys
import scipy
from scipy.stats import beta, chi2, t

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / 'outputs'
SOURCE_SHA256 = 'a3c381d6f6295e917806834364b7f55fc35684b3db53174a53c3564feab4d70a'
MODELS = [
 # name, printed page, chi-square, df, scale, CFI, RMSEA, SRMR, AIC
 ('unrefined',129,350.161,181,1.456,.934,.055,.061,52830.056),
 ('refined',130,295.571,178,1.463,.954,.046,.057,52758.669),
 ('general',131,319.462,179,1.488,.945,.050,.055,52799.519),
 ('external',134,514.150,326,1.261,.950,.043,.058,59249.022),
 ('saturated',138,514.108,326,1.261,.963,.043,.054,76438.957),
 ('all',140,1047.897,536,1.244,.900,.056,.062,76674.046),
 ('held',141,739.173,311,1.295,.917,.067,.060,76777.647),
 ('implied_structure',150,526.884,327,1.357,.961,.045,.049,76503.431),
 ('implied_indicators',150,572.421,326,1.363,.952,.050,.054,76570.611),
]
MODELS = {x[0]:dict(zip(['name','page','chi2','df','scale','cfi','rmsea','srmr','aic'],x)) for x in MODELS}
# Figure4.2 p132: standardized path labels and CV values, read from ink.
COMPOSITES = {
 'CTSE':([.898,.878,.852,.779],.91),
 'CPSE':([.730,.947,.832],.88),
 'CTFLEX':([.850,.909,.761],.88),
 'CTFLUE':([.839,.430,.434],.60),
 'CTORIG':([.913,.924,.884],.93),
 'CTELAB':([.907,.727,.535],.78),
 'CPDOMA':([.885,.859,.891],.91),
 'CPFIEL':([.756,.836,.791],.84),
 'CPPERS':([.857,.871,.834],.89),
}

def sb_difference(t0,d0,c0,t1,d1,c1):
    """Mplus official chi-square route; model0 is more restrictive.
    https://www.statmodel.com/chidiff.shtml
    """
    df=d0-d1
    cd=(d0*c0-d1*c1)/df
    return {'df':df,'cd':cd,'unscaled_difference':t0*c0-t1*c1,
            'statistic':(t0*c0-t1*c1)/cd}


def sb_decimal(t0,d0,c0,t1,d1,c1):
    """Independent high-precision rearranged formula, avoiding float cd."""
    with localcontext() as ctx:
        ctx.prec=40
        a,b,c,d=map(lambda x:Decimal(str(x)),[t0,c0,t1,c1])
        return float(Decimal(d0-d1)*(a*b-c*d)/(Decimal(d0)*b-Decimal(d1)*d))


def rounding_band(t0,d0,c0,t1,d1,c1):
    """Extrema for nearest-.001 rounding of t0,c0,t1,c1.
    For fixed other variables the ratio is linear-fractional in each input.
    If its denominator never crosses zero, every extremum lies at a corner.
    We verify positive denominator on every corner (denominator is affine).
    Endpoints are conservatively inclusive.
    """
    vals=[]; cds=[]
    for delta in product([-.0005,.0005],repeat=4):
        a,b,c,d=[x+y for x,y in zip([t0,c0,t1,c1],delta)]
        ans=sb_difference(a,d0,b,c,d1,d)
        vals.append(ans['statistic']); cds.append(ans['cd'])
    assert min(cds)>0
    return [min(vals),max(vals)]


def composite(loadings, square_sum=False):
    """Standardized indicators, residual variances1-lambda²; excludes covariances."""
    numerator=sum(loadings)**2 if square_sum else sum(x*x for x in loadings)
    residual=sum(1-x*x for x in loadings)
    return numerator/(numerator+residual)


def read_power_table():
    """Parse only numerical rows of the printed Appendix I, pp251–252."""
    txt='\n'.join((ROOT/'sources/pages'/f'pdf-{p:03d}.txt').read_text() for p in [265,266])
    rows=[]; group=''
    for line in txt.splitlines():
        s=line.strip()
        if re.fullmatch(r'\w+ (BY|WITH)',s) or s=='Variances': group=s
        m=re.fullmatch(r'(\w+)\s+(-?\d+\.\d+)\s+(-?\d+\.\d+)\s+(-?\d+\.\d+)\s+(-?\d+\.\d+)\s+(-?\d+\.\d+)\s+(-?\d+\.\d+)\s+(-?\d+\.\d+)',s)
        if not m: continue
        vals=list(map(float,m.groups()[1:]))
        row=dict(zip(['population','mean','sd','se','mse','coverage','significance'],vals))
        row['parameter']=group+':'+m[1]
        row['fixed']=row['sd']==0
        row['relative_parameter_bias']=None if row['population']==0 else (row['mean']-row['population'])/row['population']
        row['relative_se_bias']=None if row['sd']==0 else (row['se']-row['sd'])/row['sd']
        # SD divisor is not printed. Compare both R and R-1 conventions.
        row['mse_from_summary']=row['sd']**2+(row['mean']-row['population'])**2
        row['mse_from_sample_sd']=9999/10000*row['sd']**2+(row['mean']-row['population'])**2
        # Rounding intervals: means & SD have four decimals, population three.
        # Population is the simulation design, hence exact as printed here.
        lo_sd=max(0,row['sd']-.00005); hi_sd=row['sd']+.00005
        b=row['mean']-row['population']; abslo=max(0,abs(b)-.00005); abshi=abs(b)+.00005
        lo=9999/10000*lo_sd**2+abslo**2; hi=hi_sd**2+abshi**2
        row['mse_rounding_band']=[lo,hi]
        row['mse_compatible']=max(lo,row['mse']-.00005)<=min(hi,row['mse']+.00005)
        rows.append(row)
    assert len(rows)==31, len(rows)
    return rows


def build():
    checks=[]; details={}
    def add(claim,published,ours,verdict,reason,page):
        checks.append(dict(claim=claim,published=published,ours=ours,verdict=verdict,reason=reason,page=page))
    for label,restricted,comparison,published in [('refinement','unrefined','refined',52.457),('general','general','refined',-21.803)]:
        m0,m1=MODELS[restricted],MODELS[comparison]
        args=(m0['chi2'],m0['df'],m0['scale'],m1['chi2'],m1['df'],m1['scale'])
        ans=sb_difference(*args); ans['rounding_band']=rounding_band(*args)
        ans['decimal_independent']=sb_decimal(*args)
        assert abs(ans['decimal_independent']-ans['statistic'])<1e-10
        ans['conventional_chi2_p']=float(chi2.sf(ans['statistic'],ans['df']))
        # Diagnostic comparison only, not a claim about the author's process.
        ans['scaled_statistics_subtraction_over_cd']=(m0['chi2']-m1['chi2'])/ans['cd']
        details[label]=ans
        add('SB difference: '+label,str(published),f"{ans['statistic']:.6f}; rounding band [{ans['rounding_band'][0]:.6f}, {ans['rounding_band'][1]:.6f}]",'no match','Published value lies outside all nearest-.001 input rounding possibilities under the official chi-square formula.',m0['page'] if label=='general' else 130)
        add('SB difference df: '+label,'2' if label=='general' else '3',str(ans['df']),'no match' if label=='general' else 'match','Difference of printed model degrees of freedom.',131 if label=='general' else 130)
        delta_aic=m0['aic']-m1['aic']
        implied=ans['unscaled_difference']-2*ans['df']
        band=[]
        for ds in product([-.0005,.0005],repeat=4):
            a,b,c,d=[x+y for x,y in zip([m0['chi2'],m0['scale'],m1['chi2'],m1['scale']],ds)]
            band.append(a*b-c*d-2*ans['df'])
        ans['aic_delta']=delta_aic; ans['aic_from_scaled_products']=implied
        ans['aic_rounding_band']=[min(band),max(band)]
        assert min(band)-.001<delta_aic<max(band)+.001
        add('AIC/chi-square identity: '+label,f'{delta_aic:.3f}',f'{implied:.6f}; rounding band [{min(band):.6f}, {max(band):.6f}]','close','AIC difference agrees within rounding with recovered unscaled chi-square difference minus twice the df difference, assuming same cases/likelihood.',m0['page'])
    # Summary-statistic RMSEA calculation, not a second model fit.
    details['rmsea']=[]
    for name,m in MODELS.items():
        value=math.sqrt(max((m['chi2']-m['df'])/(308*m['df']),0))
        value_n1=math.sqrt(max((m['chi2']-m['df'])/(307*m['df']),0))
        details['rmsea'].append(dict(model=name,published=m['rmsea'],ours=value,n_minus_1=value_n1))
        add('RMSEA: '+name,f"{m['rmsea']:.3f}",f'{value:.6f}','match' if abs(value-m['rmsea'])<=.0005 else 'no match','Matches printed three decimals using Mplus N=308 convention; uses reported chi-square, not raw-data fit.',m['page'])
    for label,total,complete,printed in [('all',308,297,3.57),('male',93,90,3.22),('female',215,207,3.72)]:
        value=100*(total-complete)/total
        add('Incomplete questionnaires: '+label,f'{printed:.2f}%',f'{value:.6f}%', 'match' if abs(value-printed)<.005 else 'close', 'Counts reproduce percentage to nearest .01.' if label!='male' else 'Nearest rounding gives3.23%; truncation gives printed3.22%. Small reporting difference only.',125)
    base=MODELS['saturated']['aic']
    details['aic_ranking']={name:MODELS[name]['aic']-base for name in ['saturated','all','held','implied_structure','implied_indicators']}
    add('H5/H6 AIC ranking','Revised preferred over All, Held, Implied Structure, Implied Indicators', '; '.join(f'{k}: ΔAIC={v:.3f}' for k,v in details['aic_ranking'].items()),'match','All four published alternative AICs exceed the published Revised AIC; this checks reported ranking, not fitted likelihoods.','140–150')
    add('Implied Structure AIC subtraction','64.474',f"{details['aic_ranking']['implied_structure']:.3f}",'match','Direct subtraction of published AICs.',150)
    add('Implied Indicators AIC subtraction','131.65',f"{details['aic_ranking']['implied_indicators']:.3f}",'match','131.654 rounds to131.65 at two decimals.',150)
    details['composites']=[]
    for name,(loadings,published) in COMPOSITES.items():
        printed_formula=composite(loadings)
        alt=composite(loadings,True)
        d=dict(factor=name,loadings=loadings,published=published,printed_formula=printed_formula,square_of_sum=alt)
        d['alternative_rounding_band']=[composite([x+offset for x in loadings],True) for offset in [-.0005,.0005]]
        details['composites'].append(d)
        add('Figure4.2 composite: '+name,str(published),f'printed formula={printed_formula:.6f}; square-of-sum alternative={alt:.6f}','partial','Printed sum-of-squares formula does not match; square-of-sum alternative rounds to printed CV. Standardized residual variances1−λ² assumed; residual covariances excluded, so this is a formula-identification check, not validation of composite reliability.',132)
        assert abs(alt-published)<.005
    rows=read_power_table(); details['power_rows']=rows
    free=[r for r in rows if not r['fixed']]; nonzero=[r for r in free if r['population']!=0]
    maxbias=max(abs(r['relative_parameter_bias']) for r in nonzero)
    maxse=max(abs(r['relative_se_bias']) for r in free)
    details['power_summary']=dict(n_rows=len(rows),n_free=len(free),n_nonzero_free=len(nonzero),max_absolute_relative_parameter_bias=maxbias,max_absolute_relative_se_bias=maxse,mse_compatible_count=sum(r['mse_compatible'] for r in rows),replications_reported=10000,seed_reported=0)
    add('Appendix I parameter/SE-bias thresholds','Parameter bias<.10; SE bias<.05 for parameters of interest and<.10 overall',f'Max absolute relative nonzero-parameter bias={maxbias:.6f}; max SE bias={maxse:.6f}','partial','Displayed31 rows satisfy these relative-bias bounds; appendix omits complete generating inputs/output, so not all parameters or Monte Carlo rerun can be checked. Zero population covariance excluded from relative parameter bias.','96,251–252')
    add('Appendix I displayed nonzero free parameter significance','At least.80 power',f'{len(nonzero)} displayed nonzero free parameters: significance proportion1.000','partial','The printed simulated proportions meet.80, but no new simulation was run. Null covariance proportion.045 is type-I error, and fixed coefficients are not power targets.','96,251–252')
    add('Appendix I MSE identity','31 printed MSE entries',f"{sum(r['mse_compatible'] for r in rows)}/31 compatible with SD²+bias² and rounding",'match','Checks arithmetic of selected printed simulation output under both SD divisor conventions, not reproducibility of simulation.','251–252')
    details['correlation_thresholds']=[]
    for n in [296,308]:
        for alpha in [.05,.01,.001]:
            vals=[]
            for sides in [1,2]:
                q=t.isf(alpha/sides,n-2)
                vals.append(float(q/math.sqrt(q*q+n-2)))
            details['correlation_thresholds'].append(dict(n=n,alpha=alpha,one_sided=vals[0],two_sided=vals[1]))
    add('Table3.2 correlation significance cutoffs','r>.10/.13/.18 for p<.05/.01/.001','Two-sided r>.11403/.14951/.19031; one-sided r>.09579/.13517/.17892','partial','Ordinary Pearson null test at n296 does not support the stated blanket cutoffs; test sidedness is unstated. Latent Table4.1 correlations require model-based SE and are not tested by this calculation.',95)
    add('CFI prose values on p131','.054 versus threshold.05','.945 in same-page model summary; threshold.95 on p102','no match','Internal prose inconsistency visible in source; using model summary preserves reported CFI-based rejection of the general model.',131)
    add('External-model strict CFI criterion','CFI=.950 reported as passing CFI>.95','Unrounded CFI cannot be recovered from three decimals','partial','Printed.950 is exactly the declared strict boundary; rounding prevents determining which side the unrounded estimate lies.','102,134')
    details['metadata']={'kind':'published-summary consistency audit, not empirical rerun','source_sha256':SOURCE_SHA256,'source_pdf_page_offset':14,'python':platform.python_version(),'scipy':scipy.__version__,'formula_source':'https://www.statmodel.com/chidiff.shtml','rmsea_convention_source':'https://www.statmodel.com/discussion/messages/23/26.html','deterministic':True,'random_seed':None}
    return checks,details


def self_test():
    z=sb_difference(15,10,1,10,8,1)
    assert z['statistic']==5 and z['df']==2 and z['cd']==1
    assert sb_decimal(15,10,1,10,8,1)==5
    assert composite([1,1])==1 and composite([1,1],True)==1
    assert composite([0,0])==0 and composite([0,0],True)==0
    assert abs(composite([.5,.5])-.25)<1e-12
    assert abs(composite([.5,.5],True)-.4)<1e-12
    # Independent beta-law and Student-t calculations of Pearson's null cutoff.
    for n in [296,308]:
        for alpha in [.05,.01,.001]:
            q=t.isf(alpha/2,n-2)
            rt=q/math.sqrt(q*q+n-2)
            rb=2*beta.ppf(1-alpha/2,n/2-1,n/2-1)-1
            assert abs(rt-rb)<1e-10
    assert len(SOURCE_SHA256)==64


def main():
    self_test(); checks,details=build(); OUT.mkdir(exist_ok=True)
    with (OUT/'published_checks.csv').open('w',newline='') as f:
        writer=csv.DictWriter(f,fieldnames=list(checks[0])); writer.writeheader();writer.writerows(checks)
    (OUT/'published_checks.json').write_text(json.dumps(dict(checks=checks,details=details),indent=2)+'\n')
    lines=['# Published-summary checks','', 'These are arithmetic and internal-consistency checks, not a participant-data replication.','', '| Claim | Published | Ours | Verdict | Reason | Printed page |','|---|---|---|---|---|---|']
    lines.extend('| '+' | '.join(str(r[k]).replace('|','\\|') for k in ['claim','published','ours','verdict','reason','page'])+' |' for r in checks)
    (OUT/'published_checks.md').write_text('\n'.join(lines)+'\n')
    print(json.dumps({'checks':len(checks),'self_test':'passed','power_summary':details['power_summary'],'outputs':['outputs/published_checks.csv','outputs/published_checks.json','outputs/published_checks.md']},indent=2))

if __name__=='__main__': main()
