import SwiftUI

public struct FABActionItem: Identifiable, Equatable {
    public let id: String
    public let title: String
    public let icon: BrandIcon
    public let viewState: ViewState
    public let action: () -> Void

    private init(
        id: String,
        title: String,
        icon: BrandIcon,
        viewState: ViewState,
        action: @escaping () -> Void
    ) {
        self.id = id
        self.title = title
        self.icon = icon
        self.viewState = viewState
        self.action = action
    }

    public static func challenge(
        state: ViewState = .idle,
        action: @escaping () -> Void
    ) -> FABActionItem {
        FABActionItem(
            id: "challenge",
            title: "Challenge",
            icon: .challenge,
            viewState: state,
            action: action
        )
    }

    public static func expense(
        state: ViewState = .idle,
        action: @escaping () -> Void
    ) -> FABActionItem {
        FABActionItem(
            id: "expense",
            title: "Expense",
            icon: .expense,
            viewState: state,
            action: action
        )
    }

    public static func withdrawal(
        state: ViewState = .idle,
        action: @escaping () -> Void
    ) -> FABActionItem {
        FABActionItem(
            id: "withdrawal",
            title: "Withdrawal",
            icon: .withdrawal,
            viewState: state,
            action: action
        )
    }

    var isEnabled: Bool {
        switch viewState {
        case .idle, .success:
            return true
        case .loading, .error:
            return false
        }
    }

    var tooltip: String? {
        if case .error(let message) = viewState {
            return message
        }

        return nil
    }

    public static func == (lhs: FABActionItem, rhs: FABActionItem) -> Bool {
        lhs.id == rhs.id &&
        lhs.title == rhs.title &&
        lhs.icon == rhs.icon &&
        lhs.viewState == rhs.viewState
    }
}

public struct FABView: View {
    @Binding public var isExpanded: Bool

    public let actionItems: [FABActionItem]

    @State private var selectedTooltipID: String?
    @State private var tooltipTask: Task<Void, Never>?

    public init(
        isExpanded: Binding<Bool>,
        actionItems: [FABActionItem]
    ) {
        self._isExpanded = isExpanded
        self.actionItems = actionItems
    }

    public var body: some View {
        ZStack(alignment: .bottomTrailing) {
            if isExpanded {
                backdrop
            }

            fabStack
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
        .animation(.spring(response: 0.35, dampingFraction: 0.75), value: isExpanded)
        .onDisappear {
            tooltipTask?.cancel()
        }
    }

    private var backdrop: some View {
        Color.black.opacity(0.2)
            .ignoresSafeArea()
            .contentShape(Rectangle())
            .onTapGesture {
                collapse()
            }
            .gesture(
                DragGesture(minimumDistance: 20)
                    .onEnded { value in
                        if value.translation.height > 24 {
                            collapse()
                        }
                    }
            )
            .transition(.opacity)
    }

    private var fabStack: some View {
        VStack(alignment: .trailing, spacing: 12) {
            if isExpanded {
                expandedMenu
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }

            triggerButton
        }
        .padding(.trailing, 20)
        .padding(.bottom, 24)
    }

    private var expandedMenu: some View {
        VStack(alignment: .trailing, spacing: 10) {
            ForEach(actionItems) { item in
                FABActionRow(
                    item: item,
                    isTooltipVisible: selectedTooltipID == item.id,
                    onTap: { handleTap(for: item) }
                )
                .equatable()
            }
        }
    }

    private var triggerButton: some View {
        Button {
            toggleExpanded()
        } label: {
            BrandIcon.plus.view(scale: .large)
                .foregroundColor(.white)
                .frame(width: 56, height: 56)
                .background(Color.brandPrimary)
                .clipShape(Circle())
                .shadow(color: .brandPrimary.opacity(0.35), radius: 10, x: 0, y: 6)
                .rotationEffect(.degrees(isExpanded ? 45 : 0))
        }
        .buttonStyle(.plain)
        .accessibilityLabel(isExpanded ? "Close actions" : "Open actions")
    }

    private func toggleExpanded() {
        selectedTooltipID = nil
        isExpanded.toggle()
    }

    private func collapse() {
        selectedTooltipID = nil
        isExpanded = false
    }

    private func handleTap(for item: FABActionItem) {
        if item.isEnabled {
            collapse()
            item.action()
            return
        }

        guard item.tooltip != nil else {
            return
        }

        selectedTooltipID = item.id
        tooltipTask?.cancel()
        tooltipTask = Task {
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            await MainActor.run {
                if selectedTooltipID == item.id {
                    selectedTooltipID = nil
                }
            }
        }
    }
}

private struct FABActionRow: View {
    let item: FABActionItem
    let isTooltipVisible: Bool
    let onTap: () -> Void

    var body: some View {
        rowContent
    }

    private var rowContent: some View {
        VStack(alignment: .trailing, spacing: 6) {
            Button {
                onTap()
            } label: {
                HStack(spacing: 10) {
                    iconContent

                    Text(item.title)
                        .dsBody()
                        .foregroundColor(textColor)
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 14)
                .background(backgroundColor)
                .clipShape(Capsule())
            }
            .buttonStyle(.plain)

            tooltipView
        }
    }

    @ViewBuilder
    private var iconContent: some View {
        if item.viewState == .loading {
            ProgressView()
                .tint(.coolGrey)
                .frame(width: 20, height: 20)
        } else {
            item.icon
                .view()
                .foregroundColor(iconColor)
                .frame(width: 20, height: 20)
        }
    }

    @ViewBuilder
    private var tooltipView: some View {
        if isTooltipVisible, let tooltip = item.tooltip {
            Text(tooltip)
                .font(.dsFootnote)
                .foregroundColor(.white)
                .padding(.vertical, 6)
                .padding(.horizontal, 10)
                .background(Color.black.opacity(0.85))
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                .transition(.opacity.combined(with: .move(edge: .trailing)))
        }
    }

    private var textColor: Color {
        item.isEnabled ? .brandPrimary : .coolGrey
    }

    private var iconColor: Color {
        item.isEnabled ? .brandPrimary : .coolGrey
    }

    private var backgroundColor: Color {
        item.isEnabled ? Color.white : Color.coolGrey.opacity(0.18)
    }
}

extension FABActionRow: @preconcurrency Equatable {
    static func == (lhs: FABActionRow, rhs: FABActionRow) -> Bool {
        lhs.item == rhs.item && lhs.isTooltipVisible == rhs.isTooltipVisible
    }
}
