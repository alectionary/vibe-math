"""Independent exact source-combination and full-domain residual pricing check.

An interrupted numerical dual only selects rational source multipliers here.
No primal feasibility, dual stationarity, or phase-I optimum is inferred.
The producer is not imported. Every residual is bounded with source rows.
"""
from fractions import Fraction as Q
from pathlib import Path
import argparse,copy,json,re,time
from verify_shared_master_common import guard,resolve,sha,read,bindings,expected_rows,value
from verify_shared_master_preparation import context
from verify_two_sided_full_basis_oracle import check_sector,columns as physical_owner_columns

LOW=(0,1,2,4,8,3,5,9,6,10,12)
HIGH=(7,11,13,14,15)
DECIMAL=re.compile(r'[+-]?(?:\d+(?:\.\d*)?|\.\d+)(?:[eE][+-]?\d+)?\Z')
FOOTER=re.compile(r'All other dual values are zero \(within [0-9.eE+\-]+\)\.\Z')

def parse_decimal_dual(text,names):
    names=list(names);assert len(names)==len(set(names))
    lines=text.splitlines();header='Dual solution (name, value):'
    positions=[i for i,line in enumerate(lines) if line.strip()==header]
    assert len(positions)==1,'Missing/duplicate named decimal dual section'
    values={name:Q(0) for name in names};seen=set();tokens=[];end=None
    for i in range(positions[0]+1,len(lines)):
        line=lines[i].strip()
        if not line:continue
        if FOOTER.fullmatch(line):end=i;break
        fields=line.split();assert len(fields)==2,'Malformed decimal dual line'
        name,token=fields
        assert name in values and name not in seen and DECIMAL.fullmatch(token)
        values[name]=Q(token);seen.add(name);tokens.append([name,token,str(values[name])])
    assert end is not None,'Missing completed sparse-zero section'
    rest=[line.strip() for line in lines[end+1:] if line.strip()]
    assert rest and rest[0]=='Reduced costs (name, value):'
    return values,tokens

def parse_named_candidate(candidate,names):
    assert candidate['status']=='NUMERICAL_SHARED_MASTER_ROW_DUAL_CANDIDATE'
    assert candidate['dual_valid'] is True and candidate['rows']==len(names)
    assert len(candidate['row_dual'])==len(names)
    values={};tokens=[]
    for pair,name in zip(candidate['row_dual'],names):
        assert len(pair)==2 and pair[0]==name
        token=pair[1];assert isinstance(token,str) and DECIMAL.fullmatch(token)
        assert name not in values
        values[name]=Q(token);tokens.append([name,token,str(values[name])])
    return values,tokens

def add_scaled(out,terms,scale):
    for j,v in terms.items():
        q=out.get(j,Q(0))+scale*v
        if q:out[j]=q
        else:out.pop(j,None)

def combine(witness,rows):
    G,V={},{};assert witness and len(witness)==len({name for name,c in witness})
    for name,c in witness:
        assert type(c)is int and c>0
        e,relation=rows[name];assert relation=='<='
        add_scaled(G,e[0],Q(c));add_scaled(V,e[1],Q(c))
    return G,V

