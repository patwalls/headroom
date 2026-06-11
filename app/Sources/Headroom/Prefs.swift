import Foundation

// User-configurable preferences. Read from ~/.claude/headroom-prefs.json.
// All thresholds are utilization percentages (0–100). Defaults: warn at 70, crit at 90.
// Example ~/.claude/headroom-prefs.json:
//   { "sessionWarnAt": 60, "sessionCritAt": 85, "weekWarnAt": 70, "weekCritAt": 90 }
// Unknown keys are ignored. Missing keys use defaults. Bad JSON → defaults (silent).
struct Prefs: Codable {
    var sessionWarnAt: Double = 70
    var sessionCritAt: Double = 90
    var weekWarnAt:    Double = 70
    var weekCritAt:    Double = 90

    static func load() -> Prefs {
        let url = URL(fileURLWithPath: NSHomeDirectory())
            .appendingPathComponent(".claude/headroom-prefs.json")
        guard let data = try? Data(contentsOf: url),
              let p = try? JSONDecoder().decode(Prefs.self, from: data) else {
            return Prefs()
        }
        return p.clamped()
    }

    // Silently clamp each threshold to [1, 99] so callers don't have to guard.
    private func clamped() -> Prefs {
        var p = self
        p.sessionWarnAt = min(99, max(1, sessionWarnAt))
        p.sessionCritAt = min(99, max(1, sessionCritAt))
        p.weekWarnAt    = min(99, max(1, weekWarnAt))
        p.weekCritAt    = min(99, max(1, weekCritAt))
        return p
    }
}
