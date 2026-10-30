import sys,unittest
from pathlib import Path
sys.path.insert(0,str(Path(__file__).resolve().parents[1]/'scripts'))
from announcement_url import check_announcement_url
class AnnouncementURL(unittest.TestCase):
 repo='alectionary/vibe-math'
 path='formalization/higgott-quantum-decoding/paper/sixfold_qubit_savings__a_replication_of_higgott_bolza_codes.pdf'
 def url(self):return 'https://github.com/'+self.repo+'/blob/master/'+self.path
 def check(self,url,path=None):return check_announcement_url(url,self.repo,path or self.path)
 def test_approved_main_pdf(self):self.assertEqual(self.check(self.url()),[])
 def test_raw_not_public_announcement_link(self):self.assertTrue(self.check('https://raw.githubusercontent.com/'+self.repo+'/master/'+self.path))
 def test_branch_or_commit_not_master(self):
  for ref in ['feature','a'*40]:self.assertTrue(self.check(self.url().replace('/master/','/'+ref+'/')))
 def test_folder_not_pdf(self):self.assertTrue(self.check(self.url().rsplit('/',1)[0]))
 def test_wrong_evidence_pdf(self):self.assertTrue(self.check(self.url().replace(self.path,'source-evidence/appendix.pdf')))
 def test_queries_and_fragments_rejected(self):
  for suffix in ['?raw=true','#page=1']:self.assertTrue(self.check(self.url()+suffix))
 def test_private_and_download_urls(self):
  for u in ['sandbox:/mnt/data/report.pdf','https://github.com/'+self.repo+'/raw/master/'+self.path,'https://example.org/download/main.pdf']:self.assertTrue(self.check(u))
 def test_host_and_credentials(self):
  for host in ['github.com.evil.invalid','user@github.com','github.com:443']:self.assertTrue(self.check(self.url().replace('github.com',host)))
 def test_wrong_repository(self):self.assertTrue(self.check(self.url().replace(self.repo,'other/repo')))
 def test_generic_pdf_not_descriptive(self):
  p='paper/report.pdf';self.assertTrue(self.check('https://github.com/'+self.repo+'/blob/master/'+p,p))
 def test_path_traversal(self):
  p='paper/../descriptive_result.pdf';self.assertTrue(self.check('https://github.com/'+self.repo+'/blob/master/'+p,p))
 def test_nulls_fail_cleanly(self):self.assertTrue(check_announcement_url(None,self.repo,self.path))
