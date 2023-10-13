import Foundation

public struct Person: Decodable, Identifiable, BuddyIconConstructable {
    public let id: String
    public let username: String
    public let iconFarm: Int
    public let iconServer: String
    
    enum CodingKeys: String, CodingKey {
        case id = "nsid"
        case username
        case iconFarm = "iconfarm"
        case iconServer = "iconserver"
    }
}
