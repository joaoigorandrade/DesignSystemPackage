import SwiftUI

public struct GroupoolTopBar: View {
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
        HStack {
            circularButton("chevron-left", action: onBack)
            Spacer()
            if let step, let total {
                HStack(spacing: 4) {
                    ForEach(0..<total, id: \.self) { index in
                        Capsule()
                            .fill(index < step ? theme.pool : theme.lineSecondary)
                            .frame(width: index == step - 1 ? 20 : 6, height: 6)
                    }
                }
            }
            Spacer()
            Color.clear.frame(width: 40, height: 40)
        }
    }

    private func circularButton(_ icon: String, action: (() -> Void)?) -> some View {
        Button(action: { action?() }) {
            GroupoolIcon(icon, size: 20, color: theme.ink)
                .frame(width: 40, height: 40)
                .background(theme.surface)
                .overlay(Circle().stroke(theme.line, lineWidth: 1))
        }
        .buttonStyle(.plain)
        .opacity(action == nil ? 0 : 1)
        .disabled(action == nil)
    }
}

public struct GroupoolFloatingActionButton<Label: View>: View {
    @Environment(\.groupoolTheme) private var theme

    private let action: () -> Void
    private let label: Label

    public init(action: @escaping () -> Void, @ViewBuilder label: () -> Label) {
        self.action = action
        self.label = label()
    }

    public var body: some View {
        Button(action: action) {
            label
                .foregroundStyle(.white)
                .frame(width: 60, height: 60)
                .background(theme.pool)
                .clipShape(Circle())
                .shadow(color: theme.pool.opacity(0.35), radius: 12, y: 8)
        }
        .buttonStyle(.plain)
    }
}

public struct GroupoolTabItem: Identifiable, Hashable, Sendable {
    public let id: String
    public let title: String
    public let icon: String

    public init(id: String, title: String, icon: String) {
        self.id = id
        self.title = title
        self.icon = icon
    }
}

public struct GroupoolTabBar: View {
    @Environment(\.groupoolTheme) private var theme

    private let items: [GroupoolTabItem]
    private let activeID: String
    private let action: (GroupoolTabItem) -> Void

    public init(items: [GroupoolTabItem], activeID: String, action: @escaping (GroupoolTabItem) -> Void) {
        self.items = items
        self.activeID = activeID
        self.action = action
    }

    public var body: some View {
        HStack {
            ForEach(items) { item in
                Button {
                    action(item)
                } label: {
                    VStack(spacing: 3) {
                        GroupoolIcon(item.icon, size: 20, color: item.id == activeID ? theme.pool : theme.inkTertiary)
                        Text(item.title)
                            .groupoolTextStyle(.label, color: item.id == activeID ? theme.pool : theme.inkTertiary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 6)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 12)
        .padding(.top, 10)
        .padding(.bottom, 26)
        .background(theme.surface)
        .overlay(alignment: .top) {
            Rectangle()
                .fill(theme.line)
                .frame(height: 1)
        }
    }
}
