import SwiftUI

public enum GPTextFieldMask: Sendable {
    case brazilianPhone

    public func apply(_ value: String) -> String {
        switch self {
        case .brazilianPhone:
            let digits = String(value.filter(\.isNumber).prefix(11))
            guard !digits.isEmpty else { return "" }

            if digits.count <= 2 {
                return digits
            }

            let areaCode = String(digits.prefix(2))
            let rest = String(digits.dropFirst(2))

            if rest.count <= 5 {
                return "(\(areaCode)) \(rest)"
            }

            let prefix = String(rest.prefix(5))
            let suffix = String(rest.dropFirst(5))
            return "(\(areaCode)) \(prefix)-\(suffix)"
        }
    }
}

public struct GPTextField<Leading: View, Trailing: View>: View {
    private let title: String?
    @Binding private var text: String
    private let prompt: String
    private let isMultiline: Bool
    private let isBig: Bool
    private let mask: GPTextFieldMask?
    private let leading: Leading
    private let trailing: Trailing

    public init(
        title: String? = nil,
        text: Binding<String>,
        prompt: String = "",
        isMultiline: Bool = false,
        isBig: Bool = false,
        mask: GPTextFieldMask? = nil,
        @ViewBuilder prefix: () -> Leading = { EmptyView() },
        @ViewBuilder suffix: () -> Trailing = { EmptyView() }
    ) {
        self.title = title
        self._text = text
        self.prompt = prompt
        self.isMultiline = isMultiline
        self.isBig = isBig
        self.mask = mask
        self.leading = prefix()
        self.trailing = suffix()
    }

    public var body: some View {
        GroupoolInputField(
            title: title,
            text: $text,
            prompt: prompt,
            isMultiline: isMultiline,
            isLarge: isBig,
            leading: { leading },
            trailing: { trailing }
        )
        .onAppear {
            guard let mask else { return }
            let masked = mask.apply(text)
            if masked != text {
                text = masked
            }
        }
        .onChange(of: text) { _, newValue in
            guard let mask else { return }
            let masked = mask.apply(newValue)
            if masked != newValue {
                text = masked
            }
        }
    }
}

#Preview("Text Fields") {
    @Previewable @State var name = ""
    @Previewable @State var amount = ""
    @Previewable @State var description = ""

    VStack {
        GPTextField(title: "Nome", text: $name, prompt: "Seu nome")
        GPTextField(
            title: "Valor",
            text: $amount,
            prompt: "0,00",
            isBig: true,
            prefix: { Text("R$") }
        )
        GPTextField(
            title: "Descrição",
            text: $description,
            prompt: "Descreva o desafio...",
            isMultiline: true
        )
    }
    .padding()
}
