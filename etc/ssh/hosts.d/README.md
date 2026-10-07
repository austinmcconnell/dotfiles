# Machine-Specific SSH Host Config (`hosts.d/`)

`~/.ssh/config` (tracked as `etc/ssh/config`) holds the global defaults and `Include`s every
`~/.ssh/hosts.d/*.conf` file **before** its `Host *` block. SSH applies the *first* value it sees
for each directive, so anything defined in a `hosts.d` file wins over the global default for the
hosts it matches. On a fresh machine `install/ssh.sh` seeds `local.conf` from
`example.conf.template`; `local.conf` is machine-specific and not tracked.

## The ControlPath Multiplexing Trap (read before touching `ControlPath`)

**Symptom.** `git push` to a personal GitHub repo fails with `ERROR: Repository not found` even
though the repo exists and the key is valid. `ssh -T git@personal` greets you as the **wrong**
GitHub account (e.g. your work account), so GitHub hides the personal repo and reports it missing.

**Root cause — connection multiplexing reuses a socket across same-host aliases.** With
`ControlMaster auto`, the first connection to a host becomes a master and later connections reuse
its socket — *including its already-authenticated identity*. The socket is keyed by `ControlPath`.
The global default is:

```sshconfig
ControlPath ~/.ssh/controlmasters/%C
```

`%C` is a hash of **local host (FQDN) + remote host + port + remote user + jump host**. It
deliberately **omits `%n`**, the host alias as typed on the command line. Two aliases that differ
*only* by `IdentityFile` — the classic two-GitHub-accounts setup —

```sshconfig
Host personal        # IdentityFile ~/.ssh/id_personal
    Hostname github.com
    User git
Host github.com      # IdentityFile ~/.ssh/id_github_enterprise
    Hostname github.com
    User git
```

resolve to the **same** host+port+user, so `%C` produces the **same hash** → **one shared socket**.
Whichever account connects first owns the master, and every later connection to *either* alias rides
it under that first identity. Hence `personal` silently authenticating as the work account.

## Why Not Just Revert to a Literal Path?

The obvious counter-fix is a literal `ControlPath` that includes the alias, e.g.
`~/.ssh/controlmasters/%r@%h:%p-%n`. That *does* separate the aliases (it carries `%n`) — but the
literal `user@fqdn:port` is unbounded, and a long FQDN (e.g. `publish@artifacts.lab.home.arpa`)
overflows the macOS ~104-byte Unix-domain socket limit, failing **before authentication** with
`unix_listener: path too long for Unix domain socket`.

So there are **two real constraints that no single global rule can satisfy** with a 40-char hash:

| `ControlPath` form      | Separates same-host aliases | Survives long FQDNs |
| ----------------------- | --------------------------- | ------------------- |
| `%r@%h:%p-%n` (literal) | ✅ (has `%n`)               | ❌ overflows        |
| `%C` (hash)             | ❌ (omits `%n`)             | ✅ bounded          |
| `%n-%C` (hash + alias)  | ✅                          | ❌ overflows again¹ |

¹ `%n-%C` fails too: the base dir (~44 bytes) + alias + a 40-char `%C` + SSH's runtime master-setup
suffix (~17 bytes) exceeds 104. Verified empirically — do not re-propose it.

## The Resolution — split the rule by host type

Give each host the token it actually needs, instead of forcing one global rule to serve both:

- **Global default stays `%C`** (`etc/ssh/config`, `Host *`) — bounded and overflow-safe, correct
  for ordinary and long-FQDN hosts. **Do not change it to add alias separation.**
- **Same-host multi-account aliases override `ControlPath` with `%n` per-alias** in `hosts.d`. `%n`
  is the command-line alias (`personal` vs `github.com`) — short, and the one field `%C` omits — so
  each alias gets its own distinct, short socket (~69 bytes incl. SSH's suffix, well under 104).

Multiplexing stays **fully enabled** everywhere — you keep connection reuse, a single auth
handshake, and `ControlPersist`. The only change is which socket each alias lands on.

```sshconfig
Host personal
    Hostname github.com
    User git
    IdentityFile ~/.ssh/id_personal
    IdentitiesOnly yes
    ControlPath ~/.ssh/controlmasters/%n

Host github.com
    Hostname github.com
    User git
    IdentityFile ~/.ssh/id_github_enterprise
    IdentitiesOnly yes
    ControlPath ~/.ssh/controlmasters/%n
```

**Tradeoff to know:** `%n` disambiguates by the *typed alias name*, not by connection parameters, so
two different aliases must have different names (`personal` ≠ `github.com`). That is exactly the
multi-account case, so it is the right tool here.

### Recovering from a poisoned socket

If a shared socket already bound the wrong identity, close it (no `rm` needed) and reconnect. This
targets the **old** shared `%C` socket from before the fix:

```shell
ssh -O exit -o ControlPath=~/.ssh/controlmasters/%C git@personal
```

Once the per-alias `%n` override is in place, each alias has its own live socket, so close it with
the normal form instead (SSH resolves the `%n` path from the config):

```shell
ssh -O exit git@personal
```

## History — why this doc exists

This exact `%C` ↔ literal tradeoff was swung **four times**, each flip fixing one constraint while
silently reintroducing the other, because the reasoning lived only in commit messages that the next
change overwrote:

- `%r@%h:%p-%n` literal (2025-05) → `%C` (2026-02-14) → literal again (2026-02-19, "prevent key
  conflicts") → `%C` again (2026-10-05, "avoid socket overflow").

The 2026-10-05 commit called the earlier key-conflict comment "stale" and removed it — then the
collision resurfaced the first time two GitHub accounts were used under multiplexing. The fix is the
split above (global `%C` + per-alias `%n`), and this README is the durable home for the *why* so the
pendulum stops. If you are about to edit `ControlPath`, you are at the exact spot that broke twice —
re-read the two-constraint table before changing it.
