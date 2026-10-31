"""Deterministic first-page evidence/arithmetic/render checks, not semantic review."""
import json
import math
import re
import unicodedata
from decimal import Decimal, ROUND_HALF_UP
from pathlib import Path

LABELS = {'smaller', 'same', 'larger', 'not established'}


def text(v):
    return isinstance(v, str) and bool(v.strip())


def number(v):
    try:
        return type(v) in (int, float) and math.isfinite(v)
    except OverflowError:
        return False


def norm(v):
    v = re.sub(r'([A-Za-z])-\s*\n\s*([a-z])', r'\1\2', v)
    return ' '.join(unicodedata.normalize('NFKC', v).replace('\u2212', '-').replace('–', '-').replace('—', '-').replace('--', '-').split()).casefold()


def dec(v):
    return Decimal(str(v))


def tolerance(row):
    t = row['tolerance']
    if not isinstance(t, dict) or not text(t.get('basis')) or not number(t.get('value')) or t['value'] < 0:
        raise ValueError('nonnegative tolerance and scientific basis required')
    if t.get('kind') == 'rounding':
        components = t.get('components', [dict(decimals=t.get('decimals'), weight=1)])
        if not isinstance(components, list) or not components:
            raise ValueError('rounding components required')
        bound = Decimal(0)
        for component in components:
            if not isinstance(component, dict):
                raise ValueError('rounding component must be an object')
            places, weight = component.get('decimals'), component.get('weight')
            if type(places) is not int or not 0 <= places <= 15 or not number(weight) or weight <= 0:
                raise ValueError('rounding component needs decimals and positive absolute weight')
            bound += dec(weight)*Decimal(5).scaleb(-places-1)
        if dec(t['value']) != bound:
            raise ValueError('rounding tolerance must equal sum of input rounding bounds')
    elif t.get('kind') != 'prespecified':
        raise ValueError('tolerance must be rounding-aware or prespecified')
    return dec(t['value'])


def signed_direction(row):
    if not all(number(row.get(k)) for k in ('published_effect', 'ours_effect')):
        return 'not established'
    source, ours = dec(row['published_effect']), dec(row['ours_effect'])
    sign = lambda v: (v > 0) - (v < 0)
    return 'same direction' if sign(source) == sign(ours) else 'reversed direction' if source*ours < 0 else 'zero vs nonzero'


def applicability_errors(row, claim=None, claims=None):
    """Exceptions are explicit evidence contracts, never inferred from null values."""
    mode = row.get('comparison_kind', 'scalar')
    if mode == 'scalar':
        return []
    errors = []
    if mode not in ('nonscalar', 'scalar_unestablished'):
        return ['invalid comparison_kind']
    if not text(row.get('applicability_reason')):
        errors.append('applicability_reason required')
    t = row.get('tolerance')
    kind = 'not_applicable' if mode == 'nonscalar' else 'unestablished'
    if not isinstance(t, dict) or t.get('kind') != kind or t.get('value') is not None or not text(t.get('basis')):
        errors.append('explicit '+kind+' null tolerance and basis required')
    if row.get('estimate_status') != 'unresolved':
        errors.append('exception requires unresolved magnitude status')
    expected_direction = signed_direction(row) if mode == 'scalar_unestablished' else 'not established'
    if row.get('magnitude') != 'not established' or row.get('direction') != expected_direction:
        errors.append('exception magnitude must be not established and direction must retain available signs')
    if mode == 'nonscalar':
        if any(row.get(k) is not None for k in ('published_effect', 'ours_effect', 'contrast_index', 'display_decimals')):
            errors.append('nonscalar row cannot contain scalar effects, precision or contrast index')
        if claim is not None:
            if claim.get('comparison_kind') != 'nonscalar':
                errors.append('nonscalar applicability must be declared on the source claim')
            refs = row.get('component_claim_ids')
            expected = claim.get('component_claim_ids', [])
            if not isinstance(expected, list) or not all(text(x) for x in expected):
                errors.append('invalid source component_claim_ids'); expected = []
            if not isinstance(refs, list) or not all(text(x) for x in refs) or len(set(refs)) != len(refs) or set(refs) != set(expected):
                errors.append('preserve complete component_claim_ids')
            elif any(x not in claims or x == claim.get('id') for x in refs):
                errors.append('component claim reference missing or self-referential')
            contrasts = claim.get('contrasts', [])
            if not isinstance(contrasts, list):
                errors.append('invalid source contrasts'); contrasts = []
            if len(contrasts) == 1 and isinstance(contrasts[0], dict) and any(number(contrasts[0].get(k)) for k in ('published', 'ours')):
                errors.append('single numeric contrast requires scalar comparison')
            indices = row.get('component_contrast_indices')
            if not isinstance(indices, list) or any(type(x) is not int for x in indices) or sorted(indices) != list(range(len(contrasts))):
                errors.append('preserve every parent contrast in component_contrast_indices')
            if not contrasts and not text(claim.get('contrast_not_applicable')):
                errors.append('nonscalar claim needs contrast_not_applicable rationale')
    else:
        idx = row.get('contrast_index')
        source_contrasts = claim.get('contrasts', []) if claim else []
        component_declared = (type(idx) is int and isinstance(source_contrasts, list) and 0 <= idx < len(source_contrasts) and isinstance(source_contrasts[idx], dict) and source_contrasts[idx].get('comparison_kind') == 'scalar_unestablished')
        if type(idx) is int and isinstance(source_contrasts, list) and 0 <= idx < len(source_contrasts) and isinstance(source_contrasts[idx], dict):
            retained_tolerance = source_contrasts[idx].get('tolerance')
            if isinstance(retained_tolerance, dict) and number(retained_tolerance.get('value')):
                errors.append('cannot discard retained numeric component tolerance')
        if claim is not None and claim.get('comparison_kind') != 'scalar_unestablished' and not component_declared:
            errors.append('unestablished tolerance must be declared on the source claim')
        if type(row.get('contrast_index')) is not int:
            errors.append('unestablished scalar requires a defined contrast index')
    return errors


