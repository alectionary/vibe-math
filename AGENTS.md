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

Do not set `user.name` or `user.email` to a personal identity or a consumer-domain address. Noreply addresses are allowed, including `alectionary@users.noreply.github.com` and `noreply@github.com`. The domain list, trailer rules, and what the hooks check are in [CONTRIBUTING.md](CONTRIBUTING.md).
