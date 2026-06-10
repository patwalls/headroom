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
    /// never its stale number. The menu bar shows the weekly %; the COLOR tracks
    /// whichever LIVE window is closer to its limit, so an imminent 5h stop turns
    /// the title red even on a calm week.
    struct Decision {
        let title: String
        let tone: Tone
        let session: Usage.Window?  // nil = rolled over, show "—"
        let week: Usage.Window?
        let context: Double?        // nil = not available
        let modelName: String?
    }

    static func decide(_ usage: Usage) -> Decision {
        let five = usage.fiveHour.isLive ? usage.fiveHour : nil
        let seven = usage.sevenDay.isLive ? usage.sevenDay : nil
        let levels = [five, seven].compactMap { $0?.utilization }
        return Decision(
            title: "CC \(seven.map { percent($0.utilization) } ?? "—%")",
            tone: levels.isEmpty ? .calm : Tone(utilization: levels.max()!),
            session: five,
            week: seven,
            context: usage.contextUsed,
            modelName: usage.modelName)
    }

    static func percent(_ utilization: Double) -> String {
        "\(Int(utilization.rounded()))%"
    }

    /// "14% — resets in 2h 1m (7:40 PM)"
    static func line(_ window: Usage.Window, now: Date = Date()) -> String {
        var text = percent(window.utilization)
        if let resetsAt = window.resetsAt {
            text += " — resets in \(countdown(from: now, to: resetsAt)) (\(clock.string(from: resetsAt)))"
        }
        return text
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
