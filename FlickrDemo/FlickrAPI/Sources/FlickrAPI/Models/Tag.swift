import Foundation

public struct Tag: Decodable, Identifiable {
    public let id: String
    public let name: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name = "raw"
    }
}
