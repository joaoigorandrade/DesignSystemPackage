import UIKit

public enum GPHapticEvent: Sendable {
    case success
    case error
    case selection
}

public final class GPHaptics: Sendable {
    public static let shared = GPHaptics()

    private init() {}

    public func play(_ event: GPHapticEvent) {
        switch event {
        case .success:
            UINotificationFeedbackGenerator().notificationOccurred(.success)
        case .error:
            UINotificationFeedbackGenerator().notificationOccurred(.error)
        case .selection:
            UISelectionFeedbackGenerator().selectionChanged()
        }
    }
}
