# Headroom

Your Claude Code usage, live in the menu bar — session (5h) and weekly (7d) utilization
as a color-coded %, before a limit stops you mid-task. Zero config: it reads the OAuth
token Claude Code already keeps in your macOS Keychain.

**Wall #003 of [walls.sh](https://walls.sh)** — free download from
[headroom.walls.sh](https://headroom.walls.sh).

- `app/` — the Swift menu bar app (`cd app && swift build`)
- `site/` — the landing + downloads server (`node site/server.js`, zero deps)
- [`VISION.md`](VISION.md) — the North Star (100 stranger downloads) + the loop log
- [`LOOP.md`](LOOP.md) — how the autonomous loop runs (`/lap`, `/loop /lap`)

**The trust contract:** Headroom sends your token to `api.anthropic.com` and nowhere
else. Never logged, never stored elsewhere, never phoned home.
