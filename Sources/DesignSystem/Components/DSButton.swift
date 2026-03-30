import SwiftUI

public enum DSButtonStyle {
    case primary
    case secondary
    case destructive
}

public struct DSButton: View {
    public let title: String
    public let icon: BrandIcon?
    public let style: DSButtonStyle
    public let state: ViewState
    public let tapHaptic: DSHapticEvent?
    public let stateHapticsEnabled: Bool
    public let action: () -> Void
    
    public init(
        title: String,
        icon: BrandIcon? = nil,
        style: DSButtonStyle = .primary,
        state: ViewState = .idle,
        tapHaptic: DSHapticEvent? = .tapPrimary,
        stateHapticsEnabled: Bool = true,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.style = style
        self.state = state
        self.tapHaptic = tapHaptic
        self.stateHapticsEnabled = stateHapticsEnabled
        self.action = action
    }
    
    public var body: some View {
        Button(action: handleTap) {
            HStack(spacing: 8) {
                if state == .loading {
                    ProgressView()
                        .tint(spinnerColor)
                } else {
                    if let icon = icon {
                        icon.view()
                    }
                    Text(title)
                        .dsHeadline()
                }
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(DSButtonStyleModifier(style: style, state: state))
        .disabled(state == .loading || state == .success)
        .opacity(state == .loading ? 0.8 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: state)
        .onChange(of: state) { oldValue, newValue in
            handleStateChange(from: oldValue, to: newValue)
        }
    }
    
    private var spinnerColor: Color {
        switch style {
        case .primary, .destructive:
            return .white
        case .secondary:
            return .brandPrimary
        }
    }

    private func handleTap() {
        if let tapHaptic {
            DSHaptics.shared.play(event: tapHaptic)
        }
        action()
    }

    private func handleStateChange(from oldValue: ViewState, to newValue: ViewState) {
        guard stateHapticsEnabled else { return }
        guard oldValue != newValue else { return }

        switch newValue {
        case .success:
            DSHaptics.shared.play(event: .success)
        case .error:
            DSHaptics.shared.play(event: .error)
        default:
            break
        }
    }
}

private struct DSButtonStyleModifier: ButtonStyle {
    let style: DSButtonStyle
    let state: ViewState
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.vertical, 16)
            .padding(.horizontal, 24)
            .background(backgroundColor)
            .foregroundColor(foregroundColor)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(borderColor, lineWidth: 2)
            )
            .shadow(color: shadowColor.opacity(configuration.isPressed ? 0.1 : 0.3), radius: configuration.isPressed ? 4 : 8, x: 0, y: configuration.isPressed ? 2 : 4)
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .opacity(configuration.isPressed ? 0.9 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
    
    private var backgroundColor: Color {
        switch style {
        case .primary:
            return .brandPrimary
        case .secondary:
            return .clear
        case .destructive:
            return .danger
        }
    }
    
    private var foregroundColor: Color {
        switch style {
        case .primary, .destructive:
            return .white
        case .secondary:
            return .brandPrimary
        }
    }
    
    private var borderColor: Color {
        switch style {
        case .primary:
            return .brandPrimary
        case .secondary:
            return .coolGrey.opacity(0.3)
        case .destructive:
            return .danger
        }
    }
    
    private var shadowColor: Color {
        switch style {
        case .primary:
            return .brandPrimary
        case .destructive:
            return .danger
        case .secondary:
            return .clear
        }
    }
}
