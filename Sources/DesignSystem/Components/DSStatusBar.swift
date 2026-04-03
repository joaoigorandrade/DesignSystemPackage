import SwiftUI

public struct DSStatusDistributionSegment: Identifiable, Equatable {
    public let id: String
    public let value: Double
    public let color: Color

    public init(id: String, value: Double, color: Color) {
        self.id = id
        self.value = value
        self.color = color
    }
}

public struct DSStatusContinuousStyle {
    public let foregroundColor: Color
    public let backgroundColor: Color

    public init(foregroundColor: Color, backgroundColor: Color) {
        self.foregroundColor = foregroundColor
        self.backgroundColor = backgroundColor
    }

    public static var positive: DSStatusContinuousStyle {
        DSStatusContinuousStyle(
            foregroundColor: .success,
            backgroundColor: .success.opacity(0.15)
        )
    }

    public static var warning: DSStatusContinuousStyle {
        DSStatusContinuousStyle(
            foregroundColor: .warning,
            backgroundColor: .warning.opacity(0.15)
        )
    }

    public static var neutral: DSStatusContinuousStyle {
        DSStatusContinuousStyle(
            foregroundColor: .coolGrey,
            backgroundColor: .coolGrey.opacity(0.15)
        )
    }
}

public struct DSStatusBar: View {
    public let segments: [DSStatusDistributionSegment]
    public let barHeight: CGFloat
    public let barBackgroundColor: Color

    @State private var appeared = false

    private var normalizedSegments: [NormalizedSegment] {
        let positiveValues = segments.map { max($0.value, 0) }
        let total = positiveValues.reduce(0, +)

        if total <= 0, !positiveValues.isEmpty {
            let fallback = 1.0 / Double(positiveValues.count)
            return zip(segments, positiveValues).map { segment, _ in
                NormalizedSegment(id: segment.id, color: segment.color, ratio: fallback)
            }
        }

        return zip(segments, positiveValues).map { segment, value in
            NormalizedSegment(id: segment.id, color: segment.color, ratio: total > 0 ? value / total : 0)
        }
    }

    private var visibleRatio: Double { appeared ? 1.0 : 0.0 }

    public init(
        segments: [DSStatusDistributionSegment],
        barHeight: CGFloat = DSSpacing.space8,
        barBackgroundColor: Color = .coolGrey.opacity(0.2)
    ) {
        self.segments = segments
        self.barHeight = barHeight
        self.barBackgroundColor = barBackgroundColor
    }

    public var body: some View {
        distributionTrack
            .onAppear {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.82)) {
                    appeared = true
                }
            }
    }

    private var distributionTrack: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                ForEach(normalizedSegments) { segment in
                    Rectangle()
                        .fill(segment.color.opacity(0.6))
                        .frame(width: geometry.size.width * segment.ratio * visibleRatio)
                }
            }
            .background(trackBackground)
            .animation(.easeInOut(duration: 0.35), value: normalizedSegments.map(\.ratio))
        }
        .frame(height: barHeight)
        .clipShape(RoundedRectangle(cornerRadius: DSRadius.small, style: .continuous))
    }

    private var trackBackground: some View {
        RoundedRectangle(cornerRadius: DSRadius.small, style: .continuous)
            .fill(barBackgroundColor)
    }

}

private struct NormalizedSegment: Identifiable, Equatable {
    let id: String
    let color: Color
    let ratio: Double
}

#Preview {
    VStack(spacing: DSSpacing.space16) {
        DSStatusBar(
            segments: [
                DSStatusDistributionSegment(id: "available", value: 0.52, color: .brandPrimary),
                DSStatusDistributionSegment(id: "frozen", value: 0.28, color: .coolGrey),
                DSStatusDistributionSegment(id: "debt", value: 0.20, color: .danger)
            ],
        )

        DSStatusBar(
            segments: [
                DSStatusDistributionSegment(id: "stocks", value: 0, color: .success),
                DSStatusDistributionSegment(id: "bonds", value: 0, color: .info),
                DSStatusDistributionSegment(id: "cash", value: 0, color: .warning)
            ],
        )
    }
    .padding()
    .background(Color.backgroundTop)
}
