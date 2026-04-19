import SwiftUI

public enum GPPillVariant: Sendable {
    case good
    case warn
    case bad
    case pool
    case neutral

    fileprivate var inner: GroupoolPillVariant {
        switch self {
        case .good: .good
        case .warn: .warning
        case .bad: .bad
        case .pool: .pool
        case .neutral: .neutral
        }
    }
}

public struct GPPillView: View {
    private let text: String
    private let variant: GPPillVariant

    public init(_ text: String, variant: GPPillVariant = .neutral) {
        self.text = text
        self.variant = variant
    }

    public var body: some View {
        GroupoolPill(text, variant: variant.inner)
    }
}

#Preview("Pills") {
    HStack(spacing: 8) {
        GPPillView("Pago", variant: .good)
        GPPillView("Pendente", variant: .warn)
        GPPillView("Atrasado", variant: .bad)
        GPPillView("Pool", variant: .pool)
        GPPillView("Neutro", variant: .neutral)
    }
    .padding()
}
