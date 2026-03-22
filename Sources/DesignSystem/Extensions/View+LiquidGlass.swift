import SwiftUI

public extension View {
    func glassEffect(cornerRadius: CGFloat = 24) -> some View {
        modifier(GlassEffectModifier(cornerRadius: cornerRadius))
    }
}

private struct GlassEffectModifier: ViewModifier {
    @Environment(\.colorScheme) private var colorScheme
    let cornerRadius: CGFloat

    private var highlightOpacity: Double { colorScheme == .dark ? 0.25 : 0.5 }
    private var edgeOpacity: Double { colorScheme == .dark ? 0.06 : 0.1 }
    private var shineOpacity: Double { colorScheme == .dark ? 0.15 : 0.3 }

    func body(content: Content) -> some View {
        content
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                .white.opacity(highlightOpacity),
                                .white.opacity(edgeOpacity),
                                .clear,
                                .white.opacity(edgeOpacity),
                                .white.opacity(shineOpacity)
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
