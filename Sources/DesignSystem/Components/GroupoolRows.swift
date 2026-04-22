import SwiftUI

public enum GroupoolActivityAmountKind: Sendable {
    case neutral
    case frozen
    case credit
}

public struct GroupoolActivityRow: View {
    @Environment(\.groupoolTheme) private var theme

    private let icon: String
    private let title: String
    private let subtitle: String
    private let amount: String
    private let kind: GroupoolActivityAmountKind
    private let showsDivider: Bool

    public init(
        icon: String,
        title: String,
        subtitle: String,
        amount: String,
        kind: GroupoolActivityAmountKind = .neutral,
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
        GroupoolListRow(showsDivider: showsDivider) {
            RoundedRectangle(cornerRadius: GroupoolRadius.small(for: theme), style: .continuous)
                .fill(theme.background)
                .frame(width: 36, height: 36)
                .overlay {
                    GroupoolIcon(icon, size: 18, color: theme.inkSecondary)
                }
        } content: {
            VStack(alignment: .leading, spacing: 1) {
                Text(title)
                    .groupoolTextStyle(.bodyStrong)
                    .lineLimit(1)
                Text(subtitle)
                    .groupoolTextStyle(.caption, color: theme.inkTertiary)
            }
        } trailing: {
            Text(amount)
                .groupoolTextStyle(.bodyStrong, color: amountColor)
        }
    }

    private var amountColor: Color {
        switch kind {
        case .neutral: theme.ink
        case .frozen: theme.poolDeep
        case .credit: theme.good
        }
    }
}

public struct GroupoolMemberChip: View {
    @Environment(\.groupoolTheme) private var theme

    private let name: String
    private let subtitle: String
    private let selected: Bool
    private let action: () -> Void

    public init(name: String, subtitle: String, selected: Bool = false, action: @escaping () -> Void = {}) {
        self.name = name
        self.subtitle = subtitle
        self.selected = selected
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                GroupoolAvatar(name: name, size: 40)
                VStack(alignment: .leading, spacing: 2) {
                    Text(name)
                        .groupoolTextStyle(.bodyStrong)
                    Text(subtitle)
                        .groupoolTextStyle(.caption, color: theme.inkTertiary)
                }
                Spacer()
                ZStack {
                    Circle()
                        .stroke(selected ? theme.pool : theme.lineSecondary, lineWidth: 2)
                        .frame(width: 22, height: 22)
                    if selected {
                        Circle()
                            .fill(theme.pool)
                            .frame(width: 22, height: 22)
                        GroupoolIcon("checkmark", size: 14, color: .white)
                    }
                }
            }
            .padding(12)
            .background(selected ? theme.poolSoft : theme.surface)
            .overlay(
                RoundedRectangle(cornerRadius: GroupoolRadius.medium(for: theme), style: .continuous)
                    .stroke(selected ? theme.pool : theme.line, lineWidth: 1.5)
            )
            .clipShape(RoundedRectangle(cornerRadius: GroupoolRadius.medium(for: theme), style: .continuous))
        }
        .buttonStyle(.plain)
    }
}

public struct GroupoolOutcomeRow: View {
    @Environment(\.groupoolTheme) private var theme

    private let letter: String
    private let title: String
    private let subtitle: String
    private let color: Color
    private let locked: Bool

    public init(letter: String, title: String, subtitle: String, color: Color, locked: Bool = false) {
        self.letter = letter
        self.title = title
        self.subtitle = subtitle
        self.color = color
        self.locked = locked
    }

    public var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(color)
                .frame(width: 36, height: 36)
                .overlay {
                    Text(letter)
                        .groupoolTextStyle(.title, color: .white)
                }
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .groupoolTextStyle(.bodyStrong)
                Text(subtitle)
                    .groupoolTextStyle(.caption, color: theme.inkTertiary)
            }
            Spacer()
            if locked {
                GroupoolIcon("shield", size: 16, color: theme.inkTertiary)
            }
        }
        .padding(14)
        .background(theme.surface)
        .overlay(
            RoundedRectangle(cornerRadius: GroupoolRadius.medium(for: theme), style: .continuous)
                .stroke(theme.line, lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: GroupoolRadius.medium(for: theme), style: .continuous))
    }
}

public struct GroupoolProofThumbnail: View {
    @Environment(\.groupoolTheme) private var theme

    private let label: String
    private let subtitle: String

    public init(label: String, subtitle: String) {
        self.label = label
        self.subtitle = subtitle
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            ZStack {
                RoundedRectangle(cornerRadius: GroupoolRadius.medium(for: theme), style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [theme.line, theme.background, theme.line, theme.background],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                Text("[proof]")
                    .groupoolTextStyle(.mono, color: theme.inkTertiary)
            }
            .frame(width: 140, height: 100)
            Text(label)
                .groupoolTextStyle(.mono, color: theme.inkSecondary)
            Text(subtitle)
                .groupoolTextStyle(.label, color: theme.inkTertiary)
        }
    }
}
