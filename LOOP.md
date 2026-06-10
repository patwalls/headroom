# The Headroom Loop

Headroom runs the same **build loop** as Superhighway and Pulse: ship one real thing per
lap toward the North Star, verify it with real output, log it, push. Headroom is Wall #003
of walls.sh — a macOS menu bar app that shows your Claude Code usage as a live %.

## The two pieces

1. **The plan** — [`VISION.md`](./VISION.md): the North Star (§0 — **100 real downloads by
   strangers**), the milestone ladder, the autonomous mandate, and the **loop log** (every
   lap, newest first: *what shipped + the fact learned*).
2. **The motor** — the [`/lap`](./.claude/commands/lap.md) command: one lap = read the
   plan → pick the highest-leverage rung → ship + **verify with real output** → log →
   keep the wall honest → commit + push.

## Running it

Open a session rooted in this repo (`~/code/headroom`), then:

```
/go                  # THE command — start the autonomous loop (laps on repeat, self-paced)
/go 1h               # same, one lap per hour
/lap                 # run exactly ONE lap — supervised mode
/lap keychain        # one lap, focused on a topic you name
```

**`/go` is the ignition** — the memorable name for `/loop /lap`, same in every venture repo.

## The two halves of the product

- **The app** (`app/`) — a Swift Package, zero dependencies. Build: `swift build`
  (release: `swift build -c release`). Run it locally to see the status item. Shipping a
  downloadable build means: release build → `.app` bundle → zip → (eventually) codesign +
  notarize — the Apple Developer ID is the one known human gate.
- **The site** (`site/`) — zero-dep Node, serves `headroom.walls.sh`: landing + `/health` +
  `/metrics` (downloads counter) + `/download`. Deploy: `railway up --ci` from `site/`,
  then `node ~/code/walls/bin/cf.mjs add headroom <railway-host>` once there's an origin.

## What the loop will and won't do on its own

- **Will:** wire the Keychain → usage endpoint → menu bar pipeline, verify against Pat's
  real token, build + zip releases, deploy the site, keep the landing honest, count
  downloads truthfully, draft launch copy, and log + push every lap.
- **Won't (surfaces instead):** the Apple Developer ID enrollment ($99/yr) for
  notarization, posting to Pat's social accounts, any spend. It does everything up to
  that line, states the one thing Pat must do, and runs a different lap meanwhile.

## Where we are

Always the top of [`VISION.md`](./VISION.md): the §0 milestones and the loop log.
