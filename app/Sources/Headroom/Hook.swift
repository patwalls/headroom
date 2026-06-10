import Foundation

// The local-first data path (VISION Lap 17). Claude Code hands its OWN 5h/7d
// rate-limit numbers to any configured statusLine command on stdin — see
// code.claude.com/docs/en/statusline, fields `rate_limits.five_hour.used_percentage`
// / `seven_day` + `resets_at`. Our hook captures them to a file the app reads, so
// Headroom never has to poll api.anthropic.com: no rate limit, no Keychain dialog,
// and the numbers are authoritative (Claude Code already fetched them server-side).
// Proven in the wild by ClaudeWatch, which does the same thing.

/// Where the hook writes its snapshot.
private func claudePath(_ component: String) -> String {
    (NSHomeDirectory() as NSString).appendingPathComponent(".claude/\(component)")
}

struct UsageReading {
    enum Source { case hook, api }
    let usage: Usage
    let source: Source
}

enum HookUsage {
    static let path = claudePath("headroom-usage.json")

    /// The reading plus when the hook captured it, so callers can judge staleness.
    /// Returns nil when the file is absent, malformed, or carries no rate-limit data
    /// (older Claude Code, or an account without subscription limits).
    static func read() -> (usage: Usage, capturedAt: Date)? {
        guard let data = FileManager.default.contents(atPath: path),
              let root = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
        else { return nil }

        func window(_ key: String) -> Usage.Window? {
            guard let obj = root[key] as? [String: Any],
                  let pct = (obj["used_percentage"] as? NSNumber)?.doubleValue
            else { return nil }
            var resetsAt: Date?
            if let secs = (obj["resets_at"] as? NSNumber)?.doubleValue {
                resetsAt = Date(timeIntervalSince1970: secs)
            }
            return Usage.Window(utilization: pct, resetsAt: resetsAt)
        }

        guard let five = window("five_hour"), let seven = window("seven_day") else { return nil }
        let at = (root["at"] as? NSNumber).map { Date(timeIntervalSince1970: $0.doubleValue) } ?? Date()
        return (Usage(fiveHour: five, sevenDay: seven), at)
    }
}

enum UsageProvider {
    /// While Claude Code is active the hook keeps this fresh, so we read the file and
    /// touch the network zero times. Past this window we fall back to the API to catch
    /// a reset that happened while idle — but a stale hook reading still beats nothing
    /// when the API is rate-limited.
    static let hookFreshness: TimeInterval = 15 * 60

    static func fetch(_ tokenStore: TokenStore) throws -> UsageReading {
        let hook = HookUsage.read()
        if let hook, Date().timeIntervalSince(hook.capturedAt) < hookFreshness {
            return UsageReading(usage: hook.usage, source: .hook)
        }
        do {
            return UsageReading(usage: try tokenStore.fetchUsage(), source: .api)
        } catch {
            if let hook { return UsageReading(usage: hook.usage, source: .hook) }
            throw error
        }
    }
}

enum HookInstaller {
    static let scriptPath = claudePath("headroom-statusline.sh")
    static let settingsPath = claudePath("settings.json")

    // No backslashes anywhere (keeps this Swift string literal clean): the jq programs
    // build JSON with object construction and the status line with `+` concatenation
    // rather than "\(…)" interpolation.
    static let script = """
    #!/bin/bash
    # Headroom — Claude Code statusline hook.
    # Captures Claude Code's own 5h/7d rate-limit numbers (handed to this script on
    # stdin) into a file the Headroom menu bar app reads — so Headroom never calls the
    # Anthropic API: no rate limits, no Keychain prompt. Also renders a usage line.
    input=$(cat)
    out="$HOME/.claude/headroom-usage.json"
    printf '%s' "$input" | jq -c '{five_hour: .rate_limits.five_hour, seven_day: .rate_limits.seven_day, at: now}' > "$out.tmp" 2>/dev/null && mv -f "$out.tmp" "$out" 2>/dev/null
    printf '%s' "$input" | jq -r '"CC  5h " + ((.rate_limits.five_hour.used_percentage // 0) | floor | tostring) + "%  ·  7d " + ((.rate_limits.seven_day.used_percentage // 0) | floor | tostring) + "%"' 2>/dev/null

    """

    private static func jqInstalled() -> Bool {
        let fm = FileManager.default
        return ["/usr/bin/jq", "/opt/homebrew/bin/jq", "/usr/local/bin/jq"]
            .contains { fm.isExecutableFile(atPath: $0) }
    }

    /// Writes the hook script and, when no statusLine is configured yet, wires it into
    /// Claude Code settings. Never clobbers an existing statusLine — instructs instead.
    /// Returns a human-readable result for the CLI / the menu alert.
    static func install() -> String {
        let fm = FileManager.default
        try? fm.createDirectory(atPath: claudePath(""), withIntermediateDirectories: true)

        do {
            try script.write(toFile: scriptPath, atomically: true, encoding: .utf8)
            try fm.setAttributes([.posixPermissions: 0o755], ofItemAtPath: scriptPath)
        } catch {
            return "Couldn't write the hook script: \(error.localizedDescription)"
        }

        let jqNote = jqInstalled() ? "" : "\n\n⚠️ jq isn't installed — run `brew install jq` for the hook to work."

        var settings: [String: Any] = [:]
        if let data = fm.contents(atPath: settingsPath),
           let obj = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
            settings = obj
        }

        if settings["statusLine"] != nil {
            return """
            Hook script installed at:
              \(scriptPath)

            You already have a Claude Code status line, so Headroom left it alone. To feed \
            Headroom from it, add this line to your status-line script (needs jq):

              cat | jq -c '{five_hour:.rate_limits.five_hour,seven_day:.rate_limits.seven_day,at:now}' > ~/.claude/headroom-usage.json
            \(jqNote)
            """
        }

        // Back up any existing settings before writing.
        if let data = fm.contents(atPath: settingsPath) {
            try? data.write(to: URL(fileURLWithPath: settingsPath + ".bak"))
        }
        settings["statusLine"] = ["type": "command", "command": scriptPath]
        guard let out = try? JSONSerialization.data(
            withJSONObject: settings, options: [.prettyPrinted, .sortedKeys])
        else { return "Couldn't serialize settings.json." }
        do {
            try out.write(to: URL(fileURLWithPath: settingsPath))
        } catch {
            return "Couldn't write settings.json: \(error.localizedDescription)"
        }

        return """
        Live data enabled. Headroom now reads Claude Code's own usage numbers from disk \
        — no API calls, no rate limits, no Keychain. The meter refreshes whenever Claude \
        Code is active.\(jqNote)
        """
    }
}
