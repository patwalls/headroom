import AppKit
import ServiceManagement

// Headroom — Claude Code usage in the menu bar.
// One data source: a Claude Code statusline hook saves Claude Code's own 5h/7d numbers
// to ~/.claude/headroom-usage.json, and this app reads that file. No API, no token, no
// rate limits, no permission prompts. The hook is wired automatically on first launch.
// See Hook.swift.

// MARK: - CLI harnesses (verify with real output, VISION §0.5)

if CommandLine.arguments.contains("--install-hook") {
    switch HookInstaller.install() {
    case .enabled:   print("Live data enabled — Headroom reads your Claude Code usage from disk.")
    case .chained:   print("Live data enabled — your existing Claude Code status line was preserved.")
    case .alreadyOn: print("Already enabled — nothing to do.")
    case .failed(let why): FileHandle.standardError.write("headroom: \(why)\n".data(using: .utf8)!); exit(1)
    }
    exit(0)
}

if CommandLine.arguments.contains("--print") {
    guard let (usage, at) = HookUsage.read() else {
        FileHandle.standardError.write(
            "headroom: no usage data yet — make sure the hook is installed (--install-hook) and use Claude Code once.\n"
                .data(using: .utf8)!)
        exit(1)
    }
    print("captured: \(ISO8601DateFormatter().string(from: at))")
    print("parsed: session(5h)=\(usage.fiveHour.utilization)% week(7d)=\(usage.sevenDay.utilization)%")
    print("render: title=\"\(Render.title(usage))\" tone=\(Render.tone(usage).rawValue)")
    print("render: session=\"\(Render.line(usage.fiveHour))\"")
    print("render: week=\"\(Render.line(usage.sevenDay))\"")
    exit(0)
}

if let i = CommandLine.arguments.firstIndex(of: "--snapshot"), CommandLine.arguments.count > i + 1 {
    let path = CommandLine.arguments[i + 1]
    _ = NSApplication.shared  // AppKit context for offscreen drawing
    guard let (usage, _) = HookUsage.read() else {
        FileHandle.standardError.write("headroom: no usage data yet — use Claude Code once, then retry.\n".data(using: .utf8)!)
        exit(1)
    }
    do {
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
    private let statusLine = NSMenuItem(title: "Starting…", action: nil, keyEquivalent: "")
    private let loginItem = NSMenuItem(title: "Launch at Login", action: #selector(toggleLaunchAtLogin(_:)), keyEquivalent: "")
    private var timer: Timer?

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
        menu.addItem(NSMenuItem(title: "Repair Live Data", action: #selector(repairLiveData), keyEquivalent: ""))
        // SMAppService only works from a real .app bundle (not a bare swift-build binary).
        if Bundle.main.bundleIdentifier != nil {
            loginItem.state = SMAppService.mainApp.status == .enabled ? .on : .off
            menu.addItem(loginItem)
        }
        menu.addItem(NSMenuItem(title: "Quit Headroom", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        menu.items.forEach { $0.target = self }
        statusItem.menu = menu

        // Wire the statusline hook automatically — no dialog, no permission, non-destructive
        // (it backs up settings.json and chains any existing status line). If already wired,
        // just refresh the script from current code so app upgrades take effect.
        if HookInstaller.isWired() { HookInstaller.refreshScript() } else { HookInstaller.install() }

        refresh()
        // The hook updates the file as you use Claude Code; a light poll keeps the menu bar
        // and the reset countdowns current. Reading a tiny local file — no network.
        timer = Timer.scheduledTimer(withTimeInterval: 15, repeats: true) { [weak self] _ in
            self?.refresh()
        }
    }

    @objc private func refreshNow() { refresh() }

    /// Re-wire the hook (idempotent) and report — for when something got into a weird state.
    @objc private func repairLiveData() {
        let alert = NSAlert()
        alert.alertStyle = .informational
        alert.messageText = "Headroom — live data"
        switch HookInstaller.install() {
        case .enabled, .alreadyOn:
            alert.informativeText = "Live data is on. Headroom reads your Claude Code usage from disk — no API, no rate limits, nothing to grant. Open Claude Code and your numbers appear."
        case .chained:
            alert.informativeText = "Live data is on, and your existing Claude Code status line was preserved. Open Claude Code and your numbers appear."
        case .failed(let why):
            alert.alertStyle = .warning
            alert.informativeText = "\(why) Your ~/.claude folder may not be writable."
        }
        alert.addButton(withTitle: "OK")
        NSApp.activate(ignoringOtherApps: true)
        alert.runModal()
        refresh()
    }

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
        render(HookUsage.read())
    }

    private func render(_ reading: (usage: Usage, capturedAt: Date)?) {
        guard let (usage, at) = reading else {
            // No data captured yet — the hook writes the file the next time Claude Code
            // is active. Honest, not broken: tell the user what unlocks the number.
            setTitle("CC —%", color: nil)
            let note = "Open Claude Code to see your usage"
            sessionMeter.awaiting(note)
            weeklyMeter.awaiting(note)
            statusLine.title = note
            return
        }

        // Show each window only while it's still live; a rolled-over window's old % would
        // be wrong, so we show "—" for it instead of faking a number.
        let five = usage.fiveHour.isLive ? usage.fiveHour : nil
        let seven = usage.sevenDay.isLive ? usage.sevenDay : nil
        if let five { sessionMeter.update(five) } else { sessionMeter.awaiting("window reset — open Claude Code") }
        if let seven { weeklyMeter.update(seven) } else { weeklyMeter.awaiting("window reset — open Claude Code") }

        // Menu bar shows the weekly %; color tracks whichever live window is closest to its
        // limit, so an imminent 5h stop turns the title red even on a calm week.
        let weekText = seven.map { Render.percent($0.utilization) } ?? "—%"
        let levels = [five, seven].compactMap { $0?.utilization }
        let tone = levels.isEmpty ? Tone.calm : Tone(utilization: levels.max()!)
        setTitle("CC \(weekText)", color: tone.color)

        statusLine.title = "Updated \(Self.clock.string(from: at))"
    }

    /// Re-render countdowns and re-read the file the moment the menu opens.
    func menuWillOpen(_ menu: NSMenu) {
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
