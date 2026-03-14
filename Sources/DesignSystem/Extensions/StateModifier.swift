import SwiftUI

public struct DSStateModifier: ViewModifier {
    public let state: ViewState
    
    public init(state: ViewState) {
        self.state = state
    }
    
    public func body(content: Content) -> some View {
        ZStack {
            content
                .disabled(state == .loading)
                .opacity(state == .loading ? 0.7 : 1.0)
            
            if state == .loading {
                ProgressView()
                    .scaleEffect(1.5)
            }
        }
        .overlay(
            Group {
                if case .error(let message) = state {
                    VStack {
                        Spacer()
                        HStack(spacing: 12) {
                            BrandIcon.error.view()
                                .foregroundColor(.danger)
                            Text(message)
                                .dsBody()
                                .foregroundColor(.primary)
                            Spacer(minLength: 0)
                        }
                        .padding(16)
                        .glassEffect(cornerRadius: 16)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .stroke(Color.danger.opacity(0.5), lineWidth: 1)
                        )
                        .shadow(color: Color.danger.opacity(0.15), radius: 10, x: 0, y: 5)
                        .padding()
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                }
            }
        )
        .animation(.spring(response: 0.4, dampingFraction: 0.7), value: state)
    }
}

public extension View {
    func dsState(_ state: ViewState) -> some View {
        self.modifier(DSStateModifier(state: state))
    }
}
