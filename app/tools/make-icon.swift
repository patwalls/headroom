import AppKit

// Renders Headroom's app icon at every .iconset size — the dropdown's meter bars on a
// Big Sur-style squircle. Vector-drawn per size (no upscaling blur).
// Usage: swift make-icon.swift <output.iconset-dir>

func drawIcon(size s: CGFloat) -> NSBitmapImageRep {
    let rep = NSBitmapImageRep(
        bitmapDataPlanes: nil, pixelsWide: Int(s), pixelsHigh: Int(s),
        bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true, isPlanar: false,
        colorSpaceName: .deviceRGB, bytesPerRow: 0, bitsPerPixel: 0)!
    NSGraphicsContext.saveGraphicsState()
    NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: rep)

    // Big Sur grid: squircle fills ~80% of the canvas.
    let inset = s * 0.1
    let body = NSRect(x: inset, y: inset, width: s - inset * 2, height: s - inset * 2)
    let squircle = NSBezierPath(roundedRect: body, xRadius: s * 0.18, yRadius: s * 0.18)
    let gradient = NSGradient(
        starting: NSColor(calibratedRed: 0.13, green: 0.15, blue: 0.19, alpha: 1),
        ending: NSColor(calibratedRed: 0.07, green: 0.08, blue: 0.11, alpha: 1))!
    gradient.draw(in: squircle, angle: -90)

    // Two meter bars, echoing the dropdown: session (green, low) + week (amber, high).
    let barWidth = body.width * 0.62
    let barHeight = s * 0.075
    let barX = body.midX - barWidth / 2
    let radius = barHeight / 2
    let fills: [(CGFloat, NSColor, CGFloat)] = [
        (body.midY + s * 0.05, NSColor(calibratedRed: 0.36, green: 0.78, blue: 0.42, alpha: 1), 0.34),
        (body.midY - s * 0.05 - barHeight, NSColor(calibratedRed: 0.92, green: 0.66, blue: 0.26, alpha: 1), 0.71),
    ]
    for (y, color, fraction) in fills {
        let track = NSRect(x: barX, y: y, width: barWidth, height: barHeight)
        NSColor(calibratedWhite: 1, alpha: 0.12).setFill()
        NSBezierPath(roundedRect: track, xRadius: radius, yRadius: radius).fill()
        let fill = NSRect(x: barX, y: y, width: max(barHeight, barWidth * fraction), height: barHeight)
        color.setFill()
        NSBezierPath(roundedRect: fill, xRadius: radius, yRadius: radius).fill()
    }

    NSGraphicsContext.restoreGraphicsState()
    return rep
}

let out = CommandLine.arguments.count > 1 ? CommandLine.arguments[1] : "Headroom.iconset"
try? FileManager.default.createDirectory(atPath: out, withIntermediateDirectories: true)
let sizes: [(String, CGFloat)] = [
    ("icon_16x16", 16), ("icon_16x16@2x", 32),
    ("icon_32x32", 32), ("icon_32x32@2x", 64),
    ("icon_128x128", 128), ("icon_128x128@2x", 256),
    ("icon_256x256", 256), ("icon_256x256@2x", 512),
    ("icon_512x512", 512), ("icon_512x512@2x", 1024),
]
for (name, size) in sizes {
    let rep = drawIcon(size: size)
    try! rep.representation(using: .png, properties: [:])!
        .write(to: URL(fileURLWithPath: "\(out)/\(name).png"))
}
print("wrote \(sizes.count) sizes to \(out)")
