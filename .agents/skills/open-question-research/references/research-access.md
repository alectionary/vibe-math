# Research access: GitHub, X and browser connections

Use this reference when choosing research search tools, setting up a new machine,
or diagnosing an access failure. Keep the access record in the investigation's
existing notes; the [worksheet](investigation.md) has a small table for it.

## Discover capabilities before depending on them

Make a short read-only check early, while independent proof or literature work
can still proceed. Discover available connectors, CLIs and browser tools through
the current environment's supported interfaces. A successful setup on another
machine does not establish installation, authentication or permissions here.

Distinguish these signals:

- Tool installed or browser listed: a possible route, not a completed search.
- Connection responds: transport works, but the target site may still require login.
- Target search returns inspected results: the operation and observed scope work.

Use a known-positive query to test relevant search filters before interpreting
empty results. Preserve effective queries, dates, result caps, inspected matches
and access limitations. Search results are discovery evidence; read the primary
source before relying on its mathematical claims.

## Choose a supported route

| Service | Preferred available route | Other useful coverage |
|---|---|---|
| GitHub | Applicable connector or authenticated `gh`, unless the user explicitly requests browser interaction | Signed-in browser extension for unsupported operations or UI-dependent searches; public indexed search as separately labeled supplementary coverage |
| X | Applicable connector; otherwise the user's signed-in browser extension | Desktop browser control when appropriate and available; public indexed search as separately labeled supplementary coverage |

For `gh`, `gh auth status` checks the existing login. Use supported search/read
commands for the relevant repository, code, issue or pull-request operation;
check current command help and endpoint limitations rather than assuming all
search types or pagination behave alike. Do not print tokens or request broader
account access merely to perform public research. A failed authentication check
under restricted network access is not by itself evidence that credentials need
replacement. Distinguish sandbox/network failure from a genuine login failure
before proposing reauthentication; use permitted retries and approval handling.

For browser work, use the current browser plugin/skill's discovery, connection
and interaction instructions. Prefer the requested browser family. Do not copy
another installation's runtime paths, extension IDs or browser/tab identifiers.
GitHub CLI access does not establish X access, and a working browser connection
does not establish signed-in access to either site. Do not use a fallback to
bypass a sign-in requirement, permission boundary or explicit browser choice.

## What another machine may need

Only set up the routes needed for the task. The options are:

- A connected service plugin, with the permissions needed for the intended reads.
- For CLI GitHub access: installed GitHub CLI, network access, and an authorized
  login where the selected operation requires one.
- For signed-in browser access: a supported browser, its browser-control plugin
  and official extension, the supported app-to-browser connection, and the user's
  existing site login. Verify an actual operation after setup.

Follow the current official/plugin setup flow. Tool discovery and read-only
checks do not authorize installing software, signing into accounts, expanding
permissions or changing computer security settings. Obtain any needed user
authorization through the applicable workflow; do not copy credentials, browser
profiles or native-host configuration from another machine. Setup is separate
from routine research, not an automatic installation requirement for every run.

## Locked screens, sleep and different control methods

Browser-extension operations and native desktop control are different routes.
A desktop-control failure while locked does not prove that the browser extension
also fails. A successful extension test does not prove that desktop interaction,
permission dialogs, downloads or every website operation will work while locked.
Sleep is a separate condition: do not infer sleep behavior from a screen-lock test.

If locked-screen capability matters, test a small read-only operation with the
user coordinating the lock. Record the environment, method, timing, operation,
result and whether lock status was independently observed or user-reported.
Do not lock/unlock the user's machine or change sleep/security settings as a
routine access check. The dated [research lesson](../../../../RESEARCH-LESSONS.md#browser-extensions-and-cli-access-can-avoid-a-desktop-dependency)
records this project's observed Edge/X test, without making it a portable guarantee.

## Opportunistic execution, mandatory accounting

Attempt a bounded GitHub/X pass early, saving useful links for later primary-text
reading. If a route is blocked, record the affected queries and continue work
that does not depend on that access. Try an authorized alternative when it
actually covers the operation. Public indexed results remain distinct from
searches performed directly on the service.

Retry at useful research phase boundaries, after the user reports access is
ready, or after a relevant connection/login/network change. Avoid repeated
unchanged polling. Before closeout, each required service search must have a
completed coverage record or an explicit access gap. Qualify any conclusion
that depends on missing coverage; do not claim a complete prior-art audit.
If that gap prevents the requested conclusion, explain the limitation directly.
This accounting rule does not authorize an indefinite wait, background monitoring
or a new scheduled task.

## Retrieve full text before recording an access gap

An archive landing record and its PDF may use different hosts and access routes.
Follow the actual Download link through the publisher page, inspect any open-access
notice, and try its Download PDF control. Do not infer access restrictions from
an archive CGI returning403 or from the publisher's name. For example, an older
UNL ProQuest record can lead to an openly downloadable dissertation.

If direct tools fail, discover and attempt the supported browser extension,
using the user's requested browser when specified and following its current
connection/troubleshooting instructions. Handle ordinary cookie banners within
the browser's authorization rules. Record a failed browser connection as a tool
failure, not a restriction on the document; do not bypass browser security controls.

Use user-supplied final download links as evidence-backed retrieval routes. Check
for sentence punctuation accidentally included in a pasted URL without inventing
or modifying its access token. Temporary signed links may expire; retain the
stable document identifier, not a signed query string, in public provenance.
Verify PDF bytes and the title/author/version before attributing the recovered
text. Keep downloaded, selectively consulted and fully screened statuses distinct.
When a route succeeds, correct the access record while preserving dated attempts.

For UNL records linked to ProQuest, the archive's general institutional-access
banner does not determine the individual dissertation's access. Resolve its AAI
publication number using the publisher's [documented OpenURL syntax](https://supportcenter.clarivate.com/articledetail?id=kA0400000004JHqCAM),
then inspect the actual destination for an open-access Download PDF control or
an explicit preview/institutional-access notice. A route-specific preview does
not rule out a public departmental or author copy. Use observed document IDs,
not guessed publisher identifiers. Indexed CORE mirror links can also use an
older download path; check the currently observed download route for the same
verified CORE identifier rather than treating a stale URL as document unavailability.

Validate completeness as well as PDF bytes: front matter or a publisher preview
is not a dissertation body. Check the contents, main chapters, references and final
pages. Text extraction can return many characters with a broken glyph mapping;
inspect readability, OCR when necessary, and visually check relevant passages
before interpreting a zero-result keyword search as a completed question screen.

## Hand off a source this environment cannot finish

After the attempts above, a missing complete PDF is a handoff, not a reason to
keep retrying the same failure. File the
[document acquisition queue](../../document-acquisition-queue/SKILL.md) issue
the day the block is known: one `fetch-request` per stable source, then work
that does not need that text. Index the source in the collection that same
day, with the access gap, rather than at wrap-up. Check code and supplementary
material with that skill's availability ledger before calling a numerical
result unavailable.
At the next research block, merge any manifest a retrieval worker has posted.
The worker procedure is
[document retrieval](../../document-retrieval-worker/SKILL.md). Site notes,
read only when the source matches, are in
[that skill's references](../../document-retrieval-worker/references/unl-proquest.md).
The checks in this file are what to try before filing.
