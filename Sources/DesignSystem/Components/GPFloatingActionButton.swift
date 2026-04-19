import SwiftUI

public struct GPFABOption: Identifiable, Sendable {
    public let id: String
    public let icon: GPIconName
    public let title: String
    public let subtitle: String
    public let isDisabled: Bool

    public init(id: String = UUID().uuidString, icon: GPIconName, title: String, subtitle: String, isDisabled: Bool = false) {
        self.id = id
        self.icon = icon
        self.title = title
        self.subtitle = subtitle
        self.isDisabled = isDisabled
    }
}

public struct GPFABOptionView: View {
    @Environment(\.groupoolTheme) private var theme
    private let option: GPFABOption
    private let action: () -> Void

    public init(option: GPFABOption, action: @escaping () -> Void) {
        self.option = option
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                RoundedRectangle(cornerRadius: GPRadii.small, style: .continuous)
                    .fill(theme.poolSoft)
                    .frame(width: 44, height: 44)
                    .overlay {
                        GPIcon(option.icon, size: 20, color: theme.pool)
                    }
                VStack(alignment: .leading, spacing: 2) {
                    Text(option.title)
                        .groupoolTextStyle(.bodyStrong)
                    Text(option.subtitle)
                        .groupoolTextStyle(.caption, color: theme.inkTertiary)
                }
                Spacer()
                GPIcon(.chevronRight, size: 16, color: theme.inkTertiary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        .buttonStyle(.plain)
        .opacity(option.isDisabled ? 0.45 : 1)
        .disabled(option.isDisabled)
    }
}

public struct GPFloatingActionButton: View {
    @Environment(\.groupoolTheme) private var theme

    private let options: [GPFABOption]
    private let onSelect: (GPFABOption) -> Void

    @State private var isOpen = false

    public init(options: [GPFABOption], onSelect: @escaping (GPFABOption) -> Void) {
        self.options = options
        self.onSelect = onSelect
    }

    public var body: some View {
        ZStack(alignment: .bottomTrailing) {
            if isOpen {
                Color.black.opacity(0.25)
                    .ignoresSafeArea()
                    .onTapGesture { withAnimation(.spring(response: 0.3)) { isOpen = false } }
                    .transition(.opacity)
            }

            VStack(alignment: .trailing, spacing: 0) {
                if isOpen {
                    VStack(spacing: 0) {
                        ForEach(options) { option in
                            GPFABOptionView(option: option) {
                                withAnimation(.spring(response: 0.3)) { isOpen = false }
                                onSelect(option)
                            }
                            if option.id != options.last?.id {
                                Divider()
                                    .padding(.leading, 74)
                            }
                        }
                    }
                    .background(theme.surface)
                    .clipShape(RoundedRectangle(cornerRadius: GPRadii.large, style: .continuous))
                    .shadow(color: .black.opacity(0.12), radius: 16, y: 8)
                    .padding(.bottom, 16)
                    .padding(.trailing, 0)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }

                Button {
                    withAnimation(.spring(response: 0.3)) { isOpen.toggle() }
                } label: {
                    Image(systemName: isOpen ? "xmark" : "plus")
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundStyle(.white)
                        .rotationEffect(.degrees(isOpen ? 45 : 0))
                        .frame(width: 60, height: 60)
                        .background(theme.pool)
                        .clipShape(Circle())
                        .shadow(color: theme.pool.opacity(0.35), radius: 12, y: 8)
                }
                .buttonStyle(.plain)
            }
        }
    }
}

#Preview("FAB") {
    ZStack(alignment: .bottomTrailing) {
        Color.gray.opacity(0.1).ignoresSafeArea()
        GPFloatingActionButton(
            options: [
                GPFABOption(icon: .swords, title: "Novo Desafio", subtitle: "Aposte com alguém"),
                GPFABOption(icon: .send, title: "Transferir", subtitle: "Envie para membros"),
                GPFABOption(icon: .dollar, title: "Depositar", subtitle: "Adicione saldo ao pool"),
                GPFABOption(icon: .bell, title: "Notificações", subtitle: "Ver pendências", isDisabled: true),
            ]
        ) { _ in }
        .padding()
    }
}
