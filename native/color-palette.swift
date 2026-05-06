import AppKit

class AppDelegate: NSObject, NSApplicationDelegate {

    var window: NSWindow!
    var colorWell: NSColorWell!

    func applicationDidFinishLaunching(_ notification: Notification) {

        NSApp.setActivationPolicy(.regular)
        NSApp.activate(ignoringOtherApps: true)

        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 260, height: 160),
            styleMask: [.titled, .closable],
            backing: .buffered,
            defer: false
        )

        window.title = "Color Picker"

        window.level = .floating
        window.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]

        let contentView = NSView(frame: window.contentView!.bounds)

        colorWell = NSColorWell(frame: NSRect(x: 20, y: 90, width: 220, height: 30))
        contentView.addSubview(colorWell)

        let label = NSTextField(labelWithString: "Pick a color:")
        label.frame = NSRect(x: 20, y: 120, width: 200, height: 20)
        contentView.addSubview(label)

        let button = NSButton(title: "Select", target: self, action: #selector(selectColor))
        button.frame = NSRect(x: 20, y: 30, width: 220, height: 40)
        button.bezelStyle = .rounded
        contentView.addSubview(button)

        window.contentView = contentView
        window.center()
        window.makeKeyAndOrderFront(nil)
    }

    @objc func selectColor() {
        guard let color = colorWell.color.usingColorSpace(.sRGB) else {
            print("null")
            NSApplication.shared.terminate(nil)
            return
        }

        let output = "\(color.redComponent) \(color.greenComponent) \(color.blueComponent) \(color.alphaComponent)"
        print(output)

        NSApplication.shared.terminate(nil)
    }
}

// Entry point
let app = NSApplication.shared
let delegate = AppDelegate()

app.delegate = delegate
app.run()