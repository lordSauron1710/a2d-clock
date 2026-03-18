import A2DClockCore
import SwiftUI

public struct ClockSettingsSheetView: View {
    @Environment(\.colorScheme) private var colorScheme

    @Binding private var customization: ClockCustomizationStore

    private let onCancel: () -> Void
    private let onSave: () -> Void

    public init(
        customization: Binding<ClockCustomizationStore>,
        onCancel: @escaping () -> Void,
        onSave: @escaping () -> Void
    ) {
        self._customization = customization
        self.onCancel = onCancel
        self.onSave = onSave
    }

    public var body: some View {
        VStack(spacing: 18) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("A2D Clock")
                        .font(.system(size: 24, weight: .semibold, design: .rounded))

                    Text("Dial in the mode, theme, and time format before the saver starts.")
                        .font(.system(size: 13, weight: .medium, design: .rounded))
                        .foregroundStyle(.secondary)
                }

                Spacer()
            }

            TimelineView(.animation(minimumInterval: 1.0 / 20.0)) { context in
                ClockSceneView(date: context.date, customization: customization)
                    .frame(height: 250)
                    .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .strokeBorder(Color.black.opacity(0.08), lineWidth: 1)
                    )
            }

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    settingsSection("Mode") {
                        Picker("Mode", selection: $customization.appearanceMode) {
                            ForEach(ClockAppearanceMode.allCases) { mode in
                                Text(mode.title).tag(mode)
                            }
                        }
                        .pickerStyle(.segmented)
                    }

                    settingsSection("Time Display") {
                        Picker("Time Display", selection: $customization.hourFormat) {
                            ForEach(ClockHourFormat.allCases) { format in
                                Text(format.title).tag(format)
                            }
                        }
                        .pickerStyle(.segmented)
                    }

                    settingsSection("Theme") {
                        Picker("Style", selection: $customization.dialPalette) {
                            ForEach(ClockDialPalette.allCases) { palette in
                                Text(palette.title).tag(palette)
                            }
                        }
                        .pickerStyle(.menu)
                    }
                }
            }

            HStack(spacing: 12) {
                Button("Cancel", action: onCancel)
                    .keyboardShortcut(.cancelAction)

                Spacer()

                Button("Save", action: onSave)
                    .keyboardShortcut(.defaultAction)
            }
        }
        .padding(24)
        .frame(width: 720, height: 720)
    }

    private func settingsSection<Content: View>(
        _ title: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 13, weight: .semibold, design: .rounded))
                .foregroundStyle(.secondary)

            content()
        }
    }
}
