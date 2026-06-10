import AppKit
import ServiceManagement

// Headroom — Claude Code usage in the menu bar.
// Lap 1 wired the real number (Keychain OAuth token → Anthropic usage endpoint).
// Lap 2: color-coded title (calm → amber → red), reset countdowns, launch-at-login.
// `headroom --print` is the verification harness: raw usage JSON + the parsed values
// + the exact render decisions, from the real endpoint.

// MARK: - --print harness (verify with real output, VISION §0.5)

if CommandLine.arguments.contains("--print") {
    do {
        let token = try KeychainToken.read()
        let data = try UsageClient.fetchRaw(token: token)
        FileHandle.standardOutput.write(data)
        print("")
        let usage = try UsageClient.fetch(token: token)
        print("parsed: session(5h)=\(usage.fiveHour.utilization)% week(7d)=\(usage.sevenDay.utilization)%")
        print("render: title=\"\(Render.title(usage))\" tone=\(Render.tone(usage).rawValue)")
        print("render: session=\"\(Render.line(usage.fiveHour))\"")
        print("render: week=\"\(Render.line(usage.sevenDay))\"")
        exit(0)
    } catch {
        FileHandle.standardError.write("headroom: \(error)\n".data(using: .utf8)!)
        exit(1)
    }
}

// MARK: - Menu bar app

final class AppDelegate: NSObject, NSApplicationDelegate, NSMenuDelegate {
    private var statusItem: NSStatusItem!
    private let sessionMeter = MeterMenuView(label: "Session (5h)")
    private let weeklyMeter = MeterMenuView(label: "Week (7d)")
    private let statusLine = NSMenuItem(title: "Fetching…", action: nil, keyEquivalent: "")
    private let loginItem = NSMenuItem(title: "Launch at Login", action: #selector(toggleLaunchAtLogin(_:)), keyEquivalent: "")
    private let tokenStore = TokenStore()
    private var timer: Timer?
    private var lastUsage: Usage?
    private var lastSuccess: Date?
    private var backoffUntil: Date?
    private var rateLimitStrikes = 0
    /// A failed refresh keeps showing the last good number for this long (the data is
    /// 60s old, not unknown); past it, degrade honestly to "CC ?%".
    private static let staleGrace: TimeInterval = 10 * 60

    private static let titleFont = NSFont.monospacedDigitSystemFont(
        ofSize: NSFont.systemFontSize, weight: .regular)

    func applicationDidFinishLaunching(_ notification: Notification) {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusItem.button?.title = "CC —%"

        let menu = NSMenu()
        menu.delegate = self
        for meter in [sessionMeter, weeklyMeter] {
            let item = NSMenuItem()
            item.view = meter
            item.isEnabled = false
            menu.addItem(item)
        }
        statusLine.isEnabled = false
        menu.addItem(statusLine)
        menu.addItem(.separator())
        menu.addItem(NSMenuItem(title: "Refresh Now", action: #selector(refreshNow), keyEquivalent: "r"))
        // SMAppService only works from a real .app bundle (not a bare swift-build binary).
        if Bundle.main.bundleIdentifier != nil {
            loginItem.state = SMAppService.mainApp.status == .enabled ? .on : .off
            menu.addItem(loginItem)
        }
        menu.addItem(NSMenuItem(title: "Quit Headroom", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        menu.items.forEach { $0.target = self }
        statusItem.menu = menu

        refreshNow()
        timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { [weak self] _ in
            self?.refresh()
        }
    }

    @objc private func refreshNow() { refresh() }

    @objc private func toggleLaunchAtLogin(_ sender: NSMenuItem) {
        do {
            if SMAppService.mainApp.status == .enabled {
                try SMAppService.mainApp.unregister()
            } else {
                try SMAppService.mainApp.register()
            }
        } catch {
            statusLine.title = "Launch at login failed: \(error.localizedDescription)"
        }
        sender.state = SMAppService.mainApp.status == .enabled ? .on : .off
    }

    private func refresh() {
        // While the endpoint is rate-limiting us, don't pile on — the 60s tick and
        // menu-open refreshes both wait out the backoff window.
        if let until = backoffUntil, Date() < until { return }
        DispatchQueue.global(qos: .utility).async {
            let outcome: Result<Usage, Error> = Result {
                try self.tokenStore.fetchUsage()
            }
            DispatchQueue.main.async { self.render(outcome) }
        }
    }

    private func render(_ outcome: Result<Usage, Error>) {
        switch outcome {
        case .success(let usage):
            lastUsage = usage
            lastSuccess = Date()
            backoffUntil = nil
            rateLimitStrikes = 0
            setTitle(Render.title(usage), color: Render.tone(usage).color)
            sessionMeter.update(usage.fiveHour)
            weeklyMeter.update(usage.sevenDay)
            statusLine.title = "Updated \(Self.clock.string(from: Date()))"
        case .failure(let error):
            if case HeadroomError.http(429) = error {
                rateLimitStrikes += 1
                let wait = min(300.0, 60.0 * pow(2.0, Double(rateLimitStrikes - 1)))
                backoffUntil = Date().addingTimeInterval(wait)
            }
            // A transient failure (a 429, a network blip) doesn't make the number
            // unknown — the last reading is a minute old. Keep it, say we're retrying.
            if let usage = lastUsage, let at = lastSuccess,
               Date().timeIntervalSince(at) < Self.staleGrace {
                setTitle(Render.title(usage), color: Render.tone(usage).color)
                statusLine.title = "Updated \(Self.clock.string(from: at)) — \(Self.brief(error)), retrying"
            } else {
                setTitle("CC ?%", color: nil)
                statusLine.title = "\(error)"
            }
        }
    }

    private static func brief(_ error: Error) -> String {
        switch error {
        case HeadroomError.http(let code): return "refresh got HTTP \(code)"
        case HeadroomError.network: return "network error"
        default: return "refresh failed"
        }
    }

    /// Re-render the countdowns from the cached reading the moment the menu opens
    /// (they drift between 60s refreshes), then kick a real refresh.
    func menuWillOpen(_ menu: NSMenu) {
        if let usage = lastUsage {
            sessionMeter.update(usage.fiveHour)
            weeklyMeter.update(usage.sevenDay)
        }
        refresh()
    }

    private func setTitle(_ title: String, color: NSColor?) {
        guard let button = statusItem.button else { return }
        var attributes: [NSAttributedString.Key: Any] = [.font: Self.titleFont]
        if let color { attributes[.foregroundColor] = color }
        button.attributedTitle = NSAttributedString(string: title, attributes: attributes)
    }

    private static let clock: DateFormatter = {
        let f = DateFormatter()
        f.timeStyle = .medium
        f.dateStyle = .none
        return f
    }()
}

let app = NSApplication.shared
// .accessory = menu bar only, no Dock icon (LSUIElement once bundled).
app.setActivationPolicy(.accessory)
let delegate = AppDelegate()
app.delegate = delegate
app.run()
