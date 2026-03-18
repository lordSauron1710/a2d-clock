import A2DClockCore
import SwiftUI

public struct ClockStudioPanelView: View {
    @Environment(\.colorScheme) private var colorScheme

    @Binding private var customization: ClockCustomizationStore

    private let persist: (ClockCustomizationStore) -> Void
    private let onClose: () -> Void

    public init(
        customization: Binding<ClockCustomizationStore>,
        persist: @escaping (ClockCustomizationStore) -> Void,
        onClose: @escaping () -> Void
    ) {
        self._customization = customization
        self.persist = persist
        self.onClose = onClose
    }

    public var body: some View {
        GeometryReader { proxy in
            let resolvedScheme = customization.appearanceMode.resolvedColorScheme(systemColorScheme: colorScheme)
            let theme = ClockTheme.make(
                appearanceMode: customization.appearanceMode,
                systemColorScheme: colorScheme,
                palette: customization.dialPalette
            )
            let panelHeight = StudioPanelLayout.panelHeight(containerHeight: proxy.size.height)

            ScrollView(.vertical) {
                VStack(alignment: .leading, spacing: 22) {
                    StudioHeaderView(onClose: onClose)
                    StudioHeroView(
                        theme: theme,
                        appearanceTitle: customization.appearanceMode.title,
                        paletteTitle: customization.dialPalette.title
                    )

                    StudioSectionView(
                        title: "Mode",
                        caption: "Auto follows the system. Day changes the background. Night changes the lume."
                    ) {
                        HStack(spacing: 10) {
                            ForEach(ClockAppearanceMode.allCases) { mode in
                                ModeCard(
                                    mode: mode,
                                    isSelected: customization.appearanceMode == mode
                                ) {
                                    customization.appearanceMode = mode
                                    persist(customization)
                                }
                            }
                        }
                    }

                    StudioSectionView(
                        title: "Time Display",
                        caption: "Switch between 12-hour and 24-hour time while the entire clock transitions together."
                    ) {
                        HStack(spacing: 10) {
                            ForEach(ClockHourFormat.allCases) { format in
                                TimeFormatCard(
                                    format: format,
                                    isSelected: customization.hourFormat == format
                                ) {
                                    customization.hourFormat = format
                                    persist(customization)
                                }
                            }
                        }
                    }

                    StudioSectionView(
                        title: "Theme",
                        caption: "These same five options drive the day background and the night lume."
                    ) {
                        LazyVGrid(
                            columns: [
                                GridItem(.flexible(minimum: 0), spacing: 12),
                                GridItem(.flexible(minimum: 0), spacing: 12)
                            ],
                            spacing: 12
                        ) {
                            ForEach(ClockDialPalette.allCases) { palette in
                                PaletteCard(
                                    palette: palette,
                                    isNightPreview: resolvedScheme == .dark,
                                    isSelected: customization.dialPalette == palette
                                ) {
                                    customization.dialPalette = palette
                                    persist(customization)
                                }
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(24)
            }
            .frame(width: StudioPanelLayout.panelWidth, height: panelHeight, alignment: .top)
            .background(
                RoundedRectangle(cornerRadius: 30, style: .continuous)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 30, style: .continuous)
                            .strokeBorder(Color.white.opacity(0.18), lineWidth: 1)
                    )
            )
            .shadow(color: Color.black.opacity(0.22), radius: 26, x: 0, y: 16)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
            .padding(.top, StudioPanelLayout.outerMargin)
            .padding(.trailing, StudioPanelLayout.outerMargin)
        }
    }
}

enum StudioPanelLayout {
    static let panelWidth: CGFloat = 380
    static let preferredHeight: CGFloat = 680
    static let outerMargin: CGFloat = 28

    static func panelHeight(containerHeight: CGFloat) -> CGFloat {
        let availableHeight = max(containerHeight - (outerMargin * 2), 0)
        return min(availableHeight, preferredHeight)
    }
}

private struct StudioHeaderView: View {
    let onClose: () -> Void

    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Studio")
                    .font(.system(size: 26, weight: .semibold, design: .rounded))
                    .foregroundStyle(.primary)

                Text("Tune the clock live without breaking the scene.")
                    .font(.system(size: 13, weight: .medium, design: .rounded))
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Button(action: onClose) {
                Image(systemName: "xmark")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundStyle(.primary)
                    .frame(width: 30, height: 30)
                    .background(
                        Circle()
                            .fill(Color.black.opacity(0.06))
                    )
            }
            .buttonStyle(.plain)
        }
    }
}

private struct StudioHeroView: View {
    let theme: ClockTheme
    let appearanceTitle: String
    let paletteTitle: String

