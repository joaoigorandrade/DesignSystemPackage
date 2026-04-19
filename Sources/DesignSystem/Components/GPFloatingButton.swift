import SwiftUI

public struct GPFloatingButton: View {
    @Environment(\.groupoolTheme) private var theme

    private let icon: GPIconName
    private let action: () -> Void

    public init(icon: GPIconName = .plus, action: @escaping () -> Void) {
        self.icon = icon
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            GPIcon(icon, size: 22, color: .white)
                .frame(width: 60, height: 60)
                .background(theme.pool)
                .clipShape(Circle())
                .shadow(color: theme.pool.opacity(0.35), radius: 12, y: 8)
        }
        .buttonStyle(.plain)
    }
}

#Preview("FAB") {
    ZStack(alignment: .bottomTrailing) {
        Color.gray.opacity(0.1).ignoresSafeArea()
        GPFloatingButton {}
            .padding()
    }
}
