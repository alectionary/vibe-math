#!/usr/bin/env python3
"""Extract the printed rounded Table 3.2 (not participant records)."""
from pathlib import Path
import re,csv,json,sys,platform
import numpy as np
ROOT=Path(__file__).resolve().parents[1]
PREFIX={'CPD':'CPDOMA','CPF':'CPFIEL','CPP':'CPPERS','CTE':'CTELAB','CTFx':'CTFLEX','CTFu':'CTFLUE','CTO':'CTORIG'}
def canonical(label):
    # The printed row 10 reads CPFI; sequence and Appendix J identify CPFIEL3.
    if label=='CPFI': return 'CPFIEL3'
    for k,v in PREFIX.items():
        if label.startswith(k):return v+label[len(k):]
    return label

def extract():
    rows=[]
    for page in (108,109):
        for line in (ROOT/f'sources/pages/pdf-{page:03d}.txt').read_text().splitlines():
            m=re.match(r'^\s*(\d+):\s*(\w+)\s+(.*)',line)
            if not m:continue
            i,label,rest=int(m[1]),m[2],m[3]
            nums=[float(s) for s in re.findall(r'[-+]?\d*\.\d+',rest)]
            assert len(nums)==i+1,(i,len(nums),nums)
            rows.append(dict(index=i,printed_label=label,name=canonical(label),mean=nums[0],sd=nums[1],correlations=nums[2:],pdf_page=page,printed_page=page-14))
    assert len(rows)==37
    R=np.eye(37)
    for row in rows:
        i=row['index']-1
        R[i,:i]=row['correlations'];R[:i,i]=row['correlations']
    return rows,R

def kmo(R):
    P=np.linalg.inv(R)
    P=-P/np.sqrt(np.outer(np.diag(P),np.diag(P)))
    np.fill_diagonal(P,0)
    A=R.copy();np.fill_diagonal(A,0)
    return np.sum(A*A)/(np.sum(A*A)+np.sum(P*P))

def audit(rows,R):
    names=[r['name'] for r in rows]
    subsets={'all_37':range(37),'all_35_excluding_sex_age':range(35),'creative_28':range(3,31),
        'revised_21':[names.index(x) for x in ['CPDOMA1','CPDOMA3','CPDOMA4','CPFIEL2','CPFIEL3','CPFIEL4','CPPERS1','CPPERS2','CPPERS4','CTELAB3','CTELAB4','CTELAB5','CTFLEX1','CTFLEX2','CTFLEX3','CTFLUE2','CTFLUE3','CTFLUE4','CTORIG2','CTORIG3','CTORIG4']]}
    subsets['revised_28_with_BCSE_Open']=subsets['revised_21']+list(range(3))+list(range(31,35))
    result={}
    for name,indices in subsets.items():
        indices=list(indices);A=R[np.ix_(indices,indices)];v=A[np.tril_indices(len(A),-1)]
        result[name]={'p':len(A),'eigenvalue_min':float(np.linalg.eigvalsh(A).min()),'kmo':float(kmo(A)), 'pair_count':len(v),'count_r_gt_030':int(sum(v>.30)), 'fraction_r_gt_030':float(np.mean(v>.30)),'fraction_abs_r_gt_030':float(np.mean(abs(v)>.30)), 'count_at_rounding_boundary_030':int(sum(v==.30)), 'possible_fraction_r_gt_030_under_half_unit_rounding':[float(np.mean(v>.30)),float(np.mean(v>=.30))]}
    groups=[list(range(3))]+[list(range(a,a+4)) for a in range(3,35,4)]
    v=np.concatenate([R[np.ix_(g,g)][np.tril_indices(len(g),-1)] for g in groups])
    result['within_same_first_order_factor']={'pair_count':len(v),'count_r_gt_030':int(sum(v>.30)),'fraction_r_gt_030':float(np.mean(v>.30)),'fraction_abs_r_gt_030':float(np.mean(abs(v)>.30))}
    return result

def main():
    rows,R=extract()
    with (ROOT/'sources/table_3_2.csv').open('w') as f:
        w=csv.writer(f);w.writerow(['item']+[r['name'] for r in rows]);w.writerows([[r['name']]+list(R[i]) for i,r in enumerate(rows)])
    with (ROOT/'sources/table_3_2_items.csv').open('w') as f:
        fields=['index','printed_label','name','mean','sd','pdf_page','printed_page'];w=csv.DictWriter(f,fieldnames=fields,extrasaction='ignore');w.writeheader();w.writerows(rows)
    result={'source':'Abbott (2010), Table 3.2, pp.94–95 (PDF108–109)', 'source_n':296,'scope':'Rounded published correlations only; not individual records.', 'numpy_version':np.__version__,'python_version':platform.python_version(),'subsets':audit(rows,R), 'bounded_scale_check':{'item':'CTFLUE4','published_mean':74.8,'published_sd':52.3,'assumption':'All values lie in [0,100]; sample SD divisor n-1; n=296.', 'max_sample_sd_at_printed_mean':float(np.sqrt(296/295*74.8*25.2)), 'max_sample_sd_allowing_mean_rounding':float(np.sqrt(296/295*74.75*25.25)), 'minimum_sd_allowing_printed_rounding':52.25}}
    (ROOT/'outputs/matrix_audit.json').write_text(json.dumps(result,indent=2)+'\n');print(json.dumps(result,indent=2))
if __name__=='__main__':main()
