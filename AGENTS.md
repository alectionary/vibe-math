# Agent instructions

Commit only as the placeholder identity:

```sh
git config user.name alectionary
git config user.email alectionary@users.noreply.github.com
```

Enable the hooks once per clone before the first commit:

```sh
git config core.hooksPath .githooks
```

On every machine and agent that commits, including Codex, set the noreply address globally as well. Without it, Git falls back to `user@hostname` and records the computer name (`MacBook`, `iMac`, `Mac-mini`):

```sh
git config --global user.name alectionary
git config --global user.email alectionary@users.noreply.github.com
```

Do not set `user.name` or `user.email` to a personal identity, a consumer-domain address, or a hostname-derived address. Noreply addresses on a real mail domain are allowed, including `alectionary@users.noreply.github.com` and `noreply@github.com`. `pre-commit` rejects a machine hostname in a staged file. Published history is not scanned again. The domain list, trailer rules, allowlist, and what the hooks check are in [CONTRIBUTING.md](CONTRIBUTING.md).
