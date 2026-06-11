import Foundation

// Headroom's data source — the only one. A Claude Code statusLine hook receives Claude
// Code's own session JSON on stdin, including its 5h/7d rate-limit numbers
// (rate_limits.five_hour.used_percentage / seven_day + resets_at; see
// code.claude.com/docs/en/statusline). Our hook saves that JSON to a file; this app reads
// it. Result: no API calls, no rate limits, no Keychain, no token — and the numbers are
// authoritative, because Claude Code already fetched them server-side.

private func claudePath(_ component: String) -> String {
    (NSHomeDirectory() as NSString).appendingPathComponent(".claude/\(component)")
}

enum HookUsage {
    static let path = claudePath("headroom-usage.json")

    /// The reading plus when the hook captured it (the file's mtime). nil when the file is
    /// absent, malformed, or carries no rate-limit data (older Claude Code, or an account
    /// without subscription limits). We parse Claude Code's raw statusline JSON directly,
    /// so the hook needs no jq.
    static func read() -> (usage: Usage, capturedAt: Date)? {
        guard let data = FileManager.default.contents(atPath: path),
              let root = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let limits = root["rate_limits"] as? [String: Any]
        else { return nil }

        func window(_ key: String) -> Usage.Window? {
            guard let obj = limits[key] as? [String: Any],
                  let pct = (obj["used_percentage"] as? NSNumber)?.doubleValue
            else { return nil }
            let resetsAt = (obj["resets_at"] as? NSNumber).map { Date(timeIntervalSince1970: $0.doubleValue) }
            return Usage.Window(utilization: pct, resetsAt: resetsAt)
        }

        guard let five = window("five_hour"), let seven = window("seven_day") else { return nil }

        // Bonus context Claude Code already hands us in the same JSON (not under rate_limits):
        // the live context-window fill and the active model's display name. Both optional —
        // absent on older Claude Code — so missing data just hides those rows, never breaks.
        let contextUsed = ((root["context_window"] as? [String: Any])?["used_percentage"] as? NSNumber)?.doubleValue
        let modelName = (root["model"] as? [String: Any])?["display_name"] as? String
        let sessionCost = ((root["cost"] as? [String: Any])?["total_cost_usd"] as? NSNumber)?.doubleValue

        let mtime = (try? FileManager.default.attributesOfItem(atPath: path))?[.modificationDate] as? Date
        return (Usage(fiveHour: five, sevenDay: seven, contextUsed: contextUsed, modelName: modelName, sessionCost: sessionCost), mtime ?? Date())
    }
}

enum HookInstaller {
    static let scriptPath = claudePath("headroom-statusline.sh")
    static let settingsPath = claudePath("settings.json")
    // Remembers a status line we chained through, so re-installs/upgrades can reconstruct
    // the hook without losing the user's original display.
    static let prevPath = claudePath("headroom-prev-statusline")

    enum Outcome {
        case enabled        // wired from scratch
        case chained        // wired, preserving an existing status line
        case alreadyOn      // already pointed at our hook — no change
        case failed(String)
    }

    /// True when Claude Code's statusLine already points at our hook.
    static func isWired() -> Bool {
        guard let data = FileManager.default.contents(atPath: settingsPath),
              let root = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let cmd = (root["statusLine"] as? [String: Any])?["command"] as? String
        else { return false }
        return cmd.contains("headroom-statusline.sh")
    }

    // The hook body. It saves the raw stdin JSON for Headroom (no jq needed). The status
    // LINE it prints is bonus polish: if we're chaining an existing status line we run that
    // (preserving the user's display); otherwise we render a usage line only when jq exists.
    // No backslashes leak into the script — jq builds output with `+`, not "\(…)".
    private static func scriptBody(passthrough: String?) -> String {
        let render: String
        if let cmd = passthrough {
            let escaped = cmd.replacingOccurrences(of: "'", with: "'\\''")
            render = "printf '%s' \"$input\" | bash -c '\(escaped)'"
        } else {
            render = "command -v jq >/dev/null 2>&1 && printf '%s' \"$input\" | jq -r '\"CC  5h \" + ((.rate_limits.five_hour.used_percentage // 0) | floor | tostring) + \"%  ·  7d \" + ((.rate_limits.seven_day.used_percentage // 0) | floor | tostring) + \"%\"' 2>/dev/null"
        }
        return """
        #!/bin/bash
        # Headroom — Claude Code statusline hook (auto-generated; do not edit).
        # Saves Claude Code's status data so the Headroom menu bar app can read your usage
        # locally — no API, no token, no rate limits. Re-run Headroom's setup to refresh.
        input=$(cat)
        printf '%s' "$input" > "$HOME/.claude/headroom-usage.json"
        \(render)
        """
    }

    /// The command we previously chained through, if any (nil for a fresh/solo install).
    private static func chainedPassthrough() -> String? {
        let saved = (try? String(contentsOfFile: prevPath, encoding: .utf8))?
            .trimmingCharacters(in: .whitespacesAndNewlines)
        return (saved?.isEmpty == false) ? saved : nil
    }

    private static func writeScript(passthrough: String?) -> Bool {
        let fm = FileManager.default
        try? fm.createDirectory(atPath: claudePath(""), withIntermediateDirectories: true)
        do {
            try scriptBody(passthrough: passthrough).write(toFile: scriptPath, atomically: true, encoding: .utf8)
            try fm.setAttributes([.posixPermissions: 0o755], ofItemAtPath: scriptPath)
        } catch { return false }
        return true
    }

    /// Rewrite the script in place from the current code, preserving any chained status
    /// line — cheap, touches no settings. Called on launch so app upgrades take effect.
    static func refreshScript() {
        _ = writeScript(passthrough: chainedPassthrough())
    }

    /// Wire the hook fully automatically — never asks the user to edit anything. Idempotent
    /// and upgrade-safe: always rewrites the script from current code, preserves any existing
    /// status line by chaining (remembered in a sidecar), and backs up settings.json.
    @discardableResult
    static func install() -> Outcome {
        let fm = FileManager.default

        var settings: [String: Any] = [:]
        if let data = fm.contents(atPath: settingsPath),
           let obj = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
            settings = obj
        }
        let existing = (settings["statusLine"] as? [String: Any])?["command"] as? String
        let alreadyOurs = existing?.contains("headroom-statusline.sh") ?? false

        // On a re-install, recover the chained command from the sidecar; on a first install,
        // adopt whatever status line was already configured.
        let passthrough = alreadyOurs ? chainedPassthrough() : existing

        guard writeScript(passthrough: passthrough) else { return .failed("Couldn't write the hook script.") }

        // Remember (or clear) the chained command for future repairs/upgrades.
        if let passthrough { try? passthrough.write(toFile: prevPath, atomically: true, encoding: .utf8) }
        else { try? fm.removeItem(atPath: prevPath) }

        if let data = fm.contents(atPath: settingsPath) {
            try? data.write(to: URL(fileURLWithPath: settingsPath + ".bak"))
        }
        settings["statusLine"] = ["type": "command", "command": scriptPath]
        do {
            let out = try JSONSerialization.data(withJSONObject: settings, options: [.prettyPrinted, .sortedKeys])
            try out.write(to: URL(fileURLWithPath: settingsPath))
        } catch {
            return .failed("Couldn't update Claude Code settings.")
        }

        if alreadyOurs { return .alreadyOn }
        return passthrough != nil ? .chained : .enabled
    }
}
