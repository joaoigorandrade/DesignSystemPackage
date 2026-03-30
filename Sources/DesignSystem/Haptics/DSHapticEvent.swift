import Foundation

public enum DSHapticEvent: CaseIterable, Hashable, Sendable {
    case tapPrimary
    case tapSecondary
    case selection
    case success
    case error
    case warning
}
