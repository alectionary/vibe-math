#!/usr/bin/env python3
"""Full-frame theory clauses; positive clauses must never enter projection models."""
import collections,ctypes,json,time
from functools import lru_cache
from pysat.engines import Propagator

def in_span(value,rows):
    piv={}
    for row in rows:
        while row:
            low=row&-row
            if low not in piv:piv[low]=row;break
            row^=piv[low]
    while value:
        low=value&-value
        if low not in piv:return False
        value^=piv[low]
    return True

class Certificate(ctypes.Structure):
    _fields_=[('lo',ctypes.c_uint64),('hi',ctypes.c_uint64),('kind',ctypes.c_int),('side',ctypes.c_int),('count',ctypes.c_int),('omitted',ctypes.c_int),('ids',ctypes.c_int*129)]

class NativeConditionalSpan:
    def __init__(self,X,Z,path,dimension=128):
        self.X=X;self.Z=Z;self.dimension=dimension;self.total=len(X)+len(Z);self.lib=ctypes.CDLL(str(path));u64=ctypes.c_uint64;arrays=[]
        for V in [X,Z]:arrays.extend([(u64*len(V))(*(v&((1<<64)-1) for v in V)),(u64*len(V))(*(v>>64 for v in V))])
        create=self.lib.c16_conditional_span_create;create.argtypes=[ctypes.POINTER(u64),ctypes.POINTER(u64),ctypes.c_int,ctypes.POINTER(u64),ctypes.POINTER(u64),ctypes.c_int,ctypes.c_int];create.restype=ctypes.c_void_p;self.ctx=create(arrays[0],arrays[1],len(X),arrays[2],arrays[3],len(Z),dimension)
        self.fn=self.lib.c16_conditional_span_check;self.fn.argtypes=[ctypes.c_void_p,ctypes.POINTER(ctypes.c_int8),ctypes.POINTER(Certificate),ctypes.c_int];self.fn.restype=ctypes.c_int;self.values=(ctypes.c_int8*self.total)();self.out=(Certificate*4)();self.destroy=self.lib.c16_conditional_span_destroy;self.destroy.argtypes=[ctypes.c_void_p];self.destroy.restype=None
        self.rows=[sum(((x&z).bit_count()%2)<<j for j,z in enumerate(Z)) for x in X];self.cols=[sum(((x&z).bit_count()%2)<<i for i,x in enumerate(X)) for z in Z]
    def owner(self,side,i):return i+1+(len(self.X) if side else 0)
    @staticmethod
    def remainder(value,piv):
        out=0
        while value:
            low=value&-value
            if low in piv:value^=piv[low]
            else:out|=low;value^=low
        return out
    @lru_cache(maxsize=256)
    def quotient_groups(self,side,ids):
        other=(self.Z,self.X)[side];piv={}
        for i in ids:
            v=other[i]
            while v:
                low=v&-v
                if low not in piv:piv[low]=v;break
                v^=piv[low]
        groups={}
        for j,z in enumerate(other):groups.setdefault(self.remainder(z,piv),[]).append(j)
        return piv,groups
    def check(self,values):
        assert len(values)==self.total
        for i,v in enumerate(values):self.values[i]=v
        n=self.fn(self.ctx,self.values,self.out,4);assert 0<=n<=4,n;records=[]
        for raw in self.out[:n]:
            side=raw.side;assert side in (0,1) and 0<=raw.count<=129;ids=list(raw.ids[:raw.count]);assert len(ids)==len(set(ids));V=(self.X,self.Z)[side];other=(self.Z,self.X)[side];pairings=(self.rows,self.cols)[side]
            if raw.kind==1:
                assert ids and all(0<=i<len(V) for i in ids);v=0
                for i in ids:v^=V[i]
                assert v==0;clause=[-self.owner(side,i) for i in ids];record={'kind':'basis_circuit','side':side,'indices':ids,'clause':clause}
            else:
                assert raw.kind in (2,3) and all(0<=i<len(other) for i in ids);w=raw.lo|(raw.hi<<64);assert 0<w<1<<self.dimension and not in_span(w,[other[i] for i in ids]);mask=sum(1<<i for i in ids);support=[i for i,v in enumerate(V) if not pairings[i]&mask and (v&w).bit_count()%2]
                if raw.kind==2:
                    clause=[-self.owner(1-side,j) for j in ids]+[self.owner(side,i) for i in support];record={'kind':'conditional_span','side':side,'mandatory_opposite':ids,'annihilator_hex':hex(w),'positive_support':support,'clause':clause}
                else:
                    omitted=raw.omitted;assert omitted in support;piv,groups=self.quotient_groups(side,tuple(ids));partners=groups.get(self.remainder(w,piv),[]);clause=[-self.owner(1-side,j) for j in ids]+[self.owner(side,i) for i in support if i!=omitted]+[self.owner(1-side,j) for j in partners];record={'kind':'conditional_private_partner','side':side,'mandatory_opposite':ids,'annihilator_hex':hex(w),'positive_support':support,'omitted_positive_index':omitted,'possible_partners':partners,'clause':clause}
            assert not any(values[abs(lit)-1]==(1 if lit>0 else -1) for lit in clause),'native certificate is already satisfied'
            assert sum(values[abs(lit)-1]==0 for lit in clause)<=1,'native certificate is not unit or conflicting'
            records.append(record)
        return records
    def close(self):
        if self.ctx:self.destroy(self.ctx);self.ctx=None
        self.quotient_groups.cache_clear()

