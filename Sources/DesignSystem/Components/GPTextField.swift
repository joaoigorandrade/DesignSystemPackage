import SwiftUI

public struct GPTextField<Leading: View, Trailing: View>: View {
    private let title: String?
    @Binding private var text: String
    private let prompt: String
    private let isMultiline: Bool
    private let isBig: Bool
    private let leading: Leading
    private let trailing: Trailing

    public init(
        title: String? = nil,
        text: Binding<String>,
        prompt: String = "",
        isMultiline: Bool = false,
        isBig: Bool = false,
        @ViewBuilder prefix: () -> Leading = { EmptyView() },
        @ViewBuilder suffix: () -> Trailing = { EmptyView() }
    ) {
        self.title = title
        self._text = text
        self.prompt = prompt
        self.isMultiline = isMultiline
        self.isBig = isBig
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
