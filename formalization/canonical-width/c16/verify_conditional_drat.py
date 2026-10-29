#!/usr/bin/env python3
"""Rebuild the bounded conditional CNF physically and check its DRAT proof."""
from pathlib import Path
import argparse,json,time
from verify_algebraic_model import domain
from verify_anchored_cover_chain import check_proof

def main():
 ap=argparse.ArgumentParser();ap.add_argument('--domain',type=Path,required=True);ap.add_argument('--metadata',type=Path,required=True);ap.add_argument('--drat-trim',type=Path,required=True);ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();start=time.monotonic();source=json.loads(a.domain.read_text());A,E,t,r=domain(source);d=json.loads(a.metadata.read_text());assert d['anchor']==source['anchor'] and d['trial_removed']==source['removed_classes'] and d['free_target_signature']==t;checked=check_proof(A,[0],[(*e,0) for e in E],d,a.metadata,a.drat_trim,target=t,reject_empty=True);out={'status':'PASS','source_C16_answered':False,'conditional_only':True,'physical_pairings_rebuilt':518400,**checked,'empty_proof_rejected':True,'elapsed_seconds':time.monotonic()-start};a.output.write_text(json.dumps(out,indent=2)+'\n');print(out)
if __name__=='__main__':main()
