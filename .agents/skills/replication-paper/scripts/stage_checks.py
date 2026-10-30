"""Structural stage contracts and phrase review cues; never a semantic certifier."""
import argparse
import hashlib
import json
import math
import re
from pathlib import Path

EDITORIAL_CHECKS = (
    'abstract_verdict_first', 'introduction_verdict_first', 'standalone_prose',
    'headline_fidelity', 'claim_coverage', 'limitations_preserved',
    'scientific_process_distinction',
)
STATUSES = {'replicated', 'partly_replicated', 'not_replicated', 'not_established', 'blocked'}
CUES = re.compile(
    r'previous\s+(?:draft|version\s+of\s+(?:this|the)\s+(?:paper|manuscript))'
    r'|earlier\s+(?:draft|manuscript)|remain(?:s)?\s+unchanged'
    r'|latest\s+continuation|permission\s+retr(?:y|ies)'
    r'|(?:now|still)\s+(?:awaiting|pending)\s+(?:approval|merge|release)', re.I)


def digest(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def text(value):
    return isinstance(value, str) and bool(value.strip())


def object_list(value):
    return isinstance(value, list) and bool(value) and all(isinstance(x, dict) for x in value)


def strings(value):
    return isinstance(value, list) and bool(value) and all(text(x) for x in value)


def artifact_errors(item, root, label):
    if not isinstance(item, dict):
        return [label + ': artifact object required']
    try:
        root = Path(root).resolve()
        path = (root / item['path']).resolve()
        path.relative_to(root)
        if path == root or digest(path) != item['sha256']:
            return [label + ': stale artifact hash']
    except (KeyError, TypeError, ValueError, OSError):
        return [label + ': invalid or unavailable artifact']
    return []


def packet_errors(packet, root):
    errors = []
    if not isinstance(packet, dict):
        return ['packet: object required']
    if packet.get('schema_version') != 1 or packet.get('scope') != 'whole_dissertation':
        errors.append('packet: version 1 whole_dissertation scope required')
    for key in ('dissertation', 'synthesis'):
        if not text(packet.get(key)):
            errors.append('packet: missing ' + key)
    if not strings(packet.get('limitations')):
        errors.append('packet: explicit limitations required')
    artifacts = packet.get('artifacts')
    ids = set()
    if not object_list(artifacts):
        errors.append('packet: artifacts required')
        artifacts = []
    for item in artifacts:
        ident = item.get('id')
        if not text(ident) or ident in ids:
            errors.append('packet: unique artifact id required')
        elif text(ident):
            ids.add(ident)
        errors.extend(artifact_errors(item, root, 'packet artifact'))
    claims = packet.get('claims')
    if not object_list(claims):
        errors.append('packet: claims required')
        claims = []
    claim_ids, headlines = set(), set()
    for claim in claims:
        ident = claim.get('id')
        if not text(ident) or ident in claim_ids:
            errors.append('packet: unique claim id required')
        else:
            claim_ids.add(ident)
        label = 'claim ' + str(ident)
        for key in ('statement', 'source_locator', 'conditions', 'methods', 'uncertainty',
                    'multiplicity', 'status_reason', 'numerical', 'reconstruction_scope',
                    'reproduction_deviation'):
            if not text(claim.get(key)):
                errors.append(label + ': missing ' + key)
        if claim.get('level') not in ('headline', 'supporting'):
            errors.append(label + ': invalid level')
        elif claim['level'] == 'headline' and text(ident):
            headlines.add(ident)
        if not text(claim.get('status')) or claim['status'] not in STATUSES:
            errors.append(label + ': invalid scientific status')
        refs = claim.get('artifact_ids')
        if not strings(refs) or not set(refs).issubset(ids):
            errors.append(label + ': source/result artifacts required')
        for key in ('published', 'ours'):
            value = claim.get(key)
            if not isinstance(value, dict) or 'value' not in value or not text(value.get('units')):
                errors.append(label + ': invalid ' + key)
            elif value['value'] is None:
                if not text(value.get('unavailable_reason')):
                    errors.append(label + ': explain missing ' + key)
            elif isinstance(value['value'], float) and not math.isfinite(value['value']):
                errors.append(label + ': result must be finite')
            elif isinstance(value['value'], bool) or not isinstance(value['value'], (str, int, float)) or value['value'] == '':
                errors.append(label + ': invalid result value')
        if claim.get('status') in ('replicated', 'not_replicated') and any(
                not isinstance(claim.get(k), dict) or claim[k].get('value') is None for k in ('published', 'ours')):
            errors.append(label + ': replication verdict requires both results')
        contrasts = claim.get('contrasts')
        if contrasts == []:
            if not text(claim.get('contrast_not_applicable')):
                errors.append(label + ': explain absent scientific contrast')
        elif not object_list(contrasts):
            errors.append(label + ': contrasts list required')
        else:
            for contrast in contrasts:
                if not all(text(contrast.get(k)) for k in ('definition', 'units', 'positive_means')):
                    errors.append(label + ': signed contrast definition required')
                for key in ('published', 'ours'):
                    if key not in contrast or (contrast[key] is None and not text(contrast.get('unavailable_reason'))):
                        errors.append(label + ': contrast values or missing-value reason required')
                    elif contrast[key] is not None and (isinstance(contrast[key], bool) or not isinstance(contrast[key], (int, float))):
                        errors.append(label + ': contrast must be numeric')
                    elif isinstance(contrast[key], float) and not math.isfinite(contrast[key]):
                        errors.append(label + ': contrast must be finite')
        if not strings(claim.get('limitations')):
            errors.append(label + ': explicit limitations required')
        stop = claim.get('stopping')
        if not isinstance(stop, dict) or not all(text(stop.get(k)) for k in ('reason', 'attempted', 'untested', 'resource_basis', 'next_evidence')):
            errors.append(label + ': justified stopping record required')
    order = packet.get('headline_order')
    if not strings(order) or len(set(order)) != len(order) or set(order) != headlines:
        errors.append('packet: headline order must cover every headline component')
    sections = packet.get('sections')
    covered, section_ids = set(), set()
    if not object_list(sections):
        errors.append('packet: chapter/appendix inventory required')
        sections = []
    for section in sections:
        ident = section.get('id')
        if not text(ident) or ident in section_ids or not text(section.get('locator')):
            errors.append('packet: unique section id and locator required')
        else:
            section_ids.add(ident)
        refs = section.get('claim_ids')
        if refs == [] and text(section.get('exclusion_reason')):
            continue
        if not strings(refs) or not set(refs).issubset(claim_ids):
            errors.append('packet: invalid section claim coverage')
        else:
            covered.update(refs)
    if covered != claim_ids:
        errors.append('packet: claims absent from chapter inventory')
    audit = packet.get('inventory_audit')
    if not isinstance(audit, dict) or not all(text(audit.get(k)) for k in ('reviewer', 'rationale')):
        errors.append('packet: source-reading inventory audit required')
    else:
        refs = audit.get('source_artifact_ids')
        if not strings(refs) or not set(refs).issubset(ids):
            errors.append('packet: inventory source artifacts required')
    return errors


def phrase_cues(source, label='source'):
    """Narrow phrases only. An occurrence requires judgment, not automatic rejection."""
    cues = []
    for match in CUES.finditer(source):
        line = source.count('\n', 0, match.start()) + 1
        ident = hashlib.sha256(f'{label}:{match.start()}:{match.group()}'.encode()).hexdigest()[:16]
        cues.append(dict(cue_id=ident, path=label, line=line, phrase=match.group()))
    return cues


def editorial_errors(review, cues):
    if not isinstance(review, dict):
        return ['editorial: explicit review required']
    errors = []
    if review.get('verdict') != 'pass':
        errors.append('editorial: overall verdict must pass')
    if review.get('context') != 'fresh' or review.get('read_order') != ['rendered_manuscript', 'evidence_packet']:
        errors.append('editorial: independent cold read before evidence required')
    checks = review.get('checks')
    checks = checks if isinstance(checks, dict) else {}
    for key in EDITORIAL_CHECKS:
        item = checks.get(key)
        if not isinstance(item, dict) or item.get('verdict') != 'pass':
            errors.append('editorial: missing or failing ' + key)
            continue
        findings = item.get('findings')
        if not object_list(findings) or any(type(f.get('page')) is not int or f['page'] < 1 or not text(f.get('location')) or not text(f.get('finding')) for f in findings):
            errors.append('editorial: page-specific findings required for ' + key)
    dispositions = review.get('phrase_dispositions')
    if not isinstance(dispositions, list) or not all(isinstance(d, dict) for d in dispositions):
        return errors + ['editorial: phrase dispositions list required']
    seen = []
    for d in dispositions:
        ident = d.get('cue_id')
        if not text(ident) or d.get('verdict') != 'pass' or not text(d.get('reason')):
            errors.append('editorial: unresolved phrase cue')
        if text(ident):
            seen.append(ident)
    if len(set(seen)) != len(seen) or set(seen) != {c['cue_id'] for c in cues}:
        errors.append('editorial: phrase dispositions do not cover current cues exactly')
    return errors


def stage_errors(record, root):
    if not isinstance(record, dict):
        return ['delivery: object required']
    errors = []
    def obj(value):
        return value if isinstance(value, dict) else {}
    if record.get('contract_version') != 2:
        return ['delivery contract_version 2 required; historical records need --legacy-audit']
    loaded = {}
    for name in ('packet', 'writer_manifest'):
        item = record.get(name)
        found = artifact_errors(item, root, name)
        errors.extend(found)
        if not found:
            try:
                loaded[name] = json.loads((Path(root) / item['path']).read_text())
            except (OSError, ValueError):
                errors.append(name + ': invalid JSON')
    packet, writer = loaded.get('packet'), loaded.get('writer_manifest')
    errors.extend(packet_errors(packet, root))
    if not isinstance(writer, dict):
        errors.append('writer: manifest required')
    else:
        if not text(writer.get('writer')) or writer.get('context') != 'fresh':
            errors.append('writer: isolated writing context required')
        if writer.get('packet_sha256') != obj(record.get('packet')).get('sha256'):
            errors.append('writer: stale evidence handoff')
        inputs = writer.get('inputs')
        if not object_list(inputs):
            errors.append('writer: actual input manifest required')
        else:
            for item in inputs:
                errors.extend(artifact_errors(item, root, 'writer input'))
            required = [record.get('packet'), record.get('template')]
            for item in required:
                if isinstance(item, dict) and not any(i.get('path') == item.get('path') and i.get('sha256') == item.get('sha256') for i in inputs):
                    errors.append('writer: inputs must include packet and template')
        if isinstance(packet, dict):
            for field, expected in [('claim_map', {c.get('id') for c in (packet.get('claims') if isinstance(packet.get('claims'), list) else []) if isinstance(c, dict) and text(c.get('id'))}),
                                    ('limitations_map', {str(i) for i, _ in enumerate(packet.get('limitations') if isinstance(packet.get('limitations'), list) else [])})]:
                mapping = writer.get(field)
                if not isinstance(mapping, dict) or set(mapping) != expected or not all(text(v) for v in mapping.values()):
                    errors.append('writer: incomplete ' + field)
    review = record.get('review')
    review = review if isinstance(review, dict) else {}
    for name in ('packet', 'writer_manifest'):
        if review.get(name + '_sha256') != obj(record.get(name)).get('sha256') or not review.get(name + '_sha256'):
            errors.append('review: stale ' + name + ' hash')
    if isinstance(writer, dict) and writer.get('writer') == review.get('reviewer'):
        errors.append('review: reviewer must be independent of writer')
    cues = []
    inputs = record.get('build_inputs', [])
    if not object_list(inputs):
        errors.append('editorial: declared build inputs required')
    for item in inputs if isinstance(inputs, list) else []:
        if not isinstance(item, dict) or not isinstance(item.get('path'), str):
            continue
        path = Path(root) / item['path']
        if path.suffix.lower() in ('.tex', '.txt', '.md', '.bib', '.csv'):
            try:
                cues.extend(phrase_cues(path.read_text(), item['path']))
            except (OSError, UnicodeError):
                errors.append('editorial: cannot scan text input ' + item['path'])
    errors.extend(editorial_errors(review.get('editorial'), cues))
    return errors


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    sub = parser.add_subparsers(dest='command', required=True)
    p = sub.add_parser('packet'); p.add_argument('path'); p.add_argument('--root', required=True)
    p = sub.add_parser('cues'); p.add_argument('path')
    args = parser.parse_args()
    if args.command == 'packet':
        errors = packet_errors(json.loads(Path(args.path).read_text()), args.root)
        print(json.dumps({'errors': errors, 'structural_check_only': True}, indent=2))
        raise SystemExit(bool(errors))
    print(json.dumps(phrase_cues(Path(args.path).read_text(), args.path), indent=2))
