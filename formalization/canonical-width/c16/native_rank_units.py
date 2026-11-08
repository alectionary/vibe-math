"""ctypes adapter for optional exact-rank extension checks (no exclusions trusted)."""
import ctypes


class NativeRankUnits:
    def __init__(self,X,Z,az,path):
        self.n=len(X);self.words=(self.n+63)//64
        u64=ctypes.c_uint64
        self.lo=(u64*len(Z))(*(z&((1<<64)-1) for z in Z))
        self.hi=(u64*len(Z))(*(z>>64 for z in Z))
        self.masks=(u64*(len(Z)*self.words))(*(m>>(64*k)&((1<<64)-1) for m in az for k in range(self.words)))
        self.chosen=(u64*self.words)();self.output=(ctypes.c_int*self.n)()
        self.lib=ctypes.CDLL(str(path));self.fn=self.lib.c16_rank_units
        self.fn.argtypes=[ctypes.POINTER(u64),ctypes.POINTER(u64),ctypes.c_int,ctypes.POINTER(u64),ctypes.c_int,ctypes.c_int,ctypes.POINTER(u64),ctypes.c_int,ctypes.POINTER(ctypes.c_int)]
        self.fn.restype=ctypes.c_int;self.nz=len(Z)
    def extensions(self,bits,dimension):
        for k in range(self.words):self.chosen[k]=bits>>(64*k)&((1<<64)-1)
        count=self.fn(self.lo,self.hi,self.nz,self.masks,self.n,self.words,self.chosen,dimension,self.output)
        assert 0<=count<=self.n
        return list(self.output[:count])
