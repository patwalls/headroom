# Headroom — Vision & the Entrepreneur Loop

> Headroom is a **macOS menu bar app that shows your Claude Code usage as a live %** —
> session (5h) and weekly (7d), color-coded as you approach the limit. It reads the OAuth
> token Claude Code already keeps in your Keychain, so there's nothing to configure: install
> it and the number is just *there*. Free download from [headroom.walls.sh](https://headroom.walls.sh).

This document codifies the product thesis **and** the **entrepreneur loop** that takes
Headroom from "an idea" to a real, used thing. Re-read it at the start of every lap.
Headroom is **Wall #003 of [walls.sh](https://walls.sh)**, built in public — same playbook
as Superhighway and Pulse.

---

## 0. North Star — the one number this loop drives toward

> # 📥 100 real downloads, by strangers.
>
> People who found Headroom, wanted it, and downloaded it — counted live by the site's
> own `/metrics` downloads counter. Not our verification fetches (the loop's probes use
> `?probe=1` and are excluded). Not Pat re-downloading his own build. A hundred strangers
> who decided their menu bar needed this number.

Set 2026-06-09. Full autonomy granted to pursue it.

### Milestones (the ladder to 100)

1. [x] **It exists** — the app builds, runs, and shows Pat's REAL weekly utilization % in the
   menu bar (Keychain token → Anthropic usage endpoint → live number, auto-refreshing). *(Lap 1)*
2. [x] **It's complete** — session (5h) **and** weekly (7d) utilization, color-coded
   (calm → amber → red as a limit approaches), reset countdowns in the dropdown, launch-at-login. *(Lap 2)*
3. [ ] **It's downloadable** — a signed + notarized build served from `headroom.walls.sh`
   (landing live, `/metrics` counting downloads honestly).
4. [ ] **First stranger download** — one download Pat didn't cause.
5. [ ] **25 downloads + the first piece of external feedback** (an issue, a reply, a mention).
6. [ ] **📥 100 downloads — the North Star.** Then decide the one-time-license question with
   real demand data, not vibes.

### The money hypothesis (honest version)

Free for now — the product is a *trust* play: it sits in your menu bar all day with your
credentials nearby, so free + small + transparent is how it earns installs. If it reaches
real distribution (the North Star), the candidate model is a **one-time license** (~$19,
Stripe payment link) for a "Pro" tier — multiple profiles, history charts, alerts. Until
demand is proven, `payTo` stays empty and the wall shows no revenue. No subscription; this
is a utility, not a service with marginal cost.

## 0.5 THE AUTONOMOUS MANDATE (do not violate)

- **Never stop, never "pause the loop," never declare "done," never go to watch mode.**
  There is always a next lever toward 100 downloads — build, polish, or distribute.
  Distribution alone is a never-ending backlog.
- **Never wait for Pat to do something the loop can do itself.** Build it, deploy it,
  publish it, ship it. Only truly human-gated steps (a credential, a spend, an account
  login, an irreversible call) get surfaced — and you run a *different* lap meanwhile,
  never blocking.
- **Verify with real output, never fake a number.** A lap that "should work" didn't ship.
  The menu bar % must come from the real usage endpoint; the downloads count from real
  requests. Honest errors over silent zeros.
- **One lap = one shipped thing + one fact learned.**
- **Respect the trust position.** Headroom reads the user's OAuth token. It must NEVER send
  that token anywhere except `api.anthropic.com`, never log it, never phone home. This is
  non-negotiable and stated publicly on the landing page — it IS the product's pitch.

## 1. The thesis

Everyone on a Claude Pro/Max plan lives with two invisible meters — the 5-hour session
window and the 7-day weekly cap — and discovers them the bad way: a hard stop mid-task.
The signal exists (Claude Code shows `/usage`, the API returns utilization), but it's
buried in a TUI command you have to remember to run. **A meter you have to poll isn't a
meter.** The Mac menu bar is where ambient numbers live.

The bet: this is a small, sharp, *zero-config* utility for a fast-growing audience
(Claude Code's user base), shipped weeks before anyone polishes an equivalent. Zero config
is the moat-let: Claude Code already stores an OAuth token in the macOS Keychain, so
Headroom needs no API key, no login, no setup — install, see your number. Free earns the
install base; the install base is the data that says whether a paid tier exists.

## 2. What exists

- **`app/`** — a Swift Package menu bar app (AppKit, no dependencies). Builds with
  `swift build`; shows a placeholder `CC —%` status item with a Quit menu. The skeleton
  Lap 1 wires to reality.
- **`site/`** — the zero-dep Node landing server for `headroom.walls.sh`: pitch page,
  `/health`, `/metrics` (real downloads counter, `?probe=1` excluded), `/download`
  (counts, then serves the build when one exists — honest 404 until then). Dockerfile,
  ready for `railway up`.
- Nothing else. The loop fills this section in.

### The technical spine (what Lap 1+ wires up)

- **Token:** Claude Code stores OAuth credentials in the macOS Keychain (generic password,
  service `Claude Code-credentials`). Read it the same way Claude Code does; handle the
  refresh-token dance or fall back to prompting "open Claude Code once to refresh."
- **Usage:** Anthropic's OAuth usage endpoint / rate-limit headers expose unified
  utilization for the 5h and 7d windows (the same numbers `/usage` renders). The exact
  shape is Lap-1 discovery work — verify against the real token, never guess.
- **Display:** `NSStatusItem` with the weekly % as text; dropdown with both bars, reset
  times, and a refresh timestamp. Color thresholds: <70% calm, 70–90% amber, ≥90% red.

## 3. The loop

```
  ① pick ─▶ ② ship ─▶ ③ verify (real output) ─▶ ④ log ─▶ ⑤ push ─▶ (next lap)
```

Each lap: read §0, pick the highest-leverage unblocked rung, ship it, **verify with real
output** (the app builds and shows a real number; the site answers a real curl), prepend
the lap to the log below, keep the wall's dossier honest (`~/code/walls/registry.json`),
commit + push. The motor is [`.claude/commands/lap.md`](.claude/commands/lap.md); how to
run it is [`LOOP.md`](LOOP.md).

### Loop log (newest first)

- **Lap 2 — 2026-06-09 · Complete + quiet.**
  *Shipped:* milestone 2 — color-coded title (calm/amber/red via `Render.tone`, driven by
  the WORSE of the two windows so an imminent 5h stop reddens the bar even on a calm
  week), reset countdowns ("resets in 3h 48m (Tue 22:40)"), launch-at-login toggle
  (SMAppService, shown only when bundled), and — from Pat's first live feedback — a
  `TokenStore` that caches the token in memory so the Keychain permission dialog fires
  once per launch instead of once per 60s refresh (re-reads only on 401). Verified:
  `--print` shows the real render decisions (session 22%, week 5%, tone=calm), bundle
  relaunched live in Pat's menu bar. *Fact learned:* the Keychain ACL dialog is per
  code-signature — ad-hoc signatures change every rebuild, so "Always Allow" can't stick
  until the Developer ID cert exists; until then the in-memory cache is the only real
  mitigation, and macOS's 24-hour clock preference overrides explicit `h:mm a` format
  strings (the countdown honors the user's setting for free). *Next lap:* milestone 3 —
  zip the bundle, deploy the site to Railway, wire headroom.walls.sh, count downloads.

- **Lap 1 — 2026-06-09 · The real number.**
  *Shipped:* milestone 1 — the app now shows live utilization. `KeychainToken` reads the
  OAuth token Claude Code keeps in the Keychain (service `Claude Code-credentials`);
  `UsageClient` GETs `api.anthropic.com/api/oauth/usage` (Bearer + `anthropic-beta:
  oauth-2025-04-20`); the status item renders the weekly % (`CC 3%`), dropdown shows both
  windows with reset times + refresh timestamp, auto-refresh every 60s, honest error
  states (`CC ?%` + reason). `headroom --print` is the standing verification harness — it
  printed the REAL endpoint response (session 14%, week 3%, reset timestamps) and the
  parsed values, exit 0; the GUI survived a live refresh cycle. Token goes to
  api.anthropic.com and nowhere else. *Fact learned:* the usage endpoint is
  `GET /api/oauth/usage` and returns `five_hour` / `seven_day` objects with `utilization`
  (a percentage, already 0–100) and ISO `resets_at` — plus per-model windows
  (`seven_day_sonnet` etc.) we may surface later; the session number moved 13→14% *during
  the lap*, proving it's live, not cached. *Next lap:* milestone 2 — color-coding
  (calm/amber/red) + reset countdowns, then the bundle + download.

- **Lap 0 — 2026-06-09 · Incubated.**
  *Shipped:* the venture exists — repo at `~/code/headroom`; this VISION with the North
  Star (100 stranger downloads) and the milestone ladder; the loop motor (`LOOP.md` +
  `/lap`); a buildable Swift menu bar skeleton (`swift build` clean, status item renders
  `CC —%`); the landing/metrics server (`/health` 200, `/metrics` reporting a real
  `downloads: 0`, `/download` honest 404 until a build exists); Wall #003 on walls.sh
  (`status: building`) with the seeded todo queue. *Fact learned:* the entire scaffold —
  menu bar app + landing + metrics contract — needs zero dependencies on either side;
  the only human-gated step on the whole ladder is the Apple Developer ID for
  notarization (milestone 3). *Next lap:* read the Keychain token + hit the real usage
  endpoint — print Pat's actual weekly % (milestone 1's core).

## 4. Principles (inherited from Walls)

- **Close the loop before polishing.** A real % in the menu bar beats a beautiful icon.
- **Show real numbers.** The menu bar %, the downloads count, the wall — live or absent,
  never typed.
- **Reversible by default.** Small commits, private repo until it's worth showing,
  no DNS until there's an origin.
- **The number is the story.** Headroom's whole product is one honest number in the menu
  bar; the wall's whole story is one honest downloads count. Keep both true.
