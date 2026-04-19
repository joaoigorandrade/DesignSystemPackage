import SwiftUI

public struct GPRowView: View {
    @Environment(\.groupoolTheme) private var theme

    private let title: String
    private let subtitle: String?
    private let icon: GPIconName?
    private let trailing: String?

    public init(title: String, subtitle: String? = nil, icon: GPIconName? = nil, trailing: String? = nil) {
        self.title = title
        self.subtitle = subtitle
        self.icon = icon
        self.trailing = trailing
    }

    public var body: some View {
        HStack(spacing: 12) {
            if let icon {
                GPIcon(icon, size: 18, color: theme.inkSecondary)
                    .frame(width: 32)
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .groupoolTextStyle(.bodyStrong)
                if let subtitle {
                    Text(subtitle)
                        .groupoolTextStyle(.caption, color: theme.inkTertiary)
                }
            }
            Spacer()
            if let trailing {
                Text(trailing)
                    .groupoolTextStyle(.body, color: theme.inkSecondary)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 13)
        .background(theme.surface)
    }
}

#Preview("Row Views") {
    VStack(spacing: 0) {
        GPRowView(title: "Prazo final", icon: .clock, trailing: "24h restantes")
        Divider().padding(.leading, 60)
        GPRowView(title: "Valor em jogo", subtitle: "Cada jogador paga", icon: .dollar, trailing: "R$ 50,00")
        Divider().padding(.leading, 60)
        GPRowView(title: "Árbitro", subtitle: "Decide em caso de empate", icon: .shield)
    }
    .clipShape(RoundedRectangle(cornerRadius: 18))
    .padding()
}
