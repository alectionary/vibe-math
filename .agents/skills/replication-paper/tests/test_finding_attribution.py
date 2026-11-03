"""Known source findings survive null effects and are checked in their own cells."""
import copy
import json
import unittest
import fitz
import test_first_page as fixture

m = fixture.m
CASES = json.loads((fixture.BASE/'fixtures/finding_attribution_cases.json').read_text())


class Findings(unittest.TestCase):
    setUp = fixture.FirstPage.setUp
    save = fixture.FirstPage.save

    def qualitative(self, case=CASES[0]):
        claim=self.packet['claims'][0];effect=self.packet['headline_effects'][0]
        claim.update(comparison_kind='nonscalar', contrasts=[], component_claim_ids=[],
                     contrast_not_applicable='The source statement is not a scalar contrast.')
        claim['published']['value']=case['published']
        for side in ('published','ours'):
            finding=claim['findings'][side]
            finding.update(text=case[side], locator=case['source_locator'], component_contrast_indices=[])
        claim['ours']['value']=case['ours'] if case['ours_state']=='observed' else None
        claim['findings']['ours']['state']=case['ours_state']
        if case['ours_state']!='observed':
            claim.update(status='blocked')
            claim['ours']['unavailable_reason']='The production run did not finish.'
            claim['findings']['ours']['reason']='Fixed execution budget exhausted; no comparison estimated.'
        effect.update(comparison_kind='nonscalar', applicability_reason='Qualitative finding, no scalar effect.',
                      published_effect=None,ours_effect=None,contrast_index=None,display_decimals=None,
                      estimate_status='unresolved',unresolved_reason='No scalar magnitude is defined.',
                      tolerance=dict(kind='not_applicable',value=None,basis='Theorem or qualitative finding.'),
                      magnitude='not established',direction='not established',
                      component_claim_ids=[],component_contrast_indices=[])
        row=self.writer['first_page']['table']['rows'][0]
        row.update(published_text=case['published'],ours_text=case['ours'],
                   estimand_text='Qualitative',applicability_text='Qualitative',
                   display=dict(magnitude_bbox=[345,255,445,275],direction_bbox=[445,255,550,275]))
        source=self.root/'source.tex';source.write_text(source.read_text()+'\nQualitative\n')
        self.record['review']['editorial']['checks']['comparison_applicability']=dict(verdict='pass',findings=[dict(page=1,location='table',finding='Source and replication findings retained without inventing scalar effects.')])
        self.render(row['published_text'],row['ours_text'])
        self.save()
        return claim,row

    def render(self,published,ours,extra=None):
        with fitz.open(self.root/'main.pdf') as doc:
            page=doc[0];page.add_redact_annot(fitz.Rect(45,255,555,275));page.apply_redactions()
            page.insert_text((50,270),'Qualitative',fontsize=8)
            self.assertGreaterEqual(page.insert_textbox(fitz.Rect(145,255,245,275),published,fontsize=6),0)
            self.assertGreaterEqual(page.insert_textbox(fitz.Rect(245,255,345,275),ours,fontsize=6),0)
            page.insert_text((350,270),'not established',fontsize=8)
            page.insert_text((450,270),'not established',fontsize=8)
            if extra: page.insert_textbox(fitz.Rect(45,255,140,275),extra,fontsize=6)
            doc.save(self.root/'new.pdf')
        (self.root/'new.pdf').replace(self.root/'main.pdf')

    def test_real_failure_families_preserve_known_source_and_ours(self):
        for case in CASES:
            with self.subTest(case=case['name']):
                self.setUp();self.qualitative(case)
                self.assertEqual(m.check(self.record,self.root),[])
                self.render(case['old_published'],case['ours'])
                self.assertTrue(any('published: rendered finding' in e for e in m.check(self.record,self.root)))

    def test_null_effects_never_infer_finding_absence(self):
        claim,_=self.qualitative()
        claim['findings']['published'].update(state='not_reported',reason='The scalar effect is null.')
        self.assertTrue(any('known finding cannot be marked absent' in e for e in m.packet_errors(self.packet)))

    def test_generic_verdict_rejected_even_if_declared_and_rendered(self):
        claim,row=self.qualitative()
        for value in ('not established','NOT REPLICATED','blocked','unresolved','N/A','not reported',
                      'not obtained','not assessed','unavailable','unknown',''):
            with self.subTest(value=value):
                claim['findings']['published']['text']=value;row['published_text']=value
                self.assertTrue(m.packet_errors(self.packet))

    def test_known_ours_cannot_be_replaced_by_placeholder(self):
        claim,row=self.qualitative()
        claim['findings']['ours']['text']='not assessed';row['ours_text']='not assessed'
        self.assertTrue(any('ours: generic verdict' in e for e in m.packet_errors(self.packet)))

    def test_rendered_component_estimate_cannot_disappear(self):
        case=dict(CASES[0],published='Surface 3.08/2.90; toric 2.90/2.78.')
        claim,row=self.qualitative(case)
        child=copy.deepcopy(claim);child.update(id='component',level='supporting')
        self.packet['claims'].append(child);claim['component_claim_ids']=['component']
        self.packet['headline_effects'][0]['component_claim_ids']=['component']
        for finding in claim['findings'].values():finding['component_claim_ids']=['component']
        self.save();self.assertEqual(m.check(self.record,self.root),[])
        self.render('Surface 3.08/2.90; toric 2.90.',row['ours_text'])
        self.assertTrue(any('published: rendered finding' in e for e in m.check(self.record,self.root)))

    def test_valid_absence_preserves_qualitative_parent(self):
        claim,row=self.qualitative(CASES[1])
        # A separately identified statistic, not erasure of the qualitative parent.
        child=copy.deepcopy(claim);child.update(id='power-statistic',level='supporting',statement='Numerical power difference')
        child['published']=dict(value=None,units='power probability',unavailable_reason='No rejection-rate experiment reported in source.')
        self.packet['claims'].append(child)
        claim['component_claim_ids']=['power-statistic']
        self.packet['headline_effects'][0]['component_claim_ids']=['power-statistic']
        for finding in claim['findings'].values():finding['component_claim_ids']=['power-statistic']
        self.assertEqual(m.packet_errors(self.packet),[])
        # Independently audited entirely absent statistic is legitimate too.
        child['findings']['published'].update(text='No numerical power difference reported.',state='not_reported',reason='Source reports standard errors, not rejection rates.')
        child['findings']['published']['component_claim_ids']=[]
        self.assertEqual(m.finding_errors(child,{'results'}),[])

    def test_absence_requires_reason_and_null_retained_value(self):
        claim,_=self.qualitative(CASES[1]);del claim['findings']['ours']['reason']
        self.assertTrue(m.packet_errors(self.packet))

    def test_explanatory_unresolved_words_are_not_blanket_banned(self):
        claim,_=self.qualitative();claim['findings']['published']['text']='A theorem is reported; a stochastic extension remains unresolved.'
        self.assertEqual(m.packet_errors(self.packet),[])

    def test_missing_or_wrong_evidence_binding(self):
        claim,_=self.qualitative()
        for key,value in [('artifact_ids',[]),('artifact_ids',['unknown']),('locator','')]:
            original=copy.deepcopy(claim['findings']['published']);claim['findings']['published'][key]=value
            self.assertTrue(m.packet_errors(self.packet));claim['findings']['published']=original
        del claim['findings'];self.assertTrue(m.packet_errors(self.packet))

    def test_missing_swapped_overlapping_or_off_row_cells(self):
        _,row=self.qualitative();original=copy.deepcopy(row)
        cases=[dict(published_bbox=[145,280,245,295]),dict(published_bbox=row['ours_bbox'],ours_bbox=row['published_bbox']),
               dict(ours_bbox=row['published_bbox']),dict(published_bbox=[145,255,345,275]),dict(published_text='')]
        for change in cases:
            row.update(change);self.save();self.assertTrue(m.check(self.record,self.root));row.clear();row.update(copy.deepcopy(original))
        del row['published_bbox'];self.save();self.assertTrue(m.check(self.record,self.root))

    def test_duplicate_text_in_claim_column_cannot_satisfy_source_cell(self):
        _,row=self.qualitative();self.render('not established',row['ours_text'],extra=row['published_text'])
        row['published_bbox']=[45,255,140,275];self.save()
        self.assertTrue(any('own headed column' in e for e in m.check(self.record,self.root)))

    def test_column_identity_cannot_move_with_cell_to_wrong_header(self):
        _,row=self.qualitative();table=self.writer['first_page']['table']
        table['published_column_bbox']=[45,235,140,300];table['published_heading_bbox']=[45,237,140,253]
        row['published_bbox']=[45,255,140,275];self.save()
        self.assertTrue(any('actual finding column heading' in e for e in m.check(self.record,self.root)))

    def test_heading_cannot_be_relocated_into_a_data_row(self):
        self.qualitative();table=self.writer['first_page']['table']
        table['published_heading_bbox']=[145,280,245,295]
        self.save()
        self.assertTrue(any('heading must precede' in e for e in m.check(self.record,self.root)))

    def test_missing_columns_or_spoofed_width_fail(self):
        self.qualitative();table=self.writer['first_page']['table'];del table['ours_column_bbox'];self.save()
        self.assertTrue(m.check(self.record,self.root))
        table['ours_column_bbox']=[245,235,345,300];table['published_column_bbox']=[45,235,245,300];self.save()
        self.assertTrue(any('header must span' in e for e in m.check(self.record,self.root)))

    def test_component_findings_cannot_omit_contrasts_or_children(self):
        c=self.packet['claims'][0];c['findings']['published']['component_contrast_indices']=[]
        self.assertTrue(m.packet_errors(self.packet))
        c['findings']['published']['component_contrast_indices']=[0];c['component_claim_ids']=['child']
        self.assertTrue(m.packet_errors(self.packet))

    def test_source_by_source_review_mandatory(self):
        self.qualitative();del self.record['review']['editorial']['checks']['finding_attribution']
        self.assertTrue(any('finding_attribution' in e for e in m.check(self.record,self.root)))

    def test_scalar_arithmetic_still_checked_independently(self):
        self.assertEqual(m.check(self.record,self.root),[])
        self.packet['headline_effects'][0]['ours_effect']=99;self.save()
        self.assertTrue(any('inconsistent with source contrast' in e for e in m.check(self.record,self.root)))

    def test_malformed_findings_fail_cleanly(self):
        for value in (None,[],{},'not established'):
            p=copy.deepcopy(self.packet);p['claims'][0]['findings']=value
            self.assertTrue(m.packet_errors(p))

if __name__=='__main__':unittest.main()
