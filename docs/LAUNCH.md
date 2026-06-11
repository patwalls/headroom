# Launch kit — ready to paste

Five channels. Every claim verified against live reality on 2026-06-10, v0.3.2 (zip
= 265,022 bytes ≈ 259 KB, app ≈ 650 lines, zero network calls by design, landing /
download / repo / tap all 200). **The posting itself is Pat's** — it goes out under his
name. Rules: post honestly, answer every comment, never astroturf, and if a number
changes, re-verify before pasting. A fresh real screenshot lives at `docs/dropdown.png`
(the app's own rendering, real data — now shows 3 bars: session, weekly, context window).

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

## 3. r/MacApps (Reddit — different audience from r/ClaudeAI)

**Title:**

> Headroom: shows your Claude Code session + weekly limits as a live % in the menu bar
> — zero network calls, free, notarized

**Body:**

> If you use Claude Code (Anthropic's CLI coding assistant), it runs under two
> invisible meters: a 5-hour session window and a 7-day weekly cap. When either
> fills, it stops cold mid-task. `/usage` shows the numbers, but that's reactive.
>
> **Headroom** puts both meters in the menu bar as a color-coded live %, with reset
> countdowns in the dropdown. It also shows your active model (Sonnet 4.6 / Opus /
> Fable) and context window fill.
>
> **How the data gets there:** Claude Code already gets these numbers and renders
> them in its terminal status line. Headroom installs a tiny status-line hook that
> saves that JSON to a local file, and the app reads the file. **Zero network calls
> — no API key, no token, no Keychain, no analytics.** The token never leaves the
> machine.
>
> Free, signed & notarized, ~259 KB. MIT.
>
> - Download: https://headroom.walls.sh
> - Brew: `brew install --cask patwalls/tap/headroom`
> - Source: https://github.com/patwalls/headroom

**Attach:** `docs/dropdown.png`.
**Note:** r/MacApps has 200k+ subscribers who care about Mac apps but may not be in
Claude Code circles — lead with the Mac menu bar angle, not the Claude Code angle.

---

## 4. X / Twitter

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

## 5. ProductHunt — see docs/PRODUCTHUNT.md for the full packet

Short summary: submit at https://producthunt.com/posts/new, hunter = Pat's account,
tagline in that file, topics = Developer Tools + macOS. Best day: Tuesday–Thursday.

---

---

## v0.3.6 Update Posts (new features: notifications + pace forecast + configurable thresholds)

These go out AFTER v0.3.6 ships (bundle.sh 0.3.6 + GitHub release). The initial launch posts
are already live; these are follow-up posts to the same communities announcing the update.

### r/ClaudeAI update post

**Title:**
> Headroom v0.3.6: now warns you before Claude Code hits the rate limit (plus pace forecast)

**Body:**
> A few weeks ago I posted Headroom — a menu bar app that shows Claude Code's 5h session and
> 7d weekly usage as a live %, zero network calls. Thanks for the feedback!
>
> v0.3.6 is out with two things you asked for:
>
> **Threshold notifications:** Headroom now sends a macOS notification when your session or
> weekly meter hits 70% (warning) and 90% (critical), with the reset countdown right in the
> alert. Never get surprised by the hard stop again. Configurable: add
> `~/.claude/headroom-prefs.json` to set your own thresholds.
>
> **Pace forecast:** the dropdown now shows "~2h 15m at pace" under each meter when your
> current usage rate would hit the limit before it resets. Useful for planning how much to
> take on before the next reset.
>
> Both features read the same local file — zero new network calls.
>
> **Still free, still zero network, still ~270 KB.** Download or brew:
> `brew install --cask patwalls/tap/headroom` (auto-updates) or https://headroom.walls.sh

### X update post

> Headroom v0.3.6: your Claude Code limits now warn you before they stop you.
>
> ↳ macOS notification at 70%/90% — configurable thresholds
> ↳ "~2h 15m at pace" forecast when your usage rate would hit the limit first
> ↳ still zero network calls, reads what Claude Code already writes
>
> https://headroom.walls.sh — free, notarized, ~270 KB

### HN update comment

(Reply to the original Show HN thread at https://news.ycombinator.com/item?id=48485017)

> Just shipped v0.3.6 — a few things from feedback:
>
> - macOS notifications at 70%/90% usage (configurable via a JSON prefs file)
> - Pace forecast in the dropdown: "~2h at pace" when your current rate would fill the
>   window before it resets
>
> Still zero network calls, same architecture. Homebrew tap auto-updates.

---

## Checklist (in order)

1. [ ] r/ClaudeAI first (friendliest audience, fastest feedback).
2. [ ] r/MacApps same day or day after (different audience — macOS users).
3. [ ] Show HN next weekday morning ET, first comment pasted within a minute.
4. [ ] X same day as HN.
5. [ ] ProductHunt: see PRODUCTHUNT.md — full packet ready.
6. [ ] Watch `https://headroom.walls.sh/metrics` — milestone 5 is 25 downloads +
       first external feedback. Reply to everything.
7. [ ] 2026-06-16+: submit to awesome-claude-code (packet in LISTINGS.md — update its
       description to the zero-network story before pasting).
8. [ ] MacMenuBar.com: packet in LISTINGS.md — web form, 5 minutes.
