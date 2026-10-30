import copy
import importlib.util
import json
import subprocess
import sys
import fitz
import tempfile
import unittest
from pathlib import Path

BASE = Path(__file__).resolve().parents[1]
spec = importlib.util.spec_from_file_location('stages', BASE / 'scripts/stage_checks.py')
m = importlib.util.module_from_spec(spec); spec.loader.exec_module(m)
spec = importlib.util.spec_from_file_location('delivery_v2', BASE / 'scripts/delivery_check.py')
d = importlib.util.module_from_spec(spec); spec.loader.exec_module(d)
CASES = json.loads((BASE / 'fixtures/editorial_cases.json').read_text())


def review():
    return dict(verdict='pass', context='fresh', read_order=['rendered_manuscript', 'evidence_packet'],
                checks={key: dict(verdict='pass', findings=[dict(page=1, location='abstract / headline table',
                        finding='Fixture review: published 2.712, ours 2.730; bounded result and unavailable populations disclosed.')])
                        for key in m.EDITORIAL_CHECKS}, phrase_dispositions=[])


class Stages(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory(); self.addCleanup(self.tmp.cleanup)
        self.root = Path(self.tmp.name)
        (self.root / 'results.txt').write_text('Source table 2, p 4: 2.712; replication 2.730; two populations unavailable.')
        self.artifact = dict(id='results', path='results.txt', sha256=m.digest(self.root / 'results.txt'))
        claim = dict(id='C1', statement='Method A has lower error at n=1000', level='headline',
                     source_locator='Chapter 2, p 4 table 2', artifact_ids=['results'],
                     published=dict(value=2.712, units='percent'), ours=dict(value=2.730, units='percent'),
                     conditions='n=1000; normal population; expected one cell, completed one',
                     contrasts=[dict(definition='B minus A', units='percent', positive_means='A has lower error',
                                     published=13.184, ours=13.208)],
                     reproduction_deviation='ours minus source = 0.018 percentage points',
                     methods='Same estimator; independent simulation', uncertainty='Monte Carlo SE 0.02; source SE unknown',
                     multiplicity='One prespecified contrast; alpha .05', status='replicated',
                     status_reason='Ordering and conditional agreement supported in this population',
                     numerical='mismatch at printed precision', reconstruction_scope='limited reconstruction',
                     limitations=['Unknown original counts'],
                     stopping=dict(reason='Available contrast completed', attempted='Two methods evaluated',
                                   untested='Original random seeds unknown', resource_basis='One minute observed runtime',
                                   next_evidence='Original simulation counts'))
        blocked = copy.deepcopy(claim)
        blocked.update(id='C2', statement='A is robust across all three populations', status='blocked',
                       source_locator='Chapter 3, p 12', status_reason='Two original populations unavailable',
                       ours=dict(value=None, units='percent', unavailable_reason='Missing data for two populations'),
                       contrasts=[], contrast_not_applicable='Cannot compute cross-population effect without inputs')
        blocked['stopping'] = dict(reason='Data access prevents test', attempted='Repository and archive acquisition audit',
                                   untested='Two populations', resource_basis='No feasible reconstruction; acquisition attempts exhausted',
                                   next_evidence='Original population data')
        self.packet = dict(schema_version=1, scope='whole_dissertation', dissertation='Synthetic dissertation, chapters 1–3 and appendix',
                           artifacts=[self.artifact], sections=[dict(id='ch1', locator='p 1', claim_ids=[], exclusion_reason='Background only'),
                           dict(id='ch2', locator='p 4', claim_ids=['C1']), dict(id='ch3', locator='p 12', claim_ids=['C2']),
                           dict(id='appendix', locator='p 20', claim_ids=['C1'])],
                           inventory_audit=dict(reviewer='source reviewer', source_artifact_ids=['results'],
                                                rationale='Synthetic fixture inventory reconciled with all chapters and appendix'),
                           claims=[claim, blocked], headline_order=['C1', 'C2'],
                           synthesis='Partly replicated: conditional lower error, cross-population robustness not established',
                           limitations=['C1: unknown original counts', 'C2: two populations unavailable'])

        self.packet['replicated_work'] = dict(kind='dissertation', authors='Ada Smith', year='2020',
            title='Estimation accuracy', institution_or_venue='Example University', identifier='https://example.org/source',
            verification_locator='Title page and chapter 2', artifact_ids=['results'])
        self.packet['headline_effects'] = [dict(id='E1', claim_id='C1', contrast_index=0,
            estimand='B minus A', units='percent', positive_means='A has lower error',
            published_effect=13.184, ours_effect=13.208, estimate_status='resolved',
            tolerance=dict(kind='rounding', value=0.0005, decimals=3, basis='Half of the source printed unit'),
            magnitude='larger', direction='same direction', display_decimals=3,
            interpretation='descriptive point estimates; not equivalence', uncertainty_statement='Source simulation error unknown'),
            dict(id='E2', claim_id='C2', contrast_index=None, estimand='Robustness across populations', units='percent',
            positive_means='A has lower error', published_effect=None, ours_effect=None, estimate_status='unresolved',
            unresolved_reason='Two populations unavailable', tolerance=dict(kind='prespecified',value=0.01,basis='Planned comparison threshold'),
            magnitude='not established', direction='not established', display_decimals=3,
            interpretation='descriptive point estimates; not equivalence', uncertainty_statement='No cross-population estimate')]

    def test_valid_packet_keeps_blocked_headline(self):
        self.assertEqual(m.packet_errors(self.packet, self.root), [])

    def test_missing_headline_component(self):
        self.packet['headline_order'] = ['C1']
        self.assertTrue(m.packet_errors(self.packet, self.root))

    def test_missing_section_claim(self):
        self.packet['sections'][2]['claim_ids'] = []
        self.assertTrue(m.packet_errors(self.packet, self.root))

    def test_stale_evidence(self):
        (self.root / 'results.txt').write_text('different')
        self.assertTrue(m.packet_errors(self.packet, self.root))

    def test_missing_stopping_basis(self):
        del self.packet['claims'][1]['stopping']['resource_basis']
        self.assertTrue(m.packet_errors(self.packet, self.root))

    def test_null_value_needs_reason(self):
        self.packet['claims'][1]['ours']['unavailable_reason'] = ''
        self.assertTrue(m.packet_errors(self.packet, self.root))

    def test_correct_numbers_do_not_override_editorial_failure(self):
        for case in CASES:
            with self.subTest(case=case['name']):
                r = review()
                for key in case['failed_checks']:
                    r['checks'][key] = dict(verdict='fail', findings=[dict(page=1, location='abstract', finding=case['finding'])])
                # Even an inconsistent overall "pass" cannot override a failing item.
                cues = m.phrase_cues(case['abstract'])
                r['phrase_dispositions'] = [dict(cue_id=c['cue_id'], verdict='fail', reason=case['finding']) for c in cues]
                self.assertEqual(bool(m.editorial_errors(r, cues)), bool(case['failed_checks']))

    def test_no_blanket_word_ban(self):
        self.assertEqual(m.phrase_cues(CASES[2]['abstract']), [])

    def test_legitimate_flag_can_be_explained(self):
        cues = m.phrase_cues('The calibrated reference values remain unchanged under permutation.')
        r = review()
        self.assertTrue(m.editorial_errors(r, cues))
        r['phrase_dispositions'] = [dict(cue_id=cues[0]['cue_id'], verdict='pass', reason='Methodological invariance, not document history; reviewed on page 2.')]
        self.assertEqual(m.editorial_errors(r, cues), [])

    def test_missing_page_or_cold_read(self):
        for mutate in (lambda r: r.update(context='shared'), lambda r: r.update(read_order=['evidence_packet', 'rendered_manuscript']),
                       lambda r: r['checks']['standalone_prose']['findings'][0].update(page=0)):
            r = review(); mutate(r)
            self.assertTrue(m.editorial_errors(r, []))

    def delivery_record(self, case=CASES[2]):
        def save(name, content):
            (self.root / name).write_text(content)
            return dict(path=name, sha256=m.digest(self.root / name))
        abstract_text = case['abstract'] + ' Smith (2020) reported lower error for A and robustness across populations.'
        source = save('source.tex', r'\begin{abstract}'+abstract_text+r' \cite{smith2020}\end{abstract}'+case['introduction'])
        # A real PDF is required because acceptance extracts its link annotations.
        with fitz.open() as document:
            page = document.new_page()
            page.insert_textbox(fitz.Rect(50, 50, 550, 220), abstract_text)
            page.insert_text((50,250),'Effect magnitude (percent)', fontsize=9)
            page.insert_text((50,270),'B minus A 13.184 13.208 larger same direction tol 0.0005', fontsize=9)
            page.insert_text((50,290),'Robustness not established not established not established not established tol 0.01', fontsize=9)
            page.insert_text((50,310),'Descriptive point estimates; not equivalence.', fontsize=9)
            page.insert_text((50, 400), 'results.txt')
            page.insert_link({'kind':fitz.LINK_URI, 'from':fitz.Rect(50, 385, 150, 405), 'uri':'https://github.com/a/b/blob/master/results.txt'})
            document.save(self.root / 'main.pdf')
        pdf = dict(path='main.pdf', sha256=m.digest(self.root / 'main.pdf'))
        inventory = save('links.json', json.dumps(d._links.extract(self.root / 'main.pdf')))
        packet = save('packet.json', json.dumps(self.packet))
        template = save('template.tex', 'approved template fixture')
        writer = save('writer.json', json.dumps(dict(writer='writer', context='fresh', packet_sha256=packet['sha256'],
                     inputs=[packet, template, self.artifact], claim_map={'C1': 'p1 table', 'C2': 'p1 limit'},
                     limitations_map={'0': 'p1 uncertainty', '1': 'p1 missing inputs'},
                     first_page=dict(abstract=dict(bbox=[45,45,555,225], citation_key='smith2020',
                         source_identification='Smith (2020)', source_citation='Smith (2020)',
                         original_finding='reported lower error for A and robustness across populations',
                         verdict_evidence=case['abstract'].split('. ')[0], claim_ids=['C1','C2']),
                         table=dict(bbox=[45,235,555,320], magnitude_heading='Effect magnitude',
                         comparison_note='Descriptive point estimates; not equivalence.', rows=[
                         dict(effect_id='E1',bbox=[45,255,555,275],estimand_text='B minus A',tolerance_text='tol 0.0005'),
                         dict(effect_id='E2',bbox=[45,280,555,295],estimand_text='Robustness',tolerance_text='tol 0.01')])))))
        def git(*args):
            return subprocess.check_output(['git', '-C', str(self.root), *args], stderr=subprocess.DEVNULL).decode().strip()
        git('init'); git('config', 'user.name', 'Test'); git('config', 'user.email', 'test@example.invalid')
        git('add', '.'); git('commit', '-m', 'fixture'); rev = git('rev-parse', 'HEAD')
        def remote(item):
            item = dict(item)
            item.update(url=f'https://raw.githubusercontent.com/a/b/{rev}/'+item['path'], downloaded_path='remote-'+item['path'])
            (self.root / item['downloaded_path']).write_bytes((self.root / item['path']).read_bytes())
            return item
        r = dict(contract_version=2, repository='a/b', link_inventory=inventory, link_provenance=[], primary=dict(remote(pdf), role='manuscript'), source=remote(source),
                 evidence=[remote(self.artifact)], packet=packet, writer_manifest=writer,
                 artifact_revision=rev, reproduction_revision=rev, baseline_revision=rev,
                 template=dict(template, revision=rev), build_inputs=[source])
        r['review'] = dict(reviewer='independent reviewer', pdf_sha256=pdf['sha256'], source_sha256=source['sha256'],
                           build_inputs={source['path']:source['sha256']}, packet_sha256=packet['sha256'],
                           writer_manifest_sha256=writer['sha256'], items={k:'p1 specific review fixture' for k in d.REVIEW_ITEMS}, editorial=review())
        r['review']['pdf_links'] = dict(verdict='pass', inventory_sha256=inventory['sha256'], pdf_sha256=pdf['sha256'],
                                        findings=[dict(page=1, finding='results.txt points to master; visible filename inspected.')])
        return r

    def test_complete_delivery_and_stale_packet(self):
        r = self.delivery_record()
        self.assertEqual(d.check(r, self.root), [])
        r['review']['packet_sha256'] = '0'*64
        self.assertTrue(d.check(r, self.root))

    def test_hash_correct_buried_verdict_delivery_fails(self):
        r = self.delivery_record(CASES[0])
        self.assertEqual(d.check(r, self.root, legacy_audit=True), [])
        r['review']['editorial']['checks']['abstract_verdict_first']['verdict'] = 'fail'
        self.assertTrue(d.check(r, self.root))

    def test_hash_correct_draft_reference_requires_resolution(self):
        r = self.delivery_record(CASES[1])
        self.assertEqual(d.check(r, self.root, legacy_audit=True), [])
        self.assertTrue(d.check(r, self.root))

    def test_missing_limitation_map_and_shared_writer(self):
        r = self.delivery_record()
        w = json.loads((self.root / 'writer.json').read_text())
        w['context'] = 'shared'; del w['limitations_map']['1']
        (self.root / 'writer.json').write_text(json.dumps(w))
        r['writer_manifest']['sha256'] = m.digest(self.root / 'writer.json')
        errors = m.stage_errors(r, self.root)
        self.assertTrue(any('isolated' in e for e in errors))
        self.assertTrue(any('limitations_map' in e for e in errors))

    def test_malformed_editorial_records(self):
        for value in (None, [], {}, {'checks': None}):
            self.assertTrue(m.editorial_errors(value, []))

    def test_null_packet_fields(self):
        for key in self.packet:
            p = copy.deepcopy(self.packet); p[key] = None
            self.assertTrue(m.packet_errors(p, self.root), key)

    def test_missing_evidence_cannot_be_success_or_nonreplication(self):
        for status in ('replicated', 'not_replicated'):
            self.packet['claims'][1]['status'] = status
            self.assertTrue(m.packet_errors(self.packet, self.root))

    def test_nonfinite_result(self):
        self.packet['claims'][0]['ours']['value'] = float('nan')
        self.assertTrue(m.packet_errors(self.packet, self.root))

    def test_malformed_stage_records(self):
        r = self.delivery_record()
        for key in ('packet', 'writer_manifest', 'review', 'build_inputs'):
            for value in (None, [], ['invalid'], 'invalid', 123):
                bad = copy.deepcopy(r); bad[key] = value
                self.assertTrue(m.stage_errors(bad, self.root), (key, value))

    def test_null_claim_fields(self):
        for key in self.packet['claims'][0]:
            packet = copy.deepcopy(self.packet); packet['claims'][0][key] = None
            self.assertTrue(m.packet_errors(packet, self.root), key)

    def test_cli_migration_output_and_packet(self):
        r = self.delivery_record()
        record = self.root / 'delivery.json'; record.write_text(json.dumps(r))
        command = [sys.executable, str(BASE / 'scripts/delivery_check.py'), str(record), '--root', str(self.root)]
        current = json.loads(subprocess.check_output(command))
        self.assertTrue(current['current_acceptance'])
        historical = json.loads(subprocess.check_output(command + ['--legacy-audit']))
        self.assertFalse(historical['current_acceptance'])
        self.assertTrue(historical['legacy_audit'])
        packet = subprocess.run([sys.executable, str(BASE / 'scripts/stage_checks.py'), 'packet',
                                 str(self.root / 'packet.json'), '--root', str(self.root)], capture_output=True, text=True)
        self.assertEqual(packet.returncode, 0, packet.stdout + packet.stderr)
