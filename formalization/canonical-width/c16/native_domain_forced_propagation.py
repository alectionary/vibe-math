"""Optional native fixed-point pruning; independently replayable in Python."""
import ctypes


class NativeDomainForcedPropagation:
    def __init__(self,X,Z,allowed,path,dimension=128):
        u64=ctypes.c_uint64;self.lib=ctypes.CDLL(str(path));self.words=(len(X)+63)//64;self.n=len(X)
        arrays=[]
        for V in [X,Z]:arrays.extend([(u64*len(V))(*(v&((1<<64)-1) for v in V)),(u64*len(V))(*(v>>64 for v in V))])
        create=self.lib.c16_domain_propagation_create;create.argtypes=[ctypes.POINTER(u64),ctypes.POINTER(u64),ctypes.c_int,ctypes.POINTER(u64),ctypes.POINTER(u64),ctypes.c_int,ctypes.c_int,ctypes.POINTER(u64),ctypes.c_int];create.restype=ctypes.c_void_p
        assert len(X)==len(Z) and len(allowed)==len(X)
        flat=(u64*(len(X)*self.words))(*(row>>(64*w)&((1<<64)-1) for row in allowed for w in range(self.words)))
        self.ctx=create(arrays[0],arrays[1],len(X),arrays[2],arrays[3],len(Z),dimension,flat,self.words)
        self.fn=self.lib.c16_domain_propagation_check;self.fn.argtypes=[ctypes.c_void_p,ctypes.POINTER(u64),ctypes.c_int,ctypes.POINTER(ctypes.c_int)];self.fn.restype=ctypes.c_int
        self.bits=(u64*self.words)();self.output=(ctypes.c_int*self.n)()
        self.destroy=self.lib.c16_domain_propagation_destroy;self.destroy.argtypes=[ctypes.c_void_p];self.destroy.restype=None
    def exclusion(self,bits):
        for k in range(self.words):self.bits[k]=bits>>(64*k)&((1<<64)-1)
        count=self.fn(self.ctx,self.bits,self.words,self.output)
        assert -1<=count<=self.n
        return list(self.output[:count]) if count>=0 else None
    def close(self):
        if self.ctx:self.destroy(self.ctx);self.ctx=None
