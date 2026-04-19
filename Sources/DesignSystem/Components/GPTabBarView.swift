import SwiftUI

public enum GPTab: String, CaseIterable, Identifiable, Sendable {
    case home
    case activity
    case members
    case profile

    public var id: String { rawValue }

    public var title: String {
        switch self {
        case .home: "Home"
        case .activity: "Atividade"
        case .members: "Membros"
        case .profile: "Perfil"
        }
    }

    public var icon: GPIconName {
        switch self {
        case .home: .home
        case .activity: .activity
        case .members: .users
        case .profile: .profile
        }
    }
}

public struct GPTabBarView: View {
    @Environment(\.groupoolTheme) private var theme

    private let activeTab: GPTab
    private let action: (GPTab) -> Void

    public init(activeTab: GPTab, action: @escaping (GPTab) -> Void) {
        self.activeTab = activeTab
        self.action = action
    }

    public var body: some View {
        HStack {
            ForEach(GPTab.allCases) { tab in
                Button {
                    action(tab)
                } label: {
                    VStack(spacing: 3) {
                        GPIcon(tab.icon, size: 20, color: tab == activeTab ? theme.pool : theme.inkTertiary)
                        Text(tab.title)
                            .groupoolTextStyle(.label, color: tab == activeTab ? theme.pool : theme.inkTertiary)
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

#Preview("Tab Bar") {
    @Previewable @State var active = GPTab.home
    VStack {
        Spacer()
        GPTabBarView(activeTab: active) { active = $0 }
    }
}
