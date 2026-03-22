import SwiftUI

public struct DSAvatarCropper: View {
    public let image: UIImage
    public let onCancel: () -> Void
    public let onConfirm: (UIImage) -> Void

    @State private var scale: CGFloat = 1
    @State private var offset: CGSize = .zero
    @State private var lastScale: CGFloat = 1
    @State private var lastOffset: CGSize = .zero
    
    @Environment(\.displayScale) private var displayScale

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
        NavigationStack {
            GeometryReader { geometry in
                let rawSize = min(geometry.size.width, geometry.size.height) - 40
                let cropSize = max(1, rawSize)
                
                ZStack {
                    Color.black.ignoresSafeArea()
                    
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: cropSize, height: cropSize)
                        .scaleEffect(scale)
                        .offset(offset)
                        .gesture(
                            SimultaneousGesture(
                                MagnificationGesture()
                                    .onChanged { value in
                                        scale = max(1, lastScale * value)
                                    }
                                    .onEnded { _ in
                                        lastScale = scale
                                        clampOffset(cropSize: cropSize)
                                    },
                                DragGesture()
                                    .onChanged { value in
                                        offset = CGSize(
                                            width: lastOffset.width + value.translation.width,
                                            height: lastOffset.height + value.translation.height
                                        )
                                    }
                                    .onEnded { _ in
                                        clampOffset(cropSize: cropSize)
                                        lastOffset = offset
                                    }
                            )
                        )
                    
                    Rectangle()
                        .fill(Color.black.opacity(0.6))
                        .mask(
                            ZStack {
                                Rectangle()
                                Circle()
                                    .frame(width: cropSize, height: cropSize)
                                    .blendMode(.destinationOut)
                            }
                            .compositingGroup()
                        )
                        .allowsHitTesting(false)
                        .ignoresSafeArea()
                    
                    Circle()
                        .strokeBorder(Color.white, lineWidth: 2)
                        .frame(width: cropSize, height: cropSize)
                        .allowsHitTesting(false)
                }
                .safeAreaInset(edge: .bottom) {
                    Button {
                        cropImage(cropSize: cropSize)
                    } label: {
                        Text("Use Photo")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
            }
            .navigationTitle("Crop Avatar")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel", action: onCancel)
                }
            }
        }
    }

    private func clampOffset(cropSize: CGFloat) {
        let imageRatio = image.size.width / image.size.height
        let contentWidth = imageRatio > 1 ? cropSize * imageRatio : cropSize
        let contentHeight = imageRatio < 1 ? cropSize / imageRatio : cropSize
        
        let maxOffsetX = max(0, (contentWidth * scale - cropSize) / 2)
        let maxOffsetY = max(0, (contentHeight * scale - cropSize) / 2)
        
        withAnimation(.interactiveSpring()) {
            offset.width = min(max(offset.width, -maxOffsetX), maxOffsetX)
            offset.height = min(max(offset.height, -maxOffsetY), maxOffsetY)
            lastOffset = offset
        }
    }

    @MainActor
    private func cropImage(cropSize: CGFloat) {
        let renderedView = Image(uiImage: image)
            .resizable()
            .scaledToFill()
            .frame(width: cropSize, height: cropSize)
            .scaleEffect(scale)
            .offset(offset)
            .frame(width: cropSize, height: cropSize)
            .clipShape(Circle())
        
        let renderer = ImageRenderer(content: renderedView)
        renderer.scale = displayScale
        
        if let cgImage = renderer.cgImage {
            onConfirm(UIImage(cgImage: cgImage, scale: renderer.scale, orientation: .up))
        }
    }
}
