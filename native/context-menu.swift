import AppKit

class AppDelegate: NSObject, NSApplicationDelegate, NSMenuDelegate {

    var window: NSWindow!

    func applicationDidFinishLaunching(_ notification: Notification) {

        NSApp.setActivationPolicy(.regular)
        NSApp.activate(ignoringOtherApps: true)

        let args = CommandLine.arguments

        guard args.count >= 3 else {
            print("")
            NSApplication.shared.terminate(nil)
            return
        }

        // Always required now
        let x = Double(args[1]) ?? 0
        let y = Double(args[2]) ?? 0

        let items = Array(args.dropFirst(3)).filter { !$0.isEmpty }

        guard !items.isEmpty else {
            print("")
            NSApplication.shared.terminate(nil)
            return
        }

        let menu = NSMenu()
        menu.delegate = self

        for item in items {
            let mi = NSMenuItem(title: item, action: #selector(selectItem(_:)), keyEquivalent: "")
            mi.target = self
            menu.addItem(mi)
        }

        // 🔑 IMPORTANT: anchor window must match SAME coordinate system
        let point = NSPoint(
            x: x,
            y: y
        )

        print("DEBUG x:", x, "y:", y)

        // FIX: place window at SAME location (not 0,0)
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 1, height: 1),
            styleMask: [],
            backing: .buffered,
            defer: false
        )

        window.level = .floating
        window.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        window.isOpaque = false
        window.backgroundColor = .clear
        window.makeKeyAndOrderFront(nil)

        let view = NSView(frame: window.contentView!.bounds)

        view.discardCursorRects()
        view.addCursorRect(view.bounds, cursor: NSCursor.arrow)
        NSCursor.arrow.set()

        window.contentView = view

        // ensure menu uses SAME reference space as window
        DispatchQueue.main.async {
            menu.popUp(positioning: nil, at: point, in: nil)
        }
    }

    @objc func selectItem(_ sender: NSMenuItem) {
        print(sender.title)
        DispatchQueue.main.async {
            self.cleanup()
        }
    }

    func menuDidClose(_ menu: NSMenu) {
        DispatchQueue.main.async {
            self.cleanup()
        }
    }

    func cleanup() {
        NSCursor.arrow.set()

        window?.orderOut(nil)
        window?.close()
        window = nil

        NSApplication.shared.terminate(nil)
    }
}

let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate
app.run()