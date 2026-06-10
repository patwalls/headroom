import AppKit

// `headroom --snapshot out.png` — render the dropdown's meters with REAL data into a
// PNG, using the same MeterMenuView code the menu uses. This is how the README/landing
// get a truthful "what it looks like": the app's own rendering, never a mock.

enum Snapshot {
    static func write(usage: Usage, to path: String) throws {
        let width: CGFloat = 320
        let hasContext = usage.contextUsed != nil
        let height: CGFloat = hasContext ? 216 : 158
        let panel = PanelView(frame: NSRect(x: 0, y: 0, width: width, height: height))
        panel.appearance = NSAppearance(named: .darkAqua)

        let session = MeterMenuView(label: "Session (5h)")
        session.frame = NSRect(x: 0, y: 8, width: width, height: 58)
        session.update(usage.fiveHour)
        let week = MeterMenuView(label: "Week (7d)")
        week.frame = NSRect(x: 0, y: 66, width: width, height: 58)
        week.update(usage.sevenDay)
        panel.addSubview(session)
        panel.addSubview(week)
        if let ctx = usage.contextUsed {
            let context = MeterMenuView(label: "Context")
            context.frame = NSRect(x: 0, y: 124, width: width, height: 58)
            context.update(Usage.Window(utilization: ctx, resetsAt: nil))
            panel.addSubview(context)
        }

        let clock = DateFormatter()
        clock.timeStyle = .short
        clock.dateStyle = .none
        let updatedText = "Updated \(clock.string(from: Date()))"
        panel.statusText = [usage.modelName, updatedText].compactMap { $0 }.joined(separator: " · ")

        let pixelsHigh = Int(height * 2)
        guard let rep = NSBitmapImageRep(
            bitmapDataPlanes: nil, pixelsWide: Int(width * 2), pixelsHigh: pixelsHigh,
            bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true, isPlanar: false,
            colorSpaceName: .deviceRGB, bytesPerRow: 0, bitsPerPixel: 0
        ) else { throw AppError(message: "could not create bitmap") }
        rep.size = panel.bounds.size

        NSGraphicsContext.saveGraphicsState()
        NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: rep)
        panel.displayIgnoringOpacity(panel.bounds, in: NSGraphicsContext.current!)
        NSGraphicsContext.restoreGraphicsState()

        guard let png = rep.representation(using: .png, properties: [:]) else {
            throw AppError(message: "could not encode png")
        }
        try png.write(to: URL(fileURLWithPath: path))
    }
}

/// The dark rounded card the meters sit on — visually the menu, minus the chrome.
final class PanelView: NSView {
    var statusText = ""

    override var isFlipped: Bool { true }

    override func draw(_ dirtyRect: NSRect) {
        NSColor(calibratedWhite: 0.13, alpha: 1).setFill()
        NSBezierPath(roundedRect: bounds, xRadius: 12, yRadius: 12).fill()
        if !statusText.isEmpty {
            (statusText as NSString).draw(
                at: NSPoint(x: 14, y: bounds.height - 26),
                withAttributes: [
                    .font: NSFont.systemFont(ofSize: 12),
                    .foregroundColor: NSColor.secondaryLabelColor,
                ])
        }
    }
}
