import SwiftUI

public typealias GPOTPBoxView = GroupoolOTPCell

#Preview("OTP Boxes") {
    HStack(spacing: 8) {
        GPOTPBoxView("1")
        GPOTPBoxView("2")
        GPOTPBoxView("3")
        GPOTPBoxView("")
        GPOTPBoxView("")
        GPOTPBoxView("")
    }
    .padding()
}
