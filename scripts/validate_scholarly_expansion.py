"""Validate expansion provenance and counts; does not certify published proofs."""
from pathlib import Path
from urllib.parse import urlparse
import hashlib
import importlib.util
import json
import re

ROOT = Path(__file__).resolve().parent.parent
DATA = ROOT / 'literature'
load = lambda name: json.loads((DATA / name).read_text())
review = load('scholarly-expansion-review.json')
rows = {r['id']: r for r in load('open-problems.json')}
papers = {p['id']: p for p in load('papers.json') + load('followups.json')}
manifest = {m['paper_id']: m for m in load('downstream-source-manifest.json')}
added = [rows[key] for key in review['added_target_ids']]
assert len(added) == review['added_entries'] == 57
assert sum(r['eligible_for_coverage'] for r in added) == review['added_eligible_targets'] == 27
assert len(review['added_paper_ids']) == 21
assert len(set(review['added_target_ids'])) == len(added)
for pid in review['added_paper_ids']:
    assert pid in papers and pid in manifest
    m = manifest[pid]
    source = ROOT / m['local_file']
    if source.exists():
        assert hashlib.sha256(source.read_bytes()).hexdigest() == m['sha256']
    text = ROOT / m['extracted_text_file']
    if text.exists():
        assert hashlib.sha256(text.read_bytes()).hexdigest() == m['extracted_text_sha256']
for entry in added:
    assert entry['added_on'] == '2026-10-22'
    assert not entry.get('verified_artifact')
    assert entry['lean_proof_status'] != 'verified_complete_lean_proof'
    for occurrence in entry['occurrences']:
        assert occurrence['source_id'] in review['added_paper_ids']
        assert occurrence['source_sha256'] == manifest[occurrence['source_id']]['sha256']
for merge in review['merged_occurrences']:
    assert any(o['source_id'] == merge['source_id']
               for o in rows[merge['target_id']]['occurrences'])
assert len(rows['L-F07-Q6.3']['occurrences']) == 2
assert rows['L-F14-efficient']['current_resolution_status'] == 'later_parameterized_answer_in_primary_literature'
assert rows['L-P32-Conway-existence']['lean_statement_status'] == 'identified_lean_statement_not_build_verified'
for rid in ['L-P29-period-bound', 'L-P32-triangle-bound', 'L-P32-SOS-certificate']:
    assert not rows[rid]['eligible_for_coverage']

queries = load('scholarly-expansion-searches.json')
assert sum(len(b['queries']) for b in queries['batches']) == 60
assert len(queries['google_scholar']) == 2
assert all(q['status'] == 'inaccessible_via_web_tool' for q in queries['google_scholar'])
author_searches = load('expansion-openalex-author-searches.json')['searches']
assert len(author_searches) == 30
assert sum(s['status'] == 'retrieved' for s in author_searches) == 26
assert len(load('expansion-openalex-title-searches.json')) == 6
assert len(load('expansion-openalex-forward-citations.json')['searches']) == 6
github = load('expansion-github-lean-searches.json')
assert len(github['searches']) == 8 and github['limit_per_query'] == 10
assert len(load('expansion-local-lean-searches.json')['searches']) == 7
for candidate in load('expansion-lean-candidates.json'):
    assert candidate['comparison_status']
    if candidate['status'] == 'retrieved':
        assert candidate['comparison']
        path = ROOT / candidate['local_file']
        if path.exists():
            assert hashlib.sha256(path.read_bytes()).hexdigest() == candidate['sha256']

spec = importlib.util.spec_from_file_location('graph_checks', ROOT / 'scripts/check_expansion_graphs.py')
checks = importlib.util.module_from_spec(spec)
spec.loader.exec_module(checks)
assert checks.check() == load('expansion-graph-checks.json')
doc = (DATA / 'SCHOLARLY-EXPANSION.md').read_text()
for href in re.findall(r'\]\(([^)]+)\)', doc):
    url = urlparse(href)
    if not url.scheme and url.path:
        assert (DATA / url.path).exists(), href
assert '1/101 (0.99%)' in doc and '1/74 (1.35%)' in doc
print('Validated 21 added papers, 57 entries, 27 eligible additions, source hashes, question merges, bounded searches, Lean evidence distinctions and both finite graph counterchecks.')
