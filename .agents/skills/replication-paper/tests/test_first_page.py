import copy
import importlib.util
import json
import subprocess
import sys
import unittest
from pathlib import Path

import fitz
import test_stages

BASE = Path(__file__).resolve().parents[1]
spec=importlib.util.spec_from_file_location('first_page',BASE/'scripts/first_page.py')
m=importlib.util.module_from_spec(spec);spec.loader.exec_module(m)
CASES=json.loads((BASE/'fixtures/first_page_cases.json').read_text())


class FirstPage(unittest.TestCase):
    def setUp(self):
        self.f=test_stages.Stages();self.f.setUp();self.addCleanup(self.f.doCleanups)
        self.record=self.f.delivery_record();self.root=self.f.root
        self.packet=json.loads((self.root/'packet.json').read_text())
        self.writer=json.loads((self.root/'writer.json').read_text())

    def save(self):
        (self.root/'packet.json').write_text(json.dumps(self.packet))
        (self.root/'writer.json').write_text(json.dumps(self.writer))

    def redact(self, rect):
        with fitz.open(self.root/'main.pdf') as doc:
            doc[0].add_redact_annot(fitz.Rect(rect));doc[0].apply_redactions()
            doc.save(self.root/'new.pdf')
        (self.root/'new.pdf').replace(self.root/'main.pdf')

    def test_valid_source_and_rendered_page(self):
        self.assertEqual(m.check(self.record,self.root),[])
        self.assertEqual(test_stages.d.check(self.record,self.root),[])

    def test_negative_fixtures(self):
        for case in CASES:
            with self.subTest(case=case['name']):
                packet=copy.deepcopy(self.packet);writer=copy.deepcopy(self.writer)
                source=(self.root/'source.tex').read_text();pdf=(self.root/'main.pdf').read_bytes()
                action=case['change'];effect=self.packet['headline_effects'][0]
                if action=='remove_citation':
                    (self.root/'source.tex').write_text(source.replace(r'\cite{smith2020}',''))
                elif action=='remove_original':self.writer['first_page']['abstract']['original_finding']=''
                elif action=='remove_heading':self.redact([45,235,555,253])
                elif action=='wrong_magnitude':effect['magnitude']='smaller'
                elif action=='remove_tolerance':effect.pop('tolerance')
                elif action=='unresolved_same':self.packet['headline_effects'][1]['magnitude']='same'
                elif action=='hidden_reversal':
                    effect.update(published_effect=13.184,ours_effect=-13.184,magnitude='same',direction='same direction')
                    self.packet['claims'][0]['contrasts'][0]['ours']=-13.184
                self.save();errors=m.check(self.record,self.root)
                self.assertTrue(any(case['expected'] in e for e in errors),errors)
                self.packet=packet;self.writer=writer;self.save()
                (self.root/'source.tex').write_text(source);(self.root/'main.pdf').write_bytes(pdf)

    def test_reversal_with_equal_magnitude_is_explicit(self):
        effect=self.packet['headline_effects'][0]
        effect.update(ours_effect=-13.184,magnitude='same',direction='reversed direction')
        self.packet['claims'][0]['contrasts'][0]['ours']=-13.184
        self.assertEqual(m.packet_errors(self.packet),[])
        self.assertEqual(m.comparison(effect),('same','reversed direction'))

    def test_rounding_boundary_is_decimal_not_float_epsilon(self):
        effect=self.packet['headline_effects'][0]
        effect.update(published_effect=1.0,ours_effect=1.0005)
        self.assertEqual(m.comparison(effect)[0],'same')
        effect['ours_effect']=1.0005001
        self.assertEqual(m.comparison(effect)[0],'larger')

    def test_smaller_zero_and_unstable(self):
        effect=self.packet['headline_effects'][0]
        effect.update(published_effect=-2,ours_effect=-1)
        self.assertEqual(m.comparison(effect),('smaller','same direction'))
        effect['ours_effect']=0
        self.assertEqual(m.comparison(effect),('smaller','zero vs nonzero'))
        effect['estimate_status']='unstable'
        self.assertEqual(m.comparison(effect),('not established','zero vs nonzero'))

    def test_bad_tolerance_metadata_and_nonsignificance_not_equivalence(self):
        for change in (dict(kind='posthoc'),dict(value=-1),dict(value=0.01),dict(basis='')):
            p=copy.deepcopy(self.packet);p['headline_effects'][0]['tolerance'].update(change)
            self.assertTrue(m.packet_errors(p))
        self.packet['headline_effects'][0]['interpretation']='equivalent because nonsignificant'
        self.assertTrue(m.packet_errors(self.packet))

    def test_contrast_mapping_and_headline_coverage(self):
        p=copy.deepcopy(self.packet);p['headline_effects'][0]['published_effect']=3
        self.assertTrue(m.packet_errors(p))
        self.packet['headline_effects'].pop()
        self.assertTrue(m.packet_errors(self.packet))

    def test_source_present_rendered_finding_missing(self):
        self.redact(self.writer['first_page']['abstract']['bbox'])
        errors=m.check(self.record,self.root)
        self.assertTrue(any('original_finding absent from rendered' in e for e in errors),errors)

    def test_rendered_present_source_finding_missing(self):
        p=self.root/'source.tex';p.write_text(p.read_text().replace('reported lower error for A and robustness across populations',''))
        errors=m.check(self.record,self.root)
        self.assertTrue(any('original_finding absent from source' in e for e in errors),errors)

    def test_table_row_cannot_hide_value_or_label_in_other_row(self):
        self.redact([45,255,555,275])
        self.assertTrue(any('rendered signed values' in e for e in m.check(self.record,self.root)))

    def test_first_page_required_not_page_two(self):
        with fitz.open(self.root/'main.pdf') as doc:
            doc.new_page(pno=0);doc.save(self.root/'new.pdf')
        (self.root/'new.pdf').replace(self.root/'main.pdf')
        self.assertTrue(m.check(self.record,self.root))

    def test_review_fidelity_not_keyword_certification(self):
        for name in ('abstract_source_fidelity','effect_magnitude_fidelity'):
            r=copy.deepcopy(self.record);r['review']['editorial']['checks'][name]['verdict']='fail'
            self.assertTrue(m.check(r,self.root))

    def test_missing_metadata_and_no_hidden_zero_sign(self):
        for key in self.packet['replicated_work']:
            p=copy.deepcopy(self.packet);p['replicated_work'][key]=None
            self.assertTrue(m.packet_errors(p),key)
        with self.assertRaises(ValueError):m.display(0.0001,3)

    def test_stage_packet_cli_requires_first_page_evidence(self):
        self.packet.pop('headline_effects');self.save()
        r=subprocess.run([sys.executable,str(BASE/'scripts/stage_checks.py'),'packet',str(self.root/'packet.json'),
                          '--root',str(self.root)],capture_output=True,text=True)
        self.assertNotEqual(r.returncode,0);self.assertIn('headline_effects',r.stdout)

    def test_legacy_audit_still_skips_new_contract(self):
        r=copy.deepcopy(self.record);r.pop('writer_manifest');r.pop('packet')
        self.assertEqual(test_stages.d.check(r,self.root,legacy_audit=True),[])

    def test_citation_generated_author_year_is_valid(self):
        p=self.root/'source.tex';p.write_text(p.read_text().replace('Smith (2020)',r'\citet{smith2020}'))
        self.assertEqual(m.check(self.record,self.root),[])

    def test_malformed_fidelity_checks_fail_without_crashing(self):
        for value in (None, [], 'pass'):
            r=copy.deepcopy(self.record);r['review']['editorial']['checks']=value
            self.assertTrue(test_stages.d.check(r,self.root))

    def test_rendered_expressions_are_not_matching_value_cells(self):
        self.assertEqual(m.norm('− 13.184'), '- 13.184')
        for row in ('B minus A 13.184/100 13.208/100 larger same direction tol 0.0005',
                    'B minus A 13.184 / 100 13.208 / 100 larger same direction tol 0.0005',
                    'B minus A 100 * 13.184 13.208 larger same direction tol 0.0005',
                    'B minus A - 13.184 13.208 larger same direction tol 0.0005'):
            original=(self.root/'main.pdf').read_bytes()
            with fitz.open(self.root/'main.pdf') as doc:
                page=doc[0];page.add_redact_annot(fitz.Rect(45,255,555,275));page.apply_redactions()
                page.insert_text((50,270),row,fontsize=9);doc.save(self.root/'new.pdf')
            (self.root/'new.pdf').replace(self.root/'main.pdf')
            self.assertTrue(any('rendered signed values' in e for e in m.check(self.record,self.root)),row)
            (self.root/'main.pdf').write_bytes(original)

    def test_oversized_json_integer_rejected_cleanly(self):
        self.packet['headline_effects'][0]['published_effect']=10**400
        self.assertTrue(m.packet_errors(self.packet))

    def test_adapter_api_uses_same_checks(self):
        self.assertEqual(m.check_data(self.packet,self.writer,(self.root/'source.tex').read_text(),
                         self.root/'main.pdf',self.record['review']['editorial']['checks']),[])

    def test_two_endpoint_rounding_allowance(self):
        row=self.packet['headline_effects'][0]
        row['tolerance']=dict(kind='rounding',value=0.1,components=[dict(decimals=1,weight=1),dict(decimals=1,weight=1)],basis='Two rounded endpoint errors')
        self.assertEqual(m.tolerance(row),m.dec('0.1'))
        row['tolerance']['value']=0.05
        with self.assertRaises(ValueError):m.tolerance(row)

    def test_unstable_reversal_retained_without_magnitude_claim(self):
        row=self.packet['headline_effects'][0]
        row.update(published_effect=0.3,ours_effect=-0.134,estimate_status='unstable')
        self.assertEqual(m.comparison(row),('not established','reversed direction'))

    def test_mapped_magnitude_cell_and_endpoints(self):
        def region(box):
            return fitz.Rect(box),contents[tuple(box)]
        table=fitz.Rect(0,0,600,400)
        boxes=[[0,y,200,y+20] for y in (0,30,60,90,120)]
        row=copy.deepcopy(self.packet['headline_effects'][0]);row.update(published_effect=-21.9,ours_effect=-20.9162325,magnitude='smaller')
        view=dict(form='absolute_with_endpoints',decimals=[1,3],magnitude_bbox=boxes[0],direction_bbox=boxes[1],values_bbox=boxes[2],
                  published_endpoints=dict(values=[28.4,6.5],decimals=1,bbox=boxes[3]),
                  ours_endpoints=dict(values=[27.407,6.490],decimals=3,bbox=boxes[4]))
        contents={tuple(b):t for b,t in zip(boxes,['smaller:','same','21.9 →20.916','28.4 / 6.5','27.407 / 6.490'])}
        self.assertEqual(m.display_errors(row,view,table,region),[])
        for expression in ('21.9 →20.916/100', '(21.9 →20.916)/100', '100 * 21.9 →20.916'):
            contents[tuple(boxes[2])]=expression
            self.assertTrue(m.display_errors(row,view,table,region),expression)
        contents[tuple(boxes[2])]='21.9 →20.916'
        for expression in ('- 28.4 / 6.5','28.4 / 6.5/100','100 * 28.4 / 6.5'):
            contents[tuple(boxes[3])]=expression
            self.assertTrue(m.display_errors(row,view,table,region),expression)
        contents[tuple(boxes[3])]='28.4 / 6.5'
        contents[tuple(boxes[1])]='reversed point estimate'
        self.assertTrue(m.display_errors(row,view,table,region))
        contents[tuple(boxes[1])]='same';contents[tuple(boxes[2])]='21.9/100 →20.916/100'
        self.assertTrue(m.display_errors(row,view,table,region))
        contents[tuple(boxes[2])]='21.9 →20.916';view['published_endpoints']['values']=[6.5,28.4]
        self.assertTrue(m.display_errors(row,view,table,region))

    def test_corrupt_pdf_produces_failures_not_traceback(self):
        (self.root/'main.pdf').write_bytes(b'%PDF corrupt')
        self.assertTrue(test_stages.d.check(self.record,self.root))
