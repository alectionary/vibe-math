import copy
import importlib.util
import json
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path
from unittest.mock import patch

import fitz
import test_stages

BASE = Path(__file__).resolve().parents[1]
spec = importlib.util.spec_from_file_location('pdf_links', BASE / 'scripts/pdf_links.py')
m = importlib.util.module_from_spec(spec); spec.loader.exec_module(m)
CASES = json.loads((BASE / 'fixtures/pdf_link_cases.json').read_text())
REV = 'a' * 40
REVISIONS = dict(reproduction_revision=REV, baseline_revision='b' * 40)
MASTER = 'https://github.com/a/b/blob/master/results.txt'


def make_pdf(path, links):
    with fitz.open() as document:
        page = document.new_page()
        for i, (label, uri) in enumerate(links):
            y = 70 + 40 * i
            page.insert_text((50, y), label)
            page.insert_link({'kind':fitz.LINK_URI, 'from':fitz.Rect(50, y-15, 500, y+5), 'uri':uri.replace('\\', '\\\\')})
        document.save(path)


class PDFLinks(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory(); self.addCleanup(self.tmp.cleanup)
        self.root = Path(self.tmp.name); self.pdf = self.root / 'main.pdf'

    def inventory(self, label, uri):
        make_pdf(self.pdf, [('results.txt', MASTER), (label, uri)])
        return m.extract(self.pdf)

    def test_rendered_uri_fixtures(self):
        for case in CASES:
            with self.subTest(case=case['name']):
                inventory = self.inventory(case['label'], case['uri'])
                self.assertEqual(inventory['links'][1]['uri'], case['uri'])
                self.assertEqual(not m.policy_errors(inventory, 'a/b', [], REVISIONS), case['passes'])

    def test_narrow_labeled_commit_provenance(self):
        for kind, label in [('reproduction_revision', 'Reproduction revision'), ('baseline_revision', 'Historical baseline')]:
            inventory = self.inventory(label, 'https://github.com/a/b/commit/'+REVISIONS[kind])
            declarations = [dict(link_id=inventory['links'][1]['id'], kind=kind)]
            self.assertEqual(m.policy_errors(inventory, 'a/b', declarations, REVISIONS), [])
            self.assertTrue(m.policy_errors(inventory, 'a/b', [], REVISIONS))

    def test_mislabeled_provenance(self):
        for label, uri, kind in [
            ('results.txt', 'https://github.com/a/b/commit/'+REV, 'reproduction_revision'),
            ('Historical baseline', 'https://github.com/a/b/commit/'+REV, 'reproduction_revision'),
            ('Reproduction revision', 'https://github.com/a/b/blob/'+REV+'/results.txt', 'reproduction_revision'),
            ('Reproduction revision', 'https://github.com/a/b/commit/'+'c'*40, 'reproduction_revision'),
            ('Reproduction revision', 'https://github.com/other/repo/commit/'+REV, 'reproduction_revision'),
            ('Reproduction revision', MASTER, 'reproduction_revision')]:
            inventory = self.inventory(label, uri)
            self.assertTrue(m.policy_errors(inventory, 'a/b', [dict(link_id=inventory['links'][1]['id'],kind=kind)], REVISIONS))

    def test_no_arbitrary_exceptions_or_stale_declarations(self):
        inventory = self.inventory('results.txt', MASTER)
        ident = inventory['links'][1]['id']
        for declarations in ([dict(link_id=ident, kind='navigation_exception')],
                             [dict(link_id='stale', kind='reproduction_revision')],
                             [dict(link_id=ident, kind='reproduction_revision', reason='user preference')]):
            self.assertTrue(m.policy_errors(inventory, 'a/b', declarations, REVISIONS))

    def test_encoded_query_and_download_bypasses(self):
        for uri in (MASTER+'?raw=true', MASTER.replace('master', '%6daster'),
                    'https://api.github.com/repos/a/b/contents/results.txt?ref=feature',
                    'https://codeload.github.com/a/b/zip/feature',
                    MASTER.replace('/master/', '/feature%2Fx/'),
                    MASTER.replace('github.com','github.com.'),
                    MASTER.replace('github.com','github%2ecom'),
                    MASTER.replace('/a/b/', '//a/b/')):
            self.assertTrue(m.policy_errors(self.inventory('results.txt', uri), 'a/b', [], REVISIONS))

    def test_corrupt_pdf_fails_closed(self):
        self.pdf.write_bytes(b'%PDF-1.4 not a PDF')
        with self.assertRaises(m.LinkAuditError): m.extract(self.pdf)

    def test_missing_extractor_fails_closed(self):
        make_pdf(self.pdf, [('results.txt', MASTER)])
        with patch.dict(sys.modules, {'fitz':None}):
            with self.assertRaises(m.LinkAuditError): m.extract(self.pdf)

    def test_unsupported_action_is_not_silently_omitted(self):
        make_pdf(self.pdf, [('results.txt', MASTER)])
        with fitz.open(self.pdf) as doc:
            xref = doc[0].get_links()[0]['xref']
            doc.xref_set_key(xref, 'A', '<</S/JavaScript/JS(nothing)>>')
            doc.save(self.root / 'unsupported.pdf')
        with self.assertRaises(m.LinkAuditError): m.extract(self.root / 'unsupported.pdf')

    def test_internal_destinations_allowed_but_no_uri_inventory_fails_policy(self):
        with fitz.open() as doc:
            page = doc.new_page()
            page.insert_link({'kind':fitz.LINK_GOTO, 'from':fitz.Rect(50,50,200,70), 'page':0, 'to':fitz.Point(0,0)})
            doc.save(self.pdf)
        inventory = m.extract(self.pdf)
        self.assertEqual(inventory['links'], [])
        self.assertTrue(m.policy_errors(inventory,'a/b',[],REVISIONS))

    def fixture(self):
        fixture = test_stages.Stages(); fixture.setUp(); self.addCleanup(fixture.doCleanups)
        return fixture, fixture.delivery_record()

    def test_commit_pinned_delivery_and_master_annotations_pass(self):
        fixture, record = self.fixture()
        self.assertIn(record['artifact_revision'], record['primary']['url'])
        self.assertEqual(test_stages.d.check(record, fixture.root), [])

    def test_forged_inventory_cannot_hide_actual_branch_uri(self):
        fixture, record = self.fixture()
        pdf = fixture.root / 'main.pdf'
        make_pdf(pdf, [('results.txt', MASTER.replace('/master/', '/feature/'))])
        # Pretend review hashes have been refreshed; saved inventory still contains master.
        record['primary']['sha256'] = m.digest(pdf)
        record['review']['pdf_links']['pdf_sha256'] = m.digest(pdf)
        errors = m.check(record, fixture.root)
        self.assertTrue(any('does not match annotations' in e for e in errors))
        self.assertTrue(any('artifact navigation must' in e for e in errors))

    def test_bad_pdf_target_fails_even_with_updated_hashes_and_good_source(self):
        fixture, record = self.fixture(); root = fixture.root
        (root / 'source.tex').write_text('Visible source destination: '+MASTER)
        make_pdf(root / 'main.pdf', [('results.txt', MASTER.replace('/master/', '/feature/'))])
        (root / 'links.json').write_text(json.dumps(m.extract(root / 'main.pdf')))
        record['link_inventory']['sha256'] = m.digest(root / 'links.json')
        for key in ('primary','source'):
            item=record[key]; item['sha256']=m.digest(root/item['path'])
            (root/item['downloaded_path']).write_bytes((root/item['path']).read_bytes())
        record['build_inputs'][0]['sha256']=record['source']['sha256']
        record['review'].update(pdf_sha256=record['primary']['sha256'], source_sha256=record['source']['sha256'], build_inputs={'source.tex':record['source']['sha256']})
        record['review']['pdf_links'].update(pdf_sha256=record['primary']['sha256'], inventory_sha256=record['link_inventory']['sha256'])
        subprocess.run(['git','add','.'],cwd=root,check=True)
        subprocess.run(['git','commit','-qm','Bad annotation fixture'],cwd=root,check=True)
        rev=subprocess.check_output(['git','rev-parse','HEAD'],cwd=root,text=True).strip(); record['artifact_revision']=rev
        for item in [record['primary'],record['source'],*record['evidence']]:
            item['url']='https://raw.githubusercontent.com/a/b/'+rev+'/'+item['path']
        errors=test_stages.d.check(record,root)
        self.assertTrue(errors)
        self.assertTrue(all(e.startswith('links:') for e in errors), errors)

    def test_stale_review_and_inventory(self):
        fixture, record = self.fixture()
        for change in ('inventory_hash','pdf_review','inventory_review','inventory_bytes'):
            r=copy.deepcopy(record)
            if change=='inventory_hash':r['link_inventory']['sha256']='0'*64
            elif change=='pdf_review':r['review']['pdf_links']['pdf_sha256']='0'*64
            elif change=='inventory_review':r['review']['pdf_links']['inventory_sha256']='0'*64
            else:
                p=fixture.root/'links.json'; data=json.loads(p.read_text()); data['links']=[];p.write_text(json.dumps(data))
            self.assertTrue(m.check(r, fixture.root), change)

    def test_missing_or_failed_audit(self):
        fixture, record = self.fixture()
        for key in ('repository','link_inventory','link_provenance'):
            r=copy.deepcopy(record);r.pop(key)
            self.assertTrue(m.check(r,fixture.root))
        record['review']['pdf_links']['verdict']='fail'
        self.assertTrue(m.check(record,fixture.root))

    def test_cli_extracts_current_pdf(self):
        make_pdf(self.pdf,[('results.txt',MASTER)])
        out=self.root/'inventory.json'
        subprocess.run([sys.executable,str(BASE/'scripts/pdf_links.py'),str(self.pdf),'--output',str(out)],check=True)
        self.assertEqual(json.loads(out.read_text()),m.extract(self.pdf))

    def test_full_sha_with_adjacent_rendered_provenance_label(self):
        for prefix, passes in [('immutable reproduction revision ', True),
                               ('historical baseline ', False), ('results file ', False)]:
            with fitz.open() as doc:
                page=doc.new_page()
                page.insert_text((50,70),prefix)
                x=50+fitz.get_text_length(prefix,fontsize=11)
                page.insert_text((x,70),REV+':')
                page.insert_link({'kind':fitz.LINK_URI,'from':fitz.Rect(x,55,500,75),'uri':'https://github.com/a/b/commit/'+REV})
                page.insert_text((50,110),'results.txt')
                page.insert_link({'kind':fitz.LINK_URI,'from':fitz.Rect(50,95,150,115),'uri':MASTER})
                doc.save(self.pdf)
            inventory=m.extract(self.pdf)
            declaration=[dict(link_id=inventory['links'][0]['id'],kind='reproduction_revision')]
            self.assertEqual(not m.policy_errors(inventory,'a/b',declaration,REVISIONS),passes)

    def test_delivery_cli_reports_page_uri_rule_and_nonzero_exit(self):
        fixture, record=self.fixture(); root=fixture.root
        target=MASTER.replace('/master/','/feature/')
        make_pdf(root/'main.pdf',[('results.txt',target)])
        (root/'delivery.json').write_text(json.dumps(record))
        result=subprocess.run([sys.executable,str(BASE/'scripts/delivery_check.py'),str(root/'delivery.json'),
                               '--root',str(root)],capture_output=True,text=True)
        self.assertNotEqual(result.returncode,0)
        report=json.loads(result.stdout)
        self.assertFalse(report['current_acceptance'])
        failure=next(f for f in report['pdf_link_failures'] if f['rule']=='master_navigation')
        self.assertEqual((failure['page'],failure['uri']),(1,target))
        self.assertTrue(any('page 1 URI '+target in error for error in report['errors']))

    def test_dot_and_backslash_repository_aliases_do_not_count_as_external(self):
        for path in ('/a/./b/blob/feature/results.txt', '/a/%2e/b/blob/feature/results.txt',
                     '/x/../a/b/blob/feature/results.txt', '/a\\b/blob/feature/results.txt',
                     '/a%5cb/blob/feature/results.txt'):
            inventory=self.inventory('results.txt','https://github.com'+path)
            failures=m.policy_findings(inventory,'a/b',[],REVISIONS)
            self.assertTrue(any(f['rule'] in ('canonical_repository_uri','uri_syntax') for f in failures),path)

    def test_encrypted_pdf_with_empty_user_password_fails_closed(self):
        with fitz.open() as doc:
            doc.new_page()
            doc.save(self.pdf,encryption=fitz.PDF_ENCRYPT_AES_256,owner_pw='owner',user_pw='')
        with self.assertRaises(m.LinkAuditError):m.extract(self.pdf)
