# Launch kit — ready to paste

Three posts, one per channel, in posting order. Every claim below was verified against
live reality on 2026-06-09, v0.2.0 (zip = 107,328 bytes, `Usage.swift` = 150 lines, app
total ~460 lines, landing/download/repo/tap all 200). **The posting itself is Pat's** — it goes
out under his name. Rules: post honestly, answer every comment, never astroturf, and if
a number changes (size, line count), re-verify before pasting.

---

## 1. Hacker News — Show HN (the big one)

**Title** (80 chars max, no superlatives — HN strips them):

> Show HN: Headroom – Claude Code usage limits, live in the macOS menu bar

**URL:** `https://headroom.walls.sh`

**First comment** (post immediately after submitting — Show HN convention):

> Everyone on a Claude Pro/Max plan lives with two invisible meters — the 5-hour
> session window and the 7-day weekly cap — and usually discovers them the bad way:
> a hard stop mid-task. The signal exists (`/usage` in Claude Code shows it), but a
> meter you have to remember to poll isn't a meter.
>
> Headroom puts both numbers in the menu bar as a live %, color-coded as you approach
> a limit, with reset countdowns. Zero config: Claude Code already keeps an OAuth
> token in your macOS Keychain, so Headroom reads it the same way Claude Code does and
> asks Anthropic's usage endpoint for the same numbers `/usage` shows. No API key, no
> login, no settings.
>
> An app that sits next to your credentials all day must be auditable, so the trust
> surface is deliberately small: the entire network + Keychain code is one 150-line
> file (Usage.swift), the whole app is ~460 lines of AppKit with zero dependencies,
> and the token goes to api.anthropic.com and nowhere else — no analytics, no
> auto-updater, no other network calls. Signed & notarized; ~105 KB zip; or
> `brew install --cask patwalls/tap/headroom`. Free.
>
> One more thing worth disclosing because it's in the repo anyway: most of this was
> built by Claude itself, running an autonomous "ship one real thing per lap" loop —
> the full log of what shipped each lap (and what broke) is in VISION.md. Happy to
> answer anything about that experiment too.

**Timing:** weekday, 8–10am ET. Don't repost within 8 hours if it sinks; HN allows a
second attempt days later.

---

## 2. r/ClaudeAI (Reddit)

**Title:**

> I got tired of hitting the weekly limit mid-task, so now my menu bar shows my
> Claude Code usage as a live %

**Body:**

> The 5-hour session and 7-day weekly meters always found me the bad way — a hard
> stop in the middle of something. `/usage` shows the numbers, but I never remembered
> to run it.
>
> So: **Headroom**, a tiny free macOS menu bar app. Live session + weekly %,
> color-coded (calm → amber → red as a limit approaches), reset countdowns in the
> dropdown. Zero config — it reads the OAuth token Claude Code already keeps in your
> Keychain and calls the same usage endpoint `/usage` does. No API key, no login.
>
> Because it sits next to your credentials, the trust part matters: the token goes to
> api.anthropic.com and nowhere else, no analytics, no phoning home — and the entire
> network/Keychain surface is one 150-line file you can read on GitHub (whole app is
> ~460 lines, no dependencies). Signed & notarized.
>
> Download: https://headroom.walls.sh (~105 KB) · Brew:
> `brew install --cask patwalls/tap/headroom` · Source:
> https://github.com/patwalls/headroom
>
> Fun disclosure: it was mostly built by Claude running an autonomous build loop —
> every lap is logged in the repo's VISION.md. Feedback very welcome, especially on
> the trust model.

**Attach a real screenshot** of the menu bar + dropdown (a real %, not a mock — take it
when the week is mid-range so the bar shows color). r/ClaudeAI allows self-promo that's
free + relevant; engage in comments.

---

## 3. X / Twitter

**Post:**

> Your Claude Code limits, live in the menu bar.
>
> Headroom: session (5h) + weekly (7d) usage as a %, color-coded before a limit stops
> you mid-task. Zero config — it reads the token Claude Code already stores. Free,
> notarized, 460 lines of auditable Swift.
>
> https://headroom.walls.sh

**Attach:** the same real screenshot, or a 10-second screen recording of the dropdown.
Tag nothing; let it ride. A reply tweet can carry the brew one-liner and the GitHub
link.

---

## Checklist (in order)

1. [ ] Take ONE real screenshot: menu bar % + open dropdown (used by Reddit + X).
2. [ ] r/ClaudeAI first (friendliest audience, fastest feedback — catches problems
       before HN sees them).
3. [ ] Show HN next weekday morning ET, first comment pasted within a minute.
4. [ ] X same day as HN.
5. [ ] Watch `https://headroom.walls.sh/metrics` — milestone 4 is the FIRST stranger
       download; milestone 5 is 25 + first external feedback. Reply to everything.
