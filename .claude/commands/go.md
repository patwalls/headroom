---
description: GO — start the Headroom autonomous loop. The highest-level loop — it builds the whole thing, lap after lap, until you stop it.
argument-hint: "[optional cadence like 1h, and/or a focus, e.g. '1h' or 'distribution']"
---

# /go — ignition

One command = the whole machine. `/go` starts this venture's autonomous entrepreneur
loop: run `/lap` (ship one real thing toward the North Star + learn one fact, log it,
push) on repeat until told to stop. It's the memorable name for `/loop /lap`.

## What to do

0. **Sync + label the session** (the equivalent of `/rename HEADROOM LOOP` — puts the business
   name in the cmux sidebar + session list). Run these; if either fails, continue — cosmetic:
   ```bash
   git pull --rebase --autostash   # Pat ships from other machines — start from latest
   [ -n "$CMUX_CLAUDE_HOOK_CMUX_BIN" ] && CMUX_QUIET=1 "$CMUX_CLAUDE_HOOK_CMUX_BIN" rename-workspace "HEADROOM LOOP" || true
   node -e 'const fs=require("fs"),os=require("os"),d=os.homedir()+"/.claude/sessions";const id=process.env.CLAUDE_CODE_SESSION_ID;for(const f of fs.readdirSync(d)){const p=d+"/"+f;try{const j=JSON.parse(fs.readFileSync(p,"utf8"));if(j.sessionId===id){j.name="HEADROOM LOOP";fs.writeFileSync(p,JSON.stringify(j))}}catch{}}'
   ```
1. Parse `$ARGUMENTS`:
   - A token matching `\d+[smhd]` (e.g. `1h`, `30m`) is the **cadence** — one lap per interval.
   - Anything else is a **focus** handed to every lap.
2. Invoke the `loop` skill (via the Skill tool) with args built from that:
   - `/go` → args `/lap` (self-paced — the default)
   - `/go 1h` → args `1h /lap`
   - `/go distribution` → args `/lap distribution`
   - `/go 1h distribution` → args `1h /lap distribution`
3. The loop skill runs the first lap immediately and schedules the rest — do NOT run an
   extra lap yourself outside it.

To run exactly ONE supervised lap instead: `/lap`. To stop the loop: say "stop the loop".
