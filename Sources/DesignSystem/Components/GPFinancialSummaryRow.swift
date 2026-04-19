import SwiftUI

public enum GPFinancialSummaryTone: CaseIterable, Sendable {
    case neutral
    case pool
    case good
    case warn
    case bad
}

public enum GPFinancialSummaryValueStyle: CaseIterable, Sendable {
    case body
    case mono
    case display
}

public struct GPFinancialSummaryItem: Equatable, Sendable {
    public let label: String
    public let value: String
    public let tone: GPFinancialSummaryTone

    public init(
        label: String,
        value: String,
        tone: GPFinancialSummaryTone = .neutral
    ) {
        self.label = label
        self.value = value
        self.tone = tone
    }
}

public struct GPFinancialSummaryRow: View {
    @Environment(\.groupoolTheme) private var theme

    private let items: [GPFinancialSummaryItem]
    private let valueStyle: GPFinancialSummaryValueStyle

    public init(
        items: [GPFinancialSummaryItem],
        valueStyle: GPFinancialSummaryValueStyle = .body
    ) {
        self.items = items
        self.valueStyle = valueStyle
    }

    public var body: some View {
        HStack(spacing: 0) {
            ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.label.uppercased())
                        .groupoolTextStyle(.caption, color: theme.inkSecondary)
                        .fontWeight(.bold)

                    valueView(for: item)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                if index < items.count - 1 {
                    Rectangle()
                        .fill(theme.lineSecondary)
                        .frame(width: 1)
                        .padding(.vertical, 2)
                        .padding(.horizontal, 12)
                }
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(theme.poolSoft)
        .clipShape(
            RoundedRectangle(
                cornerRadius: GroupoolRadius.medium(for: theme),
                style: .continuous
            )
        )
    }

    @ViewBuilder
    private func valueView(for item: GPFinancialSummaryItem) -> some View {
        switch valueStyle {
        case .body:
            Text(item.value)
                .groupoolTextStyle(.bodyStrong, color: color(for: item.tone))
        case .mono:
            Text(item.value)
                .groupoolTextStyle(.mono, color: color(for: item.tone))
        case .display:
            Text(item.value)
                .gpDisplay(size: 24, color: color(for: item.tone))
        }
    }

    private func color(for tone: GPFinancialSummaryTone) -> Color {
        switch tone {
        case .neutral: theme.ink
        case .pool: theme.poolDeep
        case .good: theme.good
        case .warn: theme.warning
        case .bad: theme.bad
        }
    }
}

#Preview("Financial Summary") {
    VStack(spacing: 16) {
        GPFinancialSummaryRow(
            items: [
                .init(label: "Frozen", value: "R$ 30,00", tone: .pool),
                .init(label: "Equity", value: "14%", tone: .neutral),
                .init(label: "Rep", value: "+4", tone: .good)
            ]
        )

        GPFinancialSummaryRow(
            items: [
                .init(label: "Requested", value: "R$ 100,00", tone: .neutral),
                .init(label: "Fee", value: "R$ 0,50", tone: .warn),
                .init(label: "Net", value: "R$ 99,50", tone: .good)
            ],
            valueStyle: .mono
        )
    }
    .padding()
}
