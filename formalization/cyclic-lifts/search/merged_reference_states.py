"""Direct excluded-edge equations, independent of the optimized C++ minima."""
import math
import benchmark_decoding as b
PRIOR=3332431
CAP=50*(1<<20)


def check(syndrome,incoming):
    negative=bool(syndrome)
    for value in incoming:negative^=value<0
    magnitude=min([1000*(1<<20)]+list(map(abs,incoming)))
    out=(800*magnitude+500)//1000
    return max(-CAP,min(CAP,-out if negative else out))


def graph(rows):
    edge=[];ce=[];ve=[[] for _ in range(252)];lookup={}
    for c,row in enumerate(rows):
        ids=[]
        for v in row:
            e=len(edge);edge.append((c,v));ids.append(e);ve[v].append(e);lookup[c,v]=e
        ce.append(ids)
    return dict(edge=edge,ce=ce,ve=ve,lookup=lookup)


def states(rows,error):
    g=graph(rows);target=b.syndrome(list(map(b.rowmask,rows)),b.string_mask(error))
    q=[PRIOR]*len(g['edge']);history=[]
    if not any(target):return history,(0,True,'0'*252)
    for iteration in range(1,101):
        inputs=q.copy();r=[0]*len(q)
        for c,edges in enumerate(g['ce']):
            for e in edges:r[e]=check(target[c],[inputs[f] for f in edges if f!=e])
        post=[PRIOR+sum(r[e] for e in edges) for edges in g['ve']]
        estimate=''.join('1' if value<0 else '0' for value in post)
        history.append(dict(q=inputs,r=r,estimate=estimate,posterior=post))
        if b.syndrome(list(map(b.rowmask,rows)),b.string_mask(estimate))==target:return history,(iteration,True,estimate)
        q=[max(-CAP,min(CAP,post[v]-r[e])) for e,(_,v) in enumerate(g['edge'])]
    return history,(100,False,estimate)


def local_data(original,merged,pair,error,state,from_original):
    og,mg=graph(original),graph(merged);a,z=pair
    target=b.syndrome(list(map(b.rowmask,original)),b.string_mask(error));out=[]
    def edge(c,v):
        return og['lookup'][c,v] if from_original else mg['lookup'][a if c==z else c-1 if c>z else c,v]
    for c,other in [(a,z),(z,a)]:
        for v in original[c]:
            xs=[state['q'][edge(c,w)] for w in original[c] if w!=v]
            ys=[state['q'][edge(other,w)] for w in original[other]]
            others=[state['r'][edge(d,v)] for d in range(126) if d!=c and v in original[d]]
            old=check(target[c],xs);new=check(target[c]^target[other],xs+ys)
            effective=bool(target[other])
            for q in ys:effective^=q<0
            out.append(dict(variable=v,own_check=c,own_syndrome=target[c],other_syndrome=target[other],effective_other=int(effective),
                            xs=xs,ys=ys,other_variable_messages=others,split_message=old,merged_message=new,
                            split_posterior=PRIOR+sum(others)+old,merged_posterior=PRIOR+sum(others)+new))
    return out


def local_decisions(state,locals):
    old=list(state['estimate']);new=list(state['estimate'])
    for row in locals:
        old[row['variable']]='1' if row['split_posterior']<0 else '0'
        new[row['variable']]='1' if row['merged_posterior']<0 else '0'
    return ''.join(old),''.join(new)
