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
    /// The menu bar shows the weekly %; the COLOR tracks whichever window is closer
    /// to its limit, so an imminent 5h stop turns the bar red even on a calm week.
    static func title(_ usage: Usage) -> String {
        "CC \(percent(usage.sevenDay.utilization))"
    }

    static func tone(_ usage: Usage) -> Tone {
        Tone(utilization: max(usage.fiveHour.utilization, usage.sevenDay.utilization))
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
