import SwiftUI

public enum GPStatusBannerKind: CaseIterable, Sendable {
    case observer
    case inactive
    case debt
    case warning
    case success

    fileprivate var inner: GroupoolStatusBannerKind {
        switch self {
        case .observer: .observer
        case .inactive: .inactive
        case .debt: .debt
        case .warning: .warning
        case .success: .success
        }
    }
}

public struct GPStatusBannerView<Content: View>: View {
    private let kind: GPStatusBannerKind
    private let content: Content

    public init(_ kind: GPStatusBannerKind, @ViewBuilder content: () -> Content) {
        self.kind = kind
        self.content = content()
    }

    public var body: some View {
        GroupoolStatusBanner(kind.inner) { content }
    }
}

#Preview("Status Banners") {
    VStack(spacing: 12) {
        GPStatusBannerView(.observer) { Text("Você é observador neste pool.") }
        GPStatusBannerView(.inactive) { Text("Sua conta está inativa.") }
        GPStatusBannerView(.debt) { Text("Você tem uma dívida pendente de R$ 50,00.") }
        GPStatusBannerView(.warning) { Text("Sua retirada precisa de aprovação do grupo.") }
        GPStatusBannerView(.success) { Text("Seu depósito foi confirmado com sucesso.") }
    }
    .padding()
}
