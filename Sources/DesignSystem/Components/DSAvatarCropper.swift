import SwiftUI
import UIKit

public struct DSAvatarCropper: View {
    public let image: UIImage
    public let onCancel: () -> Void
    public let onConfirm: (UIImage) -> Void

    @State private var zoom: CGFloat = 1
    @State private var offset: CGSize = .zero
    @GestureState private var pinchScale: CGFloat = 1
    @GestureState private var dragOffset: CGSize = .zero

    public init(
        image: UIImage,
        onCancel: @escaping () -> Void,
        onConfirm: @escaping (UIImage) -> Void
    ) {
        self.image = image
        self.onCancel = onCancel
        self.onConfirm = onConfirm
    }

    public var body: some View {
        cropperContent
    }

    private var cropperContent: some View {
        NavigationStack {
            GeometryReader { geometry in
                let side = min(geometry.size.width - 36, geometry.size.height - 220)
                let cropDiameter = max(200, side)
                let effectiveZoom = min(max(zoom * pinchScale, 1), 4)
                let liveOffset = CGSize(
                    width: offset.width + dragOffset.width,
                    height: offset.height + dragOffset.height
                )
                let clampedOffset = clampOffset(
                    liveOffset,
                    imageSize: image.size,
                    cropDiameter: cropDiameter,
                    zoom: effectiveZoom
                )

                VStack(spacing: 24) {
                    ZStack {
                        Color.black
                        CroppingCanvas(
                            image: image,
                            cropDiameter: cropDiameter,
                            zoom: effectiveZoom,
                            offset: clampedOffset
                        )
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .overlay(alignment: .center) {
                        CropOverlay(diameter: cropDiameter)
                    }
                    .gesture(combinedGesture(cropDiameter: cropDiameter))

                    DSButton(title: "Use Photo", style: .primary) {
                        let finalOffset = clampOffset(
                            offset,
                            imageSize: image.size,
                            cropDiameter: cropDiameter,
                            zoom: zoom
                        )
                        if let output = croppedImage(
                            image: image,
                            cropDiameter: cropDiameter,
                            zoom: zoom,
                            offset: finalOffset
                        ) {
                            onConfirm(output)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
                .background(Color.black.ignoresSafeArea())
                .navigationTitle("Crop Avatar")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Cancel", action: onCancel)
                    }
                }
            }
        }
    }

    private func combinedGesture(cropDiameter: CGFloat) -> some Gesture {
        SimultaneousGesture(
            MagnificationGesture()
                .updating($pinchScale) { value, state, _ in
                    state = value
                }
                .onEnded { value in
                    let newZoom = min(max(zoom * value, 1), 4)
                    zoom = newZoom
                    offset = clampOffset(offset, imageSize: image.size, cropDiameter: cropDiameter, zoom: newZoom)
                },
            DragGesture()
                .updating($dragOffset) { value, state, _ in
                    state = value.translation
                }
                .onEnded { value in
                    let updated = CGSize(
                        width: offset.width + value.translation.width,
                        height: offset.height + value.translation.height
                    )
                    offset = clampOffset(updated, imageSize: image.size, cropDiameter: cropDiameter, zoom: zoom)
                }
        )
    }

    private func clampOffset(
        _ value: CGSize,
        imageSize: CGSize,
        cropDiameter: CGFloat,
        zoom: CGFloat
    ) -> CGSize {
        let baseScale = max(cropDiameter / imageSize.width, cropDiameter / imageSize.height)
        let scaledWidth = imageSize.width * baseScale * zoom
        let scaledHeight = imageSize.height * baseScale * zoom
        let limitX = max(0, (scaledWidth - cropDiameter) / 2)
        let limitY = max(0, (scaledHeight - cropDiameter) / 2)

        return CGSize(
            width: min(max(value.width, -limitX), limitX),
            height: min(max(value.height, -limitY), limitY)
        )
    }

    private func croppedImage(
        image: UIImage,
        cropDiameter: CGFloat,
        zoom: CGFloat,
        offset: CGSize
    ) -> UIImage? {
        guard let cgImage = image.cgImage else { return nil }

        let imageWidth = CGFloat(cgImage.width)
        let imageHeight = CGFloat(cgImage.height)
        let baseScale = max(cropDiameter / imageWidth, cropDiameter / imageHeight)
        let renderedWidth = imageWidth * baseScale * zoom
        let renderedHeight = imageHeight * baseScale * zoom

        let pixelsPerPointX = imageWidth / renderedWidth
        let pixelsPerPointY = imageHeight / renderedHeight

        let cropSizeX = cropDiameter * pixelsPerPointX
        let cropSizeY = cropDiameter * pixelsPerPointY

        var originX = (imageWidth - cropSizeX) / 2 - (offset.width * pixelsPerPointX)
        var originY = (imageHeight - cropSizeY) / 2 - (offset.height * pixelsPerPointY)
        originX = min(max(0, originX), imageWidth - cropSizeX)
        originY = min(max(0, originY), imageHeight - cropSizeY)

        let rect = CGRect(x: originX, y: originY, width: cropSizeX, height: cropSizeY).integral
        guard let cropped = cgImage.cropping(to: rect) else { return nil }
        return UIImage(cgImage: cropped, scale: image.scale, orientation: image.imageOrientation)
    }
}

struct CroppingCanvas: View {
    let image: UIImage
    let cropDiameter: CGFloat
    let zoom: CGFloat
    let offset: CGSize

    var body: some View {
        let baseScale = max(cropDiameter / image.size.width, cropDiameter / image.size.height)
        let width = image.size.width * baseScale * zoom
        let height = image.size.height * baseScale * zoom

        Image(uiImage: image)
            .resizable()
            .frame(width: width, height: height)
            .offset(offset)
            .clipped()
    }
}

struct CropOverlay: View {
    let diameter: CGFloat

    var body: some View {
        GeometryReader { geometry in
            let rect = CGRect(
                x: (geometry.size.width - diameter) / 2,
                y: (geometry.size.height - diameter) / 2,
                width: diameter,
                height: diameter
            )
            Path { path in
                path.addRect(CGRect(origin: .zero, size: geometry.size))
                path.addEllipse(in: rect)
            }
            .fill(Color.black.opacity(0.55), style: FillStyle(eoFill: true))

            Circle()
                .stroke(Color.white, lineWidth: 2)
                .frame(width: diameter, height: diameter)
                .position(x: rect.midX, y: rect.midY)
        }
        .allowsHitTesting(false)
    }
}
