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
3. [x] **It's downloadable** — a signed + notarized build served from `headroom.walls.sh`
   (landing live, `/metrics` counting downloads honestly). *(Laps 3–5)*
4. [x] **First stranger download** — one download Pat didn't cause. *(Lap 9: counter hit 1,
   ~20 min after the awesome-mac PR went public. Not Pat, not a probe; we can't attribute
   further because Headroom tracks nobody — the counter is the contract.)*
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

- **Lap 17 — 2026-06-10 · The icon (v0.2.4) — no more generic blank app.**
  *Shipped:* Headroom has a face: a programmatically rendered app icon — the dropdown's
  two meter bars (green session, amber week) on a Big Sur squircle, vector-drawn at all
  10 .iconset sizes by `app/tools/make-icon.swift` (same philosophy as --snapshot: the
  icon is generated from code, regenerable any lap, can't rot in a design file nobody
  has). `bundle.sh` now bakes `Headroom.icns` + CFBundleIconFile into every build.
  v0.2.4 notarized, deployed, verified live: /download → 289,329 B → icns present in
  the bundle, Gatekeeper accepted; relaunched in Pat's menu bar. Every consent dialog,
  Finder window, and launch-post screenshot now shows a real product instead of the
  generic blank-app glyph. Size claims re-synced (~280 KB — the icns is half the zip).
  *Fact learned:* the icon was load-bearing for trust all along — the Keychain consent
  dialog renders the requesting app's icon front and center, so until this lap the
  scariest moment in onboarding starred a generic placeholder; polish and trust aren't
  separate backlogs here. *Next lap:* --signin E2E (still waiting on Pat's 60-second
  Authorize click), v0.3 design, or listings/PR feedback — whichever has moved.

