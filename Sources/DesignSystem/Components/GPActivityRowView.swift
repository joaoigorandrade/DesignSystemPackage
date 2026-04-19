import SwiftUI

public struct GPActivityRowView: View {
    private let icon: GPIconName
    private let title: String
    private let subtitle: String
    private let amount: String
    private let kind: GPTransactionKind
    private let showsDivider: Bool

    public init(
        icon: GPIconName,
        title: String,
        subtitle: String,
        amount: String,
        kind: GPTransactionKind = .neutral,
        showsDivider: Bool = true
    ) {
        self.icon = icon
        self.title = title
        self.subtitle = subtitle
        self.amount = amount
        self.kind = kind
        self.showsDivider = showsDivider
    }

    public var body: some View {
        GroupoolActivityRow(
            icon: icon.symbolName,
            title: title,
            subtitle: subtitle,
            amount: amount,
            kind: kind.amountKind,
            showsDivider: showsDivider
        )
    }
}

private extension GPTransactionKind {
    var amountKind: GroupoolActivityAmountKind {
        switch self {
        case .neutral: .neutral
        case .frozen: .frozen
        case .credit: .credit
        }
    }
}

#Preview("Activity Rows") {
    VStack(spacing: 0) {
        GPActivityRowView(icon: .send, title: "Transferência enviada", subtitle: "Para Ana Silva", amount: "- R$ 50,00")
        GPActivityRowView(icon: .dollar, title: "Depósito recebido", subtitle: "De Bruno Costa", amount: "+ R$ 100,00", kind: .credit)
        GPActivityRowView(icon: .clock, title: "Aguardando votação", subtitle: "Desafio expirado", amount: "R$ 200,00", kind: .frozen, showsDivider: false)
    }
    .clipShape(RoundedRectangle(cornerRadius: 18))
    .padding()
}
