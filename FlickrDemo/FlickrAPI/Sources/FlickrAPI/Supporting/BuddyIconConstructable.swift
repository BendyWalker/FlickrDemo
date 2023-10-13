import Foundation

public protocol BuddyIconConstructable {
    var id: String { get }
    var iconFarm: Int { get }
    var iconServer: String { get }
}

public extension BuddyIconConstructable {
    var buddyIconUrl: URL {
        if let server = Int(iconServer), server > 0 {
            URL(string: "http://farm\(iconFarm).staticflickr.com/\(server)/buddyicons/\(id).jpg")!
        } else {
            URL(string: "https://www.flickr.com/images/buddyicon.gif")!
        }
    }
}
