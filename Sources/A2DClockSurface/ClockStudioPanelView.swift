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
        let theme = ClockTheme.make(
            appearanceMode: customization.appearanceMode,
            systemColorScheme: colorScheme,
            palette: customization.dialPalette,
            lumeColor: customization.lumeColor
        )

        ScrollView {
            VStack(alignment: .leading, spacing: 22) {
                StudioHeaderView(onClose: onClose)
                StudioHeroView(customization: customization, theme: theme)

                StudioSectionView(
                    title: "Atmosphere",
                    caption: "Choose whether the scene follows the system or keeps its own mood."
                ) {
                    HStack(spacing: 10) {
                        ForEach(ClockAppearanceMode.allCases) { mode in
                            AppearanceCard(
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
                    caption: "Switch between classic 12-hour readout and a 24-hour instrument clock."
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
                    title: "Dial Palette",
                    caption: "Each palette changes the backdrop and the dial family together."
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
                    title: "Footprint",
                    caption: "Switch between a room-scale composition and a tighter edition."
                ) {
                    HStack(spacing: 10) {
                        ForEach(ClockScaleOption.allCases) { option in
                            ScaleCard(
                                option: option,
                                isSelected: customization.scaleOption == option
                            ) {
                                customization.scaleOption = option
                                persist(customization)
                            }
                        }
                    }
                }

                StudioSectionView(
                    title: "Night Glow",
                    caption: "Pick the lume tone used when the scene enters its darker state."
                ) {
                    LazyVGrid(
                        columns: Array(repeating: GridItem(.flexible(minimum: 0), spacing: 10), count: 4),
                        spacing: 10
                    ) {
                        ForEach(ClockLumeColor.allCases) { lume in
                            LumeChip(
                                lume: lume,
                                isSelected: customization.lumeColor == lume
                            ) {
                                customization.lumeColor = lume
                                persist(customization)
                            }
                        }
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
                        .strokeBorder(Color.white.opacity(0.2), lineWidth: 1)
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

                Text("Tune the clock live without leaving the stage.")
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
    let customization: ClockCustomizationStore
    let theme: ClockTheme

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [theme.backgroundTop, theme.backgroundBottom],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )

                Circle()
                    .fill(theme.accentOne.opacity(0.18))
                    .frame(width: 120, height: 120)
                    .offset(x: -90, y: -30)

                Rectangle()
                    .fill(theme.accentThree.opacity(0.16))
                    .frame(width: 90, height: 90)
                    .rotationEffect(.degrees(16))
                    .offset(x: 115, y: 24)

                HStack(spacing: 18) {
                    ClockFaceView(
                        pose: .clockUnits(10, 2),
                        theme: theme,
                        faceFill: theme.faceFill(for: 0)
                    )
                    .frame(width: 92, height: 92)

                    ClockFaceView(
                        pose: .clockUnits(1, 7),
                        theme: theme,
                        faceFill: theme.faceFill(for: 1)
                    )
                    .frame(width: 92, height: 92)
                }
            }
            .frame(height: 170)

            HStack(spacing: 8) {
                SettingBadge(title: customization.hourFormat.title)
                SettingBadge(title: customization.dialPalette.title)
                SettingBadge(title: customization.scaleOption.title)
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

private struct AppearanceCard: View {
    let mode: ClockAppearanceMode
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 12) {
                Image(systemName: mode.symbolName)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(isSelected ? Color.white : .primary)

                Spacer()

                Text(mode.title)
                    .font(.system(size: 13, weight: .semibold, design: .rounded))
                    .foregroundStyle(isSelected ? Color.white : .primary)
            }
            .padding(14)
            .frame(maxWidth: .infinity, minHeight: 88, alignment: .topLeading)
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(isSelected ? Color.black.opacity(0.78) : Color.white.opacity(0.12))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .strokeBorder(isSelected ? Color.white.opacity(0.3) : Color.black.opacity(0.08), lineWidth: 1)
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
                    .strokeBorder(isSelected ? Color.black.opacity(0.85) : Color.black.opacity(0.08), lineWidth: isSelected ? 2 : 1)
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
                HStack(spacing: 6) {
                    ForEach(palette.previewSwatches.indices, id: \.self) { index in
                        Circle()
                            .fill(palette.previewSwatches[index])
                            .frame(width: 18, height: 18)
                    }
                }

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
                    .strokeBorder(isSelected ? Color.black.opacity(0.85) : Color.black.opacity(0.08), lineWidth: isSelected ? 2 : 1)
            )
        }
        .buttonStyle(.plain)
    }
}

private struct ScaleCard: View {
    let option: ClockScaleOption
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(Color.black.opacity(0.15), lineWidth: 1)
                        .frame(width: 70, height: 46)

                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .stroke(Color.black.opacity(0.75), lineWidth: 2)
                        .frame(
                            width: option == .gallery ? 54 : 40,
                            height: option == .gallery ? 32 : 22
                        )
                }

                Text(option.title)
                    .font(.system(size: 13, weight: .semibold, design: .rounded))
                    .foregroundStyle(.primary)

                Text(option.detail)
                    .font(.system(size: 11, weight: .medium, design: .rounded))
                    .foregroundStyle(.secondary)
            }
            .padding(14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(Color.white.opacity(isSelected ? 0.18 : 0.08))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .strokeBorder(isSelected ? Color.black.opacity(0.85) : Color.black.opacity(0.08), lineWidth: isSelected ? 2 : 1)
            )
        }
        .buttonStyle(.plain)
    }
}

private struct LumeChip: View {
    let lume: ClockLumeColor
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Circle()
                    .fill(lume.color)
                    .frame(width: 24, height: 24)
                    .overlay(
                        Circle()
                            .strokeBorder(Color.white.opacity(0.35), lineWidth: 1)
                    )
                    .shadow(color: lume.color.opacity(0.45), radius: 10, x: 0, y: 0)

                Text(lume.title)
                    .font(.system(size: 10, weight: .semibold, design: .rounded))
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
            .padding(.vertical, 10)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Color.white.opacity(isSelected ? 0.18 : 0.08))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .strokeBorder(isSelected ? Color.black.opacity(0.85) : Color.black.opacity(0.08), lineWidth: isSelected ? 2 : 1)
            )
        }
        .buttonStyle(.plain)
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
                    .fill(Color.white.opacity(0.38))
            )
    }
}
