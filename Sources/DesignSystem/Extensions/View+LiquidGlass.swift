import SwiftUI

public extension View {
    func glassEffect(cornerRadius: CGFloat = 24) -> some View {
        self
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                .white.opacity(0.5),
                                .white.opacity(0.1),
                                .clear,
                                .white.opacity(0.1),
                                .white.opacity(0.3)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1.5
                    )
            )
            .shadow(color: .black.opacity(0.15), radius: 20, x: 0, y: 10)
            .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}
