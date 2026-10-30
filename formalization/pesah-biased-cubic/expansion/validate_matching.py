"""Check modern matching against independent NetworkX shortest-path pairing."""
import json,pathlib,itertools,sys
import numpy as np,networkx as nx
from pymatching import Matching
from pauli import lattice
rng=np.random.default_rng(202611271);rows=[]
for L in [3,4]:
 V=lattice(L)[0]
 for weighted in [False,True]:
  weights=rng.uniform(.3,3,V.shape[1]) if weighted else np.ones(V.shape[1]);matching=Matching(V,weights=weights);g=nx.Graph()
  for col in range(V.shape[1]):
   u,v=np.flatnonzero(V[:,col]);g.add_edge(int(u),int(v),weight=float(weights[col]))
  for repeat in range(20):
   error=np.zeros(V.shape[1],np.uint8);error[rng.choice(V.shape[1],size=3,replace=False)]=1;s=V@error%2;correction=matching.decode(s);assert np.array_equal(V@correction%2,s)
   defects=np.flatnonzero(s);complete=nx.Graph();complete.add_nodes_from(map(int,defects))
   for u,v in itertools.combinations(defects,2):complete.add_edge(int(u),int(v),weight=nx.shortest_path_length(g,int(u),int(v),weight='weight'))
   def exhaustive(nodes):
    if not nodes:return 0.
    u=nodes[0];return min(complete[u][v]['weight']+exhaustive([w for w in nodes[1:] if w!=v]) for v in nodes[1:])
   expected=exhaustive(list(map(int,defects)));actual=float(weights@correction);assert abs(expected-actual)<1e-8,(L,weighted,repeat,expected,actual,defects.tolist())
   rows.append(dict(L=L,weighted=weighted,repeat=repeat,matching_weight=actual,shortest_path_exhaustive_optimum=expected,valid=True))
pathlib.Path(sys.argv[1]).write_text(json.dumps(dict(passed=True,records=rows,shared='Same graph, weights, syndromes and host. PyMatching compiled sparse blossom compared with NetworkX shortest paths and exhaustive pairing of at most six defects. No claim that modern matching tie choices reproduce version0.2.4.'),indent=2)+'\n');print('80/80 modern matching weights and syndromes agree with independent shortest-path/exhaustive-pairing check')
