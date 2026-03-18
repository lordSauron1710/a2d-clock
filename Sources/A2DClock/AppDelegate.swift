import AppKit

@MainActor
final class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.regular)
        NSApp.activate(ignoringOtherApps: true)
        installScreensaverIfNeeded()
    }

    func applicationWillTerminate(_ notification: Notification) {
        NSCursor.unhide()
    }

    // MARK: - Screensaver installation

    private func installScreensaverIfNeeded() {
        guard
            let bundledSaverURL = Bundle.main.url(forResource: "A2DClock", withExtension: "saver"),
            let screenSaversURL = FileManager.default
                .urls(for: .libraryDirectory, in: .userDomainMask)
                .first?
                .appendingPathComponent("Screen Savers/A2DClock.saver")
        else { return }

        let needsInstall: Bool
        if FileManager.default.fileExists(atPath: screenSaversURL.path) {
            needsInstall = bundledVersion(at: bundledSaverURL) != installedVersion(at: screenSaversURL)
        } else {
            needsInstall = true
        }

        guard needsInstall else { return }

        do {
            if FileManager.default.fileExists(atPath: screenSaversURL.path) {
                try FileManager.default.removeItem(at: screenSaversURL)
            }
            try FileManager.default.copyItem(at: bundledSaverURL, to: screenSaversURL)
        } catch {
            showInstallError(error)
        }
    }

    private func bundledVersion(at url: URL) -> String? {
        saverVersion(at: url)
    }

    private func installedVersion(at url: URL) -> String? {
        saverVersion(at: url)
    }

    private func saverVersion(at url: URL) -> String? {
        let plistURL = url.appendingPathComponent("Contents/Info.plist")
        guard let dict = NSDictionary(contentsOf: plistURL) else { return nil }
        return dict["CFBundleVersion"] as? String
    }

    private func showInstallError(_ error: Error) {
        let alert = NSAlert()
        alert.messageText = "Couldn't install screensaver"
        alert.informativeText = error.localizedDescription
        alert.alertStyle = .warning
        alert.runModal()
    }
}
