# Listings tracker

Where Headroom is (or should be) listed. The loop ships PR-able listings itself;
form-only/human-only listings get a paste-ready packet below.

| Listing | Stars | Process | Status |
|---|---|---|---|
| [jaywcjlove/awesome-mac](https://github.com/jaywcjlove/awesome-mac) | ~105k | PR (AI-assisted welcome) | **PR open** — [#2175](https://github.com/jaywcjlove/awesome-mac/pull/2175) (2026-06-09) |
| [hesreallyhim/awesome-claude-code](https://github.com/hesreallyhim/awesome-claude-code) | ~46k | Web-UI issue form, **human-only** | Packet ready below — **submit on/after 2026-06-16** |
| [serhii-londar/open-source-mac-os-apps](https://github.com/serhii-londar/open-source-mac-os-apps) | ~49k | PR to applications.json | **PR open** — [#1153](https://github.com/serhii-londar/open-source-mac-os-apps/pull/1153) (2026-06-10) |
| [jeffreyjackson/mac-apps](https://github.com/jeffreyjackson/mac-apps) | ~1.5k | PR | **PR open** — [#84](https://github.com/jeffreyjackson/mac-apps/pull/84) (2026-06-10) |
| Homebrew (own tap) | — | `patwalls/homebrew-tap` | ✅ Live (Lap 6) |

---

## awesome-claude-code submission packet (Pat — ~3 minutes)

**Hard rules from their CONTRIBUTING:** must be submitted by a HUMAN via the
[web-UI issue form](https://github.com/hesreallyhim/awesome-claude-code/issues/new?template=recommend-resource.yml)
— `gh` CLI / programmatic submissions are auto-closed and risk a ban. Resources must be
**at least one week old**: Headroom was born 2026-06-09, so **don't submit before
2026-06-16**.


Paste these into the form fields:

- **Display Name:** `Headroom`
- **Category:** `Tooling`
- **Sub-Category:** `Tooling: Usage Monitors`
- **Primary Link:** `https://github.com/patwalls/headroom` (they want the repo, not the site)
- **Author Name:** `patwalls`
- **Author Link:** `https://github.com/patwalls`
- **License:** `MIT`
- **Description:**
  > Native macOS menu bar app that shows Claude Code's 5-hour session and 7-day weekly
  > utilization as a live percentage, color-coded as a limit approaches, with reset
  > countdowns. Zero configuration: it reads the OAuth token Claude Code already stores
  > in the macOS Keychain and queries Anthropic's usage endpoint — the same numbers
  > /usage shows.
- **Validate Claims:**
  > Install (download from https://headroom.walls.sh or `brew install --cask
  > patwalls/tap/headroom`), launch, and compare the menu bar percentage with what
  > `/usage` shows inside Claude Code — they match because both read the same endpoint.
  > The entire network + Keychain surface is one 150-line file
  > (app/Sources/Headroom/Usage.swift); the only network call is to api.anthropic.com.
  > Uninstall: quit from the menu bar, delete Headroom.app (no files left behind; the
  > Keychain item belongs to Claude Code, not Headroom).
- **Specific Task(s):**
  > Run Claude Code until the session meter moves, then glance at the menu bar — the
  > percentage updates within 60 seconds without opening a terminal.
- **Specific Prompt(s):**
  > In Claude Code, run /usage and compare its session + weekly percentages with
  > Headroom's dropdown.
- **Additional Comments:**
  > Per the guidelines: the app makes NO network requests except to api.anthropic.com
  > (that single call IS the product); no telemetry, no auto-update, no analytics.
  > Signed & notarized. Disclosure: largely built by Claude Code itself in an
  > autonomous build loop — the lap-by-lap log is in the repo's VISION.md.

After approval, add their badge to the README (snippet in their CONTRIBUTING.md).
