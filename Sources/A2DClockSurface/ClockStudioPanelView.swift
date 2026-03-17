import A2DClockCore
import SwiftUI

public struct ClockStudioPanelView: View {
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
        let theme = ClockTheme.make(palette: customization.dialPalette)

        ScrollView {
            VStack(alignment: .leading, spacing: 22) {
                StudioHeaderView(onClose: onClose)
                StudioHeroView(theme: theme)

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
                    title: "Background",
                    caption: "Choose one of five simple background colors. The hands stay black."
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
                                isSelected: customization.dialPalette == palette
                            ) {
                                customization.dialPalette = palette
                                persist(customization)
                            }
                        }
                    }
                }

                StudioSectionView(
                    title: "Clock Size",
                    caption: "Scale the composition continuously from restrained to wall-sized."
                ) {
                    ClockSizeSlider(value: customization.clockScale) { value in
                        customization.clockScale = value
                        persist(customization)
                    }
                }
            }
            .padding(24)
        }
        .frame(width: 380)
        .background(
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                        .strokeBorder(Color.white.opacity(0.18), lineWidth: 1)
                )
        )
        .shadow(color: Color.black.opacity(0.22), radius: 26, x: 0, y: 16)
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

    private let previewFrame = ClockClockFrame(
        digits: [0, 0, 0, 0],
        poses: DigitGlyph.poses(for: [0, 0, 0, 0])
    )

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(theme.backgroundColor)

                LinearGradient(
                    colors: [
                        Color.white.opacity(0.08),
                        Color.clear,
                        Color.black.opacity(0.1)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))

                ClockPreviewStripView(frame: previewFrame, theme: theme)
                    .padding(.horizontal, 18)
                    .padding(.vertical, 22)
            }
            .frame(height: 176)

            HStack(spacing: 8) {
                SettingBadge(title: "Black Hands")
                SettingBadge(title: "5 Backgrounds")
                SettingBadge(title: "Bar-Only")
            }
        }
    }
}

private struct ClockPreviewStripView: View {
    let frame: ClockClockFrame
    let theme: ClockTheme

    var body: some View {
        GeometryReader { proxy in
            let layout = ClockDisplayLayout(size: proxy.size, clockScale: 1.04)

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
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 10) {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(palette.previewColor)
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

private struct ClockSizeSlider: View {
    let value: Double
    let onChange: (Double) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Slider(
                value: Binding(
                    get: { value },
                    set: { onChange($0) }
                ),
                in: ClockCustomizationStore.clockScaleRange
            )
            .tint(.black)

            HStack {
                Text("Smaller")
                Spacer()
                Text("\(Int((value * 100).rounded()))%")
                    .foregroundStyle(.primary)
                Spacer()
                Text("Larger")
            }
            .font(.system(size: 11, weight: .medium, design: .rounded))
            .foregroundStyle(.secondary)
        }
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
