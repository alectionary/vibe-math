"""Validate a document-acquisition fetch manifest.

The structural checker implements the JSON Schema subset used by
.agents/skills/document-acquisition-queue/schema/fetch-manifest.schema.json
(type, const, enum, required, properties, additionalProperties, pattern,
numeric and length bounds, items, format, $ref, allOf, anyOf, oneOf, if/then/else).
Semantic checks cover secrets, stable ids, completeness, OCR, question counts,
and route outcomes. A front-matter preview or unreadable text cannot validate
as a completed screen or a zero question count.

Usage:
  python3 scripts/validate_fetch_manifest.py --self-check
  python3 scripts/validate_fetch_manifest.py path/to/manifest.json
"""
import calendar
import copy
import json
import pathlib
import re
import sys
from urllib.parse import parse_qs, urlsplit

ROOT = pathlib.Path(__file__).resolve().parents[1]
SKILL = ROOT / ".agents/skills/document-acquisition-queue"
SCHEMA_PATH = SKILL / "schema/fetch-manifest.schema.json"
EXAMPLE_PATH = SKILL / "examples/unl-aai3402936.manifest.json"
SEED_MANIFEST = ROOT / "literature/unl-sem/seed-source-manifest.json"
POSITIVE_SHA = "d39a696d20d6df6d9467a8906e67c40f336c3856ac74637f8db6629ca9fcc9d2"
POSITIVE_TEXT_SHA = "ed2977bdcd83119dfa4712654c2ce1e91b6af94934c6e4b8f4bf69a35b91a625"

KNOWN = {
    "$schema", "$id", "$defs", "$ref", "title", "description", "type", "required",
    "properties", "additionalProperties", "enum", "const", "pattern", "minLength",
    "maxLength", "minimum", "maximum", "minItems", "maxItems", "items", "format",
    "allOf", "anyOf", "oneOf", "if", "then", "else",
}
SECRET_QUERY = {
    "signature", "sig", "token", "access_token", "id_token", "refresh_token",
    "expires", "expires_at", "x-amz-algorithm", "x-amz-credential",
    "x-amz-signature", "x-amz-security-token", "x-amz-date", "policy",
    "key-pair-id", "credential", "credentials", "password", "passwd", "cookie",
    "session", "sessionid", "auth", "authorization", "jwt", "api_key", "apikey",
    "secret",
}
SECRET_KEY_NORMS = {
    "cookie", "setcookie", "authorization", "password", "passwd", "secret",
    "apikey", "accesstoken", "credential", "credentials", "session", "sessionid",
    "jwt", "refreshtoken", "idtoken",
}
EMBEDDED_SECRET = re.compile(
    r"(?i)(?:signature|sig|access_token|x-amz-signature|x-amz-credential|"
    r"key-pair-id|password|cookie)=|(?:set-cookie|cookie|authorization)\s*:|"
    r"\bbearer\s+|\bAKIA[0-9A-Z]{16}\b"
)
USERINFO = re.compile(r"https?://[^/\s:@]+:[^/\s@]+@")
TEMPORARY_HOSTS = ("media.proquest.com",)
TRANSPORT = {
    "bot_mitigation", "http_error", "browser_host_unavailable", "timeout",
    "network", "other",
}
ID_PATTERNS = {
    "unl_aai": re.compile(r"^AAI\d+$"),
    "unl_bepress": re.compile(r"^[a-z0-9]+/\d+$"),
    "proquest_docview": re.compile(r"^\d+$"),
    "proquest_publication": re.compile(r"^\d+$"),
    "campaign_record": re.compile(r"^[A-Z0-9]+(?:-[A-Z0-9]+)+$"),
    "doi": re.compile(r"^10\.\d{4,9}/\S+$"),
    "arxiv": re.compile(r"^(?:\d{4}\.\d{4,5}(?:v\d+)?|[a-z-]+(?:\.[A-Z]+)?/\d{7})$"),
    "url": re.compile(r"^https://\S+$"),
    "other": re.compile(r"^[a-z0-9][a-z0-9.+-]{1,40}:\S+$"),
}
MARKER = re.compile(r"<!--\s*fetch-manifest:\s*([A-Za-z0-9][A-Za-z0-9._-]*)\s*-->")
FENCE = re.compile(r"```(?:json)?\s*\n", re.IGNORECASE)


