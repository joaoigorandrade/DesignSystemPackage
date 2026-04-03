import SwiftUI

public enum DSButtonStyle {
    case primary
    case secondary
    case tertiary
    case destructive
}

public struct DSButton: View {
    public let title: String
    public let icon: BrandIcon?
    public let style: DSButtonStyle
    public let state: ViewState
    public let isDisabled: Bool
    public let tapHaptic: DSHapticEvent?
    public let stateHapticsEnabled: Bool
    public let action: () -> Void

    public init(
        title: String,
        icon: BrandIcon? = nil,
        style: DSButtonStyle = .primary,
        state: ViewState = .idle,
        isDisabled: Bool = false,
        tapHaptic: DSHapticEvent? = .tapPrimary,
        stateHapticsEnabled: Bool = true,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.style = style
        self.state = state
        self.isDisabled = isDisabled
        self.tapHaptic = tapHaptic
        self.stateHapticsEnabled = stateHapticsEnabled
        self.action = action
    }

    private var effectivelyDisabled: Bool {
        isDisabled || state == .loading || state == .success
    }

    public var body: some View {
        Button(action: handleTap) {
            HStack(spacing: DSSpacing.space8) {
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
            .frame(maxWidth: style == .tertiary ? nil : .infinity)
            .frame(minHeight: 24)
        }
        .buttonStyle(
            DSButtonInternalStyle(
                style: style,
                state: state,
                isDisabled: effectivelyDisabled
            )
        )
        .disabled(effectivelyDisabled)
        .animation(.easeInOut(duration: 0.2), value: state)
        .animation(.easeInOut(duration: 0.2), value: isDisabled)
        .onChange(of: state) { oldValue, newValue in
            handleStateChange(from: oldValue, to: newValue)
        }
    }

    private var spinnerColor: Color {
        switch style {
        case .primary, .destructive:
            return .white
        case .secondary, .tertiary:
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

// MARK: - Button Style

private struct DSButtonInternalStyle: ButtonStyle {
    let style: DSButtonStyle
    let state: ViewState
    let isDisabled: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.vertical, DSSpacing.space16)
            .padding(.horizontal, horizontalPadding)
            .background(background(isPressed: configuration.isPressed))
            .foregroundColor(foregroundColor)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .overlay(border)
            .shadow(
                color: shadowColor.opacity(configuration.isPressed ? 0.1 : 0.3),
                radius: configuration.isPressed ? 4 : 8,
                x: 0,
                y: configuration.isPressed ? 2 : 4
            )
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .opacity(pressedOpacity(isPressed: configuration.isPressed))
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }

    // MARK: - Metrics

    private var horizontalPadding: CGFloat {
        style == .tertiary ? DSSpacing.space16 : DSSpacing.space24
    }

    private var cornerRadius: CGFloat {
        style == .tertiary ? DSRadius.small : DSRadius.large
    }

    // MARK: - Colors

    private func background(isPressed: Bool) -> Color {
        if isDisabled {
            return disabledBackgroundColor
        }
        if isPressed {
            return pressedBackgroundColor
        }
        return defaultBackgroundColor
    }

    private var defaultBackgroundColor: Color {
        switch style {
        case .primary:
            return .brandPrimary
        case .secondary:
            return .clear
        case .tertiary:
            return .clear
        case .destructive:
            return .danger
        }
    }

    private var pressedBackgroundColor: Color {
        switch style {
        case .primary:
            return .brandPrimary.opacity(0.8)
        case .secondary:
            return .brandPrimary.opacity(0.1)
        case .tertiary:
            return .brandPrimary.opacity(0.08)
        case .destructive:
            return .danger.opacity(0.8)
        }
    }

    private var disabledBackgroundColor: Color {
        switch style {
        case .primary:
            return .coolGrey.opacity(0.3)
        case .secondary:
            return .clear
        case .tertiary:
            return .clear
        case .destructive:
            return .coolGrey.opacity(0.3)
        }
    }

    private var foregroundColor: Color {
        if isDisabled {
            return .coolGrey
        }
        switch style {
        case .primary, .destructive:
            return .white
        case .secondary, .tertiary:
            return .brandPrimary
        }
    }

    private var borderColor: Color {
        if isDisabled {
            switch style {
            case .primary, .destructive:
                return .coolGrey.opacity(0.3)
            case .secondary:
                return .coolGrey.opacity(0.2)
            case .tertiary:
                return .clear
            }
        }
        switch style {
        case .primary:
            return .brandPrimary
        case .secondary:
            return .borderDefault
        case .tertiary:
            return .clear
        case .destructive:
            return .danger
        }
    }

    @ViewBuilder
    private var border: some View {
        if style != .tertiary {
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .stroke(borderColor, lineWidth: style == .secondary ? 1.5 : 0)
        }
    }

    private var shadowColor: Color {
        if isDisabled { return .clear }
        switch style {
        case .primary:
            return .brandPrimary
        case .destructive:
            return .danger
        case .secondary, .tertiary:
            return .clear
        }
    }

    private func pressedOpacity(isPressed: Bool) -> Double {
        if isDisabled { return 0.6 }
        return isPressed ? 0.9 : 1.0
    }
}
