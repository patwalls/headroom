# Listings tracker

Where Headroom is (or should be) listed. The loop ships PR-able listings itself;
form-only/human-only listings get a paste-ready packet below.

| Listing | Stars | Process | Status |
|---|---|---|---|
| [jaywcjlove/awesome-mac](https://github.com/jaywcjlove/awesome-mac) | ~105k | PR (AI-assisted welcome) | **PR open** — [#2175](https://github.com/jaywcjlove/awesome-mac/pull/2175) (2026-06-09) |
| [hesreallyhim/awesome-claude-code](https://github.com/hesreallyhim/awesome-claude-code) | ~46k | Web-UI issue form, **human-only** | Packet ready below — **submit on/after 2026-06-16** |
| [serhii-londar/open-source-mac-os-apps](https://github.com/serhii-londar/open-source-mac-os-apps) | ~49k | PR to applications.json | **PR open** — [#1153](https://github.com/serhii-londar/open-source-mac-os-apps/pull/1153) (2026-06-10) |
| [jeffreyjackson/mac-apps](https://github.com/jeffreyjackson/mac-apps) | ~1.5k | PR | **PR open** — [#84](https://github.com/jeffreyjackson/mac-apps/pull/84) (2026-06-10) |
| [iCHAIT/awesome-macOS](https://github.com/iCHAIT/awesome-macOS) | ~19k | PR | **PR open** — [#868](https://github.com/iCHAIT/awesome-macOS/pull/868) (2026-06-10) |
| [rohitg00/awesome-claude-code-toolkit](https://github.com/rohitg00/awesome-claude-code-toolkit) | ~2k | PR (Companion Apps & GUIs section) | **PR open** — [#522](https://github.com/rohitg00/awesome-claude-code-toolkit/pull/522) (2026-06-10) |
| [jqueryscript/awesome-claude-code](https://github.com/jqueryscript/awesome-claude-code) | ~416 | PR (Usage & Observability section) | **PR open** — [#382](https://github.com/jqueryscript/awesome-claude-code/pull/382) (2026-06-10) |
| [LangGPT/awesome-claude-code](https://github.com/LangGPT/awesome-claude-code) | ~249 | PR (Monitoring & Analytics section) | **PR open** — [#90](https://github.com/LangGPT/awesome-claude-code/pull/90) (2026-06-10) |
| [subinium/awesome-claude-code](https://github.com/subinium/awesome-claude-code) | ~85 | PR (Monitoring & Analytics section) | **PR open** — [#25](https://github.com/subinium/awesome-claude-code/pull/25) (2026-06-10) |
| [MacMenuBar.com](https://macmenubar.com) | ~1.4k apps listed | Web form, **human-only** | Packet ready below — submit any time |
| GitHub Releases | — | own repo | ✅ [v0.3.4 release](https://github.com/patwalls/headroom/releases/tag/v0.3.4) (Lap 30) |
| Homebrew (own tap) | — | `patwalls/homebrew-tap` | ✅ Live (Lap 6) |
| r/ClaudeAI | ~200k | agent-browser post | ✅ [LIVE](https://reddit.com/r/ClaudeAI/comments/1u2m9vh/) (Lap 30) |
| r/MacApps | ~200k | agent-browser post | ✅ [LIVE](https://reddit.com/r/macapps/comments/1u2ko9m/) (Lap 28) |
| Hacker News (Show HN) | — | agent-browser post | ✅ [LIVE](https://news.ycombinator.com/item?id=48485017) (Lap 29 session) |

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
  > countdowns. Zero configuration and zero network calls: it reads the official
  > rate-limit numbers Claude Code itself renders in its status line, via a tiny
  > status-line hook — the same numbers /usage shows, from a local file.
- **Validate Claims:**
  > Install (download from https://headroom.walls.sh or `brew install --cask
  > patwalls/tap/headroom`), launch, and compare the menu bar percentage with what
  > `/usage` shows inside Claude Code — they match because Headroom reads the data
  > Claude Code itself writes. The app makes ZERO network requests (verify with Little
  > Snitch or `nettop`); the entire data surface is two small files (Hook.swift,
  > Usage.swift). Uninstall: quit from the menu bar, delete Headroom.app, and remove
  > the headroom-statusline line from ~/.claude/settings.json + the two headroom-*
  > files in ~/.claude if you want zero trace.
- **Specific Task(s):**
  > Run Claude Code until the session meter moves, then glance at the menu bar — the
  > percentage updates within 60 seconds without opening a terminal.
- **Specific Prompt(s):**
  > In Claude Code, run /usage and compare its session + weekly percentages with
  > Headroom's dropdown.
- **Additional Comments:**
  > Per the guidelines: the app makes NO network requests at all — it reads a local
  > file written by Claude Code's own status line; no telemetry, no auto-update, no
  > analytics. Signed & notarized, MIT. Disclosure: largely built by Claude Code
  > itself in an autonomous build loop — the lap-by-lap log is in the repo's
  > VISION.md.

After approval, add their badge to the README (snippet in their CONTRIBUTING.md).

---

## MacMenuBar.com submission packet (Pat — ~5 minutes)

**Process:** Go to [https://macmenubar.com](https://macmenubar.com) and click "Submit Menu Bar App" in the navigation.
Headroom qualifies: the menu bar IS the entire UI — there's no separate window, the app lives 100% in the menu bar.

Fill in:

- **App Name:** `Headroom`
- **URL:** `https://headroom.walls.sh`
- **Category:** `Developer Apps` (or System Stats — either fits)
- **Price:** `Free`
- **Short description (1–2 sentences):**
  > Shows your Claude Code session (5h) and weekly (7d) usage as a live % in the menu bar — color-coded before a limit stops you mid-task. Zero config: it reads the numbers Claude Code already writes locally, no API key or network calls.
- **Icon/screenshot:** The icon at `https://headroom.walls.sh/icon-512.png` or the dropdown screenshot at `https://headroom.walls.sh/dropdown.png`
