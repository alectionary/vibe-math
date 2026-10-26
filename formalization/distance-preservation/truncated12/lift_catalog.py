"""Lift cycle certificates to full source equations and emit kernel-checkable data."""
from pathlib import Path
from collections import deque,Counter
import gzip,json,hashlib,argparse,time
import integer_patterns as ip
R=Path(__file__).resolve().parent

def full_rows(vs,edges):
    m=len(edges);n=6+len(vs);rows=[];adj=[[] for _ in vs]
    for idx,(a,b,d) in enumerate(edges):
        row=list(d)+[0]*len(vs);row[6+a]+=1;row[6+b]-=1;rows.append(row)
        adj[a].append((b,d,idx,1));adj[b].append((a,ip.scale(-1,d),idx,-1))
    pot={0:ip.ZERO};paths={0:[0]*m};q=deque([0])
    while q:
        a=q.popleft()
        for b,d,idx,sgn in adj[a]:
            if b not in pot:
                pot[b]=ip.plus(pot[a],d);paths[b]=paths[a].copy();paths[b][idx]+=sgn;q.append(b)
    cycles=[];lifts=[]
    for idx,(a,b,d) in enumerate(edges):
        f=ip.plus(ip.plus(pot[a],d),pot[b],-1)
        if f==ip.ZERO:continue
        c=[x-y for x,y in zip(paths[a],paths[b])];c[idx]+=1
        assert [sum(c[i]*rows[i][j] for i in range(m)) for j in range(n)]==list(f)+[0]*len(vs)
        cycles.append(f);lifts.append(c)
    return rows,cycles,lifts

def zigzag(z):return 2*z if z>=0 else -2*z-1

if __name__=='__main__':
    ap=argparse.ArgumentParser();ap.add_argument('--emit-lean',action='store_true');ap.add_argument('--chunk',type=int,default=500);a=ap.parse_args()
    targets=[];lookup={};reports=[];encoded={};start=time.monotonic()
    for w,gen,filename in [(7,ip.pattern7,'completed-patterns-7.jsonl.gz'),(10,ip.pattern10,'final-patterns-10.jsonl.gz'),(11,ip.pattern11,'completed-patterns-11.jsonl.gz')]:
        codes=[];maxabs=0;maxnonzero=0;counts=Counter()
        with gzip.open(R/filename,'rt') as f:
            for idx,(line,(_,vs,edges)) in enumerate(zip(f,gen())):
                rec=json.loads(line);assert rec['id']==idx;c=rec['certificate']
                key=(c['kind'],tuple(c['locator']))
                if key not in lookup:
                    lookup[key]=len(targets);targets.append({'kind':key[0],'locator':key[1],'forms':c['forms']})
                rows,cycles,lifts=full_rows(vs,edges);lambdas=[]
                for t,(coeff,target) in enumerate(zip(c['coefficients'],c['forms'])):
                    lam=[sum(coeff[r]*lifts[r][i] for r in range(len(coeff))) for i in range(len(edges))]
                    assert [sum(lam[i]*rows[i][j] for i in range(len(edges))) for j in range(6+w)]==target+[0]*w
                    maxabs=max(maxabs,max(map(abs,lam),default=0));maxnonzero=max(maxnonzero,sum(x!=0 for x in lam))
                    lambdas.append(lam+[0]*(18-len(lam)))
                bits=max(1,max(zigzag(z).bit_length() for lam in lambdas for z in lam))
                assert bits<256
                payload=sum(zigzag(z)<<(bits*(18*t+i)) for t,lam in enumerate(lambdas) for i,z in enumerate(lam))
                assert lookup[key]<256
                codes.append(lookup[key]+(bits<<8)+(payload<<16));counts[key[0]]+=1
                if (idx+1)%25000==0:print(json.dumps({'weight':w,'lifted':idx+1,'seconds':time.monotonic()-start}),flush=True)
        encoded[w]=codes
        output=R/f'encoded-catalog-{w}.json.gz'
        with gzip.open(output,'wt') as f:json.dump([str(x) for x in codes],f,separators=(',',':'))
        reports.append({'weight':w,'cases':len(codes),'max_coefficient':maxabs,'max_nonzero_coefficients':maxnonzero,'counts':dict(counts),'encoded_sha256':hashlib.sha256(output.read_bytes()).hexdigest()})
    (R/'catalog-targets.json').write_text(json.dumps(targets,indent=2)+'\n')
    if a.emit_lean:
        import itertools
        def arr(xs):
            if isinstance(xs,int):return str(xs) if xs>=0 else '('+str(xs)+')'
            return '#['+','.join(arr(x) for x in xs)+']'
        table='set_option maxHeartbeats 0\nnamespace KernelCatalog\n'
        table+='def permutations4 : Array (Array Nat) := '+arr(list(itertools.permutations(range(4))))+'\n'
        table+='def permutations3 : Array (Array Nat) := '+arr(list(itertools.permutations(range(3))))+'\n'
        leaves=[]
        for ca,cb in itertools.product(range(4),repeat=2):
            for ls in itertools.product([k for k in range(4) if k not in (ca,cb)],repeat=3):leaves.append([ca,cb,*ls])
        assert len(leaves)==204
        table+='def centerLeaves : Array (Array Nat) := '+arr(leaves)+'\n'
        table+='def targets : Array (Array (Array Int)) := '+arr([t['forms'] for t in targets])+'\nend KernelCatalog\n'
        (R/'CatalogTables.lean').write_text(table)
        for w,codes in encoded.items():
            source='import CatalogChecker\nset_option maxHeartbeats 0\nset_option maxRecDepth 1000000\nnamespace KernelCatalog\n'
            for i,offset in enumerate(range(0,len(codes),a.chunk)):
                block=codes[offset:offset+a.chunk]
                source+=f'def data{w}_{i} : Array Nat := '+arr(block)+'\n'
                source+=f'theorem checked{w}_{i} : checkBlock {w} {offset} data{w}_{i}=true := by decide +kernel\n'
            source+='end KernelCatalog\n';(R/f'Catalog{w}.lean').write_text(source)
    out={'status':'integer_lift_verified','reports':reports,'target_types':len(targets),'encoding':'low8 bits targetID, next8 bits coefficient width b, then18 zigzag coefficients per target form, b bits each; absent rows are zero padded.','seconds':time.monotonic()-start,'scope':'Full source matching equations including all fiber variables; generated Lean sources are not certified until compiled and audited.'}
    (R/'catalog-lift.json').write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(out),flush=True)