def comparison(row):
    if row.get('comparison_kind', 'scalar') != 'scalar':
        errors = applicability_errors(row)
        if errors:
            raise ValueError('; '.join(errors))
        return 'not established', signed_direction(row) if row['comparison_kind'] == 'scalar_unestablished' else 'not established'
    tol = tolerance(row)
    if not all(number(row.get(k)) for k in ('published_effect','ours_effect')):
        return 'not established', 'not established'
    source, ours = dec(row['published_effect']), dec(row['ours_effect'])
    delta = abs(ours) - abs(source)
    magnitude = 'same' if abs(delta) <= tol else 'larger' if delta > 0 else 'smaller'
    sign = lambda v: (v > 0) - (v < 0)
    direction = 'same direction' if sign(source) == sign(ours) else 'reversed direction' if source*ours < 0 else 'zero vs nonzero'
    return magnitude if row['estimate_status'] == 'resolved' else 'not established', direction


def packet_errors(packet):
    errors = []
    if not isinstance(packet, dict):
        return ['first-page: evidence packet required']
    work = packet.get('replicated_work')
    if not isinstance(work, dict):
        errors.append('first-page: verified replicated_work metadata required')
    else:
        if work.get('kind') not in ('article', 'dissertation'):
            errors.append('first-page: source kind must be article or dissertation')
        for key in ('title', 'authors', 'year', 'institution_or_venue', 'identifier', 'verification_locator'):
            if not text(work.get(key)):
                errors.append('first-page: source metadata missing '+key)
        refs = work.get('artifact_ids')
        ids = {a.get('id') for a in packet.get('artifacts', []) if isinstance(a, dict) and text(a.get('id'))} if isinstance(packet.get('artifacts'), list) else set()
        if not isinstance(refs, list) or not refs or not all(text(r) and r in ids for r in refs):
            errors.append('first-page: source metadata needs hashed evidence artifacts')
    rows = packet.get('headline_effects')
    if not isinstance(rows, list) or not rows:
        return errors + ['first-page: headline_effects required']
    claims = {c.get('id'):c for c in packet.get('claims', []) if isinstance(c, dict) and text(c.get('id'))} if isinstance(packet.get('claims'), list) else {}
    seen, covered = set(), set()
    for row in rows:
        if not isinstance(row, dict):
            errors.append('first-page: effect row must be an object'); continue
        ident = row.get('id'); label = 'first-page effect '+str(ident)
        if not text(ident) or ident in seen:
            errors.append(label+': unique id required')
        else:
            seen.add(ident)
        claim_id = row.get('claim_id')
        claim = claims.get(claim_id) if text(claim_id) else None
        if not claim or claim.get('level') != 'headline':
            errors.append(label+': headline claim reference required')
        else:
            covered.add(claim_id)
        errors.extend(label+': '+e for e in applicability_errors(row, claim, claims))
        for key in ('estimand', 'units', 'positive_means', 'uncertainty_statement'):
            if not text(row.get(key)):
                errors.append(label+': missing '+key)
        if row.get('interpretation') != 'descriptive point estimates; not equivalence':
            errors.append(label+': distinguish descriptive magnitude from inferential equivalence')
        state = row.get('estimate_status')
        if state not in ('resolved', 'unresolved', 'unstable'):
            errors.append(label+': invalid estimate status')
        if state != 'resolved' and not text(row.get('unresolved_reason')):
            errors.append(label+': unresolved/unstable estimates need a reason')
        for key in ('published_effect', 'ours_effect'):
            if not number(row.get(key)) and not (state != 'resolved' and row.get(key) is None):
                errors.append(label+': finite signed effect or unresolved null required')
        if claim and claim.get('status') == 'blocked' and state == 'resolved':
            errors.append(label+': blocked claim cannot have resolved effect comparison')
        idx = row.get('contrast_index')
        contrasts = claim.get('contrasts', []) if claim else []
        if type(idx) is int and isinstance(contrasts, list) and 0 <= idx < len(contrasts) and isinstance(contrasts[idx], dict):
            c = contrasts[idx]
            for a,b in [('estimand','definition'),('units','units'),('positive_means','positive_means'),('published_effect','published'),('ours_effect','ours')]:
                if row.get(a) != c.get(b):
                    errors.append(label+': inconsistent with source contrast '+a)
        elif idx is not None or state == 'resolved':
            errors.append(label+': valid scientific contrast_index required')
        if row.get('comparison_kind') == 'nonscalar' and claim:
            # Component comparisons are evidence-only: do not force a whole grid
            # into the first-page table or silently turn it into an aggregate.
            components = row.get('component_comparisons', [])
            contrasts = claim.get('contrasts', [])
            if not isinstance(contrasts, list):
                contrasts = []
            if not isinstance(components, list) or not all(isinstance(c, dict) for c in components):
                errors.append(label+': component_comparisons must be objects')
            else:
                indices = [c.get('contrast_index') for c in components]
                if any(type(i) is not int for i in indices) or sorted(indices) != list(range(len(contrasts))):
                    errors.append(label+': component comparisons must cover all parent contrasts exactly once')
                elif components:
                    if any(c.get('comparison_kind', 'scalar') == 'nonscalar' or c.get('claim_id') != claim_id for c in components):
                        errors.append(label+': components must be scalar comparisons of this parent')
                    else:
                        component_packet = dict(packet, claims=[claim], headline_effects=components)
                        errors.extend(label+' component: '+e for e in packet_errors(component_packet))
        if (row.get('comparison_kind', 'scalar') == 'scalar' or any(number(row.get(k)) for k in ('published_effect', 'ours_effect'))) and (type(row.get('display_decimals')) is not int or not 0 <= row['display_decimals'] <= 15):
            errors.append(label+': display_decimals required')
        try:
            expected, direction = comparison(row)
            if row.get('magnitude') != expected:
                errors.append(label+': magnitude must be '+expected)
            if row.get('direction') != direction:
                errors.append(label+': signed direction must be '+direction)
        except (KeyError, TypeError, ValueError, ArithmeticError):
            errors.append(label+': defined tolerance and comparable signed effects required')
    headlines = {ident for ident,c in claims.items() if c.get('level') == 'headline'}
    if not headlines or covered != headlines:
        errors.append('first-page: effect table must cover all headline claims')
    return errors