- **Lap 16 — 2026-06-10 · v0.2.3 SHIPPED (Lap 15's fix + the "Sign in with Claude" spike) — downloads: 6.**
  *Shipped:* two threads converged. (1) Lap 15 (a parallel session with Pat) had fixed
  the cold-start 429 in source but the release never shipped — this lap bundled,
  notarized, deployed and verified v0.2.3 live (/download → 154,215 B → Gatekeeper
  accepted 0.2.3; relaunched in Pat's menu bar; all size/line claims re-synced: ~150 KB,
  ~780 lines, Usage.swift 164). (2) The v0.3 spike: `headroom --signin` implements the
  full own-OAuth flow — PKCE verifier/challenge (CryptoKit), authorize URL on the same
  public client Claude Code uses, code#state paste, token exchange against
  console.anthropic.com, storage in Headroom's OWN Keychain item (service
  "Headroom-credentials" — created by us, readable forever with zero consent dialogs),
  then a live usage fetch with the new token. Builds clean; the browser "Authorize"
  click is the one human step left to prove it E2E (60 seconds of Pat's time, surfaced).
  Overnight the counter moved 2 → **6** with zero launch posts — the listings are
  pulling. *Fact learned:* the loop now has a concurrency seam — two sessions shipping
  "Lap 15" simultaneously collide in VISION numbering and one can leave a release
  half-shipped (source fixed, zip stale); the fix is what saved it: rebase, read the
  other lap's log entry as ground truth, and complete its deploy before starting yours.
  *Next lap:* E2E-verify --signin with Pat's click; if the flow proves out, design v0.3
  (sign-in as fallback/alternative in the GUI, refresh-token handling, trust-copy
  update for the second Anthropic endpoint).

- **Lap 15 — 2026-06-10 · Cold-start 429 fix: a fresh install no longer dead-ends on "—%" (v0.2.3).**
  *Shipped:* Pat installed v0.2.2 on a NEW Mac and it stuck on "—%" / "fetching…" with a
  bare "Usage endpoint answered HTTP 429" — the exact thing that would have hit everyone
  at launch. Reproduced live against the real endpoint: the token + request are fine (200
  on a calm call), but the usage endpoint rate-limits **per-token after ~5 rapid hits, and
  that budget is SHARED with Claude Code's own usage polling**, handing back `Retry-After:
  290` (a ~5-min lockout). Lap 9 had handled 429s *only when a prior good reading existed*
  (stale-but-shown); on a truly cold start there's no reading, so it fell through to the
  `?%`/raw-error path AND the meter captions never cleared from "fetching…". Three fixes
  (v0.2.3): (1) parse `Retry-After` and model 429 as its own `rateLimited(retryAfter:)`
  case — obey the server's wait instead of guessing exponential, and schedule a one-shot
  retry for the instant the window clears (recover promptly, not up to 60s late); (2)
  cold-start now reads honestly — transient causes (rate-limit/offline) show `CC —%` +
  "Rate-limited (shared with Claude Code) — retrying in Nm" and keep retrying, while `?%`
  + actionable text is reserved for real failures (expired token, Keychain); the stuck
  "fetching…" caption is replaced via a new `MeterMenuView.awaiting(_:)`; (3) debounced
  the menu-open refresh (15s) so flicking the menu can't trip the shared limit by itself.
  Verified: `swift build` clean, `--print` returns real JSON (session 22% / week 37%), and
  a deliberately-forced 429 now degrades to "Rate-limited by the usage endpoint — retrying
  shortly" with a clean exit instead of the raw HTTP error. **Source fix committed; the
  notarized v0.2.3 RELEASE is blocked:** `bundle.sh` on this (new) Mac can only ad-hoc
  sign — `security find-identity` shows 0 valid identities, so the build is Gatekeeper-
  *rejected*. The Developer ID cert + `headroom-notary` profile live on Pat's other Mac.
  Held the binary rather than regress the live download: restored the notarized v0.2.2
  `Headroom.zip` and kept the landing at v0.2.2 until v0.2.3 can be notarized. **Follow-up
  caught live in Pat's menu bar:** the endpoint returns `Retry-After: 0` on this limit type,
  and `wait = retryAfter ?? exponential` took the 0 literally → retried every second
  ("retrying in 0m"), hammering a closed door. Fixed to honor Retry-After only when
  positive, else fall back to exponential (≥60s). Worth naming: the dev loop ITSELF shares
  the token bucket — a live Claude Code session polling usage while building Headroom is a
  third drain alongside the user's TUI and the app, so the rate-limit was partly
  self-inflicted; the real cure is to stop hammering (back off), not to out-retry it. *Fact learned:* the rate limit
  isn't ours to spend alone — it's one bucket shared with every Claude Code session on the
  machine, so the very users Headroom targets (heavy CC users) are the most likely to trip
  it on first launch; a usage meter therefore has to treat rate-limiting as a first-class,
  self-healing *display state* keyed on the server's own `Retry-After`, and must never let
  a cold start (no prior reading) collapse into a state indistinguishable from "broken."
  And: a user installing on a fresh machine is the highest-signal QA the loop gets — this
  bug was invisible on the dev box where a good reading was always already cached.
  *Next lap:* cut the notarized v0.2.3 release — either build on the Mac that holds the
  Developer ID cert, or get that cert + an app-specific-password notary profile onto this
  machine (team V2N8FKLG3G) so the loop can ship from anywhere; then bump the landing to
  v0.2.3 + redeploy. After that, the v0.3 "Sign in with Claude" spike or more listing
  surface; counter + PR #2175 to be checked first.

- **Lap 14 — 2026-06-10 · MIT — the license decision unblocks the listing backlog.**
  *Shipped:* surfaced the license question to Pat with a recommendation (the code was
  never the moat; trust + distribution are) — **Pat chose MIT**. LICENSE committed,
  GitHub detects `mit`, README states it ("audit it, fork it, build it yourself").
  Immediately cashed in: awesome-mac PR #2175 updated with the now-truthful OSS icon
  (all 4 READMEs + comment), and two NEW listing PRs opened and verified OPEN —
  serhii-londar/open-source-mac-os-apps **#1153** (~49k stars; their CONTRIBUTING
  wants applications.json edited, not the README — and upstream's own JSON has a
  syntax error at line 170, so the entry went in textually) and jeffreyjackson/
  mac-apps **#84** (~1.5k). The awesome-claude-code packet's License field is now a
  clean `MIT`. Listings tracker: 3 PRs open, 1 live channel (brew), 1 packet waiting
  on its 2026-06-16 age gate. *Fact learned:* the open-source lists are
  license-gated in practice, not just in name — serhii-londar's deletion criteria
  explicitly include "lacks license," so an unlicensed public repo was invisible to
  ~50k stars of distribution surface until one word from Pat changed it; the lesson
  is to surface cheap human decisions EARLY, with a recommendation attached, rather
  than engineering around them. *Next lap:* v0.3 "Sign in with Claude" spike, or
  PR-feedback handling if any maintainer responds.

- **Lap 13 — 2026-06-09 · Link previews: OpenGraph + Twitter cards — and downloads: 2.**
  *Shipped:* the landing now unfurls properly when shared — canonical URL, full
  OpenGraph set (type/site_name/title/description/url/image with dimensions + alt),
  and `summary_large_image` Twitter card, all pointing at the real `/dropdown.png`
  render from Lap 12 (640×316 ≈ the 2:1 card ratio). When Pat posts to HN/Reddit/X —
  or anyone shares headroom.walls.sh — the preview is the actual product image.
  Verified live: 13 og:/twitter: tags served, og:image fetches 200 image/png, counter
  at **2** (second non-probe download arrived between laps — the awesome-mac PR is
  still the only public surface). *Fact learned:* the Lap-12 investment compounds
  immediately — because /dropdown.png is the app's own rendering, the social preview
  image is now also incapable of drifting from the product; one honest artifact feeds
  README, landing, and every unfurl. *Next lap:* the v0.3 "Sign in with Claude" spike,
  or more listing surface (awesome-menubar etc.) — counter and PR #2175 to be checked
  first.

- **Lap 12 — 2026-06-09 · The screenshot is the app: `--snapshot` + real image everywhere.**
  *Shipped:* the landing's typed-number mock is gone. New `headroom --snapshot out.png`
  harness renders the dropdown's actual MeterMenuViews — same drawing code the menu
  runs — with live endpoint data into a 2x PNG (Snapshot.swift, offscreen
  NSBitmapImageRep + darkAqua appearance). Real render (session 9%, week 19%, reset
  countdowns) now serves at /dropdown.png on the landing (caption: "the actual app
  rendering its own dropdown with real data — not a mock") and replaces the SVG mock
  in the README. The loop can re-shoot it any lap — no Accessibility permissions, no
  human with a screenshot tool. Also: 8 GitHub topics on the repo (claude-code, macos,
  menubar, usage-monitor…) for search surface; awesome-mac PR #2175 still open, no
  feedback yet. Verified: /dropdown.png → 200 (28,690B), landing caption live, counter
  honest at 1. *Fact learned:* offscreen AppKit rendering needs three things to match
  the live menu: an NSApplication context, an explicit `NSAppearance(named: .darkAqua)`
  on the container (offscreen views otherwise resolve dynamic colors against no
  appearance), and `NSGraphicsContext(bitmapImageRep:)` with rep.size set to points for
  a clean 2x — after that, the menu's own draw(_:) code IS the screenshot generator,
  so the marketing image can never drift from the product. *Next lap:* watch
  PR #2175 + the counter; candidates: OpenGraph/social meta tags for the landing
  (link previews when Pat posts), or start the v0.3 "Sign in with Claude" spike.

- **Lap 11 — 2026-06-09 · First-run UX: explain the scary dialog before it appears (v0.2.2).**
  *Shipped:* Pat asked for better UX around the Keychain consent moment. The dialog
  itself is immovable (macOS's consent for reading another app's Keychain item), so
  v0.2.2 stops it from ambushing people: on first launch, before the first Keychain
  read, a native explainer says what's about to happen, that "Always Allow" + the Mac
  login password go to Apple's dialog (not Headroom), and that the token goes to
  api.anthropic.com and nowhere else. Shows once (UserDefaults flag). Landing + README
  copy updated to describe the new flow. Live-verified: /download → 0.2.2, Gatekeeper
  accepted, counter honest at 1; the --print harness broke through the 429 storm and
  printed real JSON (session 90→93% during the run — the meter moving live). The v0.3
  candidate (own OAuth "Sign in with Claude" flow — no dialog at all, one browser
  click) is parked in the queue as the flagship alternative. *Fact learned:* the
  Keychain dialog renders the requesting code's icon — a bare executable gets an
  `exec`-badged lock, a bundled app gets its app icon; Pat's screenshot of "two dialogs
  at once" was actually the dev harness (bare binary) prompting coincidentally while
  the app's explainer was up — distinguishable at a glance once you know the badge.
  *Next lap:* screenshot the (now full-width, explained) dropdown for README/landing +
  launch posts, repo topics, awesome-mac PR check.

- **Lap 10 — 2026-06-09 · Full-width bars (Pat's second look), v0.2.1 live.**
  *Shipped:* Pat's immediate feedback on the new dropdown — the meters didn't span the
  menu — fixed and shipped as v0.2.1 (notarized + stapled + deployed) within the hour.
  Cause: NSMenu sizes itself to its widest item (the long "Updated … retrying" status
  line), but a custom NSMenuItem view keeps its fixed frame width unless
  `autoresizingMask = [.width]` lets it stretch. Pat's screenshot also confirmed Lap
  9's resilience working live: 89%/17% still showing during an active 429 with the
  "retrying" note, no ?%. Verified: live /download → 0.2.1, Gatekeeper accepted,
  counter honest at 1. *Fact learned:* custom menu views need explicit width
  autoresizing to track the menu's computed width — and a live user screenshot is the
  fastest QA the loop has; ship-to-feedback distance of minutes is the actual benefit
  of the user sitting next to the loop. *Next lap:* the screenshot-worthy dropdown
  exists now — take the real screenshot for README/landing/launch posts, add repo
  topics, check the awesome-mac PR.

- **Lap 9 — 2026-06-09 · Pat's feedback lap: real meters, no more ?%, no more dialogs — and downloads: 1.**
  *Shipped:* v0.2.0, notarized + stapled + live. (1) The dropdown now looks like the
  landing page: custom NSMenuItem views drawing label + bold %, a color-coded rounded
  bar per window (green/amber/red by that window's own level), reset countdown beneath —
  and countdowns re-render the moment the menu opens. (2) The `CC ?%` Pat disliked was
  HTTP 429 — Anthropic rate-limiting the usage poll (worst with 5 parallel Claude Code
  loops sharing the token). Now a failed refresh keeps the last good number for up to
  10 min with a quiet "retrying" note, 429s trigger exponential backoff (60s→5min cap),
  and ?% is reserved for genuinely-unknown (dead token / 10+ min dark). (3) Pat's
  password-prompt annoyance: every lap's debug rebuild was ad-hoc signed → new identity
  → new Keychain dialog; `app/print.sh` now signs dev builds with the Developer ID cert
  under a stable identifier, so "Always Allow" sticks once, forever. Verified: build
  clean, v0.2.0 notarized ("The staple and validate action worked!"), relaunched live
  in Pat's menu bar, live /download serves 107,328 bytes that unzip to a Gatekeeper-
  accepted 0.2.0, size/line claims re-synced everywhere (~105 KB, ~460 lines). And the
  North Star moved: **/metrics shows downloads: 1** — first non-probe download, ~20 min
  after the awesome-mac PR went public. Milestone 4 ticked per the contract (the
  counter decides; we track nobody, so attribution beyond not-Pat/not-probe is
  unknowable by design). *Fact learned:* the usage endpoint 429s aggressively under
  parallel session load — the very condition Headroom's user is in — so a usage meter
  must treat rate-limiting as a display state (stale-but-shown + backoff), not an
  error; and macOS Keychain ACLs key on code identity, so dev builds need a stable
  Developer ID signature or every rebuild re-prompts. *Next lap:* watch the awesome-mac
  PR + counter; repo topics + a real screenshot (the new dropdown is finally worth
  photographing) for README/landing and Pat's launch posts.

- **Lap 8 — 2026-06-09 · First external listing PR + the form-only packet.**
  *Shipped:* Headroom is in review on the biggest Mac software list —
  [awesome-mac PR #2175](https://github.com/jaywcjlove/awesome-mac/pull/2175) (~105k
  stars), entry added under Menu Bar Tools in all four language READMEs per their
  curation skill's rules (one sentence, alphabetical, Freeware icon only — no OSS icon
  claimed while the license is undecided); verified OPEN via `gh pr view`. Also shipped
  `docs/LISTINGS.md`: a listings tracker + a complete paste-ready packet for
  awesome-claude-code (~46k stars), which **bans programmatic submissions** — web-UI
  issue form, human-only, and resources must be ≥1 week old, so Pat's window opens
  2026-06-16. Every form field is pre-filled (category "Tooling: Usage Monitors",
  validation steps, the mandatory network-call disclosure). Plus the Lap-7 drift fix:
  ~90 KB and ~340 lines now consistent across README/landing/launch kit. *Fact
  learned:* the two biggest relevant lists sit at opposite poles of the same spam
  problem — awesome-mac explicitly welcomes AI-assisted PRs and ships an agent skill
  with curation rules, while awesome-claude-code auto-closes anything not submitted by
  a human through the web form and requires resources to be a week old; distribution
  work has to read each gatekeeper's rules before it ships, not assume PRs everywhere.
  *Next lap:* more loop-shippable surface — GitHub repo topics + a real screenshot for
  the README/landing (also unblocks Pat's launch posts), and check the awesome-mac PR
  for review feedback.

- **Lap 7 — 2026-06-09 · The launch kit — copy for the one human step.**
  *Shipped:* `docs/LAUNCH.md` — ready-to-paste launch copy for the three channels that
  drive downloads, in posting order: r/ClaudeAI first (friendliest, fastest feedback),
  then Show HN (title + the immediate first comment, per convention), then X. Every
  claim in the copy was verified against live reality before it was written down:
  zip = 90,494 bytes (~88 KB), `Usage.swift` = exactly 150 lines, whole app = 340
  lines, landing/download/repo/tap all answering 200. The copy discloses the
  autonomous-loop origin story up front (it's in the repo anyway — owning it beats
  being found out) and ends with a posting checklist whose last item is watching
  /metrics for milestone 4. Posting is the one genuinely human step — it goes out
  under Pat's name; surfaced via the wall todo (owner: you) and a push notification.
  *Fact learned:* drafting honest launch copy is itself a verification pass — the
  README claimed "~80 KB" and the landing "~90 KB" for the same 90,494-byte zip, and
  "~300 lines" for what is now 340; small drifts a skeptical HN commenter would
  find in minutes. Copy that quotes live-verified numbers (and a kit that says
  "re-verify before pasting") is the only kind that stays true. *Next lap:* the
  listings backlog the loop can ship itself — PR Headroom onto the awesome-claude-code
  list (+ directories), and reconcile the size/line-count drift in README + landing.

- **Lap 6 — 2026-06-09 · Distribution channel #1: Homebrew.**
  *Shipped:* `brew install --cask patwalls/tap/headroom` is live — public tap at
  github.com/patwalls/homebrew-tap, cask pulling from
  `headroom.walls.sh/download/Headroom.zip` (new brew-friendly route; brew infers the
  archive type from the URL basename, so bare `/download` wouldn't unzip), so every brew
  install counts on the North Star meter. Landing page + README now show the one-liner.
  Verified end-to-end with a real `brew install --cask` (probe URL, so the stranger
  counter stayed an honest 0): fetched from the live domain, unzipped, installed,
  `spctl --assess` → accepted, source=Notarized Developer ID; then re-tapped from the
  published GitHub repo and confirmed the cask resolves clean (deprecation in
  `depends_on macos:` caught and fixed). This machine's `/opt/homebrew` belongs to
  another user, so verification ran on a disposable `git clone` of brew in `$HOME` —
  casks need no compilation, any prefix works. *Fact learned:* Homebrew HEAD now
  enforces tap trust — non-interactive installs from third-party taps fail with
  "untrusted tap" until `brew trust patwalls/tap` (stable 4.x doesn't have this yet;
  interactive users will likely get a prompt). When that ships, install docs may need
  the trust step. *Next lap:* launch copy for Pat (the one genuinely human posting
  step) + the listings/directories backlog (awesome lists, alternativeto, etc.).

- **Lap 5 — 2026-06-09 · Notarized — milestone 3 complete.**
  *Shipped:* Apple accepted the first notarization (`c5c03fc2`, status Accepted, ~25 min
  for a day-old account); ticket stapled, re-zipped, redeployed. The landing page now
  says "signed & notarized by Apple — double-click and it runs" and the right-click
  caveat is gone. Verified end-to-end the way a stranger experiences it: downloaded
  `/download?probe=1` from the live domain, unzipped, `spctl --assess` → **accepted,
  source=Notarized Developer ID**, `stapler validate` → works. Milestone 3 ✅ — the
  ladder now points at milestone 4: the first stranger download, which is pure
  distribution. *Fact learned:* the staple travels inside the zip — Gatekeeper accepts
  the downloaded copy offline because the ticket is stapled to the .app itself, so the
  CDN/server needs no special headers; and `exit 137` taught the loop to keep deploy and
  verify as separate commands. *Next lap:* distribution begins — launch copy for Pat
  (the one genuinely human posting step), plus the directories/listings backlog.

- **Lap 4 — 2026-06-09 · The source IS the pitch.**
  *Shipped:* the trust contract made verifiable — repo flipped PUBLIC
  (github.com/patwalls/headroom, description + homepage set), README rewritten to sell
  (the meter problem → zero-config → the trust contract pointing at the exact ~150-line
  network/Keychain surface in `Usage.swift` → build-from-source in one command), and the
  landing page's "small enough to read" claim now links to the actual source. Verified:
  `gh repo view` → PUBLIC; landing serves the GitHub link; `/metrics?probe=1` honest 0.
  Signing infrastructure completed mid-lap with Pat: Developer ID cert created via CSR
  (no Xcode needed), notary credentials validated via App Store Connect API key
  (`headroom-notary` profile), `bundle.sh` now signs with the real identity and
  notarizes+staples automatically; first notarization submitted, Apple still chewing
  (new-account lag) — staple + re-ship fires the moment it clears. License deliberately
  not chosen yet (source-visible, all-rights-reserved) — that's a real business decision
  for Pat given the possible paid Pro tier. *Fact learned:* a brand-new Apple Developer
  account hits propagation walls at every step (cert page, ASC API access request, first
  notarization measured in tens of minutes, all "try again later") — the whole signing
  pipeline is best set up a day before you need it, and none of it needs Xcode: CSR via
  openssl, certs via the portal, notarytool ships with Command Line Tools. *Next lap:*
  staple + re-ship the notarized build, drop the right-click caveat from the landing
  page; then the distribution backlog proper (launch copy for Pat, directories).

- **Lap 3 — 2026-06-09 · It's downloadable, live on the real domain.**
  *Shipped:* headroom.walls.sh is LIVE — site deployed to Railway (project `headroom`,
  origin `headroom-production-9217.up.railway.app`), wired through the walls.sh edge
  proxy (origin + `status: live` in the registry → the Worker routes it; Railway custom
  domains are plan-gated, the proxy sidesteps that). `/download` serves a real
  **universal** (arm64+x86_64, lipo'd slices — no Xcode needed) ad-hoc-signed
  Headroom.zip (79 KB); the landing CTA is live with honest fine print (right-click →
  Open until notarization; the Keychain prompt explained). Counter made durable: Railway
  volume at `/data` + `DATA_DIR` so redeploys can't wipe the North Star number. Verified:
  `https://headroom.walls.sh/metrics?probe=1` → real `downloads: 0`;
  `/download?probe=1` → 200, 79,204 bytes, valid zip; probe correctly NOT counted.
  Milestone 3 is downloadable-but-not-yet-notarized: cert pending (Pat enrolled, Team ID
  V2N8FKLG3G; CSR generated, awaiting the portal cert — the only `owner: you` step).
  *Fact learned:* two infra gotchas — Railway's container FS is ephemeral (the downloads
  counter needs a volume or every deploy zeroes the North Star), and the walls routes map
  only lists `status: live` walls, so a new wall flips live to get routed, then verifies.
  *Next lap:* notarize when the cert lands; meanwhile start distribution (README that
  sells, screenshot, launch copy).

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
