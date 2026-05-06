import AppKit

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.activate(ignoringOtherApps: true)

        let args = CommandLine.arguments

        guard args.count >= 2 else {
            FileHandle.standardOutput.write("error:missing_title\n".data(using: .utf8)!)
            NSApplication.shared.terminate(nil)
            return
        }

        let title = args[1]

        let description = args.count >= 3 ? args[2] : nil

        let okText = args.count >= 4 ? args[3] : "OK"

        let alert = NSAlert()
        alert.messageText = title

        if let description = description {
            alert.informativeText = description
        }

        alert.addButton(withTitle: okText)   
        alert.addButton(withTitle: "Cancel") 

        alert.alertStyle = .informational

        let response = alert.runModal()

        let result: String
        switch response {
        case .alertFirstButtonReturn:
            result = "ok"
        default:
            result = "cancel"
        }

        FileHandle.standardOutput.write((result + "\n").data(using: .utf8)!)
        NSApplication.shared.terminate(nil)
    }
}

let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate
app.setActivationPolicy(.accessory)
app.run()