def source_plain(s):
    s = re.sub(r'(?<!\\)%[^\n]*', '', s)
    s = re.sub(r'\\(?:cite|citep|citet|parencite|textcite)\*?(?:\[[^\]]*\]){0,2}\{[^}]*\}', '', s)
    s = re.sub(r'\\[A-Za-z]+\*?', '', s)
    s = re.sub(r'\\([%&#_$])', r'\1', s)
    return norm(s.translate(str.maketrans('', '', '{}$')))


def display(value, places):
    if value is None:
        return 'not established'
    result = dec(value).quantize(Decimal(1).scaleb(-places), rounding=ROUND_HALF_UP)
    if value != 0 and result == 0:
        raise ValueError('display precision hides the signed effect')
    return format(result, 'f')


def bare_sequence(pattern, contents):
    """Match complete bare fields, not numbers embedded in arithmetic expressions."""
    match = re.search(pattern, contents)
    if not match:
        return False
    prefix = contents[:match.start()].rstrip(' ([{')
    suffix = contents[match.end():].lstrip(' )]}')
    operators = '*/×÷^%+-'
    return not (prefix and prefix[-1] in operators) and not (suffix and suffix[0] in operators)


def display_errors(effect, view, table_rect, region, row_rect=None):
    """Validate mapped cells without imposing column order on an existing table."""
    errors = []
    label = 'first-page '+effect['id']
    def cell(name):
        rect, contents = region(view[name])
        if not table_rect.contains(rect):
            raise ValueError('display cell outside first-page table/notes region')
        if row_rect is not None and (name in ('magnitude_bbox','direction_bbox') or (name=='values_bbox' and effect['estimate_status']=='resolved')) and not row_rect.contains(rect):
            raise ValueError('display cell outside its mapped row')
        return contents
    def signed_pair(values, places, contents, magnitude=False):
        tokens=[]
        for value, precision in zip(values, places):
            token=display(abs(value) if magnitude else value, precision)
            pattern=re.escape(token)
            if not magnitude and value >= 0:
                pattern=r'\+?'+pattern
            tokens.append(r'(?<![\w.+*/%-])'+pattern+r'(?![\w.])')
        return (bare_sequence(r'\s*(?:→|->|to)?\s+'.join(tokens), contents)
                or bare_sequence(r'\s*(?:→|->|to)\s*'.join(tokens), contents))
    try:
        if not isinstance(view,dict):raise ValueError('display mapping must be an object')
        mag=cell('magnitude_bbox')
        if not re.match(re.escape(effect['magnitude'])+r'(?:\s*[:*∗]|$)',mag):
            errors.append(label+': magnitude cell does not show computed label')
        aliases={'same direction':('same','same direction'),
                 'reversed direction':('reversed','reversed direction','reversed point estimate'),
                 'zero vs nonzero':('zero vs nonzero',),'not established':('not established',)}
        if cell('direction_bbox') not in aliases[effect['direction']]:
            errors.append(label+': direction cell does not show computed signed direction')
        values=[effect['published_effect'],effect['ours_effect']]
        if not any(number(v) for v in values):return errors
        if not all(number(v) for v in values):
            if view.get('form') != 'signed':
                raise ValueError('partial scalar evidence requires signed display')
            tokens = [re.escape(display(v, effect['display_decimals'])) for v in values]
            if not bare_sequence(r'(?<![\w.+*/%-])'+r'\s+'.join(tokens)+r'(?![\w.])', cell('values_bbox')):
                errors.append(label+': partial scalar values do not match evidence')
            return errors
        places=view['decimals']
        if not isinstance(places,list) or len(places)!=2 or not all(type(p) is int and 0<=p<=15 for p in places):
            raise ValueError('two display precisions required')
        form=view.get('form')
        if form not in ('signed','absolute_with_endpoints'):raise ValueError('explicit display form required')
        if not signed_pair(values,places,cell('values_bbox'),form=='absolute_with_endpoints'):
            errors.append(label+': displayed effect values do not match evidence')
        if form=='absolute_with_endpoints':
            for field, value in zip(('published_endpoints','ours_endpoints'),values):
                entry=view[field]; endpoints=entry['values']; precision=entry['decimals']
                if not isinstance(endpoints,list) or len(endpoints)!=2 or not all(number(x) for x in endpoints) or type(precision) is not int or not 0<=precision<=15:
                    raise ValueError('two displayed endpoints and precision required')
                endpoint_rect, rendered=region(entry['bbox'])
                if not table_rect.contains(endpoint_rect) or (row_rect is not None and not row_rect.contains(endpoint_rect)):
                    raise ValueError('endpoint cell outside table region')
                endpoint_tokens=[re.escape(display(x,precision)) for x in endpoints]
                if not bare_sequence(r'(?<![\w.+-])'+r'\s*/\s*'.join(endpoint_tokens)+r'(?![\w.])',rendered):
                    errors.append(label+': displayed endpoint pair absent')
                difference=dec(endpoints[1])-dec(endpoints[0])
                if abs(difference-dec(value)) > Decimal(1).scaleb(-precision) or (difference>0)-(difference<0) != (value>0)-(value<0):
                    errors.append(label+': endpoints do not support signed effect within rounding')
    except (KeyError,TypeError,ValueError,ArithmeticError) as exc:
        errors.append(label+': incomplete display mapping: '+str(exc))
    return errors


