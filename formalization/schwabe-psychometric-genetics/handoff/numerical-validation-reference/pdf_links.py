"""Extract final-PDF URI annotations and enforce repository navigation policy.

Requires PyMuPDF (see requirements.txt). Never infers destinations from TeX or
visible labels. No HTTP availability or redirect verification is performed.
"""
import argparse
import hashlib
import json
import posixpath
import re
from pathlib import Path
from urllib.parse import unquote, urlsplit


class LinkAuditError(ValueError):
    pass


def digest(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def extract(pdf):
    """Fail closed on unreadable/repaired PDFs or unsupported link actions."""
    try:
        import fitz
    except ImportError as exc:
        raise LinkAuditError('PyMuPDF unavailable; install scripts/requirements.txt') from exc
    try:
        with fitz.open(pdf) as doc:
            if not doc.is_pdf or doc.needs_pass or doc.xref_get_key(-1, 'Encrypt')[0] != 'null' or doc.is_repaired or len(doc) == 0:
                raise LinkAuditError('unreadable, encrypted, repaired, or empty PDF')
            links = []
            for page in doc:
                resolved = {link['xref']: link for link in page.get_links() if link.get('xref')}
                for xref, annot_type, _ in page.annot_xrefs():
                    if annot_type != fitz.PDF_ANNOT_LINK:
                        continue
                    # Do not silently ignore actions the high-level API cannot read.
                    action = doc.xref_get_key(xref, 'A/S')
                    if doc.xref_get_key(xref, 'AA')[0] != 'null' or doc.xref_get_key(xref, 'A/Next')[0] != 'null':
                        raise LinkAuditError(f'page {page.number + 1}: unsupported chained/additional link action')
                    if action == ('name', '/GoTo') or (action[0] == 'null' and doc.xref_get_key(xref, 'Dest')[0] != 'null'):
                        continue  # Internal PDF destination, not a URI.
                    if action != ('name', '/URI'):
                        raise LinkAuditError(f'page {page.number + 1}: unsupported link action {action}')
                    kind, uri = doc.xref_get_key(xref, 'A/URI')
                    link = resolved.get(xref)
                    if kind != 'string' or not uri or not link or link.get('kind') != fitz.LINK_URI:
                        raise LinkAuditError(f'page {page.number + 1}: URI extraction incomplete')
                    rect = link['from']
                    label = ' '.join(page.get_textbox(rect).split())
                    prefix = ' '.join(page.get_textbox(fitz.Rect(page.rect.x0, rect.y0, rect.x0, rect.y1)).split())
                    item = dict(page=page.number + 1, annotation=xref, prefix=prefix,
                                rect=[round(float(v), 4) for v in rect], uri=uri, label=label)
                    item['id'] = hashlib.sha256(json.dumps(item, sort_keys=True).encode()).hexdigest()[:20]
                    links.append(item)
            return dict(schema_version=1, pdf_sha256=digest(pdf),
                        extractor=dict(name='PyMuPDF', version=fitz.VersionBind),
                        page_count=len(doc), links=links)
    except LinkAuditError:
        raise
    except Exception as exc:
        raise LinkAuditError('PDF annotation extraction failed: ' + type(exc).__name__) from exc


def issue(rule, message, link=None):
    return dict(rule=rule, page=link['page'] if link else None,
                uri=link['uri'] if link else None, message=message)


def format_issue(item):
    where = f"page {item['page']} URI {item['uri']}: " if item['page'] is not None else ''
    return f"links: {where}{item['rule']}: {item['message']}"


def policy_findings(inventory, repository, provenance, revisions):
    """Only commit landing pages with exact labels qualify as provenance."""
    errors = []
    if not isinstance(repository, str) or not re.fullmatch(r'[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+', repository):
        return [issue('repository_required', 'explicit owner/repository required')]
    if not isinstance(provenance, list) or not all(isinstance(p, dict) for p in provenance):
        return [issue('provenance_shape', 'provenance declarations must be a list')]
    declarations = {}
    for item in provenance:
        ident = item.get('link_id')
        if not isinstance(ident, str) or ident in declarations or set(item) != {'link_id', 'kind'} or item.get('kind') not in ('reproduction_revision', 'baseline_revision'):
            errors.append(issue('provenance_shape', 'invalid or duplicate provenance declaration'))
        else:
            declarations[ident] = item['kind']
    used = set()
    navigation = 0
    for link in inventory['links']:
        def fail(rule, message):
            errors.append(issue(rule, message, link))
        uri = link['uri']
        try:
            url = urlsplit(uri)
            host = unquote(url.hostname or '').lower().rstrip('.')
            if url.scheme not in ('http', 'https') or not host or url.username or url.password or url.port not in (None, 443, 80) or any(c.isspace() for c in uri) or '\\' in uri:
                fail('uri_syntax', 'unsupported or malformed URI')
                continue
        except ValueError:
            fail('uri_syntax', 'malformed URI')
            continue
        path = unquote(url.path)
        # Classify normalized aliases as our repository, then reject the
        # noncanonical original below rather than exempting it as external.
        parts = posixpath.normpath(path.replace("\\", '/')).strip('/').split('/')
        repo_parts = repository.lower().split('/')
        offset = 1 if host == 'api.github.com' and parts[:1] == ['repos'] else 0
        github_host = host in ('github.com', 'www.github.com', 'raw.githubusercontent.com', 'codeload.github.com', 'api.github.com')
        same_repo = github_host and [x.lower() for x in parts[offset:offset+2]] == repo_parts
        declaration = declarations.get(link['id'])
        if not same_repo:
            if declaration:
                fail('provenance_target', 'external citation cannot be declared repository provenance')
            continue
        tail = parts[offset+2:]
        canonical = (url.netloc == 'github.com' and url.scheme == 'https' and url.port is None
                     and url.path == path == '/'+'/'.join(parts) and not url.query and "\\" not in path
                     and not any(p in ('', '.', '..') for p in parts))
        if not canonical:
            fail('canonical_repository_uri', 'repository links must use canonical https://github.com URLs')
            continue
        if tail[:2] in (['blob', 'master'], ['tree', 'master']) and len(tail) > 2:
            if declaration:
                fail('provenance_target', 'artifact navigation cannot be declared provenance')
            navigation += 1
            continue
        if len(tail) == 2 and tail[0] == 'commit' and re.fullmatch('[0-9a-f]{40}', tail[1]):
            if declaration:
                used.add(link['id'])
                expected_label = {'reproduction_revision': 'Reproduction revision', 'baseline_revision': 'Historical baseline'}[declaration]
                # A full SHA may be clickable while the role label immediately
                # precedes it on the same rendered line (common academic style).
                prefix_pattern = r'(?:immutable )?reproduction revision$' if declaration == 'reproduction_revision' else r'historical baseline$'
                sha_label = link['label'] in (tail[1], tail[1]+':') and bool(re.search(r'\b'+prefix_pattern, link['prefix'], re.I))
                role_label = link['label'].casefold() == expected_label.casefold()
                if tail[1] != revisions.get(declaration) or not (role_label or sha_label) or url.fragment:
                    fail('provenance_identity', 'provenance target or visible label does not match its declared role')
            else:
                fail('provenance_required', 'commit link needs explicit provenance declaration')
            continue
        if not tail or (len(tail) == 2 and tail[0] in ('issues', 'pull') and tail[1].isdigit()):
            if declaration:
                fail('provenance_target', 'discussion/home link cannot be declared provenance')
            continue
        fail('master_navigation', 'artifact navigation must use blob/master or tree/master')
    if set(declarations) != used:
        errors.append(issue('unused_provenance', 'unused or mislabeled provenance declarations'))
    if not navigation:
        errors.append(issue('navigation_required', 'main paper must contain master artifact navigation'))
    return errors


def policy_errors(inventory, repository, provenance, revisions):
    return [format_issue(item) for item in policy_findings(inventory, repository, provenance, revisions)]


def audit(record, root):
    """Re-extract actual PDF and return deterministic, structured failures."""
    errors = []
    try:
        pdf = Path(root) / record['primary']['path']
        # Extract before trusting any saved inventory or review attestation.
        actual = extract(pdf)
        item = record['link_inventory']
        path = (Path(root) / item['path']).resolve()
        path.relative_to(Path(root).resolve())
        if digest(path) != item['sha256']:
            errors.append(issue('inventory_hash', 'stale inventory file hash'))
        saved = json.loads(path.read_text())
        if saved != actual:
            errors.append(issue('inventory_mismatch', 'inventory does not match annotations extracted from the final PDF'))
        review = record['review']['pdf_links']
        if not isinstance(review, dict) or review.get('inventory_sha256') != item['sha256'] or review.get('pdf_sha256') != actual['pdf_sha256']:
            errors.append(issue('review_hash', 'stale or missing PDF link review hashes'))
        if not isinstance(review, dict) or review.get('verdict') != 'pass':
            errors.append(issue('review_verdict', 'explicit PDF link review pass required'))
        findings = review.get('findings') if isinstance(review, dict) else None
        if not isinstance(findings, list) or not findings or any(
                not isinstance(f, dict) or type(f.get('page')) is not int or not 1 <= f['page'] <= actual['page_count']
                or not isinstance(f.get('finding'), str) or not f['finding'].strip() for f in findings):
            errors.append(issue('review_findings', 'page-specific link review findings required'))
        errors.extend(policy_findings(actual, record.get('repository'), record.get('link_provenance'), record))
    except LinkAuditError as exc:
        errors.append(issue('extraction_failed', str(exc)))
    except (KeyError, TypeError, ValueError, OSError) as exc:
        errors.append(issue('audit_incomplete', 'audit incomplete: ' + str(exc)))
    return errors


def check(record, root):
    return [format_issue(item) for item in audit(record, root)]


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('pdf', type=Path)
    parser.add_argument('--output', required=True, type=Path)
    args = parser.parse_args()
    try:
        result = extract(args.pdf)
        args.output.write_text(json.dumps(result, indent=2) + '\n')
    except (LinkAuditError, OSError) as exc:
        parser.exit(1, str(exc) + '\n')
