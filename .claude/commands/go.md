---
description: GO — start the Headroom autonomous loop. The highest-level loop — it builds the whole thing, lap after lap, until you stop it.
argument-hint: "[optional cadence like 1h, and/or a focus, e.g. '1h' or 'distribution']"
---

# /go — ignition

One command = the whole machine. `/go` starts this venture's autonomous entrepreneur
loop: run `/lap` (ship one real thing toward the North Star + learn one fact, log it,
push) on repeat until told to stop. It's the memorable name for `/loop /lap`.

## What to do

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
