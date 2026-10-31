#!/usr/bin/env python3
"""Independent full sparse-row replay of an exact count-extension recovery."""
from pathlib import Path
from fractions import Fraction
import argparse,gzip,hashlib,json,time
from two_sided_count_exact_rows import reconstruct,target
from verify_projected_profile_moment_rows import point_vector
from verify_algebraic_model import physical
ROOT=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def main():
 ap=argparse.ArgumentParser();ap.add_argument('--certificate',type=Path,required=True);ap.add_argument('--point',type=Path,required=True);ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();assert not a.output.exists();start=time.monotonic();raw=a.certificate.read_bytes();b=json.loads(gzip.decompress(raw) if str(a.certificate).endswith('.gz') else raw);assert b['status']=='EXACT_NONNEGATIVE_COUNT_EXTENSION_RECOVERED_REQUIRES_REPLAY';assert b['point_sha256']==sha(a.point) and all(sha(ROOT/p)==h for p,h in b['source_hashes'].items());X,Z,_=physical();V,E,U,_,_,domains=reconstruct(X,Z,b['anchors']);assert [list(v) for v in V]==b['variables'];x=list(map(Fraction,b['exact_variables']));assert len(x)==len(V) and all(0<=v<=1 for v in x);rhs=target(point_vector(a.point),b['anchors'])+[Fraction(0)]*(len(E)-7211)
 assert all(x[m]==0 for m,d in enumerate(domains) if d is None)
 for row,wanted in zip(E,rhs):assert sum(v*x[j] for j,v in row.items())==wanted
 for row in U:assert sum(v*x[j] for j,v in row.items())<=0
 out=dict(status='PASS_EXACT_TWO_SIDED_COUNT_EXTENSION_MEMBERSHIP',source_C16_answered=False,physical_full_frame=False,anchors=b['anchors'],bank_sha256=sha(a.certificate),point_sha256=sha(a.point),consumer_sha256=sha(Path(__file__)),dependencies={p:sha(ROOT/p) for p in ['two_sided_count_exact_rows.py','verify_two_sided_anchor_count.py','verify_projected_profile_moment_rows.py','verify_algebraic_model.py','verify_partial_frame.py','audit_pools.py']},source_hashes={p:sha(ROOT/p) for p in ['physical-pool-source.json','pools/xcoords.txt','pools/zcoords.txt']},exact_variables_checked=len(x),exact_equalities_checked=len(E),exact_upper_rows_checked=len(U),positive_pattern_masses=sum(v>0 for v in x[:16]),elapsed_seconds=time.monotonic()-start,scope='The savedpoint has an exact nonnegative extension to shared2X+2Zanchor masks and eligible fullcardinality subsets inbothsectors. Physical zero-pool independence and unanchoredcrosspair constraints are omitted. This proves neither full-basis auxiliary membership nor anysource fullframe orwidth statement.');a.output.write_text(json.dumps(out,indent=2)+'\n');print(out,flush=True)
if __name__=='__main__':main()
