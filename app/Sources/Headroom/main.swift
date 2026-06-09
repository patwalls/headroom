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

final class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusItem: NSStatusItem!
    private let sessionItem = NSMenuItem(title: "Session (5h): —", action: nil, keyEquivalent: "")
    private let weeklyItem = NSMenuItem(title: "Week (7d): —", action: nil, keyEquivalent: "")
    private let statusLine = NSMenuItem(title: "Fetching…", action: nil, keyEquivalent: "")
    private let loginItem = NSMenuItem(title: "Launch at Login", action: #selector(toggleLaunchAtLogin(_:)), keyEquivalent: "")
    private let tokenStore = TokenStore()
    private var timer: Timer?

    private static let titleFont = NSFont.monospacedDigitSystemFont(
        ofSize: NSFont.systemFontSize, weight: .regular)

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
            setTitle(Render.title(usage), color: Render.tone(usage).color)
            sessionItem.title = "Session (5h): \(Render.line(usage.fiveHour))"
            weeklyItem.title = "Week (7d): \(Render.line(usage.sevenDay))"
            statusLine.title = "Updated \(Self.clock.string(from: Date()))"
        case .failure(let error):
            setTitle("CC ?%", color: nil)
            statusLine.title = "\(error)"
        }
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
