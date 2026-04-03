import SwiftUI

public struct DSTextField: View {
    public let label: String?
    public let placeholder: String
    @Binding public var text: String
    public let state: ViewState
    public let helperText: String?
    public let characterLimit: Int?
    public let isSecure: Bool
    public let keyboardType: UIKeyboardType
    public let textContentType: UITextContentType?
    public let autocapitalization: TextInputAutocapitalization
    public let autocorrectionDisabled: Bool
    public let onSubmit: () -> Void

    @FocusState private var isFocused: Bool

    public init(
        label: String? = nil,
        placeholder: String,
        text: Binding<String>,
        state: ViewState = .idle,
        helperText: String? = nil,
        characterLimit: Int? = nil,
        isSecure: Bool = false,
        keyboardType: UIKeyboardType = .default,
        textContentType: UITextContentType? = nil,
        autocapitalization: TextInputAutocapitalization = .sentences,
        autocorrectionDisabled: Bool = false,
        onSubmit: @escaping () -> Void = {}
    ) {
        self.label = label
        self.placeholder = placeholder
        self._text = text
        self.state = state
        self.helperText = helperText
        self.characterLimit = characterLimit
        self.isSecure = isSecure
        self.keyboardType = keyboardType
        self.textContentType = textContentType
        self.autocapitalization = autocapitalization
        self.autocorrectionDisabled = autocorrectionDisabled
        self.onSubmit = onSubmit
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.space8) {
            labelView
            inputField
            footerView
        }
    }

    // MARK: - Label

    @ViewBuilder
    private var labelView: some View {
        if let label {
            Text(label)
                .dsCallout()
                .foregroundColor(labelColor)
                .padding(.leading, DSSpacing.space4)
        }
    }

    private var labelColor: Color {
        if case .error = state { return .danger }
        return isFocused ? .brandPrimary : .textSecondary
    }

    // MARK: - Input Field

    private var inputField: some View {
        ZStack(alignment: .trailing) {
            Group {
                if isSecure {
                    SecureField(placeholder, text: $text)
                } else {
                    TextField(placeholder, text: $text)
                }
            }
            .dsBody()
            .keyboardType(keyboardType)
            .textContentType(textContentType)
            .textInputAutocapitalization(autocapitalization)
            .autocorrectionDisabled(autocorrectionDisabled)
            .focused($isFocused)
            .textFieldStyle(.plain)
            .onSubmit(onSubmit)
            .padding(.leading, DSSpacing.space16)
            .padding(.trailing, DSSpacing.space48 + DSSpacing.space4)
            .padding(.vertical, 15)

            statusView
                .padding(.trailing, DSSpacing.space16)
        }
        .glassEffect(cornerRadius: CGFloat(DSRadius.medium))
        .overlay(
            RoundedRectangle(cornerRadius: DSRadius.medium, style: .continuous)
                .stroke(borderColor, lineWidth: isFocused ? 2.5 : 1)
        )
        .shadow(color: isFocused ? borderColor.opacity(0.25) : .clear, radius: 8, x: 0, y: 4)
        .scaleEffect(isFocused ? 1.01 : 1.0)
        .animation(.spring(response: 0.32, dampingFraction: 0.65), value: isFocused)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: state)
    }

    // MARK: - Status Icon

    @ViewBuilder
    private var statusView: some View {
        Group {
            if state == .loading {
                ProgressView()
                    .scaleEffect(0.85)
            } else if case .error = state {
                BrandIcon.error.view()
                    .foregroundColor(.danger)
            } else if state == .success {
                BrandIcon.checkmark.view()
                    .foregroundColor(.success)
            } else if !text.isEmpty && isFocused && !isSecure {
                Button {
                    withAnimation(.spring(response: 0.2)) {
                        text = ""
                    }
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 18))
                        .foregroundStyle(.secondary.opacity(0.85))
                }
            }
        }
        .transition(.scale.combined(with: .opacity))
    }

    // MARK: - Footer (Error / Helper / Character Count)

    @ViewBuilder
    private var footerView: some View {
        let showError = {
            if case .error = state { return true }
            return false
        }()
        let showHelper = helperText != nil && !showError
        let showCounter = characterLimit != nil

        if showError || showHelper || showCounter {
            HStack {
                if case .error(let message) = state {
                    Text(message)
                        .dsCaption()
                        .foregroundColor(.danger)
                        .transition(.opacity.combined(with: .move(edge: .top)))
                } else if let helperText {
                    Text(helperText)
                        .dsCaption()
                        .foregroundColor(.textTertiary)
                }

                Spacer()

                if let limit = characterLimit {
                    Text("\(text.count)/\(limit)")
                        .dsCaption()
                        .foregroundColor(text.count > limit ? .danger : .textTertiary)
                }
            }
            .padding(.horizontal, DSSpacing.space4)
        }
    }

    // MARK: - Border Color

    private var borderColor: Color {
        switch state {
        case .error:
            return .danger
        case .success:
            return .success
        default:
            return isFocused ? .brandPrimary : .borderDefault
        }
    }
}
