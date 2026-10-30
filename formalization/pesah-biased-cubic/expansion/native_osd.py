"""ctypes wrapper: NumPy sorting unchanged, native forward GF(2) elimination."""
import ctypes,pathlib,sys
import numpy as np
assert sys.byteorder=='little','Packed native implementation currently requires little endian'
lib=ctypes.CDLL(str(pathlib.Path(__file__).with_name('osd_native.so')))
P=ctypes.POINTER(ctypes.c_uint64);lib.solve_osd.argtypes=[P,ctypes.c_int,ctypes.c_int,P];lib.solve_osd.restype=ctypes.c_int

def osd(H,s,probabilities,sort_kind='quicksort'):
 order=np.argsort(-probabilities,kind=sort_kind);m,n=H.shape;words=(n+1+63)//64
 a=np.zeros((m,words),dtype=np.uint64);bits=np.packbits(H[:,order],axis=1,bitorder='little');a.view(np.uint8)[:,:bits.shape[1]]=bits;a[:,n//64]|=np.asarray(s,dtype=np.uint64)<<np.uint64(n%64)
 answer=np.zeros(words,np.uint64);rank=lib.solve_osd(a.ctypes.data_as(P),m,n,answer.ctypes.data_as(P));assert rank>=0,'Inconsistent syndrome'
 sorted_answer=np.unpackbits(answer.view(np.uint8),bitorder='little')[:n];out=np.zeros(n,np.uint8);out[order]=sorted_answer;return out
