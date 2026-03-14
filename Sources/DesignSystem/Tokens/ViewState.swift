import Foundation

public enum ViewState: Equatable {
    case idle
    case loading
    case success
    case error(String)
}
