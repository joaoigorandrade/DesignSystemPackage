import SwiftUI

public struct DSLoadingScreen: View {
    private let gifName: String
    private let bundle: Bundle
    private let message: String?

    public init(gifName: String = "loading-screen", bundle: Bundle? = nil, message: String? = nil) {
        self.gifName = gifName
        self.bundle = bundle ?? .module
        self.message = message
    }

    public static func local(_ name: String = "loading-screen", in bundle: Bundle? = nil, message: String? = nil) -> DSLoadingScreen {
        let resourceBundle = bundle ?? .module
        return DSLoadingScreen(gifName: name, bundle: resourceBundle, message: message)
    }

    public var body: some View {
        GeometryReader { proxy in
            let horizontalPadding: CGFloat = 32
            let maxGifWidth = max(0, min(280, proxy.size.width - (horizontalPadding * 2)))

            ZStack {
                Color.backgroundGrey.ignoresSafeArea()
                VStack(spacing: 24) {
                    DSGIFView(gifName: gifName, bundle: bundle)
                        .frame(width: maxGifWidth)
                    if let message {
                        LoadingMessageView(text: message)
                    }
                }
                .padding(horizontalPadding)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .transition(.scale)
    }
}

private struct LoadingMessageView: View {
    let text: String

    var body: some View {
        Text(text)
            .dsBody()
            .foregroundColor(.coolGrey)
            .multilineTextAlignment(.center)
    }
}

public extension View {
    func dsLoadingOverlay(isLoading: Bool, gifName: String = "loading-screen", bundle: Bundle? = nil, message: String? = nil) -> some View {
        overlay {
            if isLoading {
                DSLoadingScreen(gifName: gifName, bundle: bundle, message: message)
            }
        }
    }

    @available(*, deprecated, renamed: "dsLoadingOverlay(isLoading:gifName:bundle:message:)")
    func dsLoadingOverlay(isLoading: Bool, animationName: String = "loading-screen", bundle: Bundle? = nil, message: String? = nil) -> some View {
        dsLoadingOverlay(isLoading: isLoading, gifName: animationName, bundle: bundle, message: message)
    }
}
