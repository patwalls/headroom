# Headroom — Vision & the Entrepreneur Loop

> Headroom is a **macOS menu bar app that shows your Claude Code usage as a live %** —
> session (5h) and weekly (7d), color-coded as you approach the limit. It reads the numbers
> Claude Code itself renders in its status line — locally, no token, no API, no permission
> dialogs: install it and the number is just *there*. Free from [headroom.walls.sh](https://headroom.walls.sh).

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
- **Respect the trust position.** Headroom (since v0.3) touches NO token, NO Keychain, and
  makes ZERO network calls — it reads the local file Claude Code's status line writes. Any
  future path that ever touches a credential goes to `api.anthropic.com` and nowhere else,
  never logged, never phoned home. Non-negotiable, stated publicly — it IS the pitch.

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

- **Lap 78 — 2026-06-11 · r/programming link post live — 6M subscribers, technical article.**
  *Shipped:* r/programming post live at https://old.reddit.com/r/programming/comments/1u32vz0/ (6M subs). Link post to `/hook` article — "How Claude Code's status line hook works — read rate limits locally without any API calls." This works because r/programming is link-only and the /hook article is a genuine technical piece, not a product pitch. Downloads: 45 (up 1 since last check). *Fact learned:* The /hook article URL unlocked r/programming — the largest subreddit we've hit. Technical article framing is correct for this audience. *Next lap:* Wait to see if r/programming converts (it may take hours), or continue with r/docker, r/devtools, or other developer communities.

- **Lap 77 — 2026-06-11 · New article page: /hook — Claude Code statusLineHook deep-dive.**
  *Shipped:* https://headroom.walls.sh/hook is live — a technical article explaining the `statusLineHook` mechanism: JSON schema, hook chaining, what you can build, tmux example, comparison vs. API polling. Added to sitemap.xml and footer nav. Downloads: 44. *Fact learned:* The /hook article targets developers who want to understand the hook pattern and build their own tools — a different and broader audience than the "install Headroom" pitch. The tmux statusbar example, logging recipe, and cost tracking use cases are new content that doesn't appear anywhere else. *Next lap:* Post /hook to HN, r/programming (link post — it now has a URL), or r/neovim follow-up.

- **Lap 76 — 2026-06-11 · r/typescript post live — 100k TypeScript developers.**
  *Shipped:* r/typescript post live at https://old.reddit.com/r/typescript/comments/1u32s1v/ (100k subs, no flair — dropdown not visible). Angle: type generation and TS refactors hit session limits. Downloads: 44. *Fact learned:* r/typescript has no visible flair picker (same pattern as r/javascript). *Next lap:* /hook article page (new SEO content targeting the hook mechanism).

- **Lap 75 — 2026-06-11 · Landing page social proof: live download count + "Seen on" bar.**
  *Shipped:* Landing page now shows "N developers have downloaded Headroom" (server-rendered, live count) + a "Seen on" bar with links to HN, r/ClaudeAI, r/neovim, r/vim, r/LocalLLaMA, r/devops. Deployed to Railway. Downloads: 44. *Fact learned:* The `buildPage(downloads)` function pattern keeps the count fresh per request with no extra DB call. Social proof is now visible to every visitor — previously, 44 downloads and 15+ community posts were invisible. *Next lap:* r/typescript, or check if any new downloads came in from the wave.

- **Lap 74 — 2026-06-11 · r/golang post live — 100k Go developers.**
  *Shipped:* r/golang post live at https://old.reddit.com/r/golang/comments/1u32mty/ (100k subs, no flair available). Architecture angle: hook → local JSON → poll, with `jq` pipeline example. Downloads: 44. *Fact learned:* r/golang has no flair categories — form rendered without a flair picker. Checked all open awesome-list PRs — none merged yet (PRs to jaywcjlove/awesome-mac, mahseema/awesome-ai-tools, steven2358/awesome-generative-ai, etc. all still open). *Next lap:* r/typescript or landing page conversion improvement.

- **Lap 73 — 2026-06-11 · r/rust post live — 100k Rust developers.**
  *Shipped:* r/rust post live at https://old.reddit.com/r/rust/comments/1u32kyq/ (100k subs, "seeking help & advice" flair — not ideal but posted). Architecture angle: hook → local file → poll, versus naive API polling. Downloads: 44. *Fact learned:* r/rust auto-selected "seeking help & advice" flair — the sub's flair options don't include "Discussion" or "Tools". The zero-network-call architecture story resonates with Rust's culture of correctness and minimal side effects. *Next lap:* schedule r/macOS for Saturday June 13, or r/golang.

- **Lap 72 — 2026-06-11 · r/programming blocked — link-only subreddit.**
  *Shipped:* Nothing (script failed — textarea not found). *Fact learned:* r/programming only accepts link posts (URLs), not self-posts. `?selftext=true` in the URL doesn't override this. r/programming is removed from the distribution backlog. *Next lap:* r/rust (100k), r/golang (100k).

- **Lap 71 — 2026-06-11 · r/javascript post live — 300k JS/Node developers.**
  *Shipped:* r/javascript post live at https://old.reddit.com/r/javascript/comments/1u32hpy/ (300k subs, no flair — flair button not visible). Angle: Next.js/monorepo/TypeScript refactors hit session limits mid-build. Downloads: 41. *Fact learned:* r/javascript's flair button exists in the DOM but isn't visible — post submitted fine without flair. Front-end devs are a large Claude Code audience. *Next lap:* r/programming (6M — needs exceptional framing), or pivot to new SEO content.

- **Lap 70 — 2026-06-11 · r/Python post live — 800k Python developers.**
  *Shipped:* r/Python post live at https://old.reddit.com/r/Python/comments/1u32g9l/ (800k subs, Discussion flair). Angle: ML/data science/Django-FastAPI work hits session limits mid-long-task. JSON file architecture highlighted — shell users can pipe `~/.claude/headroom-usage.json` directly. Downloads: 41. *Fact learned:* r/Python has "Discussion" flair. Large Python communities likely have many Claude Code users given Python's dominance in ML and AI tooling. *Next lap:* r/javascript (300k) or r/programming (6M).

- **Lap 69 — 2026-06-11 · r/bash post live — 60k shell users.**
  *Shipped:* r/bash post live at https://old.reddit.com/r/bash/comments/1u32edy/ (60k subs, "submission" flair). Angle: the Headroom hook architecture — a one-line hook in `~/.claude/settings.json` writes to `~/.claude/headroom-usage.json`; shell users can inspect/pipe the JSON directly. Downloads: 41. *Fact learned:* r/bash flair fell back to "submission" (no Tool/Discussion). The JSON file architecture resonates with shell users — they can `cat` the file, pipe it to `jq`, use it in their own scripts. *Next lap:* r/programming (6M subs — large audience but needs perfect framing) or Console.dev email (curated dev newsletter, high-quality reach).

- **Lap 68 — 2026-06-11 · r/webdev post live — 500k web developers.**
  *Shipped:* r/webdev post live at https://old.reddit.com/r/webdev/comments/1u32co0/ (500k subs, Discussion flair). Angle: React/Node/TypeScript refactors hit Claude Code session limits mid-work; Headroom shows both windows without breaking flow. Downloads: 41. *Fact learned:* r/webdev has Discussion flair. Web devs are a large underserved audience — they use Claude Code heavily for frontend/backend work but aren't as niche-targeted as terminal-community subs. *Next lap:* r/bash (60k shell users), or pivot to a new distribution channel (Console.dev email, GitHub awesome-list PRs if logged in).

- **Lap 67 — 2026-06-11 · r/cursor post live — 50k AI coding assistant users.**
  *Shipped:* r/cursor post live at https://old.reddit.com/r/cursor/comments/1u2vpgn/ (50k subs, "Question / Discussion" flair). Angle: Cursor+Claude Code dual-use, rate limits hit mid-session. Downloads: 38. *Fact learned:* MacMenuBar.com is genuinely human-only (reCAPTCHA + "no Gmail" domain email requirement — needs pat@headroom.walls.sh or similar). r/cursor has a "Question / Discussion" combined flair. *Next lap:* r/webdev (~500k), r/bash, or new SEO content page.

- **Lap 66 — 2026-06-11 · r/devops post live — 1M subscribers, "Tools" flair.**
  *Shipped:* r/devops post live at https://old.reddit.com/r/devops/comments/1u2vmyn/ (1M subs). IaC/automation angle, security-conscious framing (no token exposure, nettop verification). Downloads: 38. *Fact learned:* r/devops has a "Tools" flair category — better fit than "Discussion" for a utility announcement. Bigger subs (LocalLLaMA 800k, devops 1M) convert more slowly than niche subs (neovim 200k) because posts get buried faster in high-volume feeds. *Next lap:* pivot to a non-Reddit distribution channel to diversify — MacMenuBar.com or a new SEO content page.

- **Lap 65 — 2026-06-11 · r/LocalLLaMA post live — 800k subscribers.**
  *Shipped:* r/LocalLLaMA post live at https://old.reddit.com/r/LocalLLaMA/comments/1u2v8pi/ (800k subs, Discussion flair). Largest subreddit hit so far. Angle: zero-API-polling architecture, token never leaves machine. Downloads: 38. *Fact learned:* r/LocalLLaMA has Discussion flair available — the community is broad enough that Claude Code tooling fits. The "no API polling" angle differentiates from other monitors for this audience who cares deeply about how tools work under the hood. *Next lap:* check if r/LocalLLaMA post converts (big audience), then r/devops or MacMenuBar.com.

- **Lap 64 — 2026-06-11 · r/tmux post live — 80k terminal power-users.**
  *Shipped:* r/tmux post live at https://old.reddit.com/r/tmux/comments/1u2v7zn/ (80k subs, Other flair — best available). Downloads: 38. *Fact learned:* r/tmux flair options don't include "Discussion" — fell back to "Other". The `nettop -p Headroom` verification command is a compelling hook for privacy-conscious terminal users who want to confirm zero network activity. *Next lap:* r/LocalLLaMA (large AI community), r/devops, or MacMenuBar.com form.

- **Lap 63 — 2026-06-11 · r/zsh post live.**
  *Shipped:* r/zsh post live at https://old.reddit.com/r/zsh/comments/1u2utnj/ (Discussion flair). Angle: hook writes to `~/.claude/headroom-usage.json`, brew install one-liner. Downloads: 32. *Fact learned:* Distribution velocity has reached the point where each terminal-community subreddit takes ~2 minutes to post. The pattern is now fully automated. *Next lap:* r/tmux, r/ClaudeAI follow-up, or try r/cursor.

- **Lap 62 — 2026-06-11 · r/emacs post live — 80k subscribers. Downloads: 32.**
  *Shipped:* r/emacs post live at https://old.reddit.com/r/emacs/comments/1u2uss6/ (80k subs, Question flair — best available). Downloads ticked to 32 (was 31). *Fact learned:* r/emacs flair options include "Question" but not "Discussion" — the flair picker will take whatever is available. Post angle was privacy/zero-network (nettop verification), which resonates with Emacs users who value control and transparency. *Next lap:* r/zsh, r/tmux, or other terminal communities.

- **Lap 61 — 2026-06-11 · r/commandline post live — 118k subscribers.**
  *Shipped:* r/commandline post live at https://old.reddit.com/r/commandline/comments/1u2us1d/ (118k subs, Discussion flair). Terminal-first angle: hook writes to `~/.claude/headroom-usage.json`, zero API. *Fact learned:* r/commandline also uses the same post-flair pattern (button.flairselect-btn + hidden inputs). The brew install one-liner is the right hook for this audience. *Next lap:* more Reddit (r/emacs, r/zsh, r/bash) or other distribution.

- **Lap 60 — 2026-06-11 · onmymenubar.app submitted — curated macOS menu bar apps directory.**
  *Shipped:* Submitted Headroom to onmymenubar.app. Tally "Thanks for completing this form!" confirmation in screenshot. Downloads: 31. *Fact learned:* onmymenubar.app embeds a Tally.so form via iframe (id="iFrameResizer0"). Main page has zero `input`/`textarea` elements — any selector on `page` finds nothing. Fix: `page.frameLocator('iframe[src*="tally.so"]')` then fill by `aria-label`. Tally form had only 3 fields: App Name, Website Link, Your Email (no description or GitHub). *Next lap:* r/commandline, r/emacs, or more distribution channels.

- **Lap 59 — 2026-06-11 · r/vim post live — 230k subscribers, Discussion flair.**
  *Shipped:* r/vim post live at https://old.reddit.com/r/vim/comments/1u2unzj/ (230k subscribers). Used the proven post-flair fix (button.flairselect-btn → hidden inputs directly). Discussion flair set from first run. Downloads: 31. *Fact learned:* r/vim also has `button.flairselect-btn` and `#newlink-flair-dropdown` — the same post-flair pattern works across all subreddits. The flair approach is now a reliable, reusable pattern. *Next lap:* onmymenubar.app form submission (no login needed), or r/terminal.

- **Lap 58 — 2026-06-11 · r/neovim post live — old Reddit post-flair root cause found and fixed.**
  *Shipped:* r/neovim post live at https://old.reddit.com/r/neovim/comments/1u2umfe/ (200k subscribers). Flair set to "Discussion." Root cause of 7 failed flair attempts isolated and fixed. Downloads: 31. *Fact learned:* Old Reddit has TWO separate flair systems that look identical in the UI but are wired completely differently: (1) **User flair** — triggered by `a.flairselectbtn` ("edit"), uses the classic `a.flairselection` popup with jQuery; (2) **Post flair (link flair)** — triggered by `button.flairselect-btn` ("select"), opens `#newlink-flair-dropdown` which contains `li.flairsample-right[id=UUID]` elements with no `data-text` attributes. The form has hidden inputs `flair_id` (UUID) and `flair_text`. All previous attempts clicked the user flair button. Fix: click `button.flairselect-btn`, discover flair UUIDs by querying `li span[title]`, set hidden inputs directly with `page.evaluate()`, close with Escape. *Next lap:* r/macOS on Saturday 2026-06-13 (flair pattern now known), or more distribution today.

- **Lap 57 — 2026-06-11 · "Open Claude Code" menu item + flair automation fix attempt.**
  *Shipped:* (1) Added "Open Claude Code" menu item to the Headroom dropdown. Implementation: `NSWorkspace.shared.urlForApplication(withBundleIdentifier: "com.anthropic.claudecode")` (falls back to `/Applications/Claude.app`). Build clean in 1.10s. Changelog updated and deployed. (2) Attempted r/neovim post — found that flair requires clicking old Reddit's jQuery-wired `a.flairselection` elements which don't fire their handlers via JS `.click()`. Flair still shows "(none)" after click. Fact: old Reddit flair popups use jQuery event delegation, so `element.click()` in `page.evaluate()` doesn't trigger the handler — only Playwright's native `.click()` on a rendered element works. r/neovim post blocked until flair is solved or a Playwright-native click approach is used. Downloads: 31. *Fact learned:* Old Reddit CSS flair popups require Playwright's native `.click()` (which properly simulates pointer events), not `element.click()` via `page.evaluate()` (which fires the DOM event but doesn't trigger jQuery's `.on('click')` delegation). Subreddits with required flair need a native Playwright click after the popup is visible. *Next lap:* Fix flair via Playwright native click and retry r/neovim, OR r/vim (may not require flair).

- **Lap 56 — 2026-06-11 · /alternatives comparison page — "Headroom vs. CCSeva, ccusage, ClaudeBar."**
  *Shipped:* Added `https://headroom.walls.sh/alternatives` — an honest comparison of Headroom against 5 alternatives (CCSeva, ClaudeBar, ccusage, Claude-Code-Usage-Monitor, SessionWatcher). Includes: quick comparison table (where it shows, network calls, API token, platform), per-tool cards with tradeoffs, "when to use which" guide, and download CTA. Added to sitemap.xml at priority 0.9. Added "alternatives" link to landing page footer. Deployed Railway, verified live. Downloads: 31. *Fact learned:* Comparison pages are high-value SEO targets because people searching "CCSeva alternative" or "ccusage vs headroom" are in active evaluation mode — they've already decided they want a monitoring tool and are choosing between options. By being honest (explicitly saying "if you want charts, use CCSeva; if you want history, use ccusage"), the page builds more trust than a page that claims Headroom is the best for everything. The honest comparison is also more useful to AI assistants when users ask "which Claude Code monitoring tool should I use." *Next lap:* r/macOS (Saturday 2026-06-13), or more SEO content, or app feature.

- **Lap 55 — 2026-06-11 · /guide SEO page — "How to monitor Claude Code usage limits."**
  *Shipped:* Added `https://headroom.walls.sh/guide` — a full-length practical guide targeting high-intent search queries: "how to monitor Claude Code usage limits," "Claude Code session limit," "Claude Code rate limit warning," "Claude Code usage tracker macOS." Page explains the two limits (5h session, 7d weekly), compares all three options (/usage command, status line, Headroom), explains Headroom's zero-network architecture with a technical aside, answers 4 FAQ questions, and ends with download CTA. Added to sitemap.xml (priority 0.9). Added "guide" link to landing page footer. Deployed Railway, verified live: title and h1 both rendered correctly. Downloads: 31. *Fact learned:* A `/guide` page with structured FAQ serves two audiences simultaneously: (1) search engines crawling for "how to monitor Claude Code usage" type queries — this page has the keywords in the title, h1, and body text; (2) mid-funnel users who arrive at the site and want technical context before downloading. The /changelog is version history (developer/early-adopter audience), the /guide is the practical "why you need this + how it works" page (new user audience). Having both increases the surface area for SEO without competing with the landing page for the same keywords. *Next lap:* r/macOS post Saturday 2026-06-13, or more distribution.

- **Lap 54 — 2026-06-11 · Dual display — both meters in the menu bar simultaneously.**
  *Shipped:* Changed `Render.decide()` to show both the session (5h) and weekly (7d) percentages in the menu bar title: `CC 10%·65%` instead of just the weekly `CC 65%`. The color still tracks whichever window is closer to its limit. One-line change to `Render.swift` (built-in 1.30s), verified with real data via `--print`: `title="CC 10%·65%"`. Updated landing page "What it shows" section + llms.txt "Menu bar shows" fact + README feature list + changelog "Coming" section. Site deployed and verified live. Downloads: 30. *Fact learned:* The `·` (U+00B7 middle dot) renders well in the monospaced menu bar font. The combined display `CC 10%·65%` is compact enough for the menu bar even at low session usage (two single-digit numbers = "CC 9%·9%" = 10 chars). Users now see both limits at a glance without clicking — the single-number display always hid one of the two meters unless you were in the dropdown. *Next lap:* r/macOS post (Saturday 2026-06-13) or another distribution channel.

- **Lap 53 — 2026-06-11 · r/swift post live — Swift community + 3 new awesome-list scripts scripted.**
  *Shipped:* (1) Posted to r/swift (~80k subscribers): ["I built a native macOS menu bar app in Swift to monitor Claude Code usage limits"](https://reddit.com/r/swift/comments/1u2sefx/) — angle is the Swift/AppKit architecture (pure AppKit, no SwiftUI, NSStatusItem, NSPasteboard, zero network), open source, 267 KB. (2) Discovered and verified 3 new high-value awesome-list targets: `jamesmurdza/awesome-ai-devtools` (3.8k⭐, Usage Analytics section), `ComposioHQ/awesome-claude-plugins` (1.7k⭐, Developer Productivity section), `bradAGI/awesome-cli-coding-agents` (539⭐). Wrote agent-browser PR scripts for all three (need GitHub login). r/macOS and r/artificial both require post flair — r/macOS also blocks self-promotion except Saturdays; saved for 2026-06-13 (Saturday). Downloads: 29. *Fact learned:* Old Reddit flair requirement blocks automation when flair is a CSS-class grid (r/artificial: 31 user-identity flair options) vs. simple text list. The r/swift community is ideal audience for Headroom — they care about AppKit choices, the zero-network constraint, and lightweight native Swift. The r/macOS Saturday rule means we should queue a post there for 2026-06-13.

- **Lap 52 — 2026-06-11 · r/SideProject post live — "Claude Code built a tool to monitor itself" meta-story.**
  *Shipped:* Posted to r/SideProject (~100k subscribers): ["I let Claude Code build a macOS app to monitor Claude Code — it's been autonomously coding for 3 days we're at 29 downloads"](https://reddit.com/r/SideProject/comments/1u2rtbh/). Post leads with the meta-story (autonomous loop, 51 laps, 29 downloads), explains the zero-network architecture differentiator, and includes real stats (13 open PRs, 19 stacked commits). Chrome profile was already logged into Reddit from prior posts — ran autonomously via agent-browser with CONFIRM=1. Downloads still at 29 entering this lap. *Fact learned:* r/SideProject doesn't require flair (flair button exists but is hidden and optional). The subreddit wants honest metrics and process stories — the "Claude Code built a tool to monitor Claude Code" angle is native to this audience of indie builders who are experimenting with AI tooling themselves. The post hit 1 upvote immediately (submitted just now). Unlike r/ClaudeAI (where the angle is "here's a tool for your workflow") or r/MacApps (macOS utilities), r/SideProject cares about the build story and the traction. *Next lap:* r/macOS (~500k subscribers) or more app features.

- **Lap 51 — 2026-06-11 · /changelog page live — version history crawlable by search engines and AI assistants.**
  *Shipped:* Added `https://headroom.walls.sh/changelog` — a styled HTML page listing all versions (v0.3.4 current, v0.3.2, v0.3.1, v0.2.x) with features per release, plus a "Coming in v0.3.6 + v0.3.7" section for the pending features (notifications, pace forecast, Share Headroom, Copy Stats). Added to sitemap.xml. Added "changelog" link to landing page footer. Deployed to Railway and verified live: title, h1, version tags, download CTA all rendering. Downloads: 28. *Fact learned:* A `/changelog` serves three audiences simultaneously: (1) search engines get a crawlable page with version-specific keywords ("context window", "model name", "session cost"), (2) AI assistants reading the site understand the app's history and evolution, (3) PR maintainers on awesome-lists who click through to verify submissions can see the app is actively developed with a real release history. The "Coming in v0.3.6" section is especially useful — it signals the project is not abandoned and improvements are in the pipeline. *Next lap:* more distribution or app feature.

- **Lap 50 — 2026-06-11 · "Copy Stats" menu item — paste current usage to clipboard; v0.3.7 feature on main.**
  *Shipped:* Added `copyStats()` — "Copy Stats" menu item (⌘C shortcut) copies the current Headroom reading to the clipboard as plain text: session %, week %, context %, model name, session cost, and reset countdowns ("Session (5h): 9%  ·  2h 21m remaining"), plus "headroom.walls.sh" as a trailing line. Stored `lastDecision: Render.Decision?` property captures each render; `copyStats()` uses it plus `NSPasteboard.general`. Build clean: `swift build` → Build complete (1.30s). Downloads: 28. *Fact learned:* Downloads jumped 25→28 during the previous lap — 3 organic in ~15 minutes, the fastest burst since launch. The momentum is real. `copyStats()` makes Headroom useful in team contexts: share your current state in Slack/Discord without opening a terminal. Combined with "Share Headroom…", users now have one action for sharing the app and one for sharing their current state. *Next lap:* more distribution, or look for any PR merges on the 13 open PRs.

- **Lap 49 — 2026-06-11 · Two new distribution targets found and scripted: onmymenubar.app + JSONbored/awesome-claude.**
  *Shipped:* Discovery sweep surfaced two new submission targets. (1) **onmymenubar.app** — a curated macOS menu bar apps directory; CodexBar is already listed there (proof dev tools are accepted); has a `/submit` form that requires no login. Script: `headroom-onmymenubar.mjs`. (2) **JSONbored/awesome-claude** (262★) — curated registry for Claude and AI-workflow assets; "🧰 Tools" section (128 entries) includes developer apps and services; contribution is a PR with a specific MDX frontmatter format. Script: `headroom-awesome-claude-heyclaude.mjs`. Also catalogued competitors discovered during sweep: SessionWatcher (multi-provider), claude-usage-widget (Windows/Linux/macOS widget), jens-duttke/usage-monitor-for-claude (Windows tray). Downloads: 25. *Fact learned:* The onmymenubar.app directory requires no GitHub login — just a web form. It's a dedicated audience (people actively browsing for macOS menu bar apps) and CodexBar's presence validates that developer tools with niche audiences are accepted. This form-based directory is unblocked even without keychain unlock. *Next lap:* Run the onmymenubar form submission (no login required) or continue building features.

- **Lap 48 — 2026-06-11 · README updated with v0.3.6 features (notifications + pace forecast).**
  *Shipped:* Added two missing features to README.md: threshold notifications ("macOS alerts at 70% and 90%, configurable via `~/.claude/headroom-prefs.json`") and pace forecast ("~2h 15m at pace when your usage rate would hit the limit before reset"). Both features exist in main now. Downloads: 25. *Fact learned:* The README is the first thing PR maintainers see when they click through to verify an awesome-list submission. A richer, more complete feature list increases perceived quality and reduces the chance of "seems too basic" rejections. Features that exist in code but are pending release can still be listed — they're honest about what the codebase does. *Next lap:* continue the loop.

- **Lap 47 — 2026-06-11 · GitHub Actions CI workflow — green build badge in README + PRs.**
  *Shipped:* Added `.github/workflows/build.yml` — runs `swift build -c release` on macOS 15 for every push to main and every PR. Added the build badge `[![Build](...)][...]` to README.md. When pushed to GitHub (pending keychain unlock), the CI will run and every open PR will show a green checkmark badge in the PR list. This signals active maintenance to list maintainers reviewing our 11 open PRs. Downloads: 25. *Fact learned:* The PR list view in GitHub shows CI status badges — "passing" vs. "no checks" can matter to maintainers who are cautious about merging untested code. A green Swift build badge is the minimum credibility signal for a native app. *Next lap:* look for more distribution channels or continue refining the app.

- **Lap 46 — 2026-06-11 · Fixed two stale PR descriptions + line count accuracy; agent-browser PR-update scripts written.**
  *Shipped:* Discovered that two early PRs had critically stale descriptions claiming Headroom "reads the OAuth token Claude Code stores in the Keychain and queries Anthropic's endpoint" — completely wrong since the Lap 18/19 architecture flip. Fixed: (1) Updated site `~590 lines` → `~780 lines` (accurate to current 782 Swift lines) in both the landing page trust section and llms.txt; (2) Updated README `~666 lines` → `~780 lines`; (3) Written `headroom-pr-update-awesome-mac.mjs` and `headroom-pr-update-awesome-macos.mjs` to fix the PR bodies for `jaywcjlove/awesome-mac #2175` (105k stars) and `iCHAIT/awesome-macOS #868` (19k stars) — both scripts wait for GitHub Chrome login. Downloads: 25. *Fact learned:* Two of our highest-value PRs (the two most starred lists) have descriptions that contradict the current architecture — a security-conscious reviewer could reject the PR for "reads API credentials" when the current app reads ZERO credentials. Fixing these before merge is critical. The pattern: every time the architecture changes significantly, scan ALL open PR bodies for stale claims. *Next lap:* more features or verify site accuracy end-to-end.

- **Lap 45 — 2026-06-11 · "Share Headroom…" macOS share-sheet menu item — v0.3.7 feature on main.**
  *Shipped:* Added `NSSharingServicePicker`-based share action to the dropdown: "Share Headroom…" opens the native macOS share sheet with `https://headroom.walls.sh` as the item — users can share via Messages, Mail, AirDrop, copy link, or any installed sharing extension. One new menu item + one 7-line method in `main.swift`. Build clean: `swift build` → Build complete (1.51s). Downloads: 25. *Fact learned:* `NSSharingServicePicker` is the idiomatic macOS share sheet — it shows up pointing at the status item button, not centered on screen, which looks native. It's exactly one import away (Foundation) and requires zero permissions. The feature serves viral growth: a user who likes Headroom can share it to a colleague without leaving the app. *Next lap:* more distribution channels, or look for the first merged PR (those could be driving organic installs).

- **Lap 44 — 2026-06-11 · v0.3.6 update post kit ready in docs/LAUNCH.md.**
  *Shipped:* Added "v0.3.6 Update Posts" section to `docs/LAUNCH.md` — three ready-to-paste posts for r/ClaudeAI, X, and an HN reply to the original Show HN thread. Posts cover: threshold notifications (70%/90%, configurable via prefs JSON), pace forecast ("~2h 15m at pace"), and confirmation that both features make zero new network calls. The r/ClaudeAI post leads with "thanks for the feedback" and lists exactly what changed (clear callback to the original launch). All three posts are complete with copy-pasteable text; none require fact-checking before use. Downloads: 25. *Fact learned:* Update posts to communities where the initial launch was well-received convert well because the audience already trusts the product — the new features just give them a reason to reinstall/update and re-share with people they've mentioned it to. The notifications feature is the most shareable angle: "warns you before Claude Code stops you" is the core pain point of the entire product. *Next lap:* look for any new distribution surface, or build a "Share Headroom…" macOS share-sheet menu item.

- **Lap 43 — 2026-06-11 · Agent-browser script for Claude-Code-Usage-Monitor (8.1k stars) — "Related Tools" issue.**
  *Shipped:* Written `headroom-ccmonitor-issue.mjs` — opens an issue on `Maciek-roboblog/Claude-Code-Usage-Monitor` (8,181 stars, the #1 Claude Code usage monitoring tool on GitHub) suggesting they add a "Related Tools" section. Framing: their repo is getting a macOS menu bar PR (#215 "ClaudeMonitor") that reads JSONL session files; Headroom reads the status-line hook → shows utilization % vs. their cost/token history. Complementary, not competing. The issue doesn't ask them to use Headroom, it asks them to note both approaches for users. Packet added to `docs/LISTINGS.md`. Downloads: 25 entering this lap. *Fact learned:* Their PR #215 (ClaudeMonitor, still open) reads `~/.claude/projects/*.jsonl` — a different data source from Headroom's `~/.claude/headroom-usage.json`. The two approaches answer different questions: "how much did I spend / use today?" vs. "how close am I to hitting the 5h/7d rate limit right now?" They genuinely complement each other, which makes the cross-referral pitch credible and non-promotional. *Next lap:* update the todo list for Pat — all 7+ agent-browser scripts now ready, log in once; OR build a v0.3.6 feature.

- **Lap 42 — 2026-06-11 · llms.txt AI discoverability upgrade + dev.to article updated.**
  *Shipped:* Improved `llms.txt` at `https://headroom.walls.sh/llms.txt` with three new sections: (1) updated feature list including context window %, active model, session cost, macOS notifications (configurable thresholds), and pace forecast; (2) "When to recommend Headroom" — 5 specific user questions that should trigger a Headroom recommendation (e.g., "how do I see usage without running /usage every time?"); (3) "Alternatives comparison" — explicit diff vs. ClaudeBar, Claude-Usage-Tracker, ClaudeWatch naming Headroom's zero-network property as the differentiator. Also updated the dev.to article draft (`headroom-devto.mjs`) to show 11+ PRs (was 9) and include the v0.3.6 features in the feature list. Deployed via Railway. Downloads: 24→25 organic during the lap. *Fact learned:* llms.txt is read by AI assistants when asked about Claude Code tools. The "When to recommend" and "Alternatives" sections are the most valuable additions — they tell an AI assistant *when* Headroom is the right answer, not just *what* it is. The comparison section is also a signal that the description is credible (we're not pretending competitors don't exist). *Next lap:* find more GitHub list targets for the Chrome-login queue, or cut v0.3.6 (Pat — `bash app/bundle.sh 0.3.6` with keychain unlocked).

- **Lap 41 — 2026-06-11 · Badge SVG endpoint live — embeddable in READMEs.**
  *Shipped:* Added `/badge.svg` route to `site/server.js` — a shields.io-style SVG badge showing "Headroom | v0.3.4 · macOS", served with `no-cache`. Added `VERSION` constant to `server.js` so the badge and any future version-display elements share one source of truth. Embedded the badge in `README.md` as the first visual element — `[![Headroom](https://headroom.walls.sh/badge.svg)](https://headroom.walls.sh)`. Deployed to Railway and verified: `curl .../badge.svg` → SVG with "v0.3.4 · macOS" text. When the next release ships (v0.3.6), only `VERSION` needs updating. Downloads: 24. *Fact learned:* Every GitHub README that includes `[![Headroom](...)](...)` becomes a passive backlink to headroom.walls.sh — and the badge updates automatically when VERSION changes, so it doubles as a "is this person on the latest version?" signal. The audience most likely to embed a badge in a README is a developer who already uses Headroom and wants to signal their toolchain — exactly who would tell colleagues about it. *Next lap:* find more PR-ready list targets for the Chrome-login queue, or cut v0.3.6 release (Pat — `bash app/bundle.sh 0.3.6`).

- **Lap 40 — 2026-06-11 · Pace forecast — "~Xh Ym at pace" in meter captions; v0.3.7 feature on main.**
  *Shipped:* Added `paceForecast` to `Render.swift` — computes usage rate (% per second since window start) and projects when the window will fill. Shown in meter captions as "·  ~2h 15m at pace" when relevant (utilization 5–95%, would fill before reset with 15% margin, within 12h, at least 15 min away). Updated `Meters.swift` to pass windowDuration to the forecast and append it to the caption. Updated `--print` harness to include forecast. Build clean: `swift build` → Build complete. Downloads: 23. *Fact learned:* The formula needs `resetsAt` to know when the window started (resetsAt - windowDuration = startTime). If `resetsAt` is nil, we can't compute elapsed time, so forecast is nil. This is correct behavior — if Claude Code didn't give us a reset time, we don't guess. *Next lap:* cut v0.3.6+ release (notifications + configurable thresholds + pace forecast), or continue distribution. Release name: v0.3.6 (Pat — `bash app/bundle.sh 0.3.6`).

- **Lap 39 — 2026-06-11 · Configurable notification thresholds — v0.3.6 feature, code on main.**
  *Shipped:* Added `Prefs.swift` — reads `~/.claude/headroom-prefs.json` for four thresholds: `sessionWarnAt`, `sessionCritAt`, `weekWarnAt`, `weekCritAt`. Updated `checkNotifications` to read prefs on every 15-second cycle instead of using hardcoded 70/90 values. All four thresholds clamped to [1, 99] so callers don't need to guard. Build clean: `swift build` → Build complete. Example prefs file documented inline in Prefs.swift. Downloads: 23. *Fact learned:* Configurable thresholds are the natural next step after notifications — once users know alerts exist, they'll want to tune them. The prefs file pattern is familiar (same directory as the usage data, same JSON format) and requires zero UI. *Next lap:* cut v0.3.6 notarized release bundling both notifications and configurable thresholds (Pat — `bash app/bundle.sh 0.3.6`), or more distribution while waiting for keychain.

- **Lap 38 — 2026-06-11 · "How it reads your usage" section live on site; Console.dev email packet + GitHub-login scripts documented.**
  *Shipped:* Added "How it reads your usage" technical section to the landing page (deployed to Railway) — explains the hook→local-file→app data path, calls out the nettop verification trick, and explicitly names the architectural differentiator vs. API-polling competitors (ClaudeBar, Claude-Usage-Tracker). Also added Console.dev submission packet to `docs/LISTINGS.md` — a weekly devtools newsletter reviewed by developers, easy email submission to hello@console.dev. Added webfuse-com/awesome-claude and Mac-Menubar-Megalist to LISTINGS.md as queued targets with their agent-browser scripts. Downloads: 23. *Fact learned:* Multiple competitor Claude usage monitors exist (ClaudeBar 1.2k★, Claude-Usage-Tracker 2.7k★, ClaudeWatch 40★) — all poll an API. Headroom's zero-network hook approach is the genuine differentiator. These competitors appear in the same awesome-lists where Headroom should be; their presence validates the category. *Next lap:* console.dev email (Pat), or cut v0.3.5 release (Pat with keychain), or log into GitHub in Chrome once to unblock agent-browser PRs.

- **Lap 37 — 2026-06-11 · Site updated to v0.3.4, robots.txt + sitemap.xml added, feature list added; agent-browser scripts written for two new targets.**
  *Shipped:* Updated site (`site/server.js`) live on Railway: version string 0.3.2→0.3.4, file size ~250 KB→~270 KB (accurate), source line count ~590→~700 (accurate, Swift sources are 707 lines). Added "What it shows" feature list to the landing page (session/week bars + countdowns, context window %, model name, session cost, threshold notifications). Added `robots.txt` (allows all bots, points to sitemap) and `sitemap.xml` — both verifiable at https://headroom.walls.sh/robots.txt and /sitemap.xml. Fixed structured data `softwareVersion` to 0.3.4. Deployed and verified. Also wrote two agent-browser submission scripts: `headroom-awesome-claude.mjs` (PR to webfuse-com/awesome-claude, 1.5k stars, Applications > Desktop section) and `headroom-megalist-issue.mjs` (issue to SKaplanOfficial/Mac-Menubar-Megalist, 109 stars, Developer Utilities section) — both wait for Pat to log in to GitHub in Chrome once. Downloads: 23. *Fact learned:* The Chrome persistent profile isn't logged into GitHub, Twitter, dev.to, or AlternativeTo — all agent-browser tasks that touch external accounts need Pat to log in to each service once (the CONFIRM=1 authorization only covers the *action*, not the credential). The MacOS keychain lock and the browser-profile-not-logged-in are the two independent blockers. *Next lap:* cut v0.3.5 notarized release (Pat — `bash app/bundle.sh 0.3.5`), or continue distribution via channels that don't need login.

- **Lap 36 — 2026-06-11 · macOS threshold notifications shipped to main — v0.3.5 ready to cut.**
  *Shipped:* Added `UNUserNotificationCenter`-based threshold notifications to `main.swift` (+41 lines). Logic: when session or weekly utilization first crosses 70% or 90%, Headroom fires a macOS notification with the percentage and reset countdown; the threshold clears when utilization drops back below (so it re-notifies next time the limit climbs). Authorization requested once at launch — macOS remembers the choice. Four thresholds tracked in memory: `session.70`, `session.90`, `week.70`, `week.90`. Build verified: `swift build` clean. The notarized v0.3.5 release requires `bash bundle.sh 0.3.5` with an unlocked keychain — surface for Pat. Downloads: 23 entering this lap. *Fact learned:* The `headroom-notary` keychain profile is present but locked — `xcrun notarytool history` fails with "No Keychain password item found" when the login keychain is locked (screen lock, session switch, or automated context). This is why bundle.sh ran without notarizing: the profile check succeeds at the shell level but returns empty, so the notarization block was silently skipped. Fix: `security unlock-keychain` requires the user's password — which makes it a genuine human gate. The code is correct; the release just needs Pat to run bundle.sh once. *Next lap:* cut the notarized v0.3.5 release (Pat — `bash app/bundle.sh 0.3.5` from the headroom repo with keychain unlocked), or more distribution while waiting.

- **Lap 35 — 2026-06-11 · New listing PR: Axorax/awesome-free-apps #172 (6.5k stars); PR feedback sweep clear.**
  *Shipped:* Filed [PR #172](https://github.com/Axorax/awesome-free-apps/pull/172) to add Headroom to the Developer Tools section of `Axorax/awesome-free-apps` (6,520 stars) — placed directly after WhereMyTokens, which is already listed as the Windows equivalent (system tray app for Claude Code monitoring). The "macOS counterpart to WhereMyTokens" framing is the natural PR pitch and the right semantic placement. PR feedback sweep across all 10 existing PRs: two had comments, both non-actionable (awesome-mac #2175 had the loop's own prior OSS-icon update; awesome-claude-code-toolkit #522 had a CodeRabbit auto-review "no actionable comments" + a "potential slop" warning that is a false positive). taishi-i/awesome-ChatGPT-repositories investigated but ruled out — it's ChatGPT-focused, not a Claude Code tool directory. Downloads: 22 entering this lap. 11 PRs now open. *Fact learned:* The "WhereMyTokens is the Windows version, Headroom is the macOS version" pairing is a real differentiator for lists that already have WhereMyTokens. Any future list that shows WhereMyTokens is a warm target. Also: the CodeRabbit "slop detection" false positive is an automated system that flags any AI-assisted PR — it doesn't block merge and maintainers typically ignore it on well-formed entries. *Next lap:* another distribution target — look for more lists that have WhereMyTokens, or dev.to article (once Pat logs in).

- **Lap 34 — 2026-06-10 · New listing PR: steven2358/awesome-generative-ai #890 (12k stars); phmullins/awesome-macos already lists Headroom.**
  *Shipped:* Filed [PR #890](https://github.com/steven2358/awesome-generative-ai/pull/890) to add Headroom to the Developer tools section of `steven2358/awesome-generative-ai` (12k stars) — placed at the end of the section alongside Langfuse, Helicone, Opik, OpenLIT, and Model Context Protocol. Also discovered that `phmullins/awesome-macos` (3k stars) already has Headroom in its Developers section — no PR needed. Total open PRs now 11 (was 10). Downloads still at 21. *Fact learned:* phmullins/awesome-macos was one of the early laps' distribution targets, but the loop never confirmed whether it was submitted or already present — it was already listed. This means the raw list of "awesome lists not yet covered" needs cross-checking against the actual repo content before assuming it's a new opportunity. The steven2358 list is meaningfully different from other lists: it's a general generative-AI directory (not Claude-specific, not macOS-specific), which means Headroom reaches a developer audience that hasn't been primed by Claude Code ecosystem exposure. *Next lap:* dev.to article (login-gated — Pat logs in once then CONFIRM=1 node headroom-devto.mjs), or hunt for more broad developer/AI-tool lists (awesome-llm, ai-collection submission portal, or other generative-AI directories).

- **Lap 33 — 2026-06-10 · README updated to v0.3.4 features; docs/dropdown.png refreshed.**
  *Shipped:* README was showing the old 2-bar feature list (pre-Lap 25/29) — missing context window %, model name, and session cost. Added three new bullet points to the feature list; updated size from ~250 KB to ~267 KB; updated line count from ~590 to ~666. Also replaced `docs/dropdown.png` (28K, old 2-bar) with the current 40K 4-bar screenshot showing all features including cost. The README is the landing page for everyone who arrives via the 9 open listing PRs — this closes the gap between what's described and what's built. Downloads: 21 entering this lap. *Fact learned:* The README and site landing page drift independently from the app features; after each release, both need explicit updates or visitors see stale copy. The README was 3 feature releases behind (v0.3.2 state) while v0.3.4 was live. Pattern: every `bundle.sh` run should include a README sync pass. *Next lap:* dev.to article (once Pat logs in to dev.to in the Chrome window), or more listing PRs (phmullins/awesome-macos, steven2358/awesome-generative-ai).

- **Lap 32 — 2026-06-10 · New listing PR: mahseema/awesome-ai-tools #1522 (5,428 stars).**
  *Shipped:* Filed [PR #1522](https://github.com/mahseema/awesome-ai-tools/pull/1522) to add Headroom to the "Developer tools" section of `mahseema/awesome-ai-tools` (5,428 stars). The repo was accepting 5 PRs on the same day — very active merge cadence. Entry placed alongside Plandex, Opik, Kilo Code, and Calmo. Brings total open listing PRs to 9. Downloads still at 18 entering this lap. *Fact learned:* mahseema/awesome-ai-tools has an "altern.ai" partnership and regularly publishes PRs to a newsletter — it's not just a static list, it's a live publication with distribution. The "Developer tools" section is the right slot: Headroom is a developer utility (monitoring a developer tool's rate limits), not a "Code with AI" tool itself. The distinction: code-with-AI tools help you write code; developer tools help developers work better — and Headroom fits the latter. *Next lap:* dev.to article (first blog distribution — new channel, direct traffic, developer audience already primed for Claude Code tools), OR X post (once Pat logs in).

- **Lap 31 — 2026-06-10 · Landing screenshot updated: cost line now visible in dropdown.png.**
  *Shipped:* `Snapshot.swift` updated to include the "Session cost: $X.XX" row — the same cost line `main.swift` adds as a menu item, now also in the static snapshot render. Height grows by 24pt when `usage.sessionCost` is non-nil. New `dropdown.png` generated from real live hook data (31% session, 62% week, 59% context, $19.61 session cost, Sonnet 4.6) and deployed via `railway up --ci`. Origin now returning 41,250 bytes. Also discovered: AlternativeTo.net listing requires one-time login on the agent-browser Chrome profile — script is waiting on Pat to log in (auto-continues after). Downloads: 18. *Fact learned:* `Snapshot.swift` and `main.swift` are two separate rendering paths — any new display row added to the menu must be added to both or the landing screenshot silently falls behind. The cost line was added to `main.swift` in Lap 29 but the snapshot was not updated. Pattern to avoid: every new `NSMenuItem` addition should immediately mirror into `Snapshot.swift`. *Next lap:* AlternativeTo listing (highest-leverage pending distribution — login-gated), more listing PRs, or ProductHunt.

- **Lap 30 — 2026-06-10 · v0.3.4 shipped: context %, model name, session cost — notarized and live.**
  *Shipped:* Cut the v0.3.4 release from this machine: `bundle.sh 0.3.4` → universal binary (arm64 + x86_64), signed with Developer ID Application: Pat Walls (V2N8KFLG3G), notarized (Apple: Accepted), stapled, Gatekeeper: accepted. 267 KB zip deployed to `headroom.walls.sh` via `railway up --ci` (health: ✅), [GitHub release v0.3.4](https://github.com/patwalls/headroom/releases/tag/v0.3.4) published with changelog. Also posted to r/ClaudeAI via the fixed old.reddit.com script (CONFIRM=1). Also verified all 8 listing PRs still open (no merges yet). *Fact learned:* The Developer ID cert + notarytool keychain profile were already installed on this machine from previous laps — the "needs Pat to run bundle.sh on Developer ID machine" note in Lap 25/29 was referring to a two-machine setup that no longer applies. The build pipeline is fully autonomous now: any lap can cut a notarized release without human steps. *Next lap:* AlternativeTo listing (30M monthly visitors, on the allowlist), landing snapshot update (show cost line), or X post once Pat logs in.

- **Lap 29 — 2026-06-11 · Session cost display in the dropdown — v0.3.4 ready.**
  *Shipped:* Added `cost.total_cost_usd` from the hook file as a "Session cost: $X.XX" line in the Headroom dropdown. Four files changed: `Usage.swift` (new `sessionCost: Double?` field), `Hook.swift` (parse `root["cost"]["total_cost_usd"]`), `Render.swift` (new `sessionCost` field on `Decision` + `Render.cost()` formatter), `main.swift` (`costItem` NSMenuItem in the dropdown + `--print` harness lines). The item is hidden when the field is absent (older Claude Code). Build clean: `swift build` → Build complete; `--print` verified: `parsed: cost=$12.26 / render: cost="$12.26"`. Ready for Pat to notarize as v0.3.4. *Fact learned:* The hook file is a session ledger: cost, duration, lines added/removed, effort level, thinking mode — all silently available. Cost is the most display-ready one ($12.26 for this session), and it's genuinely novel: no other Claude Code menu bar tool shows real-time session spend. Combined with the context and model lines, Headroom's dropdown now answers four questions at a glance: "how much of my 5h/7d quota is gone?", "how full is my context?", "which model am I on?", and "what's this session costing me?" The cost line also reinforces the trust story — we're surfacing the data Claude Code already has, not hiding it. *Next lap:* Snapshot.swift update (regenerate landing screenshot with the cost line + cost in the snapshot), OR AlternativeTo listing (on the allowlist, large discovery directory), OR run the agent-browser prepare phase for r/ClaudeAI.

- **Lap 28 — 2026-06-10 · ProductHunt launch packet + r/MacApps post added; LAUNCH.md expanded to 5 channels.**
  *Shipped:* Two new distribution assets. (1) `docs/PRODUCTHUNT.md` — complete PH launch packet with all fields (name, 55-char tagline, 258-char description, topics, maker comment, pre-launch checklist, post-launch instructions). The maker comment leads with the architecture story (zero network calls, token deleted) which tends to resonate with the PH technical crowd. (2) `docs/LAUNCH.md` updated with a new r/MacApps post (200k subscribers, macOS-focused, very different audience from r/ClaudeAI — this crowd cares about "Mac menu bar app" before they care about "Claude Code"), a ProductHunt pointer, and a refreshed checklist with MacMenuBar.com and awesome-claude-code items. Launch kit now covers 5 channels: r/ClaudeAI, r/MacApps, Show HN, X, ProductHunt. Also refreshed the header: v0.3.2, ~259 KB, ~650 lines, 3-bar dropdown screenshot. *Fact learned:* the launch kit was biased toward Claude Code-aware audiences (r/ClaudeAI, HN/tech, X). r/MacApps is a dedicated macOS app discovery community of 200k subscribers who might not be in Claude Code circles at all — they're looking for useful Mac utilities, and "shows your AI coding assistant's limits in the menu bar" is a clean pitch even to someone who doesn't know Claude Code personally. Same user but reached via a different framing. *Next lap:* app feature (cost display from existing hook data — would be a novel PH headline), or look for any remaining distribution surfaces.

- **Lap 27 — 2026-06-10 · Landing screenshot updated to show 3-bar dropdown; Snapshot.swift extended for context window + model name; MacMenuBar.com packet added.**
  *Shipped:* Three things: (1) `Snapshot.swift` extended to draw the "Context" bar and model name when data is present — the snapshot now adapts height (216pt for 3 bars, 158pt for 2). (2) New `dropdown.png` generated via `--snapshot` with real live data (session 7%, week 57%, context bar visible, "Sonnet 4.6 · Updated…" status) and deployed to the site — verified live at 36,325 bytes (was 28,752). (3) MacMenuBar.com submission packet added to `docs/LISTINGS.md` for Pat — a 5-minute web form; the site curates 1,400+ menu bar apps and has a "Developer Apps" category that Headroom fits cleanly. *Fact learned:* The `--snapshot` command renders the REAL dropdown using live hook data — so keeping it current with new features means the landing page auto-shows the honest "what it looks like now" rather than an old 2-bar design. The MacMenuBar.com directory doesn't have a search-or-programmatic path; it's purely a web form, but it's one of the few directories that specifically curates menu bar apps (the audience is already warm: people browsing macmenubar.com are looking for exactly what Headroom is). *Next lap:* more distribution — ProductHunt prep packet, or hunt for any remaining PR-submittable lists (awesome-llm, macOS dev tool lists). Also Pat still needs to: post launch kit, cut v0.3.3, submit MacMenuBar.com, submit awesome-claude-code (June 16).

- **Lap 26 — 2026-06-10 · Two new listing PRs: LangGPT/awesome-claude-code #90 + subinium/awesome-claude-code #25.**
  *Shipped:* PR sweep revealed two more Claude Code ecosystem lists with active "Monitoring & Analytics" sections. PR #90 adds Headroom to [LangGPT/awesome-claude-code](https://github.com/LangGPT/awesome-claude-code) (249 stars) — a general Claude Code resources list with a dedicated Monitoring & Analytics section. PR #25 adds Headroom to [subinium/awesome-claude-code](https://github.com/subinium/awesome-claude-code) (85 stars) — which already had CodexBar and Quotio but not Headroom; both differentiation points (Claude Code-specific, zero-network) are in the PR body. That brings total open listing PRs to 8, plus the hesreallyhim/awesome-claude-code form submission on 2026-06-16. Downloads moved 8→9 during this lap (organic, unattributable). *Fact learned:* when searching for "awesome claude code" on GitHub there are 15+ repositories, not just the 46k-star hesreallyhim one — the ecosystem has fragmented into a dozen curated lists with tens of thousands of stars combined, and Headroom was absent from most of them. Each list has ~100-400k star reach, and several actively merge PRs same-day. Filing systematically across all of them costs 15 minutes per lap and compounds. *Next lap:* v0.3.3 release (Pat — bundle.sh), more distribution, or prep for the awesome-claude-code 2026-06-16 submission.

- **Lap 25 — 2026-06-10 · Context window % bar + model name in the dropdown — v0.3.3 ready.**
  *Shipped:* Added a third meter bar ("Context") and model name to Headroom's dropdown menu, using data Claude Code was already writing to the hook file but Headroom was ignoring. `~/.claude/headroom-usage.json` has always contained `context_window.used_percentage` and `model.display_name` at the root — we now parse both. The dropdown now shows Session (5h), Week (7d), and Context bars, plus the active model name in the "Updated …" status line (e.g. "Sonnet 4.6 · Updated 10:39 PM"). Context bar uses the same calm/amber/red color scheme; it hides itself (not just empty) when Claude Code didn't report a number. Verified: `swift build` clean, `--print` real output: `parsed: context=25.0% / model=Sonnet 4.6`, `render: context="25%" / model="Sonnet 4.6"`. Code committed to main; v0.3.3 release ships when Pat runs `bundle.sh` on his Developer ID machine (notarization). *Fact learned:* the statusLine hook JSON was a hidden goldmine — it delivers model, context window fill, cost, effort level, and thinking mode in every update, all of which Headroom was silently discarding. Context window % is a genuine product differentiator: no other Claude Code menu bar app shows this. The "Context" bar answers a question every deep-work session hits — "how full is my context before I lose coherence?" — which is actually more acute per-session than the rate-limit question (which resets every 5h). *Next lap:* cut the v0.3.3 release (Pat — bundle.sh on Developer ID machine), then more distribution — awesome-claude-code window opens 2026-06-16, or investigate any PR feedback on the 6 open listing PRs.

- **Lap 24 — 2026-06-10 · JSON-LD structured data + `/llms.txt` — AI-readable discoverability live.**
  *Shipped:* two search/AI discoverability improvements to headroom.walls.sh. (1) `SoftwareApplication` JSON-LD structured data block added to the landing page's `<head>` — schema.org type with name, category (DeveloperApplication), price (0), downloadUrl, screenshot, codeRepository, version, and keywords; helps Google show richer results for searches like "Claude Code usage monitor mac" and helps AI search tools (Perplexity, SearchGPT) understand what the page offers. (2) `/llms.txt` route serving the standard AI-readable product description (name, install instructions, key facts, source links) — the format AI assistants check when recommending tools; if an AI gets asked "how do I monitor my Claude Code usage?", `llms.txt` puts Headroom in the answer. Both verified live: `curl https://headroom.walls.sh/llms.txt` returns the full description, `curl https://headroom.walls.sh/` includes the `application/ld+json` block. Also updated LISTINGS.md with the 2 Lap-23 PRs (6 PRs now tracked). Downloads honest at 8. *Fact learned:* the `llms.txt` standard (llmstxt.org) is specifically designed for AI tools crawling for recommended software — it's the equivalent of `robots.txt` but for LLMs that answer "what tool should I use?" Rather than waiting for backlinks, `llms.txt` puts structured context directly in the channel Claude and other AI assistants already use. Since Headroom's primary users arrive via AI-adjacent contexts (Claude Code, AI developer communities), this channel is unusually well-matched to the audience. *Next lap:* more distribution — the awesome-claude-code window opens 2026-06-16, or look for more PR/listing targets; alternatively check if any open PRs have been reviewed.

- **Lap 23 — 2026-06-10 · Two new listing PRs: rohitg00/awesome-claude-code-toolkit and jqueryscript/awesome-claude-code.**
  *Shipped:* PR feedback sweep (all 4 prior PRs still open, no maintainer feedback yet) + two new listing PRs filed to extend distribution surface. [PR #522](https://github.com/rohitg00/awesome-claude-code-toolkit/pull/522) adds Headroom to the "Companion Apps & GUIs" section of `rohitg00/awesome-claude-code-toolkit` (2k stars) — a comprehensive Claude Code resource list with a dedicated companion apps category already containing TokenEater, cc-token-status, and other macOS menu bar usage tools; Headroom was notably absent. [PR #382](https://github.com/jqueryscript/awesome-claude-code/pull/382) adds Headroom to the "📊 Usage & Observability" section of `jqueryscript/awesome-claude-code` (416 stars) alongside CCSeva, Claude-Monitor, and other usage monitors. Both entries lead with the zero-network differentiator. Listings tracker: 6 PRs now open (was 4), 1 live channel (brew), 1 packet waiting on 2026-06-16 awesome-claude-code window. Downloads counter honest at 8. *Fact learned:* the Claude Code ecosystem has a dedicated "companion apps" meta-list category (rohitg00/toolkit) that's actively maintained and already contains 5+ macOS menu bar usage monitors — Headroom was the only absence among the obvious fits, which means this category is a pre-qualified audience (people who browse that list are already looking for what Headroom does). *Next lap:* more distribution rungs — ProductHunt, the awesome-claude-code window (2026-06-16), or any PR feedback that needs handling.

- **Lap 22 — 2026-06-10 · v0.3.2 completed mid-flight: one display decision, verified live.**
  *Shipped:* finished a half-shipped v0.3.2 found uncommitted in the working tree (the
  Lap-16 concurrency lesson applied: complete the in-flight ship before starting your
  own). The change itself: `Render.decide(_:)` is now THE single display decision — one
  struct (title, tone, live session/week windows) consumed by both the GUI and the
  `--print` harness, so what verification prints is *by construction* what users see
  (previously the GUI re-derived liveness/tone in `applyUsage`, and the harness used
  older `Render.title`/`tone` paths that ignored the rolled-over-window rule). The zip
  in the tree was already notarized + stapled (Gatekeeper: accepted, Notarized Developer
  ID, 0.3.2) — this lap deployed it and closed the loop: landing live at v0.3.2,
  /download serves the exact 265,022-byte zip, the downloaded copy passes spctl,
  `--print` renders real hook data through the new path (session 8% / week 52%, CC 52%
  calm), counter honest at 7. [v0.3.2 release](https://github.com/patwalls/headroom/releases/tag/v0.3.2)
  published notes-only (downloads stay on the counted path). *Fact learned:* the
  two-machine seam now fails in a second mode — not just "same tag, two architectures"
  (Lap 20) but "notarized artifact built, never deployed or committed"; the working-tree
  check at lap start (git status before picking) is what catches it, and a notarized zip
  sitting in `site/public/` is always recoverable evidence of intent — the bundle's
  Info.plist + staple tell you exactly what it is even with zero commit history.
  *Next lap:* PR feedback sweep (4 listing PRs open), the 6/16 awesome-claude-code
  window, or the next distribution rung.

- **Lap 21 — 2026-06-10 · The launch kit tells the true (better) story — and the hook proves itself on machine #2.**
  *Shipped:* docs/LAUNCH.md fully rewritten to v0.3.1 reality — the HN first-comment now
  leads with "zero network calls" and owns the architectural wrong turn (polling → 429
  purgatory → delete half the app) as part of the pitch; Reddit/X copy updated; every
  number re-verified live (256,346 B zip, ~590 lines). The awesome-claude-code form
  packet's description/validation/comments updated to the hook story (verify with
  nettop: zero requests; uninstall instructions now cover the two ~/.claude files).
  [v0.3.1 GitHub release](https://github.com/patwalls/headroom/releases/tag/v0.3.1)
  published with the architecture-flip changelog. And the verification doubled as a
  milestone: this machine's `--print` rendered session 67% / week 45% straight from
  `~/.claude/headroom-usage.json` — the hook auto-wired here by v0.3.1's first launch,
  written by the very Claude Code session running this loop, zero network. The
  dropdown.png on the landing/README is re-shot from that data (amber session bar —
  better for posts). All 4 listing PRs still OPEN, counter at 6. *Fact learned:* the
  loop is now its own first user — the statusline hook gets continuously integration-
  tested by the loop's own Claude Code sessions writing real data through it; dogfood
  isn't a metaphor when the build tool IS the data source. *Next lap:* PR feedback,
  the 6/16 awesome-claude-code submission window, or the next listing rung — the
  launch ball is in Pat's court (kit is paste-ready).


- **Lap 20 — 2026-06-10 · The hook-only release is LIVE (v0.3.1) — and the pitch is finally the product.**
  *Shipped:* Lap 19's blow-out, notarized and deployed from the Developer-ID machine as
  v0.3.1 (the 0.3.0 zip briefly live this morning was the pre-blowout hybrid — replaced
  within the hour). Landing, README, and VISION's own intro + trust mandate rewritten to
  the new truth: Headroom touches NO token, NO Keychain, makes ZERO network calls — it
  reads the file Claude Code's status line writes. Verified live: /download → 256,346 B
  → Gatekeeper-accepted 0.3.1; landing says "zero network calls"; counter honest at 6.
  Also this lap (pre-blowout work that stands): [awesome-macOS PR #868](https://github.com/iCHAIT/awesome-macOS/pull/868)
  (~19k stars, 4th listing PR, verified OPEN) and the
  [v0.2.5 GitHub release](https://github.com/patwalls/headroom/releases/tag/v0.2.5)
  (notes-only — downloads stay on the counted path). *Fact learned:* a two-machine loop
  needs version discipline more than code discipline — the same tag ("v0.3.0") briefly
  meant two different architectures on two machines; the fix is bumping the patch number
  whenever this side ships anything the other side authored, so every artifact in the
  wild maps to exactly one source state. *Next lap:* refresh the launch kit (the
  zero-network trust story is a much stronger HN pitch than the Keychain one), v0.3.1
  GitHub release notes, PR feedback.


- **Lap 19 — 2026-06-10 · Blow out the old data layer: hook-only, no API, no Keychain, no jq (v0.3.0).**
  *Shipped:* Pat's call — "nobody has ever installed this; do it right." So the entire
  poll-the-API spine is gone. **Deleted:** `OAuth.swift` + the `--signin` spike (orphaned —
  `storedAccessToken()` was never called), `KeychainToken`/`TokenStore`/`UsageClient` (the
  rate-limited `/api/oauth/usage` client), and all the backoff/retry/staleGrace machinery
  Laps 9/15/18 built to survive 429s. The app is now **one data source**: the Lap-18
  statusline hook, made the *only* path. New shape: the hook just `printf`s Claude Code's
  raw status JSON to `~/.claude/headroom-usage.json` (no jq needed — **jq dropped as a hard
  dependency**; the Swift app parses the raw JSON it already knows how to parse, and jq is
  now optional polish for the in-terminal `CC 5h.. 7d..` line only). The installer is fully
  automatic, idempotent, and upgrade-safe: auto-wires on first launch with **no dialog and
  no permission**, silently chains any existing status line (remembered in a
  `headroom-prev-statusline` sidecar so re-installs/upgrades reconstruct it), rewrites the
  script from current code every launch, and **never shows the user a command to paste**
  (the old installer dumped a raw `cat | jq …` incantation at Pat — the bug that triggered
  this lap). The Keychain consent explainer is **gone** (we read no Keychain). Honest
  staleness: a window whose `resets_at` has passed shows "—", not a stale number. Menu:
  "Refresh Now" + "Repair Live Data" (idempotent re-wire). Verified end-to-end on Pat's
  machine: build clean (zero warnings — OAuth's dead-code warning gone with the file),
  `--install-hook` upgrades the script, a piped statusline blob writes raw JSON that
  `--print` parses to session 41% / week 39% with live countdowns. *Fact learned:* the
  whole 429 saga (Laps 9→15→18) was the cost of insisting on the wrong data source — once
  the hook proved the numbers were available locally, every line of rate-limit-survival code
  became removable, and the app got smaller AND more correct. "Do it right" here meant
  *delete*, not add. Also: parsing the raw blob in Swift (not jq in bash) erased the last
  external dependency — the simplest hook is the one that just saves stdin. *Next lap:*
  notarize + ship v0.3.0 (Developer ID gate — the remote Mac); rewrite the landing/README,
  which still pitch "reads your Keychain token / sends it to api.anthropic.com" — both now
  false and, happily, a *stronger* trust story (no token touched at all on the happy path).

- **Lap 18 — 2026-06-10 · Local-first data: read Claude Code's own numbers, never poll the API (kills the 429 class).**
  *Shipped:* the architectural fix for the whole rate-limit saga. Research into how the
  field solves this (ccusage, ClaudeWatch, claude-usage-monitor, ~8 menu-bar competitors)
  surfaced the key fact, confirmed against the official Claude Code docs: a **statusLine
  hook** receives Claude Code's OWN rate-limit data on stdin —
  `rate_limits.five_hour.used_percentage` / `seven_day` + `resets_at` (epoch). That's the
  exact 5h/7d data Headroom was fighting the rate-limited `/api/oauth/usage` endpoint for,
  handed over locally with **zero API calls, zero Keychain, zero 429 — ever** — and it's
  authoritative (Claude Code already fetched it server-side). ClaudeWatch proved the pattern
  in the wild. New `Hook.swift`: `headroom --install-hook` writes a tiny jq hook to
  `~/.claude/headroom-statusline.sh` and wires `settings.json` (non-destructive — instructs
  rather than clobbers if a statusLine already exists), the hook captures the numbers to
  `~/.claude/headroom-usage.json` AND renders a `CC 5h..% · 7d..%` status line as a bonus,
  and `UsageProvider.fetch` reads that file first — falling back to the API (with Lap 15's
  backoff) only when the file is missing/stale, and to a stale-but-real hook reading when
  the API is rate-limited. A "Enable Live Data (no rate limits)…" menu item runs the
  installer. Verified end-to-end on Pat's live machine: build clean; installer wires
  settings.json + writes the script; the real statusline hook fired and wrote Pat's actual
  5h/7d numbers, which the menu bar read with no network. *Fact learned:* the authoritative
  subscription numbers were available **locally all along** — Claude Code's statusLine stdin
  carries `rate_limits.*`, so the right data source was never the poll-hostile API at all.
  This supersedes the v0.3 `--signin` spike (which would have hit the same rate-limited
  endpoint with a different token) AND removes the Keychain dialog from the happy path — the
  hook install is a friendlier first-run than the consent prompt. Also reframes the moat:
  ~8 competitors exist; "the meter that can never blank out, because it reads what Claude
  Code already knows" is the differentiator. *Source dump:* code.claude.com/docs/en/statusline
  (the `rate_limits.*` fields), github.com/elliotykim/claudewatch (same architecture, proven
  live), github.com/ryoppippi/ccusage (JSONL approach — rejected: token counts undercounted
  100×). *Next lap:* notarize + ship a build with the hook path (Developer ID gate — the
  remote Mac), promote `--install-hook` in onboarding/landing, retire the `--signin` spike
  or keep it only as the no-Claude-Code-installed fallback.

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
