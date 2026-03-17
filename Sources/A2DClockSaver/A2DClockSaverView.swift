import A2DClockSurface
import AppKit
import ScreenSaver
import SwiftUI

@MainActor
private final class ClockSaverModel: ObservableObject {
    @Published var currentDate: Date
    @Published var customization: ClockCustomizationStore

    init(customization: ClockCustomizationStore) {
        self.currentDate = Date()
        self.customization = customization
    }
}

private struct ClockSaverRootView: View {
    @ObservedObject var model: ClockSaverModel

    var body: some View {
        ClockSceneView(date: model.currentDate, customization: model.customization)
    }
}

private struct ClockSaverConfigurationRootView: View {
    @State private var customization: ClockCustomizationStore

    let onCancel: () -> Void
    let onSave: (ClockCustomizationStore) -> Void

    init(
        customization: ClockCustomizationStore,
        onCancel: @escaping () -> Void,
        onSave: @escaping (ClockCustomizationStore) -> Void
    ) {
        self._customization = State(initialValue: customization)
        self.onCancel = onCancel
        self.onSave = onSave
    }

    var body: some View {
        ClockSettingsSheetView(
            customization: $customization,
            onCancel: onCancel,
            onSave: { onSave(customization) }
        )
    }
}

@objc(A2DClockSaverView)
final class A2DClockSaverView: ScreenSaverView {
    private let saverDefaults: UserDefaults
    private let model: ClockSaverModel
    private var hostingView: NSHostingView<ClockSaverRootView>?
    private var configurationWindow: NSWindow?

    override init?(frame: NSRect, isPreview: Bool) {
        let defaults = Self.makeDefaults()
        self.saverDefaults = defaults
        self.model = ClockSaverModel(customization: ClockCustomizationStore.load(defaults: defaults))
        super.init(frame: frame, isPreview: isPreview)
        commonInit()
    }

    required init?(coder: NSCoder) {
        let defaults = Self.makeDefaults()
        self.saverDefaults = defaults
        self.model = ClockSaverModel(customization: ClockCustomizationStore.load(defaults: defaults))
        super.init(coder: coder)
        commonInit()
    }

    override var hasConfigureSheet: Bool {
        true
    }

    override var configureSheet: NSWindow? {
        let window = makeConfigurationWindow()
        configurationWindow = window
        return window
    }

    override func startAnimation() {
        super.startAnimation()
        refreshFrame()
    }

    override func animateOneFrame() {
        refreshFrame()
    }

    private func commonInit() {
        let hostingView = NSHostingView(rootView: ClockSaverRootView(model: model))
        self.hostingView = hostingView
        hostingView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(hostingView)
        NSLayoutConstraint.activate([
            hostingView.leadingAnchor.constraint(equalTo: leadingAnchor),
            hostingView.trailingAnchor.constraint(equalTo: trailingAnchor),
            hostingView.topAnchor.constraint(equalTo: topAnchor),
            hostingView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        refreshFrame()
    }

    private func refreshFrame() {
        let now = Date()
        model.currentDate = now
        animationTimeInterval = ClockRenderCadence.nextUpdateInterval(
            for: now,
            customization: model.customization
        )
    }

    private func makeConfigurationWindow() -> NSWindow {
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 720, height: 720),
            styleMask: [.titled],
            backing: .buffered,
            defer: false
        )
        window.title = "A2D Clock"
        window.isReleasedWhenClosed = false
        window.level = .floating

        window.contentView = NSHostingView(
            rootView: ClockSaverConfigurationRootView(
                customization: model.customization,
                onCancel: { [weak self, weak window] in
                    self?.dismissConfigurationWindow(window)
                },
                onSave: { [weak self, weak window] customization in
                    guard let self else {
                        return
                    }

                    customization.persist(defaults: self.saverDefaults)
                    self.model.customization = customization
                    self.refreshFrame()
                    self.dismissConfigurationWindow(window)
                }
            )
        )

        return window
    }

    private func dismissConfigurationWindow(_ window: NSWindow?) {
        guard let window else {
            return
        }

        if let parentWindow = window.sheetParent {
            parentWindow.endSheet(window)
        } else {
            window.close()
        }
    }

    private static func makeDefaults() -> UserDefaults {
        let bundleIdentifier = Bundle(for: A2DClockSaverView.self).bundleIdentifier ?? "com.sandy.a2dclock.saver"
        return ScreenSaverDefaults(forModuleWithName: bundleIdentifier) ?? .standard
    }
}
