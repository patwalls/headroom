---
description: Run ONE lap of the Headroom loop — ship one real thing toward 100 stranger downloads, verify with real output, log it, push.
argument-hint: "[optional focus, e.g. 'keychain' or 'notarize']"
allowed-tools: Bash, Read, Edit, Write, Glob, Grep
---

## Context (auto-injected)

- Repo: !`pwd` on branch !`git branch --show-current`
- North Star + milestones + loop log: @VISION.md
- Recent laps (git): !`git log --oneline -6`
- App builds: !`cd app && swift build 2>&1 | tail -1`
- Site live: !`curl -s -o /dev/null -w "%{http_code}" --max-time 10 https://headroom.walls.sh/health 2>/dev/null` · downloads: !`curl -s --max-time 10 "https://headroom.walls.sh/metrics?probe=1" 2>/dev/null | head -c 200`

## Your task — one lap, start to finish

You are running the **Headroom** entrepreneur loop (see `VISION.md`). Headroom is a macOS
menu bar app showing Claude Code session (5h) + weekly (7d) utilization as a live %,
Wall #003 of walls.sh. The North Star is **📥 100 real downloads by strangers** — counted
by the site's own `/metrics` (probes excluded). A lap ships **one real thing** toward 100
and ends with **one fact learned**. Optional focus: **$ARGUMENTS**

**THE AUTONOMOUS MANDATE (§0.5) — do not violate:**
- **Never stop, never "pause the loop," never declare "done," never go to watch mode.**
  There is always a next lever toward 100 downloads — build, polish, or distribute.
  Distribution alone is a never-ending backlog.
- **Never wait for Pat to do something the loop can do itself.** Build it, deploy it,
  publish it, ship it. Only truly human-gated steps (a credential, a spend, an account
  login, an irreversible call) get surfaced — and you run a *different* lap meanwhile,
  never blocking.
- **Verify with real output, never fake a number.** A lap that "should work" didn't ship.
- **One lap = one shipped thing + one fact learned.**
- **Respect the trust position.** The token goes to `api.anthropic.com` and NOWHERE else —
  never logged, never phoned home. Stated publicly on the landing page.

1. **Pick the lap.** Read `VISION.md` §0 (North Star + ladder) + the loop log. Take the
   highest-leverage unblocked rung. Early ladder: Keychain token → real usage % → menu bar;
   then color-coding + both windows; then the downloadable build + site deploy; then
   distribution (the endless backlog). State the one lap.

2. **Ship it.** Real commands for THIS venture:
   - **App:** `cd app && swift build` (dev) · `swift build -c release` (ship). A
     downloadable release = release binary → `Headroom.app` bundle (Info.plist with
     `LSUIElement: true`) → `ditto -c -k` zip → `site/public/` for `/download`.
     Codesign/notarize (`codesign --deep --sign "Developer ID Application: …"`,
     `xcrun notarytool submit`) once the Apple Developer ID exists — until then ship
     ad-hoc-signed and say so honestly on the landing page.
   - **Site:** `cd site && railway up --ci` (service `headroom`). First deploy: also
     `railway init --name headroom`, then `node ~/code/walls/bin/cf.mjs add headroom
     <railway-host>` and update the wall's `origin` + flip `status` to `live` ONLY after
     a real 200 from `https://headroom.walls.sh/health`.

3. **Verify with real output — show the command + result, never "should work":**
   - App laps: `swift build` exit 0, and run the binary / a test harness that prints the
     REAL utilization JSON from the real endpoint with the real Keychain token.
   - Site laps: `curl -s https://headroom.walls.sh/health` → 200;
     `curl -s "https://headroom.walls.sh/metrics?probe=1"` → real downloads count.
   - If a platform/endpooint answers differently than expected, that's the bug to chase —
     dig in, don't paper over it.

4. **Log the lap.** Prepend to `VISION.md`'s loop log: `**Lap N — <date> · <title>.**
   *Shipped:* … *Fact learned:* …` — and tick any milestone that's now true.

5. **Commit + push.** Stage only this lap's files, commit with a `Lap N:` subject + the
   `Co-Authored-By: Claude Fable 5 <noreply@anthropic.com>` trailer, push origin main.

6. **The dossier contract — keep Wall #003 honest, every lap.** Edit
   `~/code/walls/registry.json` (the `headroom` wall's `project` block): move finished
   items to `done` stamped `{ "text": …, "at": "<ISO date>" }`, keep `todo` current
   (the loop's queue), keep `roadmap` mirroring VISION §0's ladder (✅ done, → current),
   tag `owner: "you"` ONLY for genuinely human steps (the Apple Developer ID, a spend, a
   posting). Then commit + push the walls repo too — the Walls loop redeploys the board
   on its next wakeup.

### Rules (from VISION §4)

- **Close the loop before polishing.** A real % in the menu bar beats a beautiful icon.
- **Show real numbers.** Live or absent — never typed where a live one belongs.
- **One lap = one shipped thing + one fact.**
- **Surface, don't fake, human-only steps.** Do everything up to the line, name the exact
  one thing Pat must do, run a different lap meanwhile.

End by stating: what shipped, the fact learned, and the lap you'll likely run next.
