---
description: GO — start the Headroom autonomous loop. The highest-level loop — it builds the whole thing, lap after lap, until you stop it.
argument-hint: "[optional cadence like 1h, and/or a focus, e.g. '1h' or 'distribution']"
---

# /go — ignition

One command = the whole machine. `/go` starts this venture's autonomous entrepreneur
loop: run `/lap` (ship one real thing toward the North Star + learn one fact, log it,
push) on repeat until told to stop. It runs `/lap` on repeat as fresh, token-frugal one-shots (no day-long context).

## What to do

0. **Sync + label the session** (the equivalent of `/rename HEADROOM LOOP` — puts the business
   name in the cmux sidebar + session list). Run these; if either fails, continue — cosmetic:
   ```bash
   git pull --rebase --autostash   # Pat ships from other machines — start from latest
   [ -n "$CMUX_CLAUDE_HOOK_CMUX_BIN" ] && CMUX_QUIET=1 "$CMUX_CLAUDE_HOOK_CMUX_BIN" rename-workspace "HEADROOM LOOP" || true
   node -e 'const fs=require("fs"),os=require("os"),d=os.homedir()+"/.claude/sessions";const id=process.env.CLAUDE_CODE_SESSION_ID;for(const f of fs.readdirSync(d)){const p=d+"/"+f;try{const j=JSON.parse(fs.readFileSync(p,"utf8"));if(j.sessionId===id){j.name="HEADROOM LOOP";fs.writeFileSync(p,JSON.stringify(j))}}catch{}}'
   ```
1. **Parse `$ARGUMENTS`** — a `\d+[smhd]` token (e.g. `1h`, `30m`) is the **cadence**
   (default `20m` if absent); anything else is a **focus** string handed to every lap.

2. **Launch the fresh-context runner, detached.** Each lap is a brand-new `claude -p "/lap"`
   with ZERO inherited context — token-frugal, it never re-reads a growing conversation.
   Run, substituting the parsed cadence + focus (drop the focus if none):
   ```bash
   nohup ~/.claude/loop-runner.sh <cadence> <focus> >> "$PWD/.loop.log" 2>&1 &
   echo "loop running detached — PID $!"
   ```
   The runner refuses to start if one is already running for this repo (a `.loop.pid` lock).

3. **Tell Pat** it's live: the cadence, that it KEEPS RUNNING after this session closes
   (it's detached), how to watch (`tail -f .loop.log`), and how to control it —
   `/throttle-loops <interval>` to slow it, `/pause-loops` to stop everything. Do NOT run a
   lap yourself in this session; the runner owns laps now.

To run exactly ONE supervised lap in THIS session instead: `/lap`.
