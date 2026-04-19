import SwiftUI

public struct GroupoolAvatar: View {
    @Environment(\.groupoolTheme) private var theme

    private let name: String
    private let size: CGFloat
    private let status: GroupoolStatusDotKind?

    public init(name: String, size: CGFloat = 40, status: GroupoolStatusDotKind? = nil) {
        self.name = name
        self.size = size
        self.status = status
    }

    public var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Circle()
                .fill(
                    LinearGradient(
                        colors: palette,
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: size, height: size)
                .overlay(
                    Text(initials)
                        .font(GroupoolTypography.font(.bodyStrong, theme: theme))
                        .foregroundStyle(.white)
                )
            if let status {
                GroupoolStatusDot(status)
                    .offset(x: 2, y: 2)
            }
        }
        .frame(width: size, height: size)
    }

    private var initials: String {
        name
            .split(separator: " ")
            .prefix(2)
            .compactMap { $0.first }
            .map(String.init)
            .joined()
            .uppercased()
    }

    private var palette: [Color] {
        let palettes: [[Color]] = [
            [.groupoolWood, .groupoolWoodDark],
            [.groupoolPoolBlue, .groupoolPoolBlueDeep],
            [.groupoolPoolCoral, .groupoolPoolCoralDeep],
            [.groupoolPoolViolet, .groupoolPoolVioletDeep],
            [.groupoolGood, Color(hex: "#237549")],
            [Color(hex: "#D4A53B"), Color(hex: "#AD8220")],
            [.groupoolPoolTeal, .groupoolPoolTealDeep],
            [Color(hex: "#C44D89"), Color(hex: "#9A3868")]
        ]
        let first = Int(name.unicodeScalars.first?.value ?? 0)
        return palettes[first % palettes.count]
    }
}