def verify_bounds(c,receipt,data):
    assert receipt['status']=='PASS_EXACT_SHARED_MASTER_PATTERN_LOCAL_PROBABILITY_BOUNDS'
    assert receipt['consumer_sha256']==sha('verify_shared_master_projection_bounds.py')
    bindings(receipt['source_hashes']);bindings(receipt['dependencies']);bindings(c['source_hashes'])
    assert c['manifest_sha256']==receipt['manifest_sha256']==sha(c['manifest'])
    assert c['point_sha256']==receipt['point_sha256']==data['manifest']['point_sha256']
    M=data['M'];metadata=M['variables']+[dict(kind='conditional_same_sector_pair',mask=m,side=s) for m in range(16) for s in 'XZ']
    rows={name:(e,rel) for name,e,rel in data['parent_rows']}
    assert [r['variable'] for r in c['bounds']]==list(range(5,22513))
    masks={}
    for r in c['bounds']:
        j,m=r['variable'],r['mask'];assert type(m)is int and 0<=m<16
        assert metadata[j]['kind']==r['kind'] and metadata[j]['mask']==m
        assert combine(r['lower'],rows)==({},{j:Q(-1)})
        lam=M['lambda_expressions'][m];g={};v={j:Q(1)}
        add_scaled(g,lam[0],Q(-1));add_scaled(v,lam[1],Q(-1))
        assert combine(r['upper'],rows)==(g,v);masks[j]=m
    for j,h in enumerate(HIGH):
        g,v={},{}
        for m in range(16):
            if m&h==h:
                add_scaled(g,M['lambda_expressions'][m][0],Q(1));add_scaled(v,M['lambda_expressions'][m][1],Q(1))
        assert (g,v)==({},{j:Q(1)})
    g,v={},{}
    for e in M['lambda_expressions']:add_scaled(g,e[0],Q(1));add_scaled(v,e[1],Q(1))
    assert (g,v)==({0:Q(1)},{})
    return masks

def reconstruct_source(data,L,raw):
    G,V={},{};clipped=[];multipliers=[]
    for name,e,rel in data['parent_rows']:
        mu=-raw[name]
        if rel=='<=':
            if mu<0:clipped.append([name,str(raw[name])]);mu=Q(0)
            assert mu>=0
        if mu:multipliers.append([name,str(mu)])
        add_scaled(G,e[0],mu);add_scaled(V,e[1],mu)
    blocks={};M=data['M']
    for m in range(16):
        for s in 'XZ':
            pi=raw[f'sm_mass_{s}_{m}'];e=M['lambda_expressions'][m]
            add_scaled(G,e[0],pi);add_scaled(V,e[1],pi);costs=[]
            for j,e in enumerate(M['sectors'][s]['allocations'][m]):
                pi_j=raw[f'sm_link_{s}_{m}_{j}']
                add_scaled(G,e[0],pi_j);add_scaled(V,e[1],pi_j);costs.append(-pi_j)
            blocks[s,m]=dict(gamma=-pi,c=costs)
    return G,V,blocks,clipped,multipliers

def compare_saved(p,e):
    assert p['status']=='EXACT_SHARED_MASTER_RESIDUAL_FULL_DOMAIN_PRICING_REQUIRES_REPLAY'
    assert p['phase_one_optimum_claimed'] is False and p['dual_stationarity_claimed'] is False
    assert p['zero_tau_pins'] is False and p['source_C16_answered'] is False
    assert p['parent_rows_checked']==98863
    for key in ['decimal_rows','raw_nonzero_dual','clipped_positive_parent_inequality_duals','source_parent_row_weights','ignored_sm_nonneg_nonzero']:
        assert p[key]==e[key],key
    for key in ['owner_feature_coefficients','finite_residual_coefficients','tau_residual']:
        assert len(p[key])==len(e[key]) and {j:Q(v) for j,v in p[key]}==dict(e[key]),key
    for key in ['pattern_bound_correction','high_moment_pattern_correction','pattern_costs','low_moment_targets','feasible_pattern_law']:
        assert list(map(Q,p[key]))==e[key],key
    assert p['low_owner_map']==e['low_owner_map']
    for key in ['source_target_constant','constant_minorant_gap','saved_law_cost_gap']:
        assert Q(p[key])==e[key],key
    assert [r['mask'] for r in p['pattern_records']]==list(range(16))
    for record in p['pattern_records']:
        m=record['mask'];assert set(record['sectors'])=={'X','Z'}
        for s in 'XZ':
            r=record['sectors'][s];b=e['blocks'][s,m]
            assert Q(r['constant'])==b['gamma'] and list(map(Q,r['weights']))==b['c']
            assert Q(r['minimum'])==b['minimum'] and r['selected_indices']==b['selected']
            assert record['oracle_support'][s+'_selected']==b['selected']
            assert Q(record['oracle_support'][s+'_support']['value'])==b['gamma']-b['minimum']

