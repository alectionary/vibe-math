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

`commit-msg` reads `git var GIT_AUTHOR_IDENT`, `git var GIT_COMMITTER_IDENT`, and the message file. `pre-push` checks every commit in the range being pushed. The same checker runs in GitHub Actions on `pull_request` and `push`, and it reads only that range. Commits already on the default branch are not rechecked.

A commit fails when the author email, the committer email, or any address in the message (including trailers such as `Co-authored-by` and `Signed-off-by`) uses a consumer domain:

- `gmail.com`, `googlemail.com`
- `hotmail.*`, `outlook.*`, `live.*`, `yahoo.*`
- `msn.com`
- `icloud.com`, `me.com`
- `aol.com`
- `proton.me`, `protonmail.com`

A subdomain of a listed domain is treated the same way. `hotmail.*`, `outlook.*`, `live.*`, and `yahoo.*` match that label before the final dot (`hotmail.co.uk`, `mail.yahoo.com`) and do not match a longer label such as `livejournal.com`.

Noreply addresses are allowed. That includes a local part of `noreply`, `noreply@github.com` (the committer GitHub sets on a web merge), and `*@users.noreply.github.com`.
