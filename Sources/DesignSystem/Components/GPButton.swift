import SwiftUI

public typealias GPButtonVariant = GroupoolButtonStyle.Variant
public typealias GPButtonSize = GroupoolButtonStyle.Size

public extension ButtonStyle where Self == GroupoolButtonStyle {
    static func gp(
        _ variant: GPButtonVariant = .primary,
        size: GPButtonSize = .regular,
        fullWidth: Bool = false
    ) -> GroupoolButtonStyle {
        GroupoolButtonStyle(variant: variant, size: size, fullWidth: fullWidth)
    }
}

#Preview("Button Variants") {
    VStack(spacing: 12) {
        ForEach([GPButtonVariant.primary, .pool, .ghost, .subtle], id: \.self) { variant in
            Button(variant.previewLabel) {}
                .buttonStyle(.gp(variant, fullWidth: true))
        }
        Divider()
        HStack(spacing: 12) {
            Button("Small") {}
                .buttonStyle(.gp(.pool, size: .small))
            Button("Small Ghost") {}
                .buttonStyle(.gp(.ghost, size: .small))
        }
    }
    .padding()
}

private extension GPButtonVariant {
    var previewLabel: String {
        switch self {
        case .primary: "Primary"
        case .pool: "Pool"
        case .ghost: "Ghost"
        case .subtle: "Subtle"
        }
    }
}
