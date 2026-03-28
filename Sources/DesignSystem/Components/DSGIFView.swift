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
        Group {
            if gifURL(for: gifName, in: bundle) != nil {
                GIFContainer(
                    gifName: gifName,
                    bundle: bundle,
                    contentMode: contentMode
                )
            } else {
                ProgressView()
                    .scaleEffect(2)
                    .tint(.brandPrimary)
            }
        }
    }

    private func gifURL(for name: String, in bundle: Bundle) -> URL? {
        let resource = normalizedResource(from: name)
        return bundle.url(forResource: resource.name, withExtension: resource.extension)
    }

    private func normalizedResource(from name: String) -> (name: String, extension: String) {
        let nsName = name as NSString
        let ext = nsName.pathExtension

        if ext.isEmpty {
            return (name, "gif")
        }

        return (nsName.deletingPathExtension, ext)
    }
}

private struct GIFContainer: UIViewRepresentable {
    let gifName: String
    let bundle: Bundle
    let contentMode: UIView.ContentMode

    final class FlexibleGIFHostView: UIView {
        let imageView = GIFImageView(frame: .zero)

        override init(frame: CGRect) {
            super.init(frame: frame)
            setup()
        }

        required init?(coder: NSCoder) {
            super.init(coder: coder)
            setup()
        }

        override var intrinsicContentSize: CGSize {
            CGSize(width: UIView.noIntrinsicMetric, height: UIView.noIntrinsicMetric)
        }

        private func setup() {
            backgroundColor = .clear
            clipsToBounds = true

            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.backgroundColor = .clear
            imageView.clipsToBounds = true
            addSubview(imageView)

            NSLayoutConstraint.activate([
                imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
                imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
                imageView.topAnchor.constraint(equalTo: topAnchor),
                imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
        }
    }

    final class Coordinator {
        var loadedResource: String?
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    func makeUIView(context: Context) -> FlexibleGIFHostView {
        let hostView = FlexibleGIFHostView(frame: .zero)
        hostView.imageView.contentMode = contentMode
        hostView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        hostView.setContentHuggingPriority(.defaultLow, for: .vertical)
        hostView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        hostView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        return hostView
    }

    func updateUIView(_ uiView: FlexibleGIFHostView, context: Context) {
        uiView.imageView.contentMode = contentMode
        updateGIF(in: uiView.imageView, context: context)
    }

    private func updateGIF(in imageView: GIFImageView, context: Context) {
        let resource = normalizedResource(from: gifName)
        guard let url = bundle.url(forResource: resource.name, withExtension: resource.extension),
              let data = try? Data(contentsOf: url) else {
            imageView.prepareForReuse()
            context.coordinator.loadedResource = nil
            return
        }

        let resourceIdentifier = url.path
        if context.coordinator.loadedResource == resourceIdentifier {
            return
        }

        imageView.prepareForReuse()
        imageView.animate(withGIFData: data)
        context.coordinator.loadedResource = resourceIdentifier
    }

    private func normalizedResource(from name: String) -> (name: String, extension: String) {
        let nsName = name as NSString
        let ext = nsName.pathExtension

        if ext.isEmpty {
            return (name, "gif")
        }

        return (nsName.deletingPathExtension, ext)
    }
}
