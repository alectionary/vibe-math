"""Nonscalar applicability is explicit, rendered, and cannot create effect evidence."""
import copy
import unittest
import test_first_page as fixture
m = fixture.m


class Nonscalar(unittest.TestCase):
    setUp = fixture.FirstPage.setUp
    save = fixture.FirstPage.save
    # Reuse the real PDF fixture; inherited tests also exercise unchanged scalar paths.
    def exceptional(self):
        row = self.packet['headline_effects'][0]
        claim = next(c for c in self.packet['claims'] if c['id'] == row['claim_id'])
        claim.update(comparison_kind='nonscalar', contrasts=[],
                     contrast_not_applicable='A qualitative structural proposition.', component_claim_ids=[])
        row.update(comparison_kind='nonscalar', applicability_reason='No scalar estimand.',
                   published_effect=None, ours_effect=None, contrast_index=None,
                   display_decimals=None, estimate_status='unresolved', unresolved_reason='No scalar magnitude.',
                   tolerance=dict(kind='not_applicable', value=None, basis='No scalar estimand.'),
                   magnitude='not established', direction='not established',
                   component_claim_ids=[], component_contrast_indices=[])
        return row, claim

    def test_qualitative_contract(self):
        row, _ = self.exceptional()
        self.assertEqual(m.packet_errors(self.packet), [])
        self.assertEqual(m.comparison(row), ('not established', 'not established'))

    def test_nonscalar_negative_cases(self):
        for change in (dict(applicability_reason=''), dict(published_effect=0), dict(magnitude='same'),
                       dict(direction='same direction'), dict(estimate_status='resolved'),
                       dict(display_decimals=3), dict(tolerance=dict(kind='prespecified', value=0, basis='arbitrary'))):
            with self.subTest(change=change):
                self.setUp();row,_=self.exceptional();row.update(change)
                self.assertTrue(m.packet_errors(self.packet))

    def test_complete_108_contrast_parent(self):
        row, claim = self.exceptional()
        claim['contrasts'] = [dict(definition=str(i), units='SE', positive_means='gain', published=1, ours=2) for i in range(108)]
        row['component_contrast_indices'] = list(range(108))
        row['component_comparisons'] = [dict(id='cell'+str(i), claim_id=claim['id'], contrast_index=i,
            estimand=str(i), units='SE', positive_means='gain', published_effect=1, ours_effect=2,
            estimate_status='resolved', display_decimals=2, tolerance=dict(kind='prespecified',value=0.01,basis='fixed before analysis'),
            magnitude='larger',direction='same direction',interpretation='descriptive point estimates; not equivalence',
            uncertainty_statement='Descriptive only.') for i in range(108)]
        self.assertEqual(m.packet_errors(self.packet), [])
        row['component_comparisons'][0]['magnitude']='same'
        self.assertTrue(m.packet_errors(self.packet))
        row['component_comparisons'][0]['magnitude']='larger'
        row['component_contrast_indices'].pop()
        self.assertTrue(m.packet_errors(self.packet))

    def test_missing_components_and_scalar_evasion(self):
        row, claim = self.exceptional()
        claim['component_claim_ids'] = ['missing']
        self.assertTrue(m.packet_errors(self.packet))
        row['component_claim_ids'] = ['missing']
        self.assertTrue(m.packet_errors(self.packet))
        claim['component_claim_ids'] = [];row['component_claim_ids'] = []
        claim['contrasts'] = [dict(published=1, ours=2)]
        row['component_contrast_indices'] = [0]
        self.assertTrue(m.packet_errors(self.packet))
        claim['component_claim_ids'] = [{}]
        self.assertTrue(m.packet_errors(self.packet))

    def test_scalar_unestablished(self):
        row = self.packet['headline_effects'][0]
        claim = next(c for c in self.packet['claims'] if c['id'] == row['claim_id'])
        row.update(comparison_kind='scalar_unestablished', applicability_reason='No source precision or justified margin.',
                   published_effect=None, estimate_status='unresolved', unresolved_reason='Source unavailable.',
                   magnitude='not established', direction='not established',
                   tolerance=dict(kind='unestablished', value=None, basis='Source unquantified.'))
        claim['comparison_kind']='scalar_unestablished'
        claim['contrasts'][0]['published'] = None
        self.assertEqual(m.packet_errors(self.packet), [])
        row['published_effect'] = 1
        self.assertTrue(m.packet_errors(self.packet))

    def test_rendered_exception_requires_cells_and_review(self):
        self.exceptional();self.save()
        errors=m.check(self.record,self.root)
        self.assertTrue(any('applicability explanation' in e for e in errors),errors)
        self.assertTrue(any('display mapping' in e for e in errors),errors)
        self.assertTrue(any('comparison_applicability' in e for e in errors),errors)

    def test_exception_cell_false_same_and_partial_value(self):
        import fitz
        row,_=self.exceptional()
        box=fitz.Rect(0,0,100,100)
        contents={'mag':'same', 'dir':'not established', 'vals':'9.9 not established'}
        view=dict(magnitude_bbox='mag',direction_bbox='dir',values_bbox='vals',form='signed')
        region=lambda name:(box,contents[name])
        self.assertTrue(m.display_errors(row,view,box,region,box))
        row.update(comparison_kind='scalar_unestablished',published_effect=2.5,display_decimals=1)
        contents['mag']='not established'
        self.assertTrue(m.display_errors(row,view,box,region,box))
        contents['vals']='2.5 not established'
        self.assertEqual(m.display_errors(row,view,box,region,box),[])

    def test_saved_schwabe_blocker_explicit_adapter(self):
        import json
        data=json.loads((fixture.BASE/'fixtures/schwabe_nonscalar.json').read_text())
        row=copy.deepcopy(data['blocker'])
        with self.assertRaises(ValueError):m.comparison(row)
        row.update(comparison_kind='nonscalar', applicability_reason=row['tolerance']['basis'],
                   display_decimals=None, component_claim_ids=[], component_contrast_indices=[])
        self.assertEqual(m.comparison(row),('not established','not established'))

    def test_real_schwabe_parent_components_focused_contract(self):
        import json
        data=json.loads((fixture.BASE/'fixtures/schwabe_nonscalar.json').read_text())
        for original in data['claims']:
            with self.subTest(claim=original['id']):
                self.setUp();row,claim=self.exceptional()
                claim.update(id=original['id'], component_claim_ids=original['component_claim_ids'],
                             contrast_not_applicable=original['contrast_not_applicable'])
                row.update(claim_id=claim['id'],component_claim_ids=original['component_claim_ids'],
                           component_contrast_indices=list(range(len(original['contrasts']))),component_comparisons=[])
                # This is focused first-page schema validation, not full stage acceptance:
                # referenced IDs are checked here; full evidence/hashes remain stage_checks' job.
                self.packet['claims'] += [dict(id=i,level='supporting') for i in original['component_claim_ids']]
                claim['contrasts']=[]
                for i,c in enumerate(original['contrasts']):
                    value=c['published']['value']
                    contrast={k:c[k] for k in ('definition','units','positive_means')}
                    contrast.update(published=value,ours=None)
                    claim['contrasts'].append(contrast)
                    effect=dict(id='cell'+str(i),claim_id=claim['id'],contrast_index=i,
                                estimand=c['definition'],units=c['units'],positive_means=c['positive_means'],
                                published_effect=value,ours_effect=None,estimate_status='unresolved',
                                unresolved_reason='Source-only packet; production result not asserted.',
                                display_decimals=15 if value is not None else None,
                                magnitude='not established',direction='not established',
                                interpretation='descriptive point estimates; not equivalence',uncertainty_statement='Retain source extraction bounds; no inferential equivalence.')
                    if value is None:
                        contrast['comparison_kind']='scalar_unestablished'
                        effect.update(comparison_kind='scalar_unestablished',applicability_reason=c['published']['unavailable_reason'],
                                      tolerance=dict(kind='unestablished',value=None,basis=c['tolerance']['basis']))
                    else:
                        # Explicit proposed pre-result comparison allowance equals the
                        # existing geometric extraction bound, never a new empirical value.
                        effect['tolerance']=dict(kind='prespecified',value=c['tolerance']['value'],basis='Pre-result source-extraction allowance: '+c['tolerance']['basis'])
                    row['component_comparisons'].append(effect)
                self.assertEqual(m.packet_errors(self.packet),[])
                if original['id']=='H6.precision-grid':
                    self.assertEqual(len(row['component_comparisons']),108)
                    row['component_comparisons'].pop()
                    self.assertTrue(m.packet_errors(self.packet))

    def test_finite_pair_unestablished_tolerance_preserves_reversal(self):
        row=self.packet['headline_effects'][0];claim=self.packet['claims'][0]
        claim['comparison_kind']='scalar_unestablished'
        row.update(comparison_kind='scalar_unestablished',applicability_reason='No defensible margin specified.',
                   tolerance=dict(kind='unestablished',value=None,basis='Neither source precision nor prespecified margin available.'),
                   estimate_status='unresolved',unresolved_reason='Magnitude comparison criterion unestablished.',
                   ours_effect=-13.184,magnitude='not established',direction='reversed direction')
        claim['contrasts'][0]['ours']=-13.184
        self.assertEqual(m.packet_errors(self.packet),[])
        self.assertEqual(m.comparison(row),('not established','reversed direction'))
        row['direction']='not established'
        self.assertTrue(m.packet_errors(self.packet))

    def test_rendered_nonscalar_success_and_exact_label_failure(self):
        import fitz
        self.exceptional()
        row=self.writer['first_page']['table']['rows'][0]
        row.update(estimand_text='Qualitative: no scalar',applicability_text='Qualitative: no scalar',
                   display=dict(magnitude_bbox=[265,255,365,275],direction_bbox=[400,255,510,275]))
        source=self.root/'source.tex'
        source.write_text(source.read_text()+'\nQualitative: no scalar\n')
        self.record['review']['editorial']['checks']['comparison_applicability']=dict(verdict='pass',findings=[dict(page=1,location='table',finding='Qualitative proposition; no scalar estimand; evidence retained.')])
        def render(label):
            with fitz.open(self.root/'main.pdf') as doc:
                doc[0].add_redact_annot(fitz.Rect(row['bbox']));doc[0].apply_redactions()
                doc[0].insert_text((50,270),'Qualitative: no scalar',fontsize=9)
                doc[0].insert_text((270,270),label,fontsize=9)
                doc[0].insert_text((405,270),'not established',fontsize=9)
                doc.save(self.root/'new.pdf')
            (self.root/'new.pdf').replace(self.root/'main.pdf')
        render('not established');self.save()
        self.assertEqual(m.check(self.record,self.root),[])
        render('same')
        self.assertTrue(any('magnitude cell' in e for e in m.check(self.record,self.root)))

    def test_cannot_discard_existing_component_tolerance(self):
        row=self.packet['headline_effects'][0];claim=self.packet['claims'][0]
        claim['comparison_kind']='scalar_unestablished'
        claim['contrasts'][0]['tolerance']=copy.deepcopy(row['tolerance'])
        row.update(comparison_kind='scalar_unestablished',applicability_reason='Pretend missing.',
                   tolerance=dict(kind='unestablished',value=None,basis='Pretend missing.'),
                   estimate_status='unresolved',unresolved_reason='Pretend missing.',magnitude='not established')
        self.assertTrue(any('discard' in e for e in m.packet_errors(self.packet)))