def load_schema():
    schema = json.loads(SCHEMA_PATH.read_text())
    walk_schema(schema)
    return schema


def walk_schema(schema, path="$schema"):
    if not isinstance(schema, dict):
        raise SystemExit(f"{path}: schema node is not an object")
    for key, value in schema.items():
        if key not in KNOWN:
            raise SystemExit(f"unsupported schema keyword {key} at {path}")
        if key in {"properties", "$defs"}:
            for name, sub in value.items():
                walk_schema(sub, f"{path}.{key}.{name}")
        elif key in {"items", "additionalProperties", "if", "then", "else"} and isinstance(value, dict):
            walk_schema(value, f"{path}.{key}")
        elif key in {"allOf", "anyOf", "oneOf"}:
            for index, sub in enumerate(value):
                walk_schema(sub, f"{path}.{key}[{index}]")


def resolve(schema, ref):
    if not ref.startswith("#/"):
        raise SystemExit(f"only local refs are supported, got {ref}")
    node = schema
    for part in ref[2:].split("/"):
        node = node[part]
    return node


def type_ok(instance, types):
    if isinstance(types, str):
        types = [types]
    for name in types:
        if name == "null" and instance is None:
            return True
        if name == "boolean" and isinstance(instance, bool):
            return True
        if name == "integer" and isinstance(instance, int) and not isinstance(instance, bool):
            return True
        if name == "number" and isinstance(instance, (int, float)) and not isinstance(instance, bool):
            return True
        if name == "string" and isinstance(instance, str):
            return True
        if name == "array" and isinstance(instance, list):
            return True
        if name == "object" and isinstance(instance, dict):
            return True
    return False


def utc_zulu(value):
    if not re.fullmatch(r"\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}Z", value):
        return False
    year, month, day = int(value[0:4]), int(value[5:7]), int(value[8:10])
    hour, minute, second = int(value[11:13]), int(value[14:16]), int(value[17:19])
    if not (1 <= month <= 12 and 0 <= hour <= 23 and 0 <= minute <= 59 and 0 <= second <= 59):
        return False
    return 1 <= day <= calendar.monthrange(year, month)[1]


def uri_ok(value):
    parts = urlsplit(value)
    return (
        parts.scheme == "https" and bool(parts.hostname) and parts.username is None
        and parts.password is None and " " not in value
    )


def format_ok(value, fmt):
    if fmt == "date-time":
        return utc_zulu(value)
    if fmt == "uri":
        return uri_ok(value)
    return False


