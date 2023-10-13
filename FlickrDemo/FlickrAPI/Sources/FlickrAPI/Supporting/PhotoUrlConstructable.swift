import Foundation

public enum SizeSuffix: String {
    case medium800 = "c"
}

public protocol PhotoUrlConstructable {
    var id: String { get }
    var server: String { get }
    var secret: String { get }
}

public extension PhotoUrlConstructable {
    func url(sizeSuffix: SizeSuffix = .medium800) -> URL {
        URL(string: "https://live.staticflickr.com/\(server)/\(id)_\(secret)_\(sizeSuffix.rawValue).jpg")!
    }
}
