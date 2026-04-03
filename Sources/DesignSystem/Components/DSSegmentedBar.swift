import SwiftUI

public struct DSSegmentedBarItem {
    public let id: String
    public let label: String
    public let value: String
    public let color: Color
    public let icon: BrandIcon?

    public init(
        id: String,
        label: String,
        value: String,
        color: Color,
        icon: BrandIcon? = nil
    ) {
        self.id = id
        self.label = label
        self.value = value
        self.color = color
        self.icon = icon
    }
}

public struct DSSegmentedBar: View {
    public let items: [DSSegmentedBarItem]
    public let selectedId: String?
    public let onSelect: ((String) -> Void)?
    public let isInteractive: Bool

    @State private var animatedSelectedId: String?

    public init(
        items: [DSSegmentedBarItem],
        selectedId: String? = nil,
        onSelect: ((String) -> Void)? = nil,
        isInteractive: Bool = true
    ) {
        self.items = items
        self.selectedId = selectedId
        self.onSelect = onSelect
        self.isInteractive = isInteractive
        _animatedSelectedId = State(initialValue: selectedId)
    }

    public var body: some View {
        VStack(spacing: DSSpacing.space12) {
            HStack(spacing: DSSpacing.space12) {
                ForEach(items, id: \.id) { item in
                    segmentButton(item)
                }
            }

            segmentedBarIndicator
        }
        .onChange(of: selectedId) { oldValue, newValue in
            withAnimation(.easeInOut(duration: 0.2)) {
                animatedSelectedId = newValue
            }
        }
    }

    @ViewBuilder
    private func segmentButton(_ item: DSSegmentedBarItem) -> some View {
        let isSelected = animatedSelectedId == item.id

        Button(action: {
            if isInteractive {
                withAnimation(.easeInOut(duration: 0.2)) {
                    animatedSelectedId = item.id
                }
                onSelect?(item.id)
            }
        }) {
            VStack(spacing: DSSpacing.space4) {
                HStack(spacing: DSSpacing.space4) {
                    if let icon = item.icon {
                        icon.view()
                            .font(.caption)
                    }
                    Text(item.label)
                        .font(.dsCaption)
                }
                .foregroundColor(isSelected ? item.color : .coolGrey)

                Text(item.value)
                    .font(.dsHeadline)
                    .foregroundColor(isSelected ? .textPrimary : .textSecondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, DSSpacing.space12)
            .padding(.horizontal, DSSpacing.space8)
            .background(
                RoundedRectangle(cornerRadius: DSRadius.medium, style: .continuous)
                    .fill(isSelected ? item.color.opacity(0.08) : .clear)
                    .overlay(
                        RoundedRectangle(cornerRadius: DSRadius.medium, style: .continuous)
                            .stroke(
                                isSelected ? item.color.opacity(0.3) : .borderSubtle,
                                lineWidth: isSelected ? 1.5 : 1
                            )
                    )
            )
            .contentShape(Rectangle())
        }
        .disabled(!isInteractive)
        .opacity(isInteractive ? 1.0 : 0.8)
    }

    @ViewBuilder
    private var segmentedBarIndicator: some View {
        HStack(spacing: 0) {
            ForEach(items, id: \.id) { item in
                let isSelected = animatedSelectedId == item.id

                RoundedRectangle(cornerRadius: DSRadius.small, style: .continuous)
                    .fill(isSelected ? item.color : .borderSubtle)
                    .frame(height: 3)
                    .scaleEffect(y: isSelected ? 1.2 : 0.8, anchor: .center)
                    .opacity(isSelected ? 1.0 : 0.4)

                if item.id != items.last?.id {
                    Spacer()
                        .frame(height: 3)
                }
            }
        }
        .frame(height: 3)
        .animation(.easeInOut(duration: 0.3), value: animatedSelectedId)
    }
}

#Preview {
    @Previewable @State var selectedId: String = "active"
    let items = [
        DSSegmentedBarItem(
            id: "active",
            label: "Ativos",
            value: "12",
            color: .success
        ),
        DSSegmentedBarItem(
            id: "inactive",
            label: "Inativos",
            value: "3",
            color: .warning
        ),
        DSSegmentedBarItem(
            id: "observer",
            label: "Observadores",
            value: "5",
            color: .coolGrey
        )
    ]

    VStack(spacing: DSSpacing.space32) {
        DSSegmentedBar(
            items: items,
            selectedId: selectedId,
            onSelect: { selectedId = $0 }
        )
        .padding()

        Spacer()
    }
    .background(Color(.systemBackground))
}