class ConditionalSpanOracle(Propagator):
    def __init__(self,X,Z,library,path,dimension=128,progress=None,limit=20000):
        super().__init__();self.native=NativeConditionalSpan(X,Z,library,dimension);self.values=[0]*(len(X)+len(Z));self.trail=[];self.limits=[];self.fixed=set();self.pending=collections.deque();self.seen=set();self.dirty=True;self.log=path.open('w');self.progress=progress;self.limit=limit;self.last_progress=0;self.stats={'checks':0,'clauses':0,'conflicts':0,'units':0,'native_and_certificate_seconds':0.0,'cut_limit_reached':False}
    def on_assignment(self,lit,fixed=False):
        var=abs(lit)
        if var>len(self.values):return
        if fixed:self.fixed.add(var)
        value=1 if lit>0 else -1
        if self.values[var-1]==value:return
        self.values[var-1]=value;self.trail.append(lit);self.dirty=True
    def on_new_level(self):self.limits.append(len(self.trail))
    def on_backtrack(self,to):
        while len(self.limits)>to:
            while len(self.trail)>self.limits[-1]:
                lit=self.trail.pop()
                if abs(lit) not in self.fixed:self.values[abs(lit)-1]=0
            self.limits.pop()
        self.dirty=True
    def check(self):
        if not self.dirty or self.pending or self.stats['cut_limit_reached']:return
        self.dirty=False;self.stats['checks']+=1;start=time.monotonic();records=self.native.check(self.values);self.stats['native_and_certificate_seconds']+=time.monotonic()-start
        for record in records:
            clause=record['clause'];key=tuple(sorted(clause))
            if key in self.seen:continue
            self.seen.add(key);self.pending.append(clause);self.log.write(json.dumps(record,separators=(',',':'))+'\n');self.log.flush();self.stats['clauses']+=1
            if any(self.values[abs(v)-1]==0 for v in clause):self.stats['units']+=1
            else:self.stats['conflicts']+=1
            if self.stats['clauses']>=self.limit:self.stats['cut_limit_reached']=True;break
        now=time.monotonic()
        if self.progress and now-self.last_progress>=5:self.progress(self.stats.copy());self.last_progress=now
    def propagate(self):self.check();return []
    def has_clause(self):self.check();return bool(self.pending)
    def add_clause(self):return self.pending.popleft()
    def provide_reason(self,lit):raise RuntimeError('Certified clauses, not direct propagated literals.')
    def decide(self):return 0
    def check_model(self,model):
        saved=self.values.copy()
        try:
            for lit in model:
                if abs(lit)<=len(self.values):self.values[abs(lit)-1]=1 if lit>0 else -1
            self.dirty=True;self.check();return not self.pending
        finally:self.values=saved;self.dirty=True
    def close(self):self.log.close();self.native.close()
