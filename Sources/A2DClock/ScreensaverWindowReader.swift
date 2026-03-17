import AppKit
import SwiftUI

struct ScreensaverWindowReader: NSViewRepresentable {
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    func makeNSView(context: Context) -> NSView {
        NSView(frame: .zero)
    }

    func updateNSView(_ nsView: NSView, context: Context) {
        Task { @MainActor in
            guard let window = nsView.window else {
                return
            }

            context.coordinator.configure(window: window)
        }
    }

    final class Coordinator {
        private var didConfigureAppearance = false
        private var didRequestFullScreen = false
        private var didHideCursor = false

        @MainActor
        func configure(window: NSWindow) {
            if !didConfigureAppearance {
                didConfigureAppearance = true

                window.titleVisibility = .hidden
                window.titlebarAppearsTransparent = true
                window.styleMask.insert(.fullSizeContentView)
                window.tabbingMode = .disallowed
                window.collectionBehavior = [.fullScreenPrimary, .managed, .stationary]
                window.level = .screenSaver

                window.standardWindowButton(.closeButton)?.isHidden = true
                window.standardWindowButton(.miniaturizeButton)?.isHidden = true
                window.standardWindowButton(.zoomButton)?.isHidden = true
            }

            if !didHideCursor {
                didHideCursor = true
                NSCursor.hide()
            }

            if !didRequestFullScreen {
                didRequestFullScreen = true
                window.toggleFullScreen(nil)
            }
        }
    }
}
