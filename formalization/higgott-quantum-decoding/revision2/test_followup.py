"""Small deterministic regression cases for the new diagnostic mechanisms."""
import unittest,sys
from pathlib import Path
import numpy as np,pymatching
sys.path.insert(0,str(Path(__file__).parent))
from independent_frame import sample
from basis_mapping import inverse
from confirm_and_decode import relabel,altered
class Followup(unittest.TestCase):
 def test_pair_parity_and_persistent_frame(self):
  ops=[('R',[0,1]),('PAIR',[(0,'Z'),(1,'Z')]),('PAIR',[(0,'Z'),(1,'Z')]),('DETECTOR',[-1,-2],None),('OBSERVABLE_INCLUDE',[-1],0)]
  d,o=sample(ops,4,0,1,(1,0,'X'))
  self.assertTrue(np.all(d==1));self.assertTrue(np.all(o[:,0]==1))
 def test_hadamard_exchanges_error_axes(self):
  ops=[('R',[0]),('H',[0]),('M',[0]),('OBSERVABLE_INCLUDE',[-1],0)]
  _,o=sample(ops,3,0,1,(0,0,'Z'));self.assertTrue(np.all(o[:,0]==1))
 def test_reset_erases_prior_frame(self):
  ops=[('R',[0]),('R',[0]),('M',[0]),('OBSERVABLE_INCLUDE',[-1],0)]
  _,o=sample(ops,3,0,1,(0,0,'X'));self.assertFalse(np.any(o))
 def test_canonical_inverse(self):
  a=np.array([[1,1,0,0],[1,0,1,0],[1,0,0,0],[1,0,0,1]],dtype=np.uint8)
  np.testing.assert_array_equal((a@inverse(a))%2,np.eye(4,dtype=np.uint8))
 def test_relabel_preserves_zero_and_is_involution(self):
  v=np.array([[i>>j&1 for j in range(4)] for i in range(16)],dtype=np.uint8)
  np.testing.assert_array_equal(relabel(relabel(v)),v);np.testing.assert_array_equal(np.any(relabel(v),axis=1),np.any(v,axis=1))
 def test_graph_label_roundtrip_unique_path(self):
  m=pymatching.Matching();m.add_boundary_edge(0,fault_ids={1},weight=2);m.add_edge(0,1,fault_ids={0},weight=1)
  d=np.array([[1,0],[0,1]],dtype=np.uint8);expected=m.decode_batch(d)
  np.testing.assert_array_equal(relabel(altered(m,True).decode_batch(d)),expected)
if __name__=='__main__':unittest.main()
