import AppKit

// The dropdown meters — the landing page's bars, rendered for real.
// Each window gets: label + % on one row, a color-coded bar, the reset countdown.

final class MeterMenuView: NSView {
    private let label: String
    private var percentText = "—%"
    private var fraction: CGFloat = 0
    private var fill: NSColor = .systemGreen
    private var caption = "fetching…"

    init(label: String) {
        self.label = label
        super.init(frame: NSRect(x: 0, y: 0, width: 300, height: 58))
        // The menu sizes itself to its widest item (often a status-line text item);
        // stretch with it so the bars always span the menu's full width.
        autoresizingMask = [.width]
    }

    required init?(coder: NSCoder) { fatalError("not used") }

    override var isFlipped: Bool { true }

    func update(_ window: Usage.Window?, now: Date = Date()) {
        guard let window else { needsDisplay = true; return }
        percentText = Render.percent(window.utilization)
        fraction = CGFloat(min(max(window.utilization / 100, 0), 1))
        switch Tone(utilization: window.utilization) {
        case .calm: fill = .systemGreen
        case .amber: fill = .systemOrange
        case .red: fill = .systemRed
        }
        if let resetsAt = window.resetsAt {
            caption = "resets in \(Render.countdown(from: now, to: resetsAt)) (\(Render.clock.string(from: resetsAt)))"
        } else {
            caption = ""
        }
        needsDisplay = true
    }

    override func draw(_ dirtyRect: NSRect) {
        let x: CGFloat = 14
        let width = bounds.width - x * 2

        let labelAttrs: [NSAttributedString.Key: Any] = [
            .font: NSFont.systemFont(ofSize: 13, weight: .medium),
            .foregroundColor: NSColor.labelColor,
        ]
        let percentAttrs: [NSAttributedString.Key: Any] = [
            .font: NSFont.monospacedDigitSystemFont(ofSize: 13, weight: .semibold),
            .foregroundColor: NSColor.labelColor,
        ]
        (label as NSString).draw(at: NSPoint(x: x, y: 6), withAttributes: labelAttrs)
        let percent = percentText as NSString
        let percentSize = percent.size(withAttributes: percentAttrs)
        percent.draw(at: NSPoint(x: x + width - percentSize.width, y: 6), withAttributes: percentAttrs)

        let barRect = NSRect(x: x, y: 29, width: width, height: 7)
        NSColor.labelColor.withAlphaComponent(0.14).setFill()
        NSBezierPath(roundedRect: barRect, xRadius: 3.5, yRadius: 3.5).fill()
        if fraction > 0 {
            let fillRect = NSRect(x: x, y: 29, width: max(7, width * fraction), height: 7)
            fill.setFill()
            NSBezierPath(roundedRect: fillRect, xRadius: 3.5, yRadius: 3.5).fill()
        }

        if !caption.isEmpty {
            let captionAttrs: [NSAttributedString.Key: Any] = [
                .font: NSFont.systemFont(ofSize: 11),
                .foregroundColor: NSColor.secondaryLabelColor,
            ]
            (caption as NSString).draw(at: NSPoint(x: x, y: 41), withAttributes: captionAttrs)
        }
    }
}
