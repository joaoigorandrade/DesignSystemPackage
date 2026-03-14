import SwiftUI

struct DSButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            DSButton(title: "Primary Idle", action: {})
            DSButton(title: "Primary Loading", state: .loading, action: {})
            DSButton(title: "Secondary Idle", style: .secondary, action: {})
            DSButton(title: "Destructive", style: .destructive, action: {})
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}

struct DSCard_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.vibrantOrange.ignoresSafeArea()
            
            DSCard {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Liquid Glass Card")
                        .dsHeadline()
                    Text("This card supports the new iOS material styles seamlessly.")
                        .dsBody()
                }
            }
            .padding()
        }
    }
}

struct DSTextField_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            DSTextField(placeholder: "Idle state", text: .constant(""))
            DSTextField(placeholder: "Error state", text: .constant("Invalid email"), state: .error("Invalid"))
            DSTextField(placeholder: "Success state", text: .constant("valid@email.com"), state: .success)
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