def check(instance, schema, root, path="$"):
    if "$ref" in schema:
        return check(instance, resolve(root, schema["$ref"]), root, path)
    errors = []
    for sub in schema.get("allOf", []):
        errors += check(instance, sub, root, path)
    if "anyOf" in schema:
        branches = [check(instance, sub, root, path) for sub in schema["anyOf"]]
        if all(branches):
            errors.append(f"{path}: does not match any allowed schema")
    if "oneOf" in schema:
        ok = sum(not branch for branch in (check(instance, sub, root, path) for sub in schema["oneOf"]))
        if ok != 1:
            errors.append(f"{path}: expected exactly one matching schema, found {ok}")
    if "if" in schema:
        matched = not check(instance, schema["if"], root, path)
        branch = schema.get("then") if matched else schema.get("else")
        if branch:
            errors += check(instance, branch, root, path)
    if "const" in schema and instance != schema["const"]:
        errors.append(f"{path}: expected {schema['const']!r}")
    if "enum" in schema and instance not in schema["enum"]:
        errors.append(f"{path}: expected one of {', '.join(repr(item) for item in schema['enum'])}")
    if "type" in schema and not type_ok(instance, schema["type"]):
        errors.append(f"{path}: expected type {schema['type']}, found {type(instance).__name__}")
        return errors
    if isinstance(instance, str):
        if "minLength" in schema and len(instance) < schema["minLength"]:
            errors.append(f"{path}: shorter than {schema['minLength']}")
        if "maxLength" in schema and len(instance) > schema["maxLength"]:
            errors.append(f"{path}: longer than {schema['maxLength']}")
        if "pattern" in schema and not re.fullmatch(schema["pattern"], instance):
            errors.append(f"{path}: does not match {schema['pattern']}")
        if schema.get("format") and not format_ok(instance, schema["format"]):
            errors.append(f"{path}: invalid {schema['format']}")
    if isinstance(instance, (int, float)) and not isinstance(instance, bool):
        if "minimum" in schema and instance < schema["minimum"]:
            errors.append(f"{path}: below minimum {schema['minimum']}")
        if "maximum" in schema and instance > schema["maximum"]:
            errors.append(f"{path}: above maximum {schema['maximum']}")
    if isinstance(instance, list):
        if "minItems" in schema and len(instance) < schema["minItems"]:
            errors.append(f"{path}: fewer than {schema['minItems']} items")
        if "maxItems" in schema and len(instance) > schema["maxItems"]:
            errors.append(f"{path}: more than {schema['maxItems']} items")
        if "items" in schema:
            for index, item in enumerate(instance):
                errors += check(item, schema["items"], root, f"{path}[{index}]")
    if isinstance(instance, dict):
        props = schema.get("properties", {})
        for key in schema.get("required", []):
            if key not in instance:
                errors.append(f"{path}: missing {key}")
        additional = schema.get("additionalProperties", True)
        for key, value in instance.items():
            child = f"{path}.{key}"
            if key in props:
                errors += check(value, props[key], root, child)
            elif additional is False:
                errors.append(f"{path}: unexpected {key}")
            elif isinstance(additional, dict):
                errors += check(value, additional, root, child)
    return errors


def norm_key(key):
    return re.sub(r"[^a-z0-9]", "", key.lower())


def secret_errors(instance, path="$"):
    errors = []
    if isinstance(instance, dict):
        for key, value in instance.items():
            if norm_key(key) in SECRET_KEY_NORMS:
                errors.append(f"{path}.{key}: secret material in field name")
            errors += secret_errors(value, f"{path}.{key}")
        return errors
    if isinstance(instance, list):
        for index, value in enumerate(instance):
            errors += secret_errors(value, f"{path}[{index}]")
        return errors
    if not isinstance(instance, str):
        return errors
    if USERINFO.search(instance) or EMBEDDED_SECRET.search(instance):
        errors.append(f"{path}: secret material")
    for url in re.findall(r"https?://[^\s\"'<>]+", instance):
        parts = urlsplit(url)
        host = (parts.hostname or "").lower()
        if any(host == name or host.endswith("." + name) for name in TEMPORARY_HOSTS):
            errors.append(f"{path}: temporary media host {host}")
        for query_key in parse_qs(parts.query, keep_blank_values=True):
            if query_key.lower() in SECRET_QUERY:
                errors.append(f"{path}: secret material in query {query_key}")
    return errors


