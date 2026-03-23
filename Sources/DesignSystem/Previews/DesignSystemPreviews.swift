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

struct FABView_Previews: PreviewProvider {
    static var previews: some View {
        FABPreviewContainer()
    }
}

struct DSSwitch_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            DSSwitch(isOn: .constant(false))
            DSSwitch(isOn: .constant(true))
            DSSwitch(isOn: .constant(false), isEnabled: false)
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}

private struct FABPreviewContainer: View {
    @State private var isExpanded = false

    var body: some View {
        ZStack {
            Color.backgroundGrey.ignoresSafeArea()

            FABView(
                isExpanded: $isExpanded,
                actionItems: [
                    .challenge { },
                    .expense(state: .error("Expense is unavailable for your current role.")) { },
                    .withdrawal(state: .error("Withdrawal requires a verified account.")) { }
                ]
            )
        }
        .frame(height: 450)
    }
}
