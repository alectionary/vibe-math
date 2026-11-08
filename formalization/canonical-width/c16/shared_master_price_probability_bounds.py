"""Emit explicit source-row proofs of0<=v<=lambda_mask for actual parent vars."""
from pathlib import Path
import argparse
import gzip
import json
import time
from verify_shared_master_common import guard,resolve,sha
from verify_shared_master_preparation import context


def main():
    ap=argparse.ArgumentParser()
    for key in ('manifest','preparation','output'):ap.add_argument('--'+key,required=True)
    a=ap.parse_args();guard();start=time.monotonic();out=resolve(a.output)
    assert not out.exists()
    data,L,semantic=context(a.manifest,a.preparation,check_columns=False)
    M=data['M'];assert len(M['variables'])==22481
    boxes={};flows={}
    for i,row in enumerate(M['inequalities']):
        if row['kind']=='box':boxes[row['side'],row['mask'],row['index'],row['bound']]='inequalities'+str(i)
        if row['kind']=='owner_flow_bound':flows[row['mask'],row['edge'],row['bound']]='inequalities'+str(i)
    pairs={tuple(pair):i for i,pair in enumerate(M['owner_flow_extension']['physical_pairs'])}
    result=[]
    for j,v in enumerate(M['variables']):
        kind=v['kind']
        if kind=='tau':continue
        m=v['mask']
        if kind=='allocation':
            side,k=v['side'],v['index']
            lower=[boxes[side,m,k,'lower']];upper=[boxes[side,m,k,'upper']]
        else:
            assert kind=='owner_joint';x,z=v['X_index'],v['Z_index'];edge=pairs[x,z]
            lower=[flows[m,edge,'nonnegative']]
            upper=[flows[m,edge,'X_upper'],boxes['X',m,x,'upper']]
        result.append(dict(variable=j,kind=kind,mask=m,lower=[[s,1] for s in lower],upper=[[s,1] for s in upper]))
    for m in range(16):
        for side in 'XZ':
            if side=='X':
                j=22481+2*m;singleton=1;pair=3;center=614;edges=[pairs[614,z] for z in (51,83)]
            else:
                j=22482+2*m;singleton=4;pair=12;center=51;edges=[pairs[x,51] for x in (614,281)]
            lower=[f'k22_atom_{m}_{pair}']
            upper=[f'k22_atom_{m}_{singleton}',*[flows[m,e,'nonnegative'] for e in edges],boxes[side,m,center,'upper']]
            result.append(dict(variable=j,kind='conditional_same_sector_pair',mask=m,side=side,
                               lower=[[s,1] for s in lower],upper=[[s,1] for s in upper]))
    assert len(result)==22508 and [r['variable'] for r in result]==list(range(5,22513))
    high=[7,11,13,14,15]
    tau=[dict(variable=i,mask=h,pattern_masks=[m for m in range(16) if m&h==h]) for i,h in enumerate(high)]
    sources=['shared_master_price_probability_bounds.py','verify_shared_master_common.py','verify_shared_master_preparation.py']
    cert=dict(status='EXACT_SHARED_MASTER_PATTERN_PROBABILITY_BOUNDS_REQUIRES_REPLAY',
              manifest=a.manifest,manifest_sha256=sha(a.manifest),preparation=a.preparation,preparation_sha256=sha(a.preparation),
              point_sha256=data['manifest']['point_sha256'],semantic_sha256=data['manifest']['semantic_sha256'],
              full_parent_variables=22513,bounded_variables=22508,tau_variables=5,
              kind_counts={k:sum(r['kind']==k for r in result) for k in ('allocation','owner_joint','conditional_same_sector_pair')},
              bounds=result,tau_superset_identities=tau,all16_patterns=True,zero_tau_pins=False,
              residual_formula='r_v*v >= min(0,r_v)*lambda_mask; tau_h=sum_{m superset h}lambda_m',
              source_hashes={p:sha(p) for p in sources},elapsed_seconds=time.monotonic()-start,
              scope='Actual-parent row-witness certificate only; no source-combination projection or solver run.',source_C16_answered=False)
    raw=(json.dumps(cert,separators=(',',':'))+'\n').encode()
    out.write_bytes(gzip.compress(raw,mtime=0) if out.suffix=='.gz' else raw)
    print(json.dumps(dict(status=cert['status'],output=str(out),sha256=sha(out),bounds=len(result),elapsed_seconds=cert['elapsed_seconds'])))


if __name__=='__main__':main()