def semantic_errors(manifest):
    errors = []
    document = manifest.get("document") or {}
    ids = document.get("stable_ids") or []
    seen = set()
    campaigns = 0
    for index, item in enumerate(ids):
        if not isinstance(item, dict):
            continue
        scheme, value = item.get("scheme"), item.get("value")
        pattern = ID_PATTERNS.get(scheme)
        if pattern and isinstance(value, str) and not pattern.fullmatch(value):
            errors.append(f"$.document.stable_ids[{index}]: {scheme} value does not match {pattern.pattern}")
        key = (scheme, value)
        if key in seen:
            errors.append(f"$.document.stable_ids[{index}]: duplicate stable id")
        seen.add(key)
        if scheme == "campaign_record":
            campaigns += 1
        if scheme == "url" and isinstance(value, str):
            errors += secret_errors(value, f"$.document.stable_ids[{index}].value")
    if campaigns > 1:
        errors.append("$.document.stable_ids: more than one campaign_record")
    requested = manifest.get("requested_source_id")
    if requested and requested not in {item.get("value") for item in ids if isinstance(item, dict)}:
        errors.append("$.requested_source_id: not present in stable_ids")
    if manifest.get("supersedes") and manifest.get("supersedes") == manifest.get("manifest_id"):
        errors.append("$.supersedes: a manifest cannot replace itself")
    routes = manifest.get("routes_tried") if isinstance(manifest.get("routes_tried"), list) else []
    route_ids = [route.get("id") for route in routes if isinstance(route, dict)]
    if len(route_ids) != len(set(route_ids)):
        errors.append("$.routes_tried: duplicate route id")
    outcome = manifest.get("outcome")
    complete_bytes = [
        route for route in routes
        if isinstance(route, dict) and route.get("obtained_bytes") is True and route.get("error_category") is None
    ]
    preview_bytes = [
        route for route in routes
        if isinstance(route, dict) and route.get("obtained_bytes") is True and route.get("error_category") == "preview_only"
    ]
    if outcome == "verified" and not complete_bytes:
        errors.append("$.routes_tried: verified requires a route that obtained complete bytes")
    if outcome == "preview_only":
        if not preview_bytes:
            errors.append("$.routes_tried: preview_only requires a route that obtained preview bytes")
        if complete_bytes:
            errors.append("$.routes_tried: preview_only cannot also record complete bytes")
    if outcome == "restricted":
        if not any(isinstance(route, dict) and route.get("error_category") == "restricted" for route in routes):
            errors.append("$.routes_tried: restricted requires a restricted route")
        if any(isinstance(route, dict) and route.get("obtained_bytes") is True for route in routes):
            errors.append("$.routes_tried: restricted stored no document bytes")
    if outcome == "transport_failure":
        categories = [route.get("error_category") for route in routes if isinstance(route, dict)]
        if any(isinstance(route, dict) and route.get("obtained_bytes") is True for route in routes):
            errors.append("$.routes_tried: transport_failure stored no document bytes")
        if not any(category in TRANSPORT for category in categories):
            errors.append("$.routes_tried: transport_failure requires a transport error category")
    if outcome == "needs_human" and complete_bytes:
        errors.append("$.routes_tried: needs_human cannot record complete bytes; use verified")
    completeness = manifest.get("completeness") if isinstance(manifest.get("completeness"), dict) else {}
    classification = completeness.get("classification")
    flags = {
        "complete_body": (True, False, False),
        "preview": (None, False, True),
        "front_matter_only": (None, True, False),
        "identity_mismatch": (False, False, False),
        "not_obtained": (False, False, False),
    }
    if classification in flags:
        identity, front, preview = flags[classification]
        if identity is not None and completeness.get("identity_matched") is not identity:
            errors.append(f"$.completeness.identity_matched: inconsistent with {classification}")
        if completeness.get("front_matter_only") is not front or completeness.get("preview") is not preview:
            errors.append(f"$.completeness: flags inconsistent with {classification}")
    extraction = manifest.get("extraction") if isinstance(manifest.get("extraction"), dict) else {}
    method = extraction.get("method")
    status = extraction.get("status")
    readable = extraction.get("readable")
    if method == "born_digital" and (extraction.get("ocr_applied") is not False or extraction.get("ocr_engine") is not None):
        errors.append("$.extraction: born_digital does not apply OCR")
    if method == "ocr" and (extraction.get("ocr_applied") is not True or not extraction.get("ocr_engine")):
        errors.append("$.extraction: ocr requires ocr_applied and ocr_engine")
    if method == "mixed" and extraction.get("ocr_applied") is not True:
        errors.append("$.extraction: mixed requires ocr_applied")
    if method == "not_extracted" and (status != "not_attempted" or readable is not False or extraction.get("ocr_applied") is not False or extraction.get("text_sha256") is not None):
        errors.append("$.extraction: not_extracted has no text")
    if readable is True and (status != "extracted" or not extraction.get("text_sha256") or extraction.get("text_characters") is None):
        errors.append("$.extraction: readable text requires status extracted, text_sha256, and text_characters")
    if readable is False and status == "extracted":
        errors.append("$.extraction: extracted status requires readable text")
    if status == "unreadable":
        if readable is not False or not extraction.get("unreadable_reason"):
            errors.append("$.extraction: unreadable requires readable false and a reason")
        if extraction.get("ocr_applied") is not True:
            errors.append("$.extraction: unreadable requires an OCR attempt; otherwise use needs_human")
    if status == "partial" and readable is not False:
        errors.append("$.extraction: partial text is not a readable full document")
    artifact = manifest.get("artifact")
    screen = manifest.get("question_screen") if isinstance(manifest.get("question_screen"), dict) else {}
    candidates = screen.get("candidates") if isinstance(screen.get("candidates"), list) else []
    if isinstance(artifact, dict):
        locator = ((artifact.get("storage") or {}).get("locator")) or ""
        if locator.startswith("/") or "\\" in locator or ".." in pathlib.PurePosixPath(locator).parts or "://" in locator:
            errors.append("$.artifact.storage.locator: bot_local locator is a relative path")
        page_count = artifact.get("page_count")
        if isinstance(page_count, int):
            for index, candidate in enumerate(candidates):
                pages = ((candidate or {}).get("page_locator") or {}).get("pdf_pages") or []
                if any(isinstance(page, int) and page > page_count for page in pages):
                    errors.append(f"$.question_screen.candidates[{index}]: pdf page is outside page_count {page_count}")
    if screen.get("status") != "completed" and any(isinstance(item, dict) and item.get("counts_as_target") is True for item in candidates):
        errors.append("$.question_screen: counts_as_target requires a completed screen")
    if screen.get("status") == "completed" and isinstance(screen.get("question_count"), int):
        counted = sum(isinstance(item, dict) and item.get("counts_as_target") is True for item in candidates)
        if counted != screen["question_count"]:
            errors.append(
                f"$.question_screen.question_count: {screen['question_count']} does not match "
                f"{counted} counts_as_target candidate"
            )
    producer = manifest.get("producer") if isinstance(manifest.get("producer"), dict) else {}
    if producer.get("role") == "retrieval_bot":
        issue = manifest.get("issue")
        if not isinstance(issue, dict) or not all(issue.get(key) for key in ("number", "url", "comment_url")):
            errors.append("$.issue: retrieval_bot manifests name the issue number, url, and comment_url")
        if screen.get("screen_owner") == "research_agent" and screen.get("status") == "completed":
            errors.append("$.question_screen: retrieval bot cannot set a completed screen while screen_owner is research_agent")
    errors += secret_errors(manifest)
    return errors


