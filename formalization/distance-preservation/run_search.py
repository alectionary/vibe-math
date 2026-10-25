from pathlib import Path
import argparse,hashlib,json,subprocess,time
import research as r
def split(x,k):return [(x>>(64*i))&((1<<64)-1) for i in range(k)]
def search(c,bound,limit,tag='X'):
    L=c['L'];hx,hz=r.product(c['E'],L);n=(len(c['E'])**2+len(c['E'][0])**2)*L
    assert r.commutes(hx,hz)
    checks,stabs=(hz,hx) if tag=='X' else (hx,hz)
    cols=r.columns(checks,n)
    inp=' '.join(map(str,[n,len(checks),len(stabs),L,bound,limit]))+'\n'
    inp+='\n'.join(' '.join(map(str,split(x,5))) for x in cols)+'\n'
    inp+='\n'.join(' '.join(map(str,split(x,10))) for x in stabs)+'\n'
    name=c.get('id','source')+'-'+tag+'-'+str(bound)
    (r.ROOT/'inputs').mkdir(exist_ok=True)
    input_path=r.ROOT/'inputs'/f'{name}.txt'
    if input_path.exists() and input_path.read_text()!=inp:
        input_path=r.ROOT/'inputs'/f'{name}-nodes{limit}.txt'
        if input_path.exists():assert input_path.read_text()==inp,'Input filename collision'
    input_path.write_text(inp)
    start=time.monotonic();p=subprocess.run([str(r.ROOT/'support_search')],input=inp,text=True,capture_output=True,check=True)
    res=json.loads(p.stdout);res.update(id=c.get('id','source'),L=L,E=c['E'],side=tag,bound=bound,seconds=time.monotonic()-start,node_limit=limit,
        input_file=str(input_path.relative_to(r.ROOT)),input_sha256=hashlib.sha256(inp.encode()).hexdigest())
    if res['witness']:
        v=sum(1<<j for j in res['witness']);assert all((v&row).bit_count()%2==0 for row in checks);assert r.reduce(v,r.echelon(stabs))
        res['independent_python_syndrome_and_nonmembership']=True
    return res
if __name__=='__main__':
    ap=argparse.ArgumentParser();ap.add_argument('--nodes',type=int,default=1000000);ap.add_argument('--start',type=int,default=0);ap.add_argument('--stop',type=int,default=20);ap.add_argument('--source',action='store_true');a=ap.parse_args()
    if a.source:cs=[{'id':'source-2x3','L':7,'E':[[0,0,0],[0,1,3]],'classical':{'distance':6}}]
    else:cs=json.loads((r.ROOT/'classical-small.json').read_text())[a.start:a.stop]
    with (r.ROOT/'search-results.jsonl').open('a') as f:
        for c in cs:
            out=search(c,c['classical']['distance']-1,a.nodes);f.write(json.dumps(out)+'\n');f.flush();print(json.dumps(out),flush=True)
            if out['witness'] and not a.source:break
