import importlib.abc, sys
BLOCKED={"numpy","scipy","cvxpy","scs","ortools","flint","sympy","pynauty","networkx","igraph","psutil","pysat","pycryptosat"}
class ExactOnly(importlib.abc.MetaPathFinder):
    def find_spec(self, fullname, path=None, target=None):
        if fullname.split(".")[0] in BLOCKED:
            raise ImportError("Independent replay forbids discovery dependency: "+fullname)
sys.meta_path.insert(0, ExactOnly())