def validate_manifest(manifest, schema=None):
    schema = schema or load_schema()
    if not isinstance(manifest, dict):
        return ["$: manifest is not an object"]
    return check(manifest, schema, schema) + semantic_errors(manifest)


def terminal_label(manifest):
    outcome = manifest["outcome"]
    if outcome == "verified":
        return "fetched"
    if outcome == "restricted":
        return "restricted"
    if outcome in ("preview_only", "needs_human"):
        return "needs-human"
    if outcome == "transport_failure":
        return None if manifest["retryable"] else "needs-human"
    raise ValueError(outcome)


def ledger_question_count(manifest, schema=None):
    """Return a ledger question count only for a valid completed screen."""
    if validate_manifest(manifest, schema):
        return None
    if manifest["question_screen"]["status"] != "completed":
        return None
    return manifest["question_screen"]["question_count"]


def consumable(manifest, schema=None):
    errors = validate_manifest(manifest, schema)
    if manifest.get("producer", {}).get("role") == "example":
        errors.append("$.producer.role: example is a fixture and is not merged into a ledger")
    return errors


def parse_comment(text):
    manifests, errors = [], []
    for match in MARKER.finditer(text):
        marker_id = match.group(1)
        rest = text[match.end():]
        fence = FENCE.search(rest)
        if not fence:
            errors.append(f"{marker_id}: missing JSON fence")
            continue
        body = rest[fence.end():]
        end = body.find("```")
        if end < 0:
            errors.append(f"{marker_id}: unterminated JSON fence")
            continue
        try:
            data = json.loads(body[:end])
        except json.JSONDecodeError as exc:
            errors.append(f"{marker_id}: invalid JSON: {exc}")
            continue
        if not isinstance(data, dict) or data.get("manifest_id") != marker_id:
            errors.append(f"{marker_id}: marker does not match manifest_id")
            continue
        manifests.append(data)
    if not manifests and not errors:
        errors.append("comment has no fetch-manifest marker")
    return manifests, errors


