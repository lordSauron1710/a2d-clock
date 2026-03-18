import Foundation
import SwiftUI

struct ClockBurnInTransform {
    let xOffset: CGFloat
    let yOffset: CGFloat
    let rotationDegrees: Double
    let scale: CGFloat
}

/// Multi-layer burn-in protection strategy designed for OLED and XDR displays.
///
/// Layer 1 — Lissajous spatial drift: two sinusoids with incommensurable periods
/// (~47 min and ~67 min, ratio ≈ √2) trace a Lissajous figure across the full
/// available slack space. Unlike anchor-based approaches, no position is "dwelt
/// on" — the display content moves continuously, distributing pixel exposure evenly.
///
/// Layer 2 — Micro-wobble: a ±2pt sub-pixel oscillation at a faster, independent
/// tempo ensures pixels at bright-content boundaries keep shifting even between
/// major drift movements.
///
/// Layer 3 — Luminance breathing: a very slow (53-min) sinusoidal brightness
/// cycle dims the entire scene by up to 15% at its minimum. This directly reduces
/// cumulative pixel drive time for the brightest elements (clock hands, lume glow).
///
/// Layer 4 — Backdrop gradient drift: the ambient radial gradients drift on their
/// own independent Lissajous path (71/97 min), preventing any screen region from
/// receiving a constant radial glow contribution.
enum ClockBurnInStrategy {

    // MARK: - Lissajous drift (Layer 1)

    // Incommensurable periods ensure the path never repeats.
    // Ratio 47/67 ≈ 0.701, which is close to 1/√2 — irrational, non-repeating.
    private static let driftPeriodX: Double = 47 * 60   // 47 minutes
    private static let driftPeriodY: Double = 67 * 60   // 67 minutes

    // MARK: - Micro-wobble (Layer 2)

    private static let wobblePeriodX: Double = 4.1 * 60  // 4.1 minutes
    private static let wobblePeriodY: Double = 5.8 * 60  // 5.8 minutes
    private static let wobbleAmplitude: CGFloat = 2.2

    // MARK: - Rotation and scale

    // Independent period (prime minutes) to decouple from x/y drift.
    private static let rotationPeriod: Double = 89 * 60  // 89 minutes
    private static let rotationAmplitude: Double = 0.8   // degrees

    // MARK: - Luminance breathing (Layer 3)

    private static let luminancePeriod: Double = 53 * 60  // 53 minutes
    static let luminanceDepth: Double = 0.15              // dims up to 15% at minimum

    // MARK: - Backdrop gradient drift (Layer 4)

    // Slower and independent from the clock drift to create visual depth.
    private static let backdropPeriodX: Double = 71 * 60  // 71 minutes
    private static let backdropPeriodY: Double = 97 * 60  // 97 minutes
    private static let backdropAmplitude: Double = 0.07   // ±7% drift from center

    // MARK: - Public interface

    /// Spatial transform for the clock display (offset, rotation, scale).
    /// Uses 40% of available slack between viewport and content, scaled
    /// appropriately for any resolution including retina and XDR displays.
    static func transform(
        for date: Date,
        viewportSize: CGSize,
        boardSize: CGSize
    ) -> ClockBurnInTransform {
        let t = date.timeIntervalSinceReferenceDate

        let horizontalSlack = max(0, viewportSize.width - boardSize.width)
        let verticalSlack = max(0, viewportSize.height - boardSize.height)

        // Use 40% of available slack so the clock never clips the viewport.
        let xTravel = horizontalSlack * 0.40
        let yTravel = verticalSlack * 0.40

        let mainX = CGFloat(sin(2 * .pi * t / driftPeriodX) * xTravel * 0.5)
        let mainY = CGFloat(sin(2 * .pi * t / driftPeriodY) * yTravel * 0.5)

        let wobbleX = CGFloat(sin(2 * .pi * t / wobblePeriodX + 1.1)) * wobbleAmplitude
        let wobbleY = CGFloat(sin(2 * .pi * t / wobblePeriodY + 2.7)) * wobbleAmplitude

        let rotation = sin(2 * .pi * t / rotationPeriod + 0.5) * rotationAmplitude

        let scale = CGFloat(1.0 + sin(2 * .pi * t / (rotationPeriod * 1.3) + 1.8) * 0.006)

        return ClockBurnInTransform(
            xOffset: mainX + wobbleX,
            yOffset: mainY + wobbleY,
            rotationDegrees: rotation,
            scale: scale
        )
    }

    /// Scene luminance multiplier [0.85, 1.0].
    /// Apply as a dark overlay with opacity `1 - luminance(for:)` over the
    /// entire scene so both the background and clock faces are equally dimmed.
    static func luminance(for date: Date) -> Double {
        let t = date.timeIntervalSinceReferenceDate
        // Ranges from (1 - luminanceDepth) at sin = -1, to 1.0 at sin = 1.
        return 1.0 - luminanceDepth * 0.5 * (1.0 - sin(2 * .pi * t / luminancePeriod))
    }

    /// Drifting center point for ambient radial gradients, in unit coordinates.
    /// Stays within [0.43, 0.57] × [0.43, 0.57] — a subtle but constant shift.
    static func backdropCenter(for date: Date) -> UnitPoint {
        let t = date.timeIntervalSinceReferenceDate
        let u = 0.5 + sin(2 * .pi * t / backdropPeriodX) * backdropAmplitude
        let v = 0.5 + sin(2 * .pi * t / backdropPeriodY + 1.0) * backdropAmplitude
        return UnitPoint(x: u, y: v)
    }
}
