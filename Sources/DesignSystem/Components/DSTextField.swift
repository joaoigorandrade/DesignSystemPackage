import SwiftUI

public struct DSTextField: View {
    public let placeholder: String
    @Binding public var text: String
    public let state: ViewState
    public let isSecure: Bool
    public let keyboardType: UIKeyboardType
    public let textContentType: UITextContentType?
    public let autocapitalization: TextInputAutocapitalization
    public let autocorrectionDisabled: Bool
    public let onSubmit: () -> Void
    
    @FocusState private var isFocused: Bool
    
    public init(
        placeholder: String,
        text: Binding<String>,
        state: ViewState = .idle,
        isSecure: Bool = false,
        keyboardType: UIKeyboardType = .default,
        textContentType: UITextContentType? = nil,
        autocapitalization: TextInputAutocapitalization = .sentences,
        autocorrectionDisabled: Bool = false,
        onSubmit: @escaping () -> Void = {}
    ) {
        self.placeholder = placeholder
        self._text = text
        self.state = state
        self.isSecure = isSecure
        self.keyboardType = keyboardType
        self.textContentType = textContentType
        self.autocapitalization = autocapitalization
        self.autocorrectionDisabled = autocorrectionDisabled
        self.onSubmit = onSubmit
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
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
                .padding(.leading, 16)
                .padding(.trailing, 52)
                .padding(.vertical, 15)
                
                statusView
                    .padding(.trailing, 16)
            }
            .glassEffect(cornerRadius: 16)
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(borderColor, lineWidth: isFocused ? 2.5 : 1)
            )
            .shadow(color: isFocused ? borderColor.opacity(0.25) : .clear, radius: 8, x: 0, y: 4)
            .scaleEffect(isFocused ? 1.01 : 1.0)
            .animation(.spring(response: 0.32, dampingFraction: 0.65), value: isFocused)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: state)
        
            switch state {
            case .error(let message):
                Text(message)
                    .font(.caption)
                    .lineLimit(1)
                    .foregroundColor(.danger)
                    .padding(.leading, 4)
                    .transition(.opacity.combined(with: .move(edge: .top)))
                    .frame(maxWidth: .infinity, alignment: .trailing)
            default: EmptyView()
            }
        }
    }
    
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
                // Standard iOS-style clear button (only when focused)
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
    
    private var borderColor: Color {
        switch state {
        case .error:
            return .danger
        case .success:
            return .success
        default:
            return isFocused ? .brandPrimary : .gray.opacity(0.3)
        }
    }
}


// MARK: - Previews

#Preview("DSTextField") {
    VStack(spacing: 24) {
        DSTextField(
            placeholder: "Nome completo",
            text: .constant("")
        )
        DSTextField(
            placeholder: "Nome completo",
            text: .constant("Pitbull do Agreste")
        )
        DSTextField(
            placeholder: "Validando código...",
            text: .constant(""),
            state: .loading
        )
        DSTextField(
            placeholder: "Usuário",
            text: .constant("ZK_FLawLeZ"),
            state: .success
        )
        
        DSTextField(
            placeholder: "Email",
            text: .constant("pitbull@agreste.com"),
            state: .error("Este email já está cadastrado")
        )
        
        DSTextField(
            placeholder: "Senha de acesso",
            text: .constant("minhasenha123"),
            isSecure: true
        )
        DSTextField(
            placeholder: "Nome completo",
            text: .constant("Pitbull do Agreste"),
            state: .success
        )
        .preferredColorScheme(.dark)
    }
}
