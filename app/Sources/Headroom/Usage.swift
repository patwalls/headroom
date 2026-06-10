import Foundation

// What the app shows: utilization (0–100) for the two windows, plus when each resets.
// Headroom reads these straight from Claude Code's own statusline data on disk (Hook.swift)
// — it never calls an API, reads no token, and asks for no permission. That IS the design.

struct Usage {
    struct Window {
        let utilization: Double
        let resetsAt: Date?

        /// A reading goes stale once its window has rolled over since it was captured: we
        /// no longer know the post-reset number, so the honest move is to show "—", not a
        /// wrong value. (resetsAt == nil → treat as live; we just lack a countdown.)
        var isLive: Bool {
            guard let resetsAt else { return true }
            return resetsAt > Date()
        }
    }
    let fiveHour: Window
    let sevenDay: Window
}

struct AppError: Error, CustomStringConvertible {
    let message: String
    var description: String { message }
}
