import SwiftUI
import AppKit

final class CapybaraWindowController: NSWindowController {
    private let stateStore = TaskStateStore()

    init() {
        let rootView = CapybaraView()
            .environmentObject(stateStore)

        let panel = NSPanel(
            contentRect: NSRect(x: 200, y: 200, width: 240, height: 240),
            styleMask: [.nonactivatingPanel, .fullSizeContentView],
            backing: .buffered,
            defer: false
        )
        panel.level = .floating
        panel.isOpaque = false
        panel.backgroundColor = .clear
        panel.hasShadow = false
        panel.isMovableByWindowBackground = true
        panel.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        panel.titleVisibility = .hidden
        panel.titlebarAppearsTransparent = true

        panel.contentView = NSHostingView(rootView: rootView)
        super.init(window: panel)

        stateStore.startWatching()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }
}
