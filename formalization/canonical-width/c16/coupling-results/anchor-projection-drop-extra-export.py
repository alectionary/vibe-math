#!/usr/bin/env python3
"""Export independently repriced775-only projections of accepted1512 cuts."""
from pathlib import Path
from fractions import Fraction
import gzip,hashlib,json,sys
ROOT=Path(__file__).resolve().parents[1];sys.path.insert(0,str(ROOT))
from full_partner_native import NativeFullPartnerBatch
from verify_full_partner_projection import point_data,FEATURE_LAYOUT
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def read(p):
 b=Path(p).read_bytes();return json.loads(gzip.decompress(b) if str(p).endswith('.gz') else b)
def main():
 parent=ROOT/'coupling-results/anchor-projection-witness8.json.gz';receipt=ROOT/'coupling-results/anchor-projection-witness8-independent.json';point=ROOT/'coupling-results/multi-witness8-rational.json.gz';output=ROOT/'coupling-results/anchor-projection-witness8-old775-only.json.gz';assert not output.exists()
 source=read(parent);accepted=read(receipt);assert accepted['status']=='PASS' and accepted['bank_sha256']==sha(parent);assert source['point_sha256']==sha(point)
 reps=sorted({min(((m<<h)|(m>>(16-h)))&65535 for h in range(16)) for m in source['mask_list']});assert len(reps)==291
 owner,target=point_data(point,32);batch=NativeFullPartnerBatch(reps);cuts=[]
 for original in source['cuts']:
  c=original['coefficients'][:775];priced=batch.price(c);upper=int(max(priced['full_values']));exact=sum(a*b for a,b in zip(c,target));assert exact>upper;records=[]
  for i,m in enumerate(reps):
   B=list(map(int,priced['bases'][i]));nzero=128-m.bit_count();records.append(dict(mask=m,support_value=int(priced['values'][i]),full_value=int(priced['full_values'][i]),selected_Z_indices=B,zero_basis_indices=B[:nzero],owner_indices=B[nzero:]))
  cuts.append(dict(coefficients=c,upper_bound=upper,exact_target_value=str(exact),exact_violation=str(exact-upper),pricing_scale=original['pricing_scale'],support_records=records))
 sources=set(source['source_hashes'])|{str(p.relative_to(ROOT)) for p in [parent,receipt,Path(__file__),ROOT/'full_partner_native.py',ROOT/'verify_full_partner_native.py',ROOT/'coupling-results/native-full-partner-union-accepted.json',ROOT/'coupling-results/native-full-partner-union-accepted.frozen.json',ROOT/'verify_full_partner_projection.py']}
 bank=dict(status='EXACT_SUPPORT_CUT_CANDIDATE',source_C16_answered=False,feature_layout=FEATURE_LAYOUT,orbit=32,point_sha256=sha(point),allowed_masks=4597,representatives=reps,source_hashes={p:sha(ROOT/p) for p in sorted(sources)},cuts=cuts,parent_1512_bank_sha256=sha(parent),parent_1512_receipt_sha256=sha(receipt),scope='Retain only first775 coefficients of accepted1512 cuts and independently reprice unconditioned opposite basis supports. Any strict gap is attributable to existing775 features; no extra anchor feature is used.')
 output.write_bytes(gzip.compress((json.dumps(bank,indent=2)+'\n').encode(),mtime=0));print('EXPORTED',output.name,sha(output),[(c['upper_bound'],float(Fraction(c['exact_violation'])/c['pricing_scale'])) for c in cuts],flush=True)
if __name__=='__main__':main()