def active_manifests(manifests):
    replaced = {item.get("supersedes") for item in manifests if item.get("supersedes")}
    return [item for item in manifests if item.get("manifest_id") not in replaced]


def validate_path(path, schema):
    try:
        manifest = json.loads(pathlib.Path(path).read_text())
    except (OSError, json.JSONDecodeError) as exc:
        return [f"{path}: {exc}"]
    return [f"{path}: {error}" for error in validate_manifest(manifest, schema)]


def set_path(data, path, value):
    parts = path.split(".")
    cursor = data
    for part in parts[:-1]:
        cursor = cursor[int(part)] if part.isdigit() else cursor[part]
    last = parts[-1]
    cursor[int(last) if last.isdigit() else last] = value


def mutated(base, **changes):
    data = copy.deepcopy(base)
    for path, value in changes.items():
        set_path(data, path, value)
    return data


def expect_ok(name, data, schema):
    errors = validate_manifest(data, schema)
    if errors:
        raise SystemExit(name + " should pass:\n  " + "\n  ".join(errors))


def expect_fail(name, data, needle, schema):
    errors = validate_manifest(data, schema)
    blob = "\n".join(errors)
    if needle not in blob:
        raise SystemExit(name + f" should fail with {needle!r}:\n  " + blob.replace("\n", "\n  "))


def synthetic_ids(data):
    data["requested_source_id"] = "UNL-SEM-TEST"
    data["document"]["stable_ids"] = [
        {"scheme": "campaign_record", "value": "UNL-SEM-TEST"},
        {"scheme": "unl_aai", "value": "AAI99999999"},
    ]
    data["document"]["title"] = "Synthetic fixture"
    data["document"]["author"] = "Test Author"
    data["document"]["year"] = 2020
    return data


