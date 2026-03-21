import SwiftUI

public struct LoadOnceModifier: ViewModifier {
    let state: ViewState
    let action: () async -> Void

    public func body(content: Content) -> some View {
        content
            .task {
                guard state != .success else { return }
                await action()
            }
            .refreshable {
                await action()
            }
    }
}

public extension View {
    func loadOnce(state: ViewState, action: @escaping () async -> Void) -> some View {
        modifier(LoadOnceModifier(state: state, action: action))
    }
}
