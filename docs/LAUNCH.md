# Launch kit — ready to paste

Three posts, one per channel, in posting order. Every claim verified against live
reality on 2026-06-10, v0.3.1 (zip = 256,346 bytes ≈ 250 KB, app ≈ 590 lines, zero
network calls by design, landing/download/repo/tap all 200). **The posting itself is
Pat's** — it goes out under his name. Rules: post honestly, answer every comment, never
astroturf, and if a number changes, re-verify before pasting. A fresh real screenshot
lives at `docs/dropdown.png` (the app's own rendering, real data).

---

## 1. Hacker News — Show HN (the big one)

**Title** (80 chars max, no superlatives):

> Show HN: Headroom – Claude Code usage limits, live in the macOS menu bar

**URL:** `https://headroom.walls.sh`

**First comment** (post immediately after submitting — Show HN convention):

> Everyone on a Claude Pro/Max plan lives with two invisible meters — the 5-hour
> session window and the 7-day weekly cap — and usually discovers them the bad way:
> a hard stop mid-task. The signal exists (`/usage` shows it), but a meter you have
> to remember to poll isn't a meter.
>
> Headroom puts both numbers in the menu bar as a live %, color-coded as you approach
> a limit, with reset countdowns. Zero config: install it and the numbers are there.
>
> The part I think HN will appreciate: Headroom makes **zero network calls**. Claude
> Code already receives your official rate-limit numbers and renders them in its
> status line — so Headroom installs a tiny status-line hook that saves that JSON to
> a local file, and the menu bar reads the file. No token, no Keychain access, no API
> polling (early versions polled Anthropic's usage endpoint and spent their lives
> dodging 429s — reading the data Claude Code already has locally deleted half the
> app). No analytics, no auto-updater. The whole thing is ~590 lines of dependency-free
> AppKit Swift, MIT licensed — the data surface is two small files you can read in
> five minutes.
>
> Signed & notarized, ~250 KB. Download or `brew install --cask patwalls/tap/headroom`.
>
> One more disclosure because it's in the repo anyway: most of this was built by
> Claude itself, running an autonomous "ship one real thing per lap" loop — the full
> lap-by-lap log (including the architectural wrong turn and the deletion that fixed
> it) is in VISION.md. Happy to answer anything about that experiment too.

**Timing:** weekday, 8–10am ET.

---

## 2. r/ClaudeAI (Reddit)

**Title:**

> I got tired of hitting the weekly limit mid-task, so now my menu bar shows my
> Claude Code usage as a live % — zero network calls, it reads what Claude Code
> already knows

**Body:**

> The 5-hour session and 7-day weekly meters always found me the bad way. `/usage`
> shows the numbers, but I never remembered to run it.
>
> So: **Headroom**, a tiny free macOS menu bar app. Live session + weekly %,
> color-coded (calm → amber → red), reset countdowns in the dropdown.
>
> The trust part, because an app near your Claude setup should be auditable:
> Headroom makes **zero network calls**. Claude Code already gets your official
> rate-limit numbers and renders them in its status line — Headroom hooks that and
> reads the local file. No token, no Keychain, no API polling, no analytics. MIT
> licensed, ~590 lines, no dependencies — the data path is two small files on GitHub.
>
> Download: https://headroom.walls.sh (~250 KB, signed & notarized) · Brew:
> `brew install --cask patwalls/tap/headroom` · Source:
> https://github.com/patwalls/headroom
>
> Fun disclosure: it was mostly built by Claude running an autonomous build loop —
> every lap is logged in the repo's VISION.md, including the architecture it had to
> delete. Feedback very welcome.

**Attach:** `docs/dropdown.png` (real render, real data) or a live screenshot.

---

## 3. X / Twitter

**Post:**

> Your Claude Code limits, live in the menu bar.
>
> Headroom: session (5h) + weekly (7d) usage as a color-coded %. Zero config, zero
> network calls — it reads the numbers Claude Code already renders in its status
> line. Free, notarized, ~590 lines of MIT Swift.
>
> https://headroom.walls.sh

**Attach:** same image. A reply tweet carries the brew one-liner + GitHub link.

---

## Checklist (in order)

1. [ ] r/ClaudeAI first (friendliest audience, fastest feedback).
2. [ ] Show HN next weekday morning ET, first comment pasted within a minute.
3. [ ] X same day as HN.
4. [ ] Watch `https://headroom.walls.sh/metrics` — milestone 5 is 25 downloads +
       first external feedback. Reply to everything.
5. [ ] 2026-06-16+: submit to awesome-claude-code (packet in LISTINGS.md — update its
       description to the zero-network story before pasting).
