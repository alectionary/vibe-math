import copy,importlib.util,tempfile,unittest,subprocess
from pathlib import Path
p=Path(__file__).resolve().parents[1]/'scripts/delivery_check.py';spec=importlib.util.spec_from_file_location('delivery',p);m=importlib.util.module_from_spec(spec);spec.loader.exec_module(m)
class Delivery(unittest.TestCase):
 def setUp(self):
  self.temp=tempfile.TemporaryDirectory();self.addCleanup(self.temp.cleanup);self.root=Path(self.temp.name)
  for n,b in [('main.pdf',b'%PDF-1.4 manuscript'),('source.tex',b'text'),('crop.png',b'crop')]:
   (self.root/n).write_bytes(b);(self.root/('remote-'+n)).write_bytes(b)
  def git(*args):return subprocess.check_output(['git','-C',str(self.root),*args],stderr=subprocess.DEVNULL).decode().strip()
  git('init');git('config','user.name','Test');git('config','user.email','test@example.invalid');git('add','.');git('commit','-m','fixture');rev=git('rev-parse','HEAD')
  def a(n):return dict(path=n,sha256=m.digest(self.root/n),downloaded_path='remote-'+n,url='https://raw.githubusercontent.com/a/b/'+rev+'/'+n)
  self.r=dict(primary=dict(a('main.pdf'),role='manuscript'),source=a('source.tex'),evidence=[a('crop.png')],baseline_revision=rev,reproduction_revision=rev,artifact_revision=rev,template=dict(path='source.tex',revision=rev,sha256=m.digest(self.root/'source.tex')),build_inputs=[dict(path='source.tex',sha256=m.digest(self.root/'source.tex'))])
  self.r['review']=dict(pdf_sha256=self.r['primary']['sha256'],source_sha256=self.r['source']['sha256'],reviewer='independent reviewer',build_inputs={x['path']:x['sha256'] for x in self.r['build_inputs']},items={k:'page evidence' for k in m.REVIEW_ITEMS})
 def test_valid(self):self.assertEqual(m.check(self.r,self.root),[])
 def test_appendix_is_not_main(self):
  self.r['primary']['role']='appendix';self.assertTrue(m.check(self.r,self.root))
 def test_remote_mismatch(self):
  (self.root/'remote-main.pdf').write_bytes(b'%PDF-old');self.assertTrue(m.check(self.r,self.root))
 def test_helper_passes_are_not_review(self):
  self.r['review']={'tests_passed':25};self.assertTrue(m.check(self.r,self.root))
 def test_stale_review_after_rebuild(self):
  self.r['review']['pdf_sha256']='0'*64;self.assertTrue(m.check(self.r,self.root))
 def test_missing_evidence(self):
  self.r['evidence']=[];self.assertTrue(m.check(self.r,self.root))
 def test_branch_url_rejected(self):
  self.r['primary']['url']=self.r['primary']['url'].replace(self.r['artifact_revision'],'master');self.assertTrue(m.check(self.r,self.root))
 def test_baseline_alone_insufficient(self):
  del self.r['reproduction_revision'];self.assertTrue(m.check(self.r,self.root))
 def test_html_named_pdf_rejected(self):
  (self.root/'main.pdf').write_bytes(b'<html>Error</html>');self.assertTrue(m.check(self.r,self.root))

 def test_null_shapes(self):
  for key in ['primary','review','reproduction_revision','build_inputs','template']:
   r=copy.deepcopy(self.r);r[key]=None;self.assertTrue(m.check(r,self.root))
 def test_local_copy_not_remote(self):
  self.r['primary']['downloaded_path']='main.pdf';self.assertTrue(m.check(self.r,self.root))
 def test_missing_template(self):
  self.r['template']['path']='missing.tex';self.assertTrue(m.check(self.r,self.root))
 def test_changed_included_input(self):
  (self.root/'source.tex').write_text('changed');self.assertTrue(m.check(self.r,self.root))
 def test_fake_revision(self):
  self.r['reproduction_revision']='e'*40;self.assertTrue(m.check(self.r,self.root))
