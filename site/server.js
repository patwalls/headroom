import { createServer } from "node:http";
import { readFileSync, writeFileSync, mkdirSync, existsSync, statSync, createReadStream } from "node:fs";
import { join, dirname } from "node:path";
import { fileURLToPath } from "node:url";

// Headroom landing + downloads server — zero dependencies.
// Serves: the pitch page, /health, /metrics (REAL downloads count, the wall reads this),
// and /download (counts a download, then serves the build — honest 404 until one exists).

const ROOT = dirname(fileURLToPath(import.meta.url));
const PORT = process.env.PORT || 3000;
const BUILD_ZIP = join(ROOT, "public", "Headroom.zip");
const DATA_DIR = process.env.DATA_DIR || join(ROOT, "data");
const COUNTER = join(DATA_DIR, "downloads.json");

function loadCount() {
  try { return JSON.parse(readFileSync(COUNTER, "utf8")).downloads || 0; } catch { return 0; }
}
function saveCount(n) {
  try {
    mkdirSync(DATA_DIR, { recursive: true });
    writeFileSync(COUNTER, JSON.stringify({ downloads: n }) + "\n");
  } catch { /* counting must never take the site down */ }
}
let downloads = loadCount();

const page = `<!doctype html><html lang="en"><head><meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>Headroom — Claude Code usage in your menu bar</title>
<meta name="description" content="A free macOS menu bar app that shows your Claude Code session and weekly usage as a live %. Zero config — it reads the token Claude Code already stores.">
<link rel="canonical" href="https://headroom.walls.sh/">
<meta property="og:type" content="website">
<meta property="og:site_name" content="Headroom">
<meta property="og:title" content="Headroom — Claude Code usage in your menu bar">
<meta property="og:description" content="Session (5h) + weekly (7d) Claude Code usage as a live %, color-coded before a limit stops you mid-task. Free, zero config, signed &amp; notarized.">
<meta property="og:url" content="https://headroom.walls.sh/">
<meta property="og:image" content="https://headroom.walls.sh/dropdown.png">
<meta property="og:image:width" content="640">
<meta property="og:image:height" content="316">
<meta property="og:image:alt" content="Headroom's dropdown: color-coded session and weekly usage meters with reset countdowns">
<meta name="twitter:card" content="summary_large_image">
<meta name="twitter:title" content="Headroom — Claude Code usage in your menu bar">
<meta name="twitter:description" content="Session (5h) + weekly (7d) Claude Code usage as a live %, color-coded before a limit stops you mid-task. Free, zero config, signed &amp; notarized.">
<meta name="twitter:image" content="https://headroom.walls.sh/dropdown.png">
<style>
  :root{--bg:#0f1115;--panel:#171a21;--ink:#e8e6e0;--dim:#9a978e;--accent:#d97757;--ok:#7bb97e;--warn:#d9a657;--bad:#d96157}
  body{margin:0;background:var(--bg);color:var(--ink);font:17px/1.6 -apple-system,BlinkMacSystemFont,"Segoe UI",sans-serif}
  main{max-width:680px;margin:0 auto;padding:64px 24px}
  .tag{font:600 12px/1 ui-monospace,Menlo,monospace;letter-spacing:.25em;text-transform:uppercase;color:var(--dim)}
  h1{font-size:2.6rem;line-height:1.15;margin:.4em 0 .3em}
  .sub{color:var(--dim);font-size:1.15rem;margin:0 0 2em}
  .bar{display:flex;align-items:center;gap:12px;background:var(--panel);border:1px solid #242936;border-radius:10px;padding:14px 18px;margin:10px 0;font-family:ui-monospace,Menlo,monospace;font-size:.95rem}
  .meter{flex:1;height:8px;border-radius:4px;background:#242936;overflow:hidden}
  .meter i{display:block;height:100%}
  .pct{min-width:4ch;text-align:right}
  .cta{display:inline-block;margin:1.6em 0 .4em;padding:14px 26px;border-radius:10px;background:var(--accent);color:#fff;text-decoration:none;font-weight:600}
  .cta.soon{background:#2a2f3c;color:var(--dim);cursor:default}
  .fine{color:var(--dim);font-size:.85rem}
  h2{margin-top:2.6em;font-size:1.2rem}
  p{color:#c9c6bd}
  .trust{background:var(--panel);border:1px solid #242936;border-radius:10px;padding:18px 22px;margin-top:1em}
  footer{margin-top:4em;color:var(--dim);font-size:.85rem}
  a{color:var(--accent)}
</style></head><body><main>
<p class="tag">Wall #003 · walls.sh</p>
<h1>Know your headroom.</h1>
<p class="sub">A free macOS menu bar app that shows your Claude Code usage as a live % —
the 5-hour session and the 7-day week — color-coded before a limit stops you mid-task.</p>

<img src="/dropdown.png" width="320" alt="Headroom's dropdown: Session (5h) and Week (7d) meters with color-coded bars and reset countdowns" style="border-radius:12px;box-shadow:0 8px 32px rgba(0,0,0,.45)">
<p class="fine">↑ the actual app rendering its own dropdown with real data — not a mock.
Yours shows your numbers.</p>

<a class="cta" href="/download">Download Headroom — free</a>
<p class="fine">v0.3.0 · macOS 13+ · universal (Apple Silicon &amp; Intel) · ~280 KB zip ·
signed &amp; notarized by Apple — double-click and it runs.</p>
<p class="fine">Homebrew: <code>brew install --cask patwalls/tap/headroom</code></p>
<p class="fine">On first launch Headroom explains the one permission it needs, then macOS
asks once (its standard Keychain dialog) — click "Always Allow" and it never asks again.</p>
<p class="fine">New in v0.3: "Enable Live Data" reads the numbers straight from Claude Code's
own status line — zero API calls, zero rate limits, no Keychain prompt at all.</p>

<h2>Zero config — really</h2>
<p>Claude Code already keeps an OAuth token in your macOS Keychain. Headroom reads it the
same way Claude Code does and asks Anthropic for the same utilization numbers
<code>/usage</code> shows — so there's no API key, no login, no setup. Install it and the
number is just there.</p>

<div class="trust"><strong>The trust contract.</strong> Headroom sends your token to
<code>api.anthropic.com</code> and nowhere else. It never logs it, never stores a copy,
never phones home. The source is small enough to read —
<a href="https://github.com/patwalls/headroom">read it on GitHub</a>: the entire
network + Keychain surface is one ~165-line file.</div>

<h2>Why</h2>
<p>The weekly limit always finds you mid-task, because a meter you have to remember to
poll isn't a meter. The menu bar is where ambient numbers belong.</p>

<footer>Built in public — <a href="https://walls.sh">walls.sh</a> · Wall #003 ·
<a href="https://github.com/patwalls/headroom">source</a></footer>
<a href="https://walls.sh" class="wallsbadge" title="Every startup since 2012 — live on the wall"><span class="wbdot"></span>Wall № 003 · building autonomously · <b>walls.sh</b></a><style>.wallsbadge{position:fixed;right:16px;bottom:16px;z-index:2147483000;display:inline-flex;align-items:center;gap:8px;font:600 11px/1 ui-monospace,SFMono-Regular,Menlo,monospace;letter-spacing:.07em;text-transform:uppercase;color:#efe7d6;text-decoration:none;background:#15100a;border:1px solid #caa45a;border-radius:999px;padding:9px 14px;box-shadow:0 4px 18px rgba(0,0,0,.5);opacity:.93;transition:opacity .15s,box-shadow .15s}.wallsbadge:hover{opacity:1;box-shadow:0 4px 24px rgba(202,164,90,.4)}.wallsbadge b{color:#caa45a}.wbdot{width:7px;height:7px;border-radius:50%;background:#39d98a;box-shadow:0 0 9px #39d98a;animation:wbblink 1.8s ease-in-out infinite}@keyframes wbblink{0%,100%{opacity:1}50%{opacity:.35}}@media(max-width:640px){.wallsbadge{right:10px;bottom:10px;padding:8px 11px}}</style></main></body></html>`;