    private let previewFrame = ClockClockFrame(
        digits: [0, 0, 0, 0],
        poses: DigitGlyph.poses(for: [0, 0, 0, 0])
    )

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            ZStack {
                AmbientBackdropView(theme: theme)
                    .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))

                ClockPreviewStripView(frame: previewFrame, theme: theme)
                    .padding(.horizontal, 18)
                    .padding(.vertical, 22)
            }
            .frame(height: 176)

            HStack(spacing: 8) {
                SettingBadge(title: appearanceTitle)
                SettingBadge(title: paletteTitle)
            }
        }
    }
}

private struct ClockPreviewStripView: View {
    let frame: ClockClockFrame
    let theme: ClockTheme

    var body: some View {
        GeometryReader { proxy in
            let layout = ClockDisplayLayout(size: proxy.size, clockScale: ClockCustomizationStore.defaultClockScale)

            ZStack {
                ForEach(ClockSlot.all) { slot in
                    ClockFaceView(
                        pose: frame.poses[slot.id],
                        theme: theme
                    )
                    .frame(width: layout.cellSize, height: layout.cellSize)
                    .position(layout.position(for: slot))
                }
            }
        }
    }
}

private struct StudioSectionView<Content: View>: View {
    let title: String
    let caption: String
    let content: Content

    init(
        title: String,
        caption: String,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.caption = caption
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.system(size: 15, weight: .semibold, design: .rounded))
                    .foregroundStyle(.primary)

                Text(caption)
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            content
        }
    }
}

private struct ModeCard: View {
    let mode: ClockAppearanceMode
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 8) {
                Text(mode.title)
                    .font(.system(size: 13, weight: .semibold, design: .rounded))
                    .foregroundStyle(.primary)

                Text(mode.detail)
                    .font(.system(size: 11, weight: .medium, design: .rounded))
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(14)
            .frame(maxWidth: .infinity, minHeight: 82, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(Color.white.opacity(isSelected ? 0.18 : 0.08))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .strokeBorder(isSelected ? Color.black.opacity(0.82) : Color.black.opacity(0.08), lineWidth: isSelected ? 2 : 1)
            )
        }
        .buttonStyle(.plain)
    }
}

private struct TimeFormatCard: View {
    let format: ClockHourFormat
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 10) {
                Text(format.title)
                    .font(.system(size: 13, weight: .semibold, design: .rounded))
                    .foregroundStyle(.primary)

                Text(format.detail)
                    .font(.system(size: 11, weight: .medium, design: .rounded))
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(14)
            .frame(maxWidth: .infinity, minHeight: 82, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(Color.white.opacity(isSelected ? 0.18 : 0.08))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .strokeBorder(isSelected ? Color.black.opacity(0.82) : Color.black.opacity(0.08), lineWidth: isSelected ? 2 : 1)
            )
        }
        .buttonStyle(.plain)
    }
}

private struct PaletteCard: View {
    let palette: ClockDialPalette
    let isNightPreview: Bool
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 10) {
                PalettePreviewSwatch(
                    palette: palette,
                    isNightPreview: isNightPreview
                )
                .frame(height: 52)

                Text(palette.title)
                    .font(.system(size: 13, weight: .semibold, design: .rounded))
                    .foregroundStyle(.primary)
            }
            .padding(14)
            .frame(maxWidth: .infinity, minHeight: 82, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(Color.white.opacity(isSelected ? 0.18 : 0.08))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .strokeBorder(isSelected ? Color.black.opacity(0.82) : Color.black.opacity(0.08), lineWidth: isSelected ? 2 : 1)
            )
        }
        .buttonStyle(.plain)
    }
}

private struct PalettePreviewSwatch: View {
    let palette: ClockDialPalette
    let isNightPreview: Bool

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(isNightPreview ? Color(red: 0.045, green: 0.05, blue: 0.065) : palette.dayBackground)

            if isNightPreview {
                HStack(spacing: 14) {
                    LumePreviewBar(color: palette.nightLume, angle: -.pi / 4.0)
                    LumePreviewBar(color: palette.nightLume, angle: .pi / 4.0)
                }
            } else {
                LinearGradient(
                    colors: [
                        Color.white.opacity(0.08),
                        Color.clear,
                        Color.black.opacity(0.08)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            }
        }
    }
}

private struct LumePreviewBar: View {
    let color: Color
    let angle: Double

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 3, style: .continuous)
                .fill(color.opacity(0.55))
                .frame(width: 10, height: 26)
                .blur(radius: 7)

            RoundedRectangle(cornerRadius: 3, style: .continuous)
                .fill(color)
                .frame(width: 10, height: 26)
        }
        .rotationEffect(.radians(angle))
    }
}

private struct SettingBadge: View {
    let title: String

    var body: some View {
        Text(title)
            .font(.system(size: 11, weight: .semibold, design: .rounded))
            .foregroundStyle(.primary)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(
                Capsule()
                    .fill(Color.white.opacity(0.36))
            )
    }
}
