import SwiftUI

public struct GPWaterFillView: View {
    private let percent: Double
    private let label: String?
    private let height: CGFloat

    public init(percent: Double, label: String? = nil, height: CGFloat = 52) {
        self.percent = min(max(percent, 0), 100)
        self.label = label
        self.height = height
    }

    public var body: some View {
        GroupoolWaterFill(
            progress: percent / 100,
            label: label,
            height: height
        )
    }
}

#Preview("Water Fill Levels") {
    VStack(spacing: 16) {
        ForEach([0, 25, 50, 75, 100], id: \.self) { level in
            GPWaterFillView(percent: Double(level), label: "\(level)%", height: 52)
        }
    }
    .padding()
}
