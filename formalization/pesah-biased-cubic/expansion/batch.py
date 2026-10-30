"""Two bounded subprocess workers, distinct checkpoint files, failure reporting."""
import concurrent.futures,json,os,pathlib,subprocess,sys,time
R=pathlib.Path(__file__).resolve().parent;plan=json.loads((R/'families-plan.json').read_text());start=time.time()
def run(name):
 config=R/name;output=R/name.replace('-config.json','.json');log=R/name.replace('-config.json','.log')
 with log.open('a') as f:
  proc=subprocess.run([sys.executable,str(R/'run.py'),str(config),str(output)],env=dict(os.environ,OPENBLAS_NUM_THREADS='1',OMP_NUM_THREADS='1'),stdout=f,stderr=subprocess.STDOUT)
 return dict(config=name,exit_code=proc.returncode,complete=json.loads(output.read_text()).get('complete',False) if output.exists() else False)
rows=[]
with concurrent.futures.ThreadPoolExecutor(max_workers=2) as pool:
 futures=[pool.submit(run,n) for n in plan['configs']]
 for future in concurrent.futures.as_completed(futures):
  row=future.result();rows.append(row);(R/'families-batch-status.json').write_text(json.dumps(dict(rows=rows,elapsed_seconds=time.time()-start,complete=len(rows)==len(futures)),indent=2)+'\n');print(row,flush=True)