def self_check():
    schema = load_schema()
    example = json.loads(EXAMPLE_PATH.read_text())
    expect_ok("positive control", example, schema)
    seed = json.loads(SEED_MANIFEST.read_text())
    control = next(item for item in seed if item["dissertation_id"] == "UNL-SEM-D067")
    assert example["artifact"]["sha256"] == control["pdf_sha256"] == POSITIVE_SHA
    assert example["artifact"]["page_count"] == control["pdf_pages"] == 283
    assert example["artifact"]["byte_length"] == control["pdf_bytes"]
    assert example["extraction"]["text_sha256"] == control["text_sha256"] == POSITIVE_TEXT_SHA
    assert example["extraction"]["text_characters"] == control["text_characters"]
    assert example["extraction"]["method"] == "born_digital" and example["extraction"]["ocr_applied"] is False
    assert example["document"]["title"] == control["title"]
    assert example["document"]["author"] == control["author"] and example["document"]["year"] == control["year"]
    values = {item["value"] for item in example["document"]["stable_ids"]}
    assert {"AAI3402936", "305217740", "UNL-SEM-D067"} <= values
    assert ledger_question_count(example, schema) is None
    assert terminal_label(example) == "fetched"
    assert any("example" in error for error in consumable(example, schema))
    expect_fail(
        "unscreened zero",
        mutated(example, **{"question_screen.question_count": 0}),
        "null", schema,
    )
    preview = synthetic_ids(mutated(
        example,
        **{
            "manifest_id": "example-synthetic-front-matter",
            "outcome": "preview_only",
            "artifact.sha256": "a" * 64,
            "artifact.byte_length": 4096,
            "artifact.page_count": 9,
            "artifact.storage.locator": "local-extraction/literature/unl-sem/retrieval-repair/UNL-SEM-TEST.pdf",
            "completeness.classification": "front_matter_only",
            "completeness.identity_matched": True,
            "completeness.front_matter_only": True,
            "completeness.preview": False,
            "completeness.evidence": ["Synthetic nine-page front matter, not a dissertation body."],
            "extraction.text_sha256": "b" * 64,
            "extraction.text_characters": 100,
            "question_screen.status": "blocked",
            "routes_tried.3.error_category": "preview_only",
            "routes_tried.3.notes": "Downloaded bytes are front matter only.",
            "notes": "Synthetic front-matter fixture. Not a claim about AAI3402936.",
        },
    ))
    expect_ok("readable front matter", preview, schema)
    assert ledger_question_count(preview, schema) is None
    assert terminal_label(preview) == "needs-human"
    expect_fail(
        "front matter zero",
        mutated(preview, **{"question_screen.status": "completed", "question_screen.question_count": 0}),
        "null", schema,
    )
    unreadable = mutated(
        example,
        **{
            "extraction.status": "unreadable",
            "extraction.method": "ocr",
            "extraction.ocr_applied": True,
            "extraction.ocr_engine": "tesseract",
            "extraction.readable": False,
            "extraction.text_sha256": None,
            "extraction.text_characters": None,
            "extraction.unreadable_reason": "Synthetic fixture: glyph mapping still broken after OCR.",
            "question_screen.status": "blocked",
            "notes": "Synthetic unreadable extraction. Not a claim about Abbott's file.",
        },
    )
    expect_ok("verified but unreadable", unreadable, schema)
    assert ledger_question_count(unreadable, schema) is None
    expect_fail(
        "unreadable zero",
        mutated(unreadable, **{"question_screen.status": "completed", "question_screen.question_count": 0}),
        "null", schema,
    )
    completed = mutated(
        example,
        **{"question_screen.status": "completed", "question_screen.question_count": 0},
    )
    expect_ok("completed zero on readable text", completed, schema)
    assert ledger_question_count(completed, schema) == 0
    candidate = {
        "candidate_id": "fixture-page-24",
        "kind": "future_work",
        "statement": "Validator fixture candidate, not a ledger entry.",
        "page_locator": {"pdf_pages": [24], "printed": "p. 10", "section": "Research Questions"},
        "counts_as_target": False,
    }
    with_lead = mutated(
        completed,
        **{"question_screen.candidates": [candidate], "question_screen.question_count": 0},
    )
    expect_ok("completed zero with a non-target lead", with_lead, schema)
    counted = copy.deepcopy(candidate)
    counted["counts_as_target"] = True
    expect_fail(
        "count mismatch",
        mutated(with_lead, **{"question_screen.candidates": [counted]}),
        "counts_as_target", schema,
    )
    one = mutated(with_lead, **{"question_screen.candidates": [counted], "question_screen.question_count": 1})
    expect_ok("completed count matches the locator", one, schema)
    assert ledger_question_count(one, schema) == 1
    over = copy.deepcopy(candidate)
    over["page_locator"] = {"pdf_pages": [300], "printed": None, "section": None}
    expect_fail(
        "page past the end",
        mutated(with_lead, **{"question_screen.candidates": [over]}),
        "page_count", schema,
    )
    leads_only = mutated(
        example,
        **{
            "question_screen.status": "candidates_only",
            "question_screen.candidates": [candidate],
        },
    )
    expect_ok("candidates without a count", leads_only, schema)
    assert ledger_question_count(leads_only, schema) is None
    expect_fail(
        "target flag without a completed screen",
        mutated(leads_only, **{"question_screen.candidates": [counted]}),
        "counts_as_target", schema,
    )
    expect_fail(
        "verified preview classification",
        mutated(
            example,
            **{
                "completeness.classification": "preview",
                "completeness.preview": True,
                "completeness.identity_matched": True,
            },
        ),
        "complete_body", schema,
    )
    signed = mutated(
        example,
        **{"routes_tried.3.url": "https://cdn.example.test/file.pdf?signature=abc&expires=1"},
    )
    expect_fail("signed url", signed, "secret material", schema)
    temporary = mutated(
        example,
        **{"routes_tried.3.resolved_url": "https://media.proquest.com/media/hms/ORIG/2/WYgxI"},
    )
    expect_fail("temporary media host", temporary, "temporary media host", schema)
    cookie = mutated(example, **{"notes": "Cookie: session=abc"})
    expect_fail("cookie note", cookie, "secret material", schema)
    userinfo = mutated(example, **{"routes_tried.3.url": "https://user:pass@example.test/file.pdf"})
    expect_fail("url userinfo", userinfo, "secret material", schema)
    transport = synthetic_ids(mutated(
        example,
        **{
            "manifest_id": "example-synthetic-transport",
            "outcome": "transport_failure",
            "retryable": True,
            "artifact": None,
            "completeness.classification": "not_obtained",
            "completeness.identity_matched": False,
            "completeness.front_matter_only": False,
            "completeness.preview": False,
            "completeness.evidence": ["Browser host unavailable before any PDF bytes."],
            "extraction.status": "not_attempted",
            "extraction.method": "not_extracted",
            "extraction.ocr_applied": False,
            "extraction.ocr_engine": None,
            "extraction.readable": False,
            "extraction.text_sha256": None,
            "extraction.text_characters": None,
            "extraction.unreadable_reason": None,
            "question_screen.status": "blocked",
            "routes_tried": [{
                "id": "browser-host-down",
                "url": "https://digitalcommons.unl.edu/dissertations/AAI99999999/",
                "resolved_url": None,
                "method": "browser",
                "attempted_at": "2026-10-26T23:10:00Z",
                "http_status": None,
                "error_category": "browser_host_unavailable",
                "obtained_bytes": False,
                "notes": "Browser access host unavailable before navigation.",
            }],
            "notes": "Synthetic transport fixture.",
        },
    ))
    expect_ok("retryable transport failure", transport, schema)
    assert terminal_label(transport) is None
    assert terminal_label(mutated(transport, retryable=False)) == "needs-human"
    restricted = mutated(
        transport,
        **{
            "manifest_id": "example-synthetic-restricted",
            "outcome": "restricted",
            "retryable": False,
            "routes_tried.0.error_category": "restricted",
            "routes_tried.0.http_status": 200,
            "routes_tried.0.notes": "Checked route shows a campus-access restriction.",
            "notes": "Synthetic restricted fixture.",
        },
    )
    expect_ok("restricted route", restricted, schema)
    assert terminal_label(restricted) == "restricted"
    assert ledger_question_count(restricted, schema) is None
    bot = mutated(
        leads_only,
        **{
            "manifest_id": "bot-unl-aai3402936-candidates",
            "producer.role": "retrieval_bot",
            "producer.name": "retrieval-bot",
            "issue": {
                "repository": "alectionary/vibe-math",
                "number": 1000,
                "url": "https://github.com/alectionary/vibe-math/issues/1000",
                "comment_url": "https://github.com/alectionary/vibe-math/issues/1000#issuecomment-1",
            },
        },
    )
    expect_ok("bot candidates", bot, schema)
    assert consumable(bot, schema) == []
    assert ledger_question_count(bot, schema) is None
    expect_fail(
        "bot completed screen",
        mutated(bot, **{"question_screen.status": "completed", "question_screen.question_count": 0, "question_screen.candidates": []}),
        "screen_owner", schema,
    )
    comment = "<!-- fetch-manifest: example-unl-aai3402936-verified -->\n```json\n" + json.dumps(example) + "\n```\n"
    parsed, errors = parse_comment(comment)
    assert errors == [] and parsed == [example]
    _, mismatch = parse_comment(comment.replace("example-unl-aai3402936-verified -->", "other-manifest-id -->", 1))
    assert any("marker" in error for error in mismatch)
    successor = mutated(example, **{"manifest_id": "example-unl-aai3402936-r2", "supersedes": example["manifest_id"]})
    active = active_manifests([example, successor])
    assert [item["manifest_id"] for item in active] == ["example-unl-aai3402936-r2"]
    assert len(active_manifests([example, mutated(example, **{"manifest_id": "example-unl-aai3402936-alt"})])) == 2
    print("PASS: fetch-manifest self-check (positive control, preview, unreadable, secrets, labels).")


def main(argv):
    if argv == ["--self-check"]:
        self_check()
        return 0
    if not argv or argv[0].startswith("-"):
        print(__doc__.strip())
        return 2
    schema = load_schema()
    failed = False
    for path in argv:
        errors = validate_path(path, schema)
        if errors:
            failed = True
            print("\n".join(errors))
    if failed:
        return 1
    print(f"PASS: {len(argv)} fetch manifest(s).")
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
