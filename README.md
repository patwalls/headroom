# Headroom

[![Headroom](https://headroom.walls.sh/badge.svg)](https://headroom.walls.sh) [![Build](https://github.com/patwalls/headroom/actions/workflows/build.yml/badge.svg)](https://github.com/patwalls/headroom/actions/workflows/build.yml)

**Your Claude Code usage, live in your Mac's menu bar.**

Everyone on a Claude Pro/Max plan lives with two invisible meters — the 5-hour session
window and the 7-day weekly cap — and discovers them the bad way: a hard stop mid-task.
Headroom puts the number where ambient numbers belong:

![Headroom's dropdown — the app's own rendering with real data](docs/dropdown.png)

- **Session (5h) and weekly (7d) utilization** as a live %, refreshed every minute
- **Context window fill** — a third bar so you can see how full your context is before coherence degrades
- **Active model** shown in the status line — Sonnet 4.6, Opus, Fable, whatever you're running
- **Session cost** — live dollar spend for the current session, from the same data Claude Code already tracks
- **Color-coded before it bites** — calm below 70%, amber at 70%, red at 90%, tracking
  whichever window is closer to its limit
- **Reset countdowns** for both windows in the dropdown
- **Threshold notifications** — macOS alerts at 70% and 90%, configurable via `~/.claude/headroom-prefs.json`
- **Pace forecast** — "~2h 15m at pace" when your current usage rate would hit the limit before reset
- **Zero config.** No API key, no login, no settings. Install it and the number is there.

## Install

**[Download from headroom.walls.sh](https://headroom.walls.sh/download)** — free,
macOS 13+, universal (Apple Silicon & Intel), ~267 KB. Signed & notarized.

Unzip, drag `Headroom.app` to Applications, open it. That's the whole setup: no
permission dialogs, no API key, no login — Headroom quietly wires itself into Claude
Code's status line and the numbers appear.

Or with Homebrew:

```sh
brew install --cask patwalls/tap/headroom
```

Or build it yourself in ~10 seconds:

```sh
git clone https://github.com/patwalls/headroom && cd headroom/app
swift build -c release && .build/release/Headroom
```

## How it works (the whole trick)

Claude Code already knows your usage — it receives the official 5h/7d rate-limit numbers
and renders them in its own status line. Headroom installs a tiny status-line hook that
saves that data to `~/.claude/headroom-usage.json`, and the menu bar reads it. The same
numbers `/usage` shows, updated every time Claude Code does — no scraping, no estimating,
no API polling, the real meters.

## The trust contract

An app that sits next to your credentials all day must be auditable. So:

- Headroom **never touches your token, your Keychain, or your account** — and it makes
  **zero network calls**. It reads a local file Claude Code's own status line writes.
  No analytics, no auto-updater, no phoning home.
- The entire data surface is two small files:
  [`Hook.swift`](app/Sources/Headroom/Hook.swift) (writes) and
  [`Usage.swift`](app/Sources/Headroom/Usage.swift) (reads). Read them.
- No dependencies. AppKit + Foundation, ~780 lines total.
- **MIT licensed** — audit it, fork it, build it yourself.

## Built in public

Headroom is **Wall #003 of [walls.sh](https://walls.sh)** — built by an autonomous
loop, in public, toward one number: 100 stranger downloads. The North Star, the
milestone ladder, and every lap's log live in [`VISION.md`](VISION.md); how the loop
runs is in [`LOOP.md`](LOOP.md). The downloads counter on the wall is the site's own
[`/metrics`](https://headroom.walls.sh/metrics) — verification probes excluded.
