"""Direct-owner matching and optional full-basis theory, with checked clauses."""
import collections,ctypes,json,time
from conditional_span_oracle import ConditionalSpanOracle

class OwnerFrameOracle(ConditionalSpanOracle):
    def __init__(self,*args,span_enabled=True,**kwargs):
        super().__init__(*args,**kwargs);self.span_enabled=span_enabled
        self.match=self.native.lib.c16_owner_matching_check
        self.match.argtypes=[ctypes.c_void_p,ctypes.POINTER(ctypes.c_int8),ctypes.POINTER(ctypes.c_int),ctypes.c_int]
        self.match.restype=ctypes.c_int;self.match_out=(ctypes.c_int*256)()
        self.stats.update(matching_clauses=0,span_clauses=0,cap_reported=False)
    def check(self):
        if not self.dirty or self.pending:return
        self.dirty=False;self.stats['checks']+=1;start=time.monotonic()
        for i,v in enumerate(self.values):self.native.values[i]=v
        count=self.match(self.native.ctx,self.native.values,self.match_out,64)
        assert 0<=count<=64;records=[]
        for k in range(count):
            side,i,j,h=list(self.match_out[4*k:4*k+4]);assert side in (0,1) and j!=h
            rows=(self.native.rows,self.native.cols)[side]
            assert 0<=i<len(rows) and rows[i]>>j&1 and rows[i]>>h&1
            clause=[-self.native.owner(side,i),-self.native.owner(1-side,j),-self.native.owner(1-side,h)]
            assert not any(self.values[abs(v)-1]<0 for v in clause)
            assert sum(self.values[abs(v)-1]==0 for v in clause)<=1
            records.append({'kind':'conditional_matching_at_most_one','side':side,'owner_index':i,'opposite_indices':[j,h],'clause':clause})
        # Matching is part of the exact model and can never be disabled at a cap.
        if not records and self.span_enabled and not self.stats['cut_limit_reached']:
            records=self.native.check(self.values)
        self.stats['native_and_certificate_seconds']+=time.monotonic()-start
        for record in records:
            clause=record['clause'];key=tuple(sorted(clause))
            if key in self.seen:continue
            self.seen.add(key);self.pending.append(clause)
            self.log.write(json.dumps(record,separators=(',',':'))+'\n');self.log.flush()
            self.stats['clauses']+=1
            matching=record['kind']=='conditional_matching_at_most_one'
            self.stats['matching_clauses' if matching else 'span_clauses']+=1
            if any(self.values[abs(v)-1]==0 for v in clause):self.stats['units']+=1
            else:self.stats['conflicts']+=1
            if self.stats['span_clauses']>=self.limit:self.stats['cut_limit_reached']=True
        now=time.monotonic()
        if self.progress and (now-self.last_progress>=5 or self.stats['cut_limit_reached'] and not self.stats['cap_reported']):
            self.stats['cap_reported']|=self.stats['cut_limit_reached'];self.progress(self.stats.copy());self.last_progress=now
