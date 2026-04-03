import SwiftUI

// MARK: - Button Previews

struct DSButton_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            VStack(spacing: 20) {
                DSButton(title: "Primary", action: {})
                DSButton(title: "Primary Loading", state: .loading, action: {})
                DSButton(title: "Primary Disabled", isDisabled: true, action: {})
                DSButton(title: "Secondary", style: .secondary, action: {})
                DSButton(title: "Secondary Disabled", style: .secondary, isDisabled: true, action: {})
                DSButton(title: "Tertiary Action", style: .tertiary, action: {})
                DSButton(title: "Tertiary Disabled", style: .tertiary, isDisabled: true, action: {})
                DSButton(title: "Delete Account", style: .destructive, action: {})
                DSButton(title: "Destructive Disabled", style: .destructive, isDisabled: true, action: {})
            }
            .padding()
        }
        .background(Color.backgroundBase)
        .preferredColorScheme(.dark)
    }
}

// MARK: - TextField Previews

struct DSTextField_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            VStack(spacing: 24) {
                DSTextField(
                    label: "Full Name",
                    placeholder: "Enter your name",
                    text: .constant(""),
                    helperText: "As it appears on your ID"
                )
                DSTextField(
                    label: "Username",
                    placeholder: "Choose a username",
                    text: .constant("ZK_FLawLeZ"),
                    state: .success
                )
                DSTextField(
                    label: "Email",
                    placeholder: "you@example.com",
                    text: .constant("pitbull@agreste.com"),
                    state: .error("This email is already registered")
                )
                DSTextField(
                    label: "Bio",
                    placeholder: "Tell us about yourself",
                    text: .constant("Hello world"),
                    characterLimit: 150
                )
                DSTextField(
                    label: "Password",
                    placeholder: "Create a password",
                    text: .constant("secret123"),
                    isSecure: true
                )
                DSTextField(
                    placeholder: "Validating...",
                    text: .constant(""),
                    state: .loading
                )
            }
            .padding()
        }
        .background(Color.backgroundBase)
        .preferredColorScheme(.dark)
    }
}

// MARK: - Card Previews

struct DSCard_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.backgroundBase.ignoresSafeArea()

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
        .preferredColorScheme(.dark)
    }
}

// MARK: - Navigation Bar Previews

struct DSNavigationBar_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 32) {
            DSNavigationBar(
                title: "Groupool",
                displayMode: .inline,
                leading: {
                    DSNavBarButton(icon: .close, action: {})
                },
                trailing: {
                    DSNavBarButton(icon: .bell, action: {})
                }
            )

            DSNavigationBar(
                title: "My Groups",
                subtitle: "3 active groups",
                displayMode: .large,
                trailing: {
                    DSNavBarButton(icon: .plus, action: {})
                }
            )

            Spacer()
        }
        .background(Color.backgroundBase)
        .preferredColorScheme(.dark)
    }
}

// MARK: - Loading Screen Previews

struct DSLoadingScreen_Previews: PreviewProvider {
    static var previews: some View {
        DSLoadingScreen()
    }
}
