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
