import SwiftUI

public struct DSCard<Content: View>: View {
    public let content: Content
    
    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    public var body: some View {
        content
            .padding(24)
            .glassEffect(cornerRadius: 32)
    }
}