def main():
    guard();ap=argparse.ArgumentParser();ap.add_argument('--pricing',required=True);ap.add_argument('--output',required=True)
    a=ap.parse_args();start=time.monotonic();out=resolve(a.output);assert not out.exists();p=read(a.pricing)
    assert p['candidate_format']=='HIGHS_NAMED_DECIMAL_ROW_DUAL_JSON'
    for key in ['manifest','preparation','numerical_candidate','numerical_frozen','bounds_certificate','bounds_receipt','feasible_law_source','feasible_law_receipt','point']:
        assert sha(p[key])==p[key+'_sha256'],key
    bindings(p['source_hashes']);data,L,semantic=context(p['manifest'],p['preparation'],check_columns=False)
    assert p['point_sha256']==data['manifest']['point_sha256'] and resolve(p['point'])==resolve(data['manifest']['point'])
    candidate=read(p['numerical_candidate']);frozen=read(p['numerical_frozen'])
    assert candidate['manifest_sha256']==p['manifest_sha256'] and candidate['lp_sha256']==data['manifest']['lp_sha256']
    assert candidate['frozen_sha256']==p['numerical_frozen_sha256'] and sha(candidate['frozen'])==p['numerical_frozen_sha256']
    assert frozen['manifest_sha256']==p['manifest_sha256'] and frozen['lp_sha256']==data['manifest']['lp_sha256']
    assert frozen['preparation_receipt_sha256']==p['preparation_sha256']
    bounds=read(p['bounds_certificate']);br=read(p['bounds_receipt'])
    assert br['certificate_sha256']==p['bounds_certificate_sha256']
    assert bounds['manifest_sha256']==p['manifest_sha256'] and bounds['preparation_sha256']==p['preparation_sha256']
    assert sha(bounds['preparation'])==p['preparation_sha256']
    masks=verify_bounds(bounds,br,data)
    rows=list(expected_rows(data,L));names=[r[0] for r in rows]
    raw,tokens=parse_named_candidate(candidate,names)
    G,V,blocks,clipped,multipliers=reconstruct_source(data,L,raw)
    rho=[Q(0)]*16;high=[Q(0)]*16
    for j in range(5,22513):rho[masks[j]]+=min(Q(0),V.get(j,Q(0)))
    for j,h in enumerate(HIGH):
        for m in range(16):
            if m&h==h:high[m]+=V.get(j,Q(0))
    assert len(p['pattern_records'])==16
    prefixes=0
    for record in p['pattern_records']:
        m=record['mask'];assert type(m)is int and 0<=m<16
        for s in 'XZ':
            b=blocks[s,m];chosen=record['sectors'][s]['selected_indices']
            support,n=check_sector(data[s],128,data['domains'][m][s],[-q for q in b['c']],chosen)
            minimum=b['gamma']-support;prefixes+=n
            assert minimum==b['gamma']+sum(b['c'][j] for j in chosen)
            b.update(minimum=minimum,selected=chosen)
    costs=[blocks['X',m]['minimum']+blocks['Z',m]['minimum']+rho[m]+high[m] for m in range(16)]
    M,f=data['M'],data['f'];gvalue=sum(v*f[j] for j,v in G.items())
    fmap=[0 if j is None else j+1 for j in physical_owner_columns([80,512],[186,433])[:11]]
    assert fmap==M['source_feature_to_owner_target'][:11] and len(set(fmap))==11
    q=[f[j] for j in fmap]
    source=read(p['feasible_law_source']);sr=read(p['feasible_law_receipt'])
    assert p['feasible_law_source_sha256']==data['manifest']['parent_endpoint_sha256']
    assert p['feasible_law_receipt_sha256']==data['manifest']['parent_endpoint_receipt_sha256']
    assert source['status']=='EXACT_OWNER_K22_CAPACITY_ALLOCATION_REQUIRES_REPLAY'
    assert sr['status']=='PASS_EXACT_LITERAL_OWNER_K22_CAPACITY_ALLOCATION'
    assert sr['certificate_sha256']==p['feasible_law_source_sha256'] and sr['point_sha256']==p['point_sha256']
    parameters=list(map(Q,source['exact_parameters']));assert len(parameters)==22513
    law=[value(e,f,parameters) for e in M['lambda_expressions']]
    assert law==list(map(Q,source['lambda_masses'])) and len(law)==16 and min(law)>=0 and sum(law)==1
    assert all(sum(law[m] for m in range(16) if m&h==h)==q[i] for i,h in enumerate(LOW))
    expected=dict(decimal_rows=tokens,raw_nonzero_dual=[[name,str(v)] for name,v in raw.items() if v],
        clipped_positive_parent_inequality_duals=clipped,source_parent_row_weights=multipliers,
        ignored_sm_nonneg_nonzero=[[name,str(v)] for name,v in raw.items() if name.startswith('sm_nonneg_') and v],
        owner_feature_coefficients=sorted(G.items()),finite_residual_coefficients=sorted((j,v) for j,v in V.items() if j>=5),
        tau_residual=[(h,V[j]) for j,h in enumerate(HIGH) if V.get(j)],pattern_bound_correction=rho,
        high_moment_pattern_correction=high,pattern_costs=costs,low_owner_map=fmap,low_moment_targets=q,
        feasible_pattern_law=law,source_target_constant=gvalue,constant_minorant_gap=gvalue+min(costs),
        saved_law_cost_gap=gvalue+sum(c*w for c,w in zip(costs,law)),blocks=blocks)
    compare_saved(p,expected);rejected=[]
    for label in ['residual_coefficient','pattern_price','moment_identity','source_weight','target_gap','false_optimum']:
        bad=copy.deepcopy(p)
        if label=='residual_coefficient':
            if bad['finite_residual_coefficients']:bad['finite_residual_coefficients'][0][1]=str(Q(bad['finite_residual_coefficients'][0][1])+1)
            else:bad['finite_residual_coefficients']=[[5,'1']]
        elif label=='pattern_price':bad['pattern_records'][0]['sectors']['X']['minimum']=str(Q(bad['pattern_records'][0]['sectors']['X']['minimum'])+1)
        elif label=='moment_identity':bad['high_moment_pattern_correction'][15]=str(Q(bad['high_moment_pattern_correction'][15])+1)
        elif label=='source_weight':
            if bad['source_parent_row_weights']:bad['source_parent_row_weights'][0][1]=str(Q(bad['source_parent_row_weights'][0][1])+1)
            else:bad['source_parent_row_weights']=[[data['parent_rows'][0][0],'1']]
        elif label=='target_gap':bad['constant_minorant_gap']=str(Q(bad['constant_minorant_gap'])+1)
        else:bad['phase_one_optimum_claimed']=True
        try:compare_saved(bad,expected)
        except (AssertionError,IndexError,KeyError):rejected.append(label)
        else:raise AssertionError(('Accepted residual certificate mutation',label))
    tiny='Dual solution (name, value):\na 1.25e-2\nb -3.75\nAll other dual values are zero (within 1.0e-16).\nReduced costs (name, value):\n'
    parsed,_=parse_decimal_dual(tiny,['a','b','c']);assert parsed=={'a':Q(1,80),'b':Q(-15,4),'c':Q(0)}
    for label,bad in [('parser_duplicate',tiny.replace('b -3.75','a -3.75')),('parser_unknown',tiny.replace('b -3.75','z -3.75')),
                      ('parser_nonfinite',tiny.replace('1.25e-2','nan')),('parser_missing_footer',tiny.replace('All other dual values are zero (within 1.0e-16).',''))]:
        try:parse_decimal_dual(bad,['a','b','c'])
        except (AssertionError,ValueError):rejected.append(label)
        else:raise AssertionError(('Accepted decimal parser mutation',label))
    control=dict(status='NUMERICAL_SHARED_MASTER_ROW_DUAL_CANDIDATE',dual_valid=True,rows=2,row_dual=[['a','1.25e-2'],['b','-3.75']])
    assert parse_named_candidate(control,['a','b'])[0]=={'a':Q(1,80),'b':Q(-15,4)}
    for label in ['candidate_wrong_order','candidate_short_vector','candidate_nonfinite','candidate_invalid_flag']:
        bad=copy.deepcopy(control)
        if label=='candidate_wrong_order':bad['row_dual'].reverse()
        elif label=='candidate_short_vector':bad['row_dual'].pop()
        elif label=='candidate_nonfinite':bad['row_dual'][0][1]='inf'
        else:bad['dual_valid']=False
        try:parse_named_candidate(bad,['a','b'])
        except (AssertionError,ValueError):rejected.append(label)
        else:raise AssertionError(('Accepted numerical candidate mutation',label))
    negative=[]
    for (s,m),b in blocks.items():
        if b['minimum']<0:
            archived=any(tuple(sorted(b['selected']))==tuple(sorted(L['columns'][k]['indices'])) for k in L['blocks'][s,m])
            negative.append(dict(side=s,mask=m,minimum=str(b['minimum']),is_archived=archived))
    result=dict(status='PASS_EXACT_SHARED_MASTER_RESIDUAL_FULL_DOMAIN_PRICING',pricing_sha256=sha(a.pricing),consumer_sha256=sha(Path(__file__).name),
        manifest_sha256=p['manifest_sha256'],bounds_certificate_sha256=p['bounds_certificate_sha256'],bounds_receipt_sha256=p['bounds_receipt_sha256'],
        numerical_candidate_sha256=p['numerical_candidate_sha256'],numerical_frozen_sha256=p['numerical_frozen_sha256'],
        point_sha256=p['point_sha256'],source_rows_checked=98863,lower_upper_bound_witnesses_checked=45016,bounded_parent_variables=22508,
        exact_tau_superset_identities=5,full_domains_priced=32,physical_full_basis_minimizers=32,independent_signed_prefix_ranks=prefixes,
        nonzero_nontau_residuals=sum(j>=5 for j in V),nonzero_tau_residuals=sum(j<5 for j in V),clipped_source_inequalities=len(clipped),
        non_tau_residual_L1=str(sum(abs(v) for j,v in V.items() if j>=5)),negative_price_records=negative,
        source_target_constant=str(gvalue),constant_minorant_gap=str(gvalue+min(costs)),saved_law_cost_gap=str(gvalue+sum(c*w for c,w in zip(costs,law))),
        residual_bound_corrections=list(map(str,rho)),high_moment_corrections=list(map(str,high)),
        phase_one_optimum_claimed=False,dual_stationarity_claimed=False,zero_tau_pins=False,new_separating_owner_row_accepted=False,source_C16_answered=False,
        rejected_mutants=rejected,source_hashes=p['source_hashes'],dependencies={name:sha(name) for name in ['verify_shared_master_common.py','verify_shared_master_preparation.py','verify_shared_master_projection_bounds.py','verify_two_sided_full_basis_oracle.py']},
        elapsed_seconds=time.monotonic()-start,nice=19,threads=1,
        scope='Exact source-valid combination and full32-domain pricing with all residuals bounded. No restricted optimum is asserted; final minorant awaits acceptance.')
    out.write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps({k:v for k,v in result.items() if k not in ['source_hashes','dependencies','residual_bound_corrections','high_moment_corrections']},indent=2))

if __name__=='__main__':main()