createServer((req, res) => {
  const url = new URL(req.url, "http://x");

  if (url.pathname === "/health") {
    res.writeHead(200, { "content-type": "application/json" });
    return res.end(JSON.stringify({ ok: true, service: "headroom" }));
  }

  // The wall reads this (docs/METRICS.md contract). Real count or nothing — never typed.
  if (url.pathname === "/metrics") {
    res.writeHead(200, { "content-type": "application/json" });
    return res.end(JSON.stringify({
      app: "headroom",
      updatedAt: new Date().toISOString(),
      headline: "downloads",
      metrics: [{ key: "downloads", label: "Downloads", value: downloads, hint: "all-time" }],
    }));
  }

  // /download/Headroom.zip is the same download with a brew-friendly basename
  // (Homebrew infers the archive type from the URL path).
  if (url.pathname === "/download" || url.pathname === "/download/Headroom.zip") {
    if (!existsSync(BUILD_ZIP)) {
      res.writeHead(404, { "content-type": "application/json" });
      return res.end(JSON.stringify({ error: "no_release_yet", detail: "The first release is being built — check back soon." }));
    }
    // Loop verification probes pass ?probe=1 and are NOT counted (§0: strangers only).
    if (!url.searchParams.has("probe")) saveCount(++downloads);
    res.writeHead(200, {
      "content-type": "application/zip",
      "content-disposition": 'attachment; filename="Headroom.zip"',
      "content-length": statSync(BUILD_ZIP).size,
    });
    return createReadStream(BUILD_ZIP).pipe(res);
  }

  // The dropdown image on the pitch page — the app's own rendering, real data.
  if (url.pathname === "/dropdown.png") {
    const png = join(ROOT, "public", "dropdown.png");
    if (!existsSync(png)) {
      res.writeHead(404, { "content-type": "application/json" });
      return res.end(JSON.stringify({ error: "not_found" }));
    }
    res.writeHead(200, { "content-type": "image/png", "content-length": statSync(png).size });
    return createReadStream(png).pipe(res);
  }

  if (url.pathname === "/") {
    res.writeHead(200, { "content-type": "text/html; charset=utf-8" });
    return res.end(page);
  }

  res.writeHead(404, { "content-type": "application/json" });
  res.end(JSON.stringify({ error: "not_found" }));
}).listen(PORT, () => console.log(`headroom site on :${PORT}`));
