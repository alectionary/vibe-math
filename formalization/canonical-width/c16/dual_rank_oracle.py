"""Two rank oracles: selected X variables and selected private-Z literals."""
from pysat.engines import Propagator
from rank_oracle import RankOracle


class DualRankOracle(Propagator):
    def __init__(self,X,Z,path,private_literals,cyclic=False,basis_propagation=False,propagation_library=None):
        super().__init__();self.n=len(X);self.d=private_literals
        assert len(private_literals)==len(Z)
        nonzero=[abs(l) for l in private_literals if l];assert len(set(nonzero))==len(nonzero) and all(v>self.n for v in nonzero)
        self.lookup={abs(l):(j,1 if l>0 else -1) for j,l in enumerate(private_literals) if l}
        self.x=RankOracle(X,Z,path.with_suffix('.x.lemmas.jsonl'),private_literals,cyclic=cyclic,basis_propagation=basis_propagation,propagation_library=propagation_library)
        self.z=RankOracle(Z,X,path.with_suffix('.z.lemmas.jsonl'),cyclic=cyclic,basis_propagation=basis_propagation,propagation_library=propagation_library)
        for j,l in enumerate(private_literals):
            if not l:self.z.on_assignment(j+1,fixed=True)
    @property
    def stats(self):return {'X':self.x.stats.copy(),'Z':self.z.stats.copy()}
    def on_assignment(self,lit,fixed=False):
        if abs(lit)<=self.n:self.x.on_assignment(lit,fixed)
        if abs(lit) in self.lookup:
            j,sign=self.lookup[abs(lit)];self.z.on_assignment((j+1)*(1 if lit>0 else -1)*sign,fixed)
    def on_new_level(self):self.x.on_new_level();self.z.on_new_level()
    def on_backtrack(self,to):self.x.on_backtrack(to);self.z.on_backtrack(to)
    def propagate(self):self.x.check();self.z.check();return []
    def provide_reason(self,lit):raise RuntimeError('Both oracles add certified clauses only.')
    def decide(self):return 0
    def has_clause(self):self.x.check();self.z.check();return bool(self.x.pending or self.z.pending)
    def add_clause(self):
        if self.x.pending:return self.x.pending.pop(0)
        clause=self.z.pending.pop(0);mapped=[]
        for lit in clause:
            d=self.d[abs(lit)-1]
            if not d:
                if lit>0:return [1,-1] # a constant-true literal makes it tautological
                continue
            mapped.append(d if lit>0 else -d)
        return mapped
    def check_model(self,model):
        xmodel=[l for l in model if abs(l)<=self.n]
        values={abs(l):l>0 for l in model}
        zmodel=[(j+1)*(1 if not d or values.get(abs(d),False)==(d>0) else -1) for j,d in enumerate(self.d)]
        a=self.x.check_model(xmodel);b=self.z.check_model(zmodel);return a and b
    def close(self):self.x.close();self.z.close()
