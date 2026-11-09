# Contributing

## Commit identity

Use this identity for commits in this repository:

```sh
git config user.name alectionary
git config user.email alectionary@users.noreply.github.com
```

Enable the local hooks once per clone:

```sh
git config core.hooksPath .githooks
```

On every machine and agent that commits, including Codex, set the same noreply address globally. Without `user.email`, Git falls back to `user@hostname` and records the computer name:

```sh
git config --global user.name alectionary
git config --global user.email alectionary@users.noreply.github.com
```

`commit-msg` reads `git var GIT_AUTHOR_IDENT`, `git var GIT_COMMITTER_IDENT`, and the message file. `pre-push` checks every commit in the range being pushed. The same checker runs in GitHub Actions on `pull_request` and `push`, and it reads only that range. Commits already on the default branch are not rechecked.

A commit fails when the author email, the committer email, or any address in the message (including trailers such as `Co-authored-by` and `Signed-off-by`) uses a consumer domain:

- `gmail.com`, `googlemail.com`
- `hotmail.*`, `outlook.*`, `live.*`, `yahoo.*`
- `msn.com`
- `icloud.com`, `me.com`
- `aol.com`
- `proton.me`, `protonmail.com`

A subdomain of a listed domain is treated the same way. `hotmail.*`, `outlook.*`, `live.*`, and `yahoo.*` match that label before the final dot (`hotmail.co.uk`, `mail.yahoo.com`) and do not match a longer label such as `livejournal.com`.

A commit also fails when an address is derived from a machine hostname:

- a single-label host with no real top-level domain (a bare computer name)
- a last label of `local`, `lan`, `home`, `localdomain`, or `internal` (a name ending in `.local`, `.lan`, `.home`, `.localdomain`, or `.internal`)
- a domain that names a Mac machine: `MacBook`, `iMac`, `Mac-mini`, `Mac mini`, or `Macmini`

Noreply addresses are allowed on a real mail domain. That includes a local part of `noreply`, `noreply@github.com` (the committer GitHub sets on a web merge), and `*@users.noreply.github.com`. A noreply local part does not make a hostname-derived domain acceptable.

## Machine hostnames in files

`pre-commit` rejects a staged tracked file that contains a `.local` hostname or a Mac machine name (`MacBook`, `iMac`, `Mac-mini`, `Mac mini`, or `Macmini`). A hyphenated name ending in `.local` is a hostname, and so is an email whose domain ends in `.local`. Gzip and zip members are read.

These are not hostnames: a programming name such as `self.local` or `Family.local`, and the git range wording `remote..local` in `scripts/check_commit_emails.py`. The allowlist is `SPAN_EXEMPTIONS` and `DOC_TOKENS` in `scripts/check_machine_names.py`. This note, `AGENTS.md`, and `README.md` may name those pattern tokens by themselves. A longer machine name in those files still fails. The test modules are not exempt.

GitHub Actions runs the same check on the files changed by a pull request or push. Files already on the default branch are not rechecked.

Solver logs in this repository picked up a hostname from Kissat's own banner. Kissat is not vendored here, and no script calls `uname` or `hostname`. New logs must not record the machine nodename.

## Every clone

After cloning, on every computer and agent that commits, including Codex:

```sh
git config --global user.name alectionary
git config --global user.email alectionary@users.noreply.github.com
git config core.hooksPath .githooks
```

The global email stops Git from inventing an address out of the machine name. The hooks path is stored per clone.
