import SwiftUI

public struct GPTopBarView: View {
    @Environment(\.groupoolTheme) private var theme

    private let onBack: (() -> Void)?
    private let step: Int?
    private let total: Int?

    public init(onBack: (() -> Void)? = nil, step: Int? = nil, total: Int? = nil) {
        self.onBack = onBack
        self.step = step
        self.total = total
    }

    public var body: some View {
        GroupoolTopBar(onBack: onBack, step: step, total: total)
    }
}

#Preview("Top Bar") {
    VStack(spacing: 20) {
        GPTopBarView(onBack: {})
        GPTopBarView(onBack: {}, step: 1, total: 4)
        GPTopBarView(onBack: {}, step: 2, total: 4)
        GPTopBarView(onBack: {}, step: 4, total: 4)
    }
    .padding()
}
