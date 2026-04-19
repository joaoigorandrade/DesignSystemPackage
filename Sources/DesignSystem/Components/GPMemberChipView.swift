import SwiftUI

public struct GPMemberChipView: View {
    private let name: String
    private let subtitle: String
    private let selected: Bool
    private let action: () -> Void

    public init(name: String, subtitle: String, selected: Bool = false, action: @escaping () -> Void = {}) {
        self.name = name
        self.subtitle = subtitle
        self.selected = selected
        self.action = action
    }

    public var body: some View {
        GroupoolMemberChip(name: name, subtitle: subtitle, selected: selected, action: action)
    }
}

#Preview("Member Chips") {
    @Previewable @State var selectedName: String? = nil
    VStack(spacing: 8) {
        ForEach(["Ana Silva", "Bruno Costa", "Carla Dias"], id: \.self) { name in
            GPMemberChipView(
                name: name,
                subtitle: "@\(name.lowercased().replacingOccurrences(of: " ", with: "."))",
                selected: selectedName == name
            ) {
                selectedName = selectedName == name ? nil : name
            }
        }
    }
    .padding()
}
