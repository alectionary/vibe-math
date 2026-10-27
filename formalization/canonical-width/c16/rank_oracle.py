"""Certified necessary rank clauses for a full 128-pair frame.

Every emitted clause has an independently checkable F_2 witness. The oracle
does not use heuristic exclusions. With a partial selected X set T, every Z
member of a completing frame must pair with at most one member of T.
"""
import json
import hashlib
from array import array
from pysat.engines import Propagator


def basis(rows):
    piv={}
    for v in rows:
        while v:
            p=v.bit_length()-1
            if p not in piv:piv[p]=v;break
            v^=piv[p]
    return piv


def annihilator(piv):
    free=next(p for p in range(128) if p not in piv)
    value=1<<free
    for p in sorted(piv):
        if (piv[p]&value).bit_count()%2:value^=1<<p
    assert value and all((v&value).bit_count()%2==0 for v in piv.values())
    return value


def rotate_value(v,h):
    if not h:return v
    out=0
    for b in range(8):
        block=(v>>(16*b))&65535
        out|=(((block<<h)|(block>>(16-h)))&65535)<<(16*b)
    return out


def rotate_row(row,h,X,Z,private_literals=None):
    kind=row['kind'];out={'kind':kind}
    if 'indices' in row:out['indices']=sorted((i//16)*16+(i%16+h)%16 for i in row['indices'])
    if 'annihilator' in row:out['annihilator']=hex(rotate_value(int(row['annihilator'],16),h))
    if kind in ['x_circuit','z_eligible','z_zero']:out['clause']=[-i-1 for i in out['indices']]
    elif kind=='x_available':
        w=int(out['annihilator'],16);out['clause']=[i+1 for i,x in enumerate(X) if (x&w).bit_count()%2]
    elif kind=='z_private':
        assert private_literals is not None
        w=int(out['annihilator'],16);out['clause']=[private_literals[j] for j,z in enumerate(Z) if (z&w).bit_count()%2]
    else:raise ValueError(kind)
    return out


class RankOracle(Propagator):
    def __init__(self,X,Z,path,private_literals=None,cyclic=False,basis_propagation=False):
        super().__init__();self.X=X;self.Z=Z;self.n=len(X)
        self.az=[sum(((x&z).bit_count()%2)<<i for i,x in enumerate(X)) for z in Z]
        self.values=[0]*(self.n+1);self.fixed=set();self.trail=[];self.limits=[]
        self.dirty=True;self.last_true=None;self.last_available=None;self.pending=[]
        self.private_literals=private_literals
        self.basis_propagation=basis_propagation
        self.cyclic=cyclic;self.symmetry_bases=0;self.seen=set()
        if cyclic:
            assert len(X)%16==len(Z)%16==0
            assert all(rotate_value(v,h)==vs[(i//16)*16+(i%16+h)%16]
                       for vs in [X,Z] for i,v in enumerate(vs) for h in range(16))
        self.log=path.open('w');self.stats={'checks':0,'clauses':0,'x_circuit':0,'z_eligible':0,'x_available':0,'z_private':0,'z_zero':0}
    def on_assignment(self,lit,fixed=False):
        var=abs(lit)
        if var>self.n:return
        if fixed:self.fixed.add(var)
        if self.values[var]==lit:return
        self.values[var]=lit;self.trail.append(lit);self.dirty=True
    def on_new_level(self):self.limits.append(len(self.trail))
    def on_backtrack(self,to):
        while len(self.limits)>to:
            while len(self.trail)>self.limits[-1]:
                lit=self.trail.pop()
                if abs(lit) not in self.fixed:self.values[abs(lit)]=0
            self.limits.pop()
        self.dirty=True
    def emit(self,row):
        cyclic=self.cyclic and self.symmetry_bases<5000;generated=0
        for h in range(16 if cyclic else 1):
            item=rotate_row(row,h,self.X,self.Z,self.private_literals) if cyclic else row
            clause=item['clause'];key=hashlib.sha256(array('i',sorted(clause)).tobytes()).digest()
            if key in self.seen:continue
            self.seen.add(key);self.pending.append(clause);generated+=1
        if not generated:return
        self.stats['clauses']+=generated;self.stats[row['kind']]+=generated
        if cyclic:self.symmetry_bases+=1;row=dict(row,cyclic=True)
        self.log.write(json.dumps(row)+'\n');self.log.flush()
    def check(self):
        if not self.dirty or self.pending:return
        self.dirty=False;self.stats['checks']+=1
        chosen=[i for i in range(self.n) if self.values[i+1]>0]
        truebits=sum(1<<i for i in chosen)
        if truebits!=self.last_true:
            self.last_true=truebits
            piv={}
            for i in chosen:
                v=self.X[i];comb=1<<i
                while v:
                    p=v.bit_length()-1
                    if p not in piv:piv[p]=(v,comb);break
                    v^=piv[p][0];comb^=piv[p][1]
                if not v:
                    ids=[j for j in chosen if comb>>j&1];assert ids
                    value=0
                    for j in ids:value^=self.X[j]
                    assert value==0
                    self.emit({'kind':'x_circuit','indices':ids,'clause':[-j-1 for j in ids]});return
            if len(chosen)>=8:
                zeros=[z for z,mask in zip(self.Z,self.az) if (mask&truebits)==0]
                zp=basis(zeros)
                if len(zp)<128-len(chosen):
                    # Ann(zeros) properly contains span(T). Find a witness in
                    # that difference. Each nullspace coordinate gives a
                    # canonical annihilator, so one must be outside span(T).
                    tp=basis(self.X[i] for i in chosen);w=None
                    for free in range(128):
                        if free in zp:continue
                        v=1<<free
                        for p in sorted(zp):
                            if (zp[p]&v).bit_count()%2:v^=1<<p
                        rem=v
                        while rem:
                            p=rem.bit_length()-1
                            if p not in tp:break
                            rem^=tp[p]
                        if rem:w=v;break
                    assert w is not None and all((z&w).bit_count()%2==0 for z in zeros)
                    js=[j for j,z in enumerate(self.Z) if (z&w).bit_count()%2]
                    degrees={j:(self.az[j]&truebits).bit_count() for j in js};core=chosen.copy()
                    for i in reversed(chosen):
                        affected=[j for j in js if (self.az[j]>>i)&1]
                        if all(degrees[j]>=2 for j in affected):
                            core.remove(i)
                            for j in affected:degrees[j]-=1
                    self.emit({'kind':'z_zero','indices':core,'annihilator':hex(w),
                               'clause':[-i-1 for i in core]});return
                eligible=[z for z,mask in zip(self.Z,self.az) if (mask&truebits).bit_count()<=1]
                bp=basis(eligible)
                if len(bp)<128:
                    if self.private_literals is not None:
                        w=annihilator(bp)
                        js=[j for j,z in enumerate(self.Z) if (z&w).bit_count()%2]
                        assert js and all(self.private_literals[j] for j in js)
                        self.emit({'kind':'z_private','annihilator':hex(w),
                                   'clause':[self.private_literals[j] for j in js]});return
                    # Greedily shorten the core, retaining a direct hyperplane
                    # certificate rather than trusting the rank implementation.
                    core=chosen.copy()
                    for i in chosen[:30]:
                        test=truebits^(1<<i)
                        ep=[z for z,mask in zip(self.Z,self.az) if (mask&test).bit_count()<=1]
                        pp=basis(ep)
                        if len(pp)<128:core.remove(i);truebits=test;eligible=ep;bp=pp
                    w=annihilator(bp)
                    assert all((z&w).bit_count()%2==0 for z in eligible)
                    self.emit({'kind':'z_eligible','indices':core,'annihilator':hex(w),
                               'clause':[-i-1 for i in core]});return
        if self.basis_propagation and chosen:
            # Any unselected vector in span(T) would close a circuit. Emit a
            # unit clause with its exact XOR certificate, leaving CDCL to
            # perform propagation and record the reason.
            tp={}
            for i in chosen:
                v=self.X[i];comb=1<<i
                while v:
                    p=v.bit_length()-1
                    if p not in tp:tp[p]=(v,comb);break
                    v^=tp[p][0];comb^=tp[p][1]
            for i in range(self.n):
                if self.values[i+1]:continue
                v=self.X[i];comb=1<<i
                while v:
                    p=v.bit_length()-1
                    if p not in tp:break
                    v^=tp[p][0];comb^=tp[p][1]
                if not v:
                    ids=[j for j in range(self.n) if comb>>j&1]
                    self.emit({'kind':'x_circuit','indices':ids,'clause':[-j-1 for j in ids]})
            if self.pending:return
        available=[i for i in range(self.n) if self.values[i+1]>=0]
        bits=sum(1<<i for i in available)
        if bits!=self.last_available and (self.basis_propagation or self.last_available is None or len(available)<400):
            self.last_available=bits;bp=basis(self.X[i] for i in available)
            if len(bp)<128:
                w=annihilator(bp);ids=[i for i,x in enumerate(self.X) if (x&w).bit_count()%2]
                assert all(self.values[i+1]<0 for i in ids)
                self.emit({'kind':'x_available','annihilator':hex(w),'clause':[i+1 for i in ids]})
            elif self.basis_propagation:
                # Track which independent columns participate in a dependence.
                # A basis column never used by a dependent column is a coloop,
                # and every spanning subset must contain it.
                rows={};original=[];used=0
                for i in available:
                    v=self.X[i];comb=0
                    while v:
                        p=v.bit_length()-1
                        if p not in rows:break
                        v^=rows[p][0];comb^=rows[p][1]
                    if v:
                        k=len(original);original.append(i)
                        rows[v.bit_length()-1]=(v,comb^(1<<k))
                    else:used|=comb
                assert len(original)==128
                for k,i in enumerate(original):
                    if used>>k&1 or self.values[i+1]:continue
                    w=0
                    for p in sorted(rows):
                        v,comb=rows[p]
                        if ((v&w).bit_count()%2)!=((comb>>k)&1):w^=1<<p
                    ids=[j for j,x in enumerate(self.X) if (x&w).bit_count()%2]
                    assert [j for j in ids if self.values[j+1]>=0]==[i]
                    self.emit({'kind':'x_available','annihilator':hex(w),'clause':[j+1 for j in ids]})
    def propagate(self):self.check();return []
    def provide_reason(self,lit):raise RuntimeError('This oracle adds clauses, not propagated literals.')
    def decide(self):return 0
    def has_clause(self):self.check();return bool(self.pending)
    def add_clause(self):return self.pending.pop(0)
    def check_model(self,model):
        saved=self.values.copy()
        try:
            for lit in model:
                if abs(lit)<=self.n:self.values[abs(lit)]=lit
            self.dirty=True;self.last_true=None;self.last_available=None;self.check()
            return not self.pending
        finally:
            self.values=saved;self.dirty=True;self.last_true=None;self.last_available=None
    def close(self):self.log.close()


def verify_log(X,Z,path,private_literals=None):
    az=[sum(((x&z).bit_count()%2)<<i for i,x in enumerate(X)) for z in Z]
    total=0
    rows=[]
    for line in path.read_text().splitlines():
        row=json.loads(line)
        rows.extend(rotate_row(row,h,X,Z,private_literals) for h in range(16)) if row.get('cyclic') else rows.append(row)
    for row in rows:
        kind=row['kind'];clause=row['clause']
        if kind=='x_circuit':
            value=0
            for i in row['indices']:value^=X[i]
            assert value==0 and clause==[-i-1 for i in row['indices']]
        elif kind=='z_eligible':
            bits=sum(1<<i for i in row['indices']);w=int(row['annihilator'],16);assert w
            assert clause==[-i-1 for i in row['indices']]
            assert all((z&w).bit_count()%2==0 for z,mask in zip(Z,az) if (mask&bits).bit_count()<=1)
        elif kind=='x_available':
            w=int(row['annihilator'],16);assert w
            assert clause==[i+1 for i,x in enumerate(X) if (x&w).bit_count()%2]
        elif kind=='z_private':
            w=int(row['annihilator'],16);assert w and private_literals is not None
            js=[j for j,z in enumerate(Z) if (z&w).bit_count()%2]
            assert js and clause==[private_literals[j] for j in js] and 0 not in clause
        elif kind=='z_zero':
            ids=row['indices'];bits=sum(1<<i for i in ids);w=int(row['annihilator'],16);assert w
            tp=basis(X[i] for i in ids);assert len(tp)==len(ids)
            rem=w
            while rem:
                p=rem.bit_length()-1
                if p not in tp:break
                rem^=tp[p]
            assert rem and clause==[-i-1 for i in ids]
            assert all((z&w).bit_count()%2==0 for z,mask in zip(Z,az) if (mask&bits)==0)
        else:raise ValueError(kind)
        total+=1
    return total


def seed_clauses(X,Z,paths,snapshot,private_literals=None):
    rows=[]
    for path in paths:
        for line in path.read_text().splitlines(keepends=True):
            if not line.endswith('\n'):continue
            row=json.loads(line)
            if row['kind']=='z_private':
                if private_literals is None:continue
                w=int(row['annihilator'],16)
                lits=[private_literals[j] for j,z in enumerate(Z) if (z&w).bit_count()%2]
                if 0 in lits:continue
                row=dict(row,clause=lits)
            rows.append(row)
    snapshot.write_text(''.join(json.dumps(row)+'\n' for row in rows))
    verify_log(X,Z,snapshot,private_literals)
    clauses=[];seen=set()
    for row in rows:
        for h in range(16 if row.get('cyclic') else 1):
            item=rotate_row(row,h,X,Z,private_literals) if row.get('cyclic') else row
            key=hashlib.sha256(array('i',sorted(item['clause'])).tobytes()).digest()
            if key in seen:continue
            seen.add(key);clauses.append(item['clause'])
    return clauses
