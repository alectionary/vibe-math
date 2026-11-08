#!/usr/bin/env python3
"""Exact proposal evaluation/deduplication; requires independent consumer."""
from pathlib import Path
import argparse,json,hashlib
from fractions import Fraction
from physical_integer_form_rows import compile_row
from verify_projected_profile_moment_rows import point_vector
ROOT=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def main():
 ap=argparse.ArgumentParser();ap.add_argument('--candidates',type=Path,required=True);ap.add_argument('--point',type=Path,required=True);ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();assert not a.output.exists();owner=point_vector(a.point);raw=json.loads(a.candidates.read_text());seen=set();cuts=[];rejected=[]
 for source_index,cut in enumerate(raw['cuts']):
  row,rhs=compile_row(cut);key=(tuple(row.items()),rhs);gap=sum(v*owner[j] for j,v in row.items())-rhs
  if gap<=0:rejected.append({'candidate':source_index,'exact_gap':str(gap)});continue
  if key in seen:continue
  seen.add(key);cuts.append({k:cut[k] for k in ['events','weights','constant']}|{'exact_violation':str(gap),'candidate_index':source_index})
 sources=['accept_physical_integer_forms.py','physical_integer_form_rows.py','verify_projected_profile_moment_rows.py','physical-pool-source.json','pools/xcoords.txt','pools/zcoords.txt','moment-resumption-results/symmetry-bridge-independent.json']
 out={'status':'EXACT_PHYSICAL_INTEGER_FORM_CANDIDATE','source_C16_answered':False,'point_sha256':sha(a.point),'candidate_sha256':sha(a.candidates),'source_hashes':{p:sha(ROOT/p) for p in sources},'cuts':cuts,'input_cuts':len(raw['cuts']),'nonpositive_rejected':rejected,'scope':'For everyintegerL, L(L−1)/2≥0. Exactpointseparation andindependentsymmetrytranslation stillneedconsumer.'};a.output.write_text(json.dumps(out,indent=2)+'\n');print({'input':len(raw['cuts']),'unique_positive':len(cuts),'nonpositive':len(rejected)},flush=True)
if __name__=='__main__':main()
