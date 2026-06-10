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

// MARK: - --signin spike (v0.3: own OAuth token, no Keychain consent dialog)

if CommandLine.arguments.contains("--signin") {
    let verifier = OAuth.base64url(Data((0..<64).map { _ in UInt8.random(in: 0...255) }))
    let url = OAuth.authorizeURL(verifier: verifier)
    print("Open this URL, click Authorize, then paste the code shown (looks like code#state):\n\n\(url.absoluteString)\n")
    NSWorkspace.shared.open(url)
    print("Code: ", terminator: "")
    guard let pasted = readLine(), !pasted.isEmpty else {
        FileHandle.standardError.write("headroom: no code entered\n".data(using: .utf8)!)
        exit(1)
    }
    do {
        let tokens = try OAuth.exchange(pasted: pasted, verifier: verifier)
        try OAuth.store(tokens)
        print("Token stored in Headroom's own Keychain item (service \"\(OAuth.keychainService)\").")
        guard let access = tokens["access_token"] as? String else { exit(1) }
        let usage = try UsageClient.fetch(token: access)
        print("usage via signed-in token: session(5h)=\(usage.fiveHour.utilization)% week(7d)=\(usage.sevenDay.utilization)%")
        exit(0)
    } catch {
        FileHandle.standardError.write("headroom: \(error)\n".data(using: .utf8)!)
        exit(1)
    }
}

// MARK: - --snapshot harness (real rendering, real data — for README/landing)

if let i = CommandLine.arguments.firstIndex(of: "--snapshot"), CommandLine.arguments.count > i + 1 {
    let path = CommandLine.arguments[i + 1]
    _ = NSApplication.shared  // AppKit context for offscreen drawing
    do {
        let usage = try TokenStore().fetchUsage()
        try Snapshot.write(usage: usage, to: path)
        print("wrote \(path) — session \(usage.fiveHour.utilization)% week \(usage.sevenDay.utilization)%")
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
    private var retryTimer: Timer?
    private var lastUsage: Usage?
    private var lastSuccess: Date?
    private var lastFetchAt: Date?
    private var backoffUntil: Date?
    private var rateLimitStrikes = 0
    /// Opening the menu kicks a refresh; ignore the kick if we just fetched, so flicking
    /// the menu open and shut a few times can't trip the shared rate limit by itself.
    private static let menuRefreshDebounce: TimeInterval = 15
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

        primeKeychainExplainerIfNeeded()
        refreshNow()
        timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { [weak self] _ in
            self?.refresh()
        }
    }

    /// Apple's Keychain consent dialog is scary when it ambushes you on first launch.
    /// Explain it in our own words first — once, before the first Keychain read.
    private func primeKeychainExplainerIfNeeded() {
        let key = "keychainExplainerShown"
        guard !UserDefaults.standard.bool(forKey: key) else { return }
        UserDefaults.standard.set(true, forKey: key)
        let alert = NSAlert()
        alert.alertStyle = .informational
        alert.messageText = "One quick permission"
        alert.informativeText = """
        Headroom shows your usage by reading the token Claude Code already keeps in \
        your Mac's Keychain — no API key, no login, nothing to configure.

        macOS may now ask once with its standard Keychain dialog. Choose “Always \
        Allow” — the password it wants is your Mac login password, and you're typing \
        it into Apple's dialog, not into Headroom. After that it never asks again.

        Headroom sends the token to api.anthropic.com and nowhere else — never \
        logged, never stored, no analytics.
        """
        alert.addButton(withTitle: "Continue")
        NSApp.activate(ignoringOtherApps: true)
        alert.runModal()
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
        lastFetchAt = Date()
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
            retryTimer?.invalidate()
            setTitle(Render.title(usage), color: Render.tone(usage).color)
            sessionMeter.update(usage.fiveHour)
            weeklyMeter.update(usage.sevenDay)
            statusLine.title = "Updated \(Self.clock.string(from: Date()))"
        case .failure(let error):
            // Rate-limited: obey the server's Retry-After (it can be ~5 min), fall back to
            // exponential only when the header is absent. Then schedule a retry for the
            // moment the window clears, so we recover promptly instead of up to 60s late.
            if case HeadroomError.rateLimited(let retryAfter) = error {
                rateLimitStrikes += 1
                // Retry-After can come back 0 ("limited, but no specific delay") — taking
                // that literally means retrying every second and hammering a closed door.
                // Honor it only when positive; otherwise fall back to exponential (min 60s).
                let exponential = min(300.0, 60.0 * pow(2.0, Double(rateLimitStrikes - 1)))
                let wait = retryAfter.flatMap { $0 > 0 ? $0 : nil } ?? exponential
                backoffUntil = Date().addingTimeInterval(wait)
                scheduleRetry(after: wait)
            }
            // A transient failure (a 429, a network blip) doesn't make the number
            // unknown — the last reading is a minute old. Keep it, say we're retrying.
            if let usage = lastUsage, let at = lastSuccess,
               Date().timeIntervalSince(at) < Self.staleGrace {
                setTitle(Render.title(usage), color: Render.tone(usage).color)
                statusLine.title = "Updated \(Self.clock.string(from: at)) — \(Self.brief(error)), retrying"
            } else if Self.isTransient(error) {
                // No reading yet (cold start) but the cause is temporary — don't look broken.
                // The shared limit with Claude Code makes this the likely first-launch state.
                setTitle("CC —%", color: nil)
                let note: String
                if case HeadroomError.rateLimited = error, let until = backoffUntil {
                    note = "Rate-limited (shared with Claude Code) — retrying in \(Render.countdown(from: Date(), to: until))"
                } else {
                    note = "Waiting for connection — retrying"
                    scheduleRetry(after: 15)
                }
                sessionMeter.awaiting(note)
                weeklyMeter.awaiting(note)
                statusLine.title = note
            } else {
                // A real, actionable failure (expired token, Keychain, bad shape).
                setTitle("CC ?%", color: nil)
                sessionMeter.awaiting("—")
                weeklyMeter.awaiting("—")
                statusLine.title = "\(error)"
            }
        }
    }

    /// Temporary conditions that fix themselves with a retry — never an error to surface
    /// as if the user must act. Auth/Keychain/shape failures are the opposite, and fall through.
    private static func isTransient(_ error: Error) -> Bool {
        switch error {
        case HeadroomError.rateLimited, HeadroomError.network: return true
        default: return false
        }
    }

    private static func brief(_ error: Error) -> String {
        switch error {
        case HeadroomError.rateLimited: return "rate-limited"
        case HeadroomError.http(let code): return "refresh got HTTP \(code)"
        case HeadroomError.network: return "network error"
        default: return "refresh failed"
        }
    }

    /// One-shot retry timed to the backoff window's end (a hair past it, so the guard in
    /// refresh() has cleared). Replaces any pending retry so waits never stack.
    private func scheduleRetry(after seconds: TimeInterval) {
        retryTimer?.invalidate()
        retryTimer = Timer.scheduledTimer(withTimeInterval: seconds + 1, repeats: false) { [weak self] _ in
            self?.refresh()
        }
    }

    /// Re-render the countdowns from the cached reading the moment the menu opens
    /// (they drift between 60s refreshes), then kick a real refresh.
    func menuWillOpen(_ menu: NSMenu) {
        if let usage = lastUsage {
            sessionMeter.update(usage.fiveHour)
            weeklyMeter.update(usage.sevenDay)
        }
        // Don't let opening the menu become a request firehose against a shared limit.
        if let at = lastFetchAt, Date().timeIntervalSince(at) < Self.menuRefreshDebounce { return }
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
