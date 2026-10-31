"""Regression tests for this study's source-owned numerical cell contract."""
import unittest
from numerical_contract_checks import validate_source_text,verify_number,geometry,norm
class NumericalContractTests(unittest.TestCase):
 def test_valid_positive(self):verify_number('0.00356296',0.003562963913674194,8)
 def test_valid_negative(self):verify_number('−0.01093086',-0.010930861504939271,8)
 def test_source_status_rejected(self):
  for s in ['Not established','not estimated','Blocked','unresolved','Not replicated']:
   with self.subTest(s=s),self.assertRaises(ValueError):validate_source_text(s)
 def test_source_numeric_allowed(self):validate_source_text('−3.0777')
 def test_wrong_value_rejected(self):
  with self.assertRaises(ValueError):verify_number('0.00490662',0.003562963913674194,8)
 def test_wrong_sign_rejected(self):
  with self.assertRaises(ValueError):verify_number('0.01093086',-0.010930861504939271,8)
 def test_zero_rounding_rejected(self):
  with self.assertRaises(ValueError):verify_number('0.00',0.00023543933144523854,2)
 def test_geometry_valid(self):geometry({'row_bbox':[0,0,30,10],'published_bbox':[10,0,20,10],'ours_bbox':[20,0,30,10]},[0,0,40,30])
 def test_overlapping_columns_rejected(self):
  with self.assertRaises(ValueError):geometry({'row_bbox':[0,0,30,10],'published_bbox':[10,0,23,10],'ours_bbox':[20,0,30,10]},[0,0,40,30])
 def test_column_outside_row_rejected(self):
  with self.assertRaises(ValueError):geometry({'row_bbox':[0,0,30,10],'published_bbox':[10,0,20,15],'ours_bbox':[20,0,30,10]},[0,0,40,30])
if __name__=='__main__':unittest.main()
