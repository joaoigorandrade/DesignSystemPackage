import SwiftUI

public struct GPTrackBadgeView: View {
    @Environment(\.groupoolTheme) private var theme

    private let label: String
    private let variant: GPPillVariant
    private let icon: GPIconName?

    public init(_ label: String, variant: GPPillVariant = .neutral, icon: GPIconName? = nil) {
        self.label = label
        self.variant = variant
        self.icon = icon
    }

    public var body: some View {
        GPPillView(label, variant: variant)
    }
}

#Preview("Track Badges") {
    HStack(spacing: 8) {
        GPTrackBadgeView("Ativo", variant: .good)
        GPTrackBadgeView("Em votação", variant: .pool)
        GPTrackBadgeView("Expirado", variant: .warn)
        GPTrackBadgeView("Cancelado", variant: .bad)
    }
    .padding()
}
