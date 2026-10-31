"""Read terminal A0 files only; never launch, extend or diagnose chains."""
import csv
import hashlib
import json
from pathlib import Path
import subprocess
import time

ROOT=Path(__file__).resolve().parents[1]
NS=ROOT/'production/score-a0-v1'
def digest(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def main():
 start=time.monotonic()
 outcome=json.loads((NS/'chains/outcomes.json').read_text())
 assert outcome['requested']==4 and len(outcome['outcomes'])==4
 assert sorted(r['id'] for r in outcome['outcomes'])==[1,2,3,4]
 assert all(r['state'] in ('completed','failed','cancelled','not_launched') for r in outcome['outcomes']), 'Pilot still running'
 script='''args<-commandArgs(TRUE);d<-args[1];out<-args[2]
 rows<-lapply(1:4,function(i){
  p<-file.path(d,'prepared',paste0('chain-',i));ap<-file.path(p,'adaptation.rds');cp<-file.path(p,'checkpoint.rds');rp<-file.path(p,'result.rds')
  a<-if(file.exists(ap))readRDS(ap)else list(adaptation_complete=FALSE,elapsed_seconds=NA_real_)
  c<-if(file.exists(cp))readRDS(cp)else list(retained=0L,completed_chunks=0L,elapsed_seconds=NA_real_)
  r<-if(file.exists(rp))readRDS(rp)else list(status='no_final_result',retained=0L)
  part<-file.path(p,'partial-draws.rds');n<-if(file.exists(part))nrow(readRDS(part))else 0L
  data.frame(chain=i,adapted=a$adaptation_complete,adaptation_elapsed=a$elapsed_seconds,retained_checkpoint=c$retained,checkpoint_chunks=c$completed_chunks,partial_draw_rows=n,checkpoint_rows_consistent=n==c$retained,checkpoint_elapsed=c$elapsed_seconds,final_status=r$status,final_retained=r$retained)
 });write.csv(do.call(rbind,rows),out,row.names=FALSE)
'''
 out=NS/'terminal-checkpoints.csv'
 if out.exists():raise RuntimeError('Refuse overwrite of terminal audit')
 proc=subprocess.run(['/workspace/slot3-runtime/bin/Rscript','-e',script,'--args',str(NS),str(out)],cwd=ROOT,capture_output=True,text=True,timeout=30)
 if proc.returncode:raise RuntimeError(proc.stderr)
 rows=list(csv.DictReader(out.open()))
 chain_seconds=sum(r.get('elapsed_seconds',0) for r in outcome['outcomes'])
 prep=json.loads((NS/'preparation/outcomes.json').read_text())
 dispatch=json.loads((NS/'dispatch.json').read_text())
 diagpath=NS/'diagnostic/outcomes.json'
 diag=json.loads(diagpath.read_text()) if diagpath.exists() else None
 all_seconds=dispatch['validation_seconds']+prep['summed_process_seconds']+chain_seconds+(diag['summed_process_seconds'] if diag else 0)
 benchmark=4927.558111619001
 record={'status':'terminal','requested_chains':4,'completed_fixed_28000_chains':sum(r['final_status']=='completed' and int(r['final_retained'])==28000 for r in rows),
 'checkpoints':rows,'chain_outcomes':outcome,'summed_chain_seconds':chain_seconds,'summed_all_phase_seconds':all_seconds,
 'elapsed_seconds':max(outcome['elapsed_seconds'],diag['elapsed_seconds'] if diag else 0),'limits':dispatch['manifest']['caps'],
 'historical_item_chain_seconds':benchmark,'raw_consumed_time_ratio_score_over_item':chain_seconds/benchmark,
 'comparison_limit':'Consumed time ratio is not equal-work speedup if fixed draw target incomplete; historical runtime and distinct starts/RNG confound causal timing claims. Same JAGS backend, not independent-engine validation.',
 'diagnostic_stage_ran':diag is not None,'diagnostic_stage_complete':bool(diag and all(r['state']=='completed' for r in diag['outcomes'])),
 'fixed_gate_rule':'No full joint gate or five-global posterior comparison eligible unless all four fixed28000 chains complete; do not reuse partial chains as successful replication.',
 'source_count_targets':'Pending; this one-dataset implementation pilot does not complete any100/250-dataset recovery/power aggregate.',
 'new_datasets':0,'automatic_retries':0,'evidence':{str(p.relative_to(ROOT)):digest(p) for p in NS.rglob('*') if p.is_file()},
 'audit_elapsed_seconds':time.monotonic()-start}
 target=ROOT/'provenance/score-a0-terminal-outcome.json'
 if target.exists():raise RuntimeError('Refuse overwrite terminal outcome')
 target.write_text(json.dumps(record,indent=2)+'\n')
 print(json.dumps({k:record[k] for k in ['status','completed_fixed_28000_chains','summed_chain_seconds','summed_all_phase_seconds','elapsed_seconds','diagnostic_stage_ran']}))
if __name__=='__main__':main()
