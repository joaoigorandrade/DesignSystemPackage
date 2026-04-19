import SwiftUI

public typealias GPProofThumbView = GroupoolProofThumbnail

#Preview("Proof Thumbnails") {
    HStack(spacing: 12) {
        GPProofThumbView(label: "foto_1.jpg", subtitle: "Enviado ontem")
        GPProofThumbView(label: "video_2.mp4", subtitle: "3.2 MB")
    }
    .padding()
}
