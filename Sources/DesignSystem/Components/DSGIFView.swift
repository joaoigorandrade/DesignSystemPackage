import SwiftUI
import UIKit
import Gifu

public struct DSGIFView: View {
    public let gifName: String
    public let bundle: Bundle
    public let contentMode: UIView.ContentMode

    public init(
        gifName: String,
        bundle: Bundle? = nil,
        contentMode: UIView.ContentMode = .scaleAspectFit
    ) {
        self.gifName = gifName
        self.bundle = bundle ?? .module
        self.contentMode = contentMode
    }

    public var body: some View {
        if resourceURL != nil {
            GIFContainer(
                resourceURL: resourceURL,
                contentMode: contentMode
            )
        } else {
            ProgressView()
                .scaleEffect(2)
                .tint(.brandPrimary)
        }
    }
}

private struct GIFContainer: UIViewRepresentable {
    let resourceURL: URL?
    let contentMode: UIView.ContentMode

    final class Coordinator {
        var loadedPath: String?
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    func makeUIView(context: Context) -> GIFImageView {
        let imageView = GIFImageView(frame: .zero)
        imageView.backgroundColor = .clear
        imageView.clipsToBounds = true
        imageView.contentMode = contentMode
        imageView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        imageView.setContentHuggingPriority(.defaultLow, for: .vertical)
        imageView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        imageView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        return imageView
    }

    func updateUIView(_ uiView: GIFImageView, context: Context) {
        uiView.contentMode = contentMode
        updateGIF(in: uiView, context: context)
    }

    private func updateGIF(in imageView: GIFImageView, context: Context) {
        guard let url = resourceURL,
              let data = try? Data(contentsOf: url) else {
            imageView.prepareForReuse()
            context.coordinator.loadedPath = nil
            return
        }

        if context.coordinator.loadedPath == url.path {
            return
        }

        imageView.prepareForReuse()
        imageView.animate(withGIFData: data)
        context.coordinator.loadedPath = url.path
    }
}

private extension DSGIFView {
    var resourceURL: URL? {
        let nsName = gifName as NSString
        let ext = nsName.pathExtension
        let name = ext.isEmpty ? gifName : nsName.deletingPathExtension
        let fileExtension = ext.isEmpty ? "gif" : ext
        return bundle.url(forResource: name, withExtension: fileExtension)
    }
}
