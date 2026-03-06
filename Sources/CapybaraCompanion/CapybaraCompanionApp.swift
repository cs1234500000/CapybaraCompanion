import SwiftUI
import AppKit

@main
struct CapybaraCompanionApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        Settings { EmptyView() }
    }
}

final class AppDelegate: NSObject, NSApplicationDelegate {
    private var windowController: CapybaraWindowController?

    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApplication.shared.setActivationPolicy(.accessory)
        windowController = CapybaraWindowController()
        windowController?.showWindow(nil)
        windowController?.window?.orderFrontRegardless()
    }
}
