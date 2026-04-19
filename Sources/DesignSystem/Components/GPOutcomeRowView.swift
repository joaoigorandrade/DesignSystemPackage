import SwiftUI

public struct GPOutcomeRowView: View {
    private let letter: String
    private let title: String
    private let subtitle: String
    private let outcomeColor: GPOutcomeColor
    private let locked: Bool

    public init(
        letter: String,
        title: String,
        subtitle: String,
        color: GPOutcomeColor,
        locked: Bool = false
    ) {
        self.letter = letter
        self.title = title
        self.subtitle = subtitle
        self.outcomeColor = color
        self.locked = locked
    }

    public var body: some View {
        OutcomeRowBody(
            letter: letter,
            title: title,
            subtitle: subtitle,
            outcomeColor: outcomeColor,
            locked: locked
        )
    }
}

private struct OutcomeRowBody: View {
    @Environment(\.groupoolTheme) private var theme
    let letter: String
    let title: String
    let subtitle: String
    let outcomeColor: GPOutcomeColor
    let locked: Bool

    var body: some View {
        GroupoolOutcomeRow(
            letter: letter,
            title: title,
            subtitle: subtitle,
            color: outcomeColor.color(theme: theme),
            locked: locked
        )
    }
}

#Preview("Outcome Rows") {
    VStack(spacing: 8) {
        GPOutcomeRowView(letter: "A", title: "João vence", subtitle: "Ele chega primeiro", color: .good)
        GPOutcomeRowView(letter: "B", title: "Ana vence", subtitle: "Ela chega primeiro", color: .bad)
        GPOutcomeRowView(letter: "C", title: "Empate", subtitle: "Nenhum vence", color: .neutral, locked: true)
    }
    .padding()
}