def check_data(packet, writer, source, pdf_path, editorial_checks):
    """Canonical adapter interface; callers must separately bind artifacts/hashes."""
    errors = []
    try:
        import fitz
        errors.extend(packet_errors(packet))
        if errors:
            return errors
        first = writer['first_page']; abstract = first['abstract']; table = first['table']
        source = re.sub(r'(?<!\\)%[^\n]*', '', source)
        match = re.search(r'\\begin\{abstract\}(.*?)\\end\{abstract\}', source, re.S)
        if not match:
            return ['first-page: supported LaTeX abstract environment required for source verification']
        abstract_source = match[1]
        key = abstract['citation_key']
        citation_groups = re.findall(r'\\(?:cite|citep|citet|parencite|textcite)\*?(?:\[[^\]]*\]){0,2}\{([^}]+)\}', abstract_source)
        if not text(key) or key not in {k.strip() for group in citation_groups for k in group.split(',')}:
            errors.append('first-page: replicated-work citation key missing from source abstract')
        if not isinstance(abstract.get('claim_ids'), list) or set(abstract['claim_ids']) != set(packet['headline_order']):
            errors.append('first-page: abstract must identify all original headline components')
        with fitz.open(pdf_path) as doc:
            if not doc.is_pdf or doc.needs_pass or not len(doc):
                raise ValueError('unreadable PDF')
            page = doc[0]
            def region(box):
                if not isinstance(box, list) or len(box) != 4 or not all(number(v) for v in box):
                    raise ValueError('page-1 rectangle must contain four finite coordinates')
                rect = fitz.Rect(box)
                if rect.is_empty or rect.is_infinite or not page.rect.contains(rect):
                    raise ValueError('page-1 rectangle out of bounds')
                return rect, norm(page.get_textbox(rect))
            abstract_rect, abstract_pdf = region(abstract['bbox'])
            for field in ('source_identification', 'source_citation', 'original_finding', 'verdict_evidence'):
                excerpt = abstract.get(field)
                if not text(excerpt) or norm(excerpt) not in abstract_pdf:
                    errors.append('first-page: abstract '+field+' absent from rendered page 1')
                if field not in ('source_citation', 'source_identification') and (not text(excerpt) or norm(excerpt) not in source_plain(abstract_source)):
                    errors.append('first-page: abstract '+field+' absent from source abstract')
            if abstract.get('original_finding') == abstract.get('verdict_evidence'):
                errors.append('first-page: original finding and our evidence need distinct excerpts')
            table_rect, table_pdf = region(table['bbox'])
            if abstract_rect.intersects(table_rect):
                errors.append('first-page: abstract and table regions must not overlap')
            heading = table.get('magnitude_heading')
            if heading != 'Effect magnitude' or norm(heading) not in table_pdf:
                errors.append('first-page: Effect magnitude column absent from rendered table')
            notes = table.get('comparison_note')
            if not text(notes) or norm(notes) not in table_pdf:
                errors.append('first-page: descriptive/tolerance note absent from rendered table region')
            if not text(notes) or not re.search(r'point[- ]estimat', norm(notes)) or not re.search(r'not[^.]*equivalence', norm(notes)):
                errors.append('first-page: table note must explicitly distinguish point estimates from equivalence')
            effects = {r['id']:r for r in packet['headline_effects']}
            rows = table.get('rows')
            if not isinstance(rows, list) or not all(isinstance(r, dict) for r in rows):
                raise ValueError('table row mappings required')
            mapped = [r.get('effect_id') for r in rows]
            if not all(text(x) for x in mapped) or len(set(mapped)) != len(mapped) or set(mapped) != set(effects):
                errors.append('first-page: table mapping must cover each effect exactly once')
            row_rects = []
            for row in rows:
                effect = effects.get(row.get('effect_id')) if text(row.get('effect_id')) else None
                if not effect:
                    continue
                rect, rendered = region(row['bbox'])
                if any(rect.intersects(other) for other in row_rects):
                    errors.append('first-page: table row regions must not overlap')
                row_rects.append(rect)
                unit_label = row.get('units_text', effect['units'])
                if not text(unit_label) or norm(unit_label) not in table_pdf:
                    errors.append('first-page '+effect['id']+': effect units absent from table')
                if not table_rect.contains(rect):
                    errors.append('first-page: row lies outside table region')
                exceptional = effect.get('comparison_kind', 'scalar') != 'scalar'
                if exceptional:
                    explanation = row.get('applicability_text')
                    if not text(explanation) or norm(explanation) not in rendered or norm(explanation) not in source_plain(source):
                        errors.append('first-page '+effect['id']+': applicability explanation missing from source/rendered row')
                    if 'not established' not in rendered:
                        errors.append('first-page '+effect['id']+': unresolved magnitude label absent')
                    if not text(row.get('estimand_text')) or norm(row['estimand_text']) not in rendered:
                        errors.append('first-page '+effect['id']+': estimand absent')
                    errors.extend(display_errors(effect, row.get('display'), table_rect, region, rect))
                    continue
                view = row.get('display')
                if view is not None:
                    errors.extend(display_errors(effect, view, table_rect, region, rect))
                else:
                    # Ordered bare tokens stop "same direction" from replacing a
                    # missing "same" magnitude cell; arithmetic is not a value cell.
                    tokens = [display(effect[k], effect['display_decimals']) for k in ('published_effect', 'ours_effect')]
                    tokens += [effect['magnitude'], effect['direction']]
                    pattern = r'\s+'.join(r'(?<![\w.+*/%-])'+re.escape(norm(t))+r'(?![\w.])' for t in tokens)
                    if not bare_sequence(pattern, rendered):
                        errors.append('first-page '+effect['id']+': rendered signed values/magnitude/direction missing or out of order')
                if exceptional:
                    continue
                for field in ('estimand_text', 'tolerance_text'):
                    target_text = table_pdf if field == 'tolerance_text' else rendered
                    if not text(row.get(field)) or norm(row[field]) not in target_text:
                        errors.append('first-page '+effect['id']+': rendered row missing '+field)
                tolerance_values = re.findall(r'[-+]?(?:[0-9]+(?:\.[0-9]*)?|\.[0-9]+)(?:[eE][-+]?[0-9]+)?', row.get('tolerance_text', '') or '')
                if not any(dec(v) == dec(effect['tolerance']['value']) for v in tolerance_values):
                    errors.append('first-page '+effect['id']+': displayed tolerance must include its declared value')
        review = editorial_checks if isinstance(editorial_checks, dict) else {}
        required = ['abstract_source_fidelity', 'effect_magnitude_fidelity']
        if any(r.get('comparison_kind', 'scalar') != 'scalar' for r in packet['headline_effects']):
            required.append('comparison_applicability')
        for name in required:
            item = review.get(name)
            if not isinstance(item, dict) or item.get('verdict') != 'pass':
                errors.append('first-page: explicit editorial pass required for '+name)
            if name == 'comparison_applicability' and isinstance(item, dict):
                findings = item.get('findings')
                if not isinstance(findings, list) or not findings or any(not isinstance(f, dict) or type(f.get('page')) is not int or f.get('page') != 1 or not text(f.get('location')) or not text(f.get('finding')) for f in findings):
                    errors.append('first-page: page-specific applicability findings required')
    except (KeyError, TypeError, ValueError, OSError, ArithmeticError, ImportError, RuntimeError) as exc:
        errors.append('first-page: incomplete verification: '+str(exc))
    return errors


def check(record, root):
    try:
        packet = json.loads((Path(root)/record['packet']['path']).read_text())
        writer = json.loads((Path(root)/record['writer_manifest']['path']).read_text())
        source = (Path(root)/record['source']['path']).read_text()
        return check_data(packet, writer, source, Path(root)/record['primary']['path'],
                          record['review']['editorial']['checks'])
    except (KeyError, TypeError, ValueError, OSError) as exc:
        return ['first-page: incomplete verification: '+str(exc)]
