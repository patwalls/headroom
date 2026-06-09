import AppKit

// Headroom — Claude Code usage in the menu bar.
// Lap 1: the real number. Keychain OAuth token → Anthropic usage endpoint → live %,
// auto-refreshing. `headroom --print` is the verification harness: it prints the raw
// usage JSON from the real endpoint and exits.

// MARK: - --print harness (verify with real output, VISION §0.5)

if CommandLine.arguments.contains("--print") {
    do {
        let token = try KeychainToken.read()
        let data = try UsageClient.fetchRaw(token: token)
        FileHandle.standardOutput.write(data)
        print("")
        let usage = try UsageClient.fetch(token: token)
        print("parsed: session(5h)=\(usage.fiveHour.utilization)% resets=\(usage.fiveHour.resetsAt.map(String.init(describing:)) ?? "nil")"
            + " · week(7d)=\(usage.sevenDay.utilization)% resets=\(usage.sevenDay.resetsAt.map(String.init(describing:)) ?? "nil")")
        exit(0)
    } catch {
        FileHandle.standardError.write("headroom: \(error)\n".data(using: .utf8)!)
        exit(1)
    }
}

// MARK: - Menu bar app

final class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusItem: NSStatusItem!
    private let sessionItem = NSMenuItem(title: "Session (5h): —", action: nil, keyEquivalent: "")
    private let weeklyItem = NSMenuItem(title: "Week (7d): —", action: nil, keyEquivalent: "")
    private let statusLine = NSMenuItem(title: "Fetching…", action: nil, keyEquivalent: "")
    private var timer: Timer?

    func applicationDidFinishLaunching(_ notification: Notification) {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusItem.button?.title = "CC —%"

        let menu = NSMenu()
        for item in [sessionItem, weeklyItem, statusLine] {
            item.isEnabled = false
            menu.addItem(item)
        }
        menu.addItem(.separator())
        menu.addItem(NSMenuItem(title: "Refresh Now", action: #selector(refreshNow), keyEquivalent: "r"))
        menu.addItem(NSMenuItem(title: "Quit Headroom", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        menu.items.forEach { $0.target = self }
        statusItem.menu = menu

        refreshNow()
        timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { [weak self] _ in
            self?.refresh()
        }
    }

    @objc private func refreshNow() { refresh() }

    private func refresh() {
        DispatchQueue.global(qos: .utility).async {
            let outcome: Result<Usage, Error> = Result {
                try UsageClient.fetch(token: KeychainToken.read())
            }
            DispatchQueue.main.async { self.render(outcome) }
        }
    }

    private func render(_ outcome: Result<Usage, Error>) {
        switch outcome {
        case .success(let usage):
            statusItem.button?.title = "CC \(Self.percent(usage.sevenDay.utilization))"
            sessionItem.title = "Session (5h): \(Self.line(usage.fiveHour))"
            weeklyItem.title = "Week (7d): \(Self.line(usage.sevenDay))"
            statusLine.title = "Updated \(Self.clock.string(from: Date()))"
        case .failure(let error):
            statusItem.button?.title = "CC ?%"
            statusLine.title = "\(error)"
        }
    }

    // MARK: formatting

    private static let clock: DateFormatter = {
        let f = DateFormatter()
        f.timeStyle = .medium
        f.dateStyle = .none
        return f
    }()

    private static let resetFormat: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "EEE h:mm a"
        return f
    }()

    static func percent(_ utilization: Double) -> String {
        "\(Int(utilization.rounded()))%"
    }

    static func line(_ window: Usage.Window) -> String {
        var text = percent(window.utilization)
        if let resetsAt = window.resetsAt {
            text += " — resets \(resetFormat.string(from: resetsAt))"
        }
        return text
    }
}

let app = NSApplication.shared
// .accessory = menu bar only, no Dock icon (LSUIElement once bundled).
app.setActivationPolicy(.accessory)
let delegate = AppDelegate()
app.delegate = delegate
app.run()
