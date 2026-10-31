"""Regression for the actual source/replication column conflation."""
import unittest
from check_published_column import check_source_text, validate_boxes, check, ROOT
import fitz,json,copy
class SourceColumnRegression(unittest.TestCase):
 def test_known_claim_cannot_be_replaced_by_replication_verdict(self):
  for value in ['not established','NOT ESTABLISHED','blocked','not replicated','unresolved']:
   with self.subTest(value=value):
    with self.assertRaises(ValueError):check_source_text(value)
 def test_reported_qualitative_findings_are_valid_without_pooled_scalar(self):
  for value in ['IRT remedies scale bias','FI gives smaller variance SE','Large samples needed','Nine-item subscale','0/13 coefficients detected']:
   check_source_text(value)
 def test_actual_source_values_remain_permitted(self):
  for value in ['-3.0777','0.00106356','IRT -2.81; sum score 0.10']:
   check_source_text(value)
 def test_valid_geometry(self):
  validate_boxes(fitz.Rect(10,10,30,20),fitz.Rect(40,10,60,20),fitz.Rect(0,0,100,30),fitz.Rect(0,0,100,100))
 def test_geometry_cannot_point_to_unrelated_text(self):
  for pub,ours in [(fitz.Rect(10,40,30,50),fitz.Rect(40,10,60,20)),(fitz.Rect(50,10,70,20),fitz.Rect(10,10,30,20)),(fitz.Rect(10,10,50,20),fitz.Rect(40,10,60,20)),(fitz.Rect(10,10,10,20),fitz.Rect(40,10,60,20))]:
   with self.assertRaises(AssertionError):validate_boxes(pub,ours,fitz.Rect(0,0,100,30),fitz.Rect(0,0,100,100))
 def test_missing_known_statement_is_rejected_in_actual_pdf_check(self):
  m=json.loads((ROOT/'handoff/a0-writer-manifest.json').read_text());p=json.loads((ROOT/'handoff/a0-evidence-packet.json').read_text())
  del p['headline_effects'][0]['published_statement']
  with self.assertRaisesRegex(AssertionError,'Known source statement'):check(ROOT/'paper/a0-main.pdf',m,p)
if __name__=='__main__':unittest.main()
