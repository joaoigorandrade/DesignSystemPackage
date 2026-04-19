import SwiftUI

public typealias GPFormLabel = GroupoolFormLabel

#Preview("Form Label") {
    VStack(alignment: .leading) {
        GPFormLabel("Nome do desafio")
        Text("Text field here")
        GPFormLabel("Descrição")
        Text("Text field here")
    }
    .padding()
}
