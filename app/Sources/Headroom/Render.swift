import AppKit

// Display decisions, kept pure so the --print harness can verify them with real data.

enum Tone: String {
    case calm, amber, red

    init(utilization: Double) {
        switch utilization {
        case ..<70: self = .calm
        case ..<90: self = .amber
        default: self = .red
        }
    }

    /// nil = the standard adaptive menu bar color.
    var color: NSColor? {
        switch self {
        case .calm: return nil
        case .amber: return .systemOrange
        case .red: return .systemRed
        }
    }
}

enum Render {
    /// THE display decision — the one source of truth shared by the GUI and the
    /// --print harness, so what the harness verifies is exactly what users see.
    /// Liveness rule: a window whose reset has passed shows nil (rendered as "—"),
    /// never its stale number. The menu bar shows both windows as "CC 9%·64%"
    /// (session·weekly); the COLOR tracks whichever LIVE window is closer to its
    /// limit, so an imminent 5h stop turns the title red even on a calm week.
    struct Decision {
        let title: String
        let tone: Tone
        let session: Usage.Window?  // nil = rolled over, show "—"
        let week: Usage.Window?
        let context: Double?        // nil = not available
        let modelName: String?
        let sessionCost: Double?    // nil = not available
    }

    static func decide(_ usage: Usage) -> Decision {
        let five = usage.fiveHour.isLive ? usage.fiveHour : nil
        let seven = usage.sevenDay.isLive ? usage.sevenDay : nil
        let levels = [five, seven].compactMap { $0?.utilization }
        let fivePct  = five.map  { percent($0.utilization) } ?? "—"
        let sevenPct = seven.map { percent($0.utilization) } ?? "—"
        return Decision(
            title: "CC \(fivePct)·\(sevenPct)",
            tone: levels.isEmpty ? .calm : Tone(utilization: levels.max()!),
            session: five,
            week: seven,
            context: usage.contextUsed,
            modelName: usage.modelName,
            sessionCost: usage.sessionCost)
    }

    static func percent(_ utilization: Double) -> String {
        "\(Int(utilization.rounded()))%"
    }

    static func cost(_ usd: Double) -> String {
        String(format: "$%.2f", usd)
    }

    /// "14% — resets in 2h 1m (7:40 PM) · ~1h 30m at pace"
    static func line(_ window: Usage.Window, windowDuration: TimeInterval = 0, now: Date = Date()) -> String {
        var text = percent(window.utilization)
        if let resetsAt = window.resetsAt {
            text += " — resets in \(countdown(from: now, to: resetsAt)) (\(clock.string(from: resetsAt)))"
        }
        if let forecast = paceForecast(window: window, windowDuration: windowDuration, now: now) {
            text += " · \(forecast)"
        }
        return text
    }

    static let sessionWindowDuration: TimeInterval = 5 * 3600
    static let weekWindowDuration:    TimeInterval = 7 * 24 * 3600

    // "~2h 15m at pace" when you're on track to fill the window before it resets.
    // Returns nil when the data is too noisy, the pace is slow enough not to matter,
    // or the meter is already nearly full (no warning left to give).
    static func paceForecast(window: Usage.Window, windowDuration: TimeInterval, now: Date = Date()) -> String? {
        guard let resetsAt = window.resetsAt,
              window.utilization > 5, window.utilization < 95,
              windowDuration > 0 else { return nil }
        let elapsed = now.timeIntervalSince(resetsAt.addingTimeInterval(-windowDuration))
        guard elapsed > 60 else { return nil }  // need at least 1 minute of signal
        let pacePerSecond = window.utilization / (elapsed * 100)  // fraction of window per second
        guard pacePerSecond > 0 else { return nil }
        let secondsToFull = (100 - window.utilization) / 100 / pacePerSecond
        let secondsUntilReset = resetsAt.timeIntervalSince(now)
        // Show only when: pace implies hitting the limit before reset (with 15% margin),
        // the fill would happen within 12h (distant forecasts aren't useful), and it's at
        // least 15 minutes away (don't clutter a meter that's already basically full).
        guard secondsToFull < secondsUntilReset * 0.85,
              secondsToFull < 12 * 3600,
              secondsToFull > 900 else { return nil }
        return "~\(countdown(from: now, to: now.addingTimeInterval(secondsToFull))) at pace"
    }

    static func countdown(from: Date, to: Date) -> String {
        let total = Int(max(0, to.timeIntervalSince(from)) / 60)  // whole minutes
        let (days, hours, minutes) = (total / 1440, total / 60 % 24, total % 60)
        if days > 0 { return "\(days)d \(hours)h" }
        if hours > 0 { return "\(hours)h \(minutes)m" }
        return "\(minutes)m"
    }

    static let clock: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "EEE h:mm a"
        return f
    }()
}
