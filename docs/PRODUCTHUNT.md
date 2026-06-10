# ProductHunt launch packet — ready to submit

Everything you need for a ProductHunt launch. Fill in the fields below at
https://www.producthunt.com/posts/new. Best timing: Tuesday–Thursday, launch at
12:01am PT (the day resets, you get the full day's votes).

---

## Core fields

**Name:** `Headroom`

**Tagline** (60 chars max — count before pasting):
> Claude Code limits, live in your menu bar

(55 chars — fits)

**Description** (260 chars max):
> Free macOS menu bar app showing your Claude Code session (5h) and weekly (7d) usage as a live %, color-coded before a limit stops you mid-task. Also shows context window fill and active model. Zero network calls — reads data Claude Code already writes locally.

(258 chars — fits)

**Website:** `https://headroom.walls.sh`

**Topics** (choose up to 5):
- Developer Tools
- macOS
- Productivity
- Open Source
- AI

**Gallery:** Upload `docs/dropdown.png` (real-rendered 3-bar screenshot with live data). If a short screen recording is possible, 10 seconds of the menu bar number updating is compelling.

**Pricing:** Free

---

## Maker comment (post immediately after going live — this is crucial for PH)

> Hi PH 👋 — I'm Pat, I built Headroom.
>
> The problem: every Claude Pro/Max plan runs under two invisible meters — the 5-hour
> session window and the 7-day weekly cap. When either fills, it stops cold mid-task.
> The numbers are there (Claude Code's `/usage` command shows them), but a meter you
> have to remember to run isn't a meter.
>
> Headroom just puts both in the menu bar as a live %, color-coded as you approach the
> limit. There's also a context window fill bar (the question "how full is my context?"
> hits differently per session than "have I burned my weekly quota?") and the model
> name — so the menu bar shows something like `CC 34%` in amber, and the dropdown breaks
> it down: Session 34%, Week 56%, Context 71%, "Sonnet 4.6 · Updated 10:39 PM".
>
> **The architecture detail I think is worth sharing:** early versions of this called
> Anthropic's usage API directly, which meant Keychain access, 429 errors, and a token
> living in an app near your Claude setup. I deleted all of that. Claude Code already
> receives your official rate-limit numbers and writes them to a local file when it
> updates its terminal status line — Headroom hooks that file. Zero network calls, zero
> token, zero Keychain. You can verify it with Little Snitch or nettop; the app never
> touches the network. That architecture deletion was the best thing I shipped.
>
> Signed & notarized, ~259 KB, MIT, ~650 lines of pure AppKit Swift, no dependencies.
> `brew install --cask patwalls/tap/headroom` or direct download.
>
> Happy to answer anything — about the app, or about the autonomous build loop that
> wrote most of it (every lap is logged in VISION.md in the repo).

---

## Pre-launch checklist

- [ ] Verify version number on the landing page matches the download
- [ ] Check that dropdown.png shows the 3-bar layout (session + weekly + context)
- [ ] Take a fresh screenshot if the landing image looks stale
- [ ] Have the Maker comment text ready to paste the instant it goes live
- [ ] Set a calendar reminder for 12:01am PT on launch day

## Post-launch (first 2 hours are critical on PH)

- Reply to every comment — even a "thanks, that's a great point"
- Share the PH link to X and r/ClaudeAI: "Just launched on PH — would appreciate any
  feedback: [link]"
- If you get traction, a comment about the zero-network architecture tends to spark
  interesting discussion with the PH technical crowd
