import SwiftUI

public enum GPMemberStatus: String, CaseIterable, Sendable {
    case good
    case observer
    case inactive
    case debt
    case restricted
}

public enum GPTransactionKind: String, CaseIterable, Sendable {
    case neutral
    case frozen
    case credit
}

public enum GPOutcomeColor: String, CaseIterable, Sendable {
    case pool
    case good
    case warn
    case bad
    case neutral

    public func color(theme: GroupoolTheme = .default) -> SwiftUI.Color {
        switch self {
        case .pool: theme.pool
        case .good: theme.good
        case .warn: theme.warning
        case .bad: theme.bad
        case .neutral: theme.inkTertiary
        }
    }
}
