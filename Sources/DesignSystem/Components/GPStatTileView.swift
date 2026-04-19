import SwiftUI

public struct GPStatTileView: View {
    @Environment(\.groupoolTheme) private var theme

    private let label: String
    private let value: String
    private let icon: GPIconName?
    private let variant: GPPillVariant?

    public init(label: String, value: String, icon: GPIconName? = nil, variant: GPPillVariant? = nil) {
        self.label = label
        self.value = value
        self.icon = icon
        self.variant = variant
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 4) {
                if let icon {
                    GPIcon(icon, size: 13, color: theme.inkTertiary)
                }
                Text(label.uppercased())
                    .groupoolTextStyle(.label, color: theme.inkTertiary)
            }
            Text(value)
                .groupoolTextStyle(.displayM)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(theme.surface)
        .overlay(
            RoundedRectangle(cornerRadius: GPRadii.large, style: .continuous)
                .stroke(theme.line, lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: GPRadii.large, style: .continuous))
    }
}

#Preview("Stat Tiles") {
    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
        GPStatTileView(label: "Saldo", value: "R$ 420", icon: .dollar)
        GPStatTileView(label: "Vitórias", value: "7", icon: .check, variant: .good)
        GPStatTileView(label: "Desafios", value: "12", icon: .swords)
        GPStatTileView(label: "Membros", value: "5", icon: .users)
    }
    .padding()
}
