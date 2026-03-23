import SwiftUI

public struct DSSwitch: View {
    @Binding public var isOn: Bool
    public let isEnabled: Bool

    public init(
        isOn: Binding<Bool>,
        isEnabled: Bool = true
    ) {
        self._isOn = isOn
        self.isEnabled = isEnabled
    }

    public var body: some View {
        Button(action: toggle) {
            switchTrack
        }
        .buttonStyle(.plain)
        .disabled(!isEnabled)
    }

    private var switchTrack: some View {
        ZStack(alignment: isOn ? .trailing : .leading) {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(trackColor)

            Circle()
                .fill(Color.white)
                .frame(width: 12, height: 12)
                .shadow(color: .black.opacity(0.12), radius: 1.5, x: 0, y: 1)
                .padding(2)
        }
        .frame(width: 25, height: 16)
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(borderColor, lineWidth: 1)
        )
        .animation(.spring(response: 0.28, dampingFraction: 0.72), value: isOn)
        .opacity(isEnabled ? 1.0 : 0.55)
    }

    private var trackColor: Color {
        switch isOn {
        case true:
            return isEnabled ? .brandPrimary : .brandPrimary.opacity(0.45)
        case false:
            return isEnabled ? .coolGrey.opacity(0.25) : .coolGrey.opacity(0.15)
        }
    }

    private var borderColor: Color {
        switch isOn {
        case true:
            return .brandPrimary.opacity(isEnabled ? 0.35 : 0.2)
        case false:
            return .coolGrey.opacity(isEnabled ? 0.18 : 0.1)
        }
    }
    
    private func toggle() {
        guard isEnabled else {
            return
        }

        withAnimation(.spring(response: 0.28, dampingFraction: 0.72)) {
            isOn.toggle()
        }
    }
}
