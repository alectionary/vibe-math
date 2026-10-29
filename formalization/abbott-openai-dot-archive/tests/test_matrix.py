"""Checks on transcription and an independent KMO calculation."""
import unittest, sys
from pathlib import Path
import numpy as np
sys.path.insert(0,str(Path(__file__).resolve().parents[1]/'scripts'))
from extract_matrix import extract,kmo,audit
class MatrixTest(unittest.TestCase):
 def test_shape_order_and_values(self):
  rows,R=extract()
  self.assertEqual(R.shape,(37,37))
  self.assertEqual([r['index']for r in rows],list(range(1,38)))
  self.assertEqual(len(set(r['name']for r in rows)),37)
  self.assertTrue(np.array_equal(R,R.T));self.assertTrue(np.all(np.diag(R)==1))
  self.assertGreater(np.linalg.eigvalsh(R)[0],0)
  self.assertEqual(rows[9]['name'],'CPFIEL3');self.assertEqual(rows[26]['sd'],52.3)
  # Visually checked edge cases: negative correlations and zero.
  self.assertEqual(R[31,7],-.02);self.assertEqual(R[33,7],.02)
  self.assertEqual(R[31,25],0);self.assertEqual(R[36,35],.10)
 def test_independent_partial_correlations(self):
  _,R=extract();p=len(R);a=[];b=[]
  # Schur complement computes each partial covariance without inversion of R.
  for i in range(p):
   for j in range(i):
    ij=[i,j];others=[k for k in range(p)if k not in ij]
    Q=R[np.ix_(ij,ij)]-R[np.ix_(ij,others)]@np.linalg.solve(R[np.ix_(others,others)],R[np.ix_(others,ij)])
    a.append(R[i,j]**2);b.append(Q[0,1]**2/(Q[0,0]*Q[1,1]))
  independent=sum(a)/(sum(a)+sum(b))
  self.assertAlmostEqual(independent,kmo(R),places=13)
 def test_bound_and_rounding(self):
  # For 0<=x<=100, x^2<=100x; hence s^2<=n/(n-1)*mean*(100-mean).
  bound=np.sqrt(296/295*74.75*25.25)
  self.assertLess(bound,52.25)
  for n in [2,10,296]:
   x=np.array([0.]*(n//2)+[100.]*(n-n//2));m=x.mean()
   self.assertAlmostEqual(x.var(ddof=1),n/(n-1)*m*(100-m),places=10)
if __name__=='__main__':unittest.main()
