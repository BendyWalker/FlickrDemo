import Foundation

/// Full set of photo data fields.
public struct Photo: Decodable, Identifiable, PhotoUrlConstructable {
    public let id: String
    public let server: String
    public let secret: String
    
    @ContentWrapped public var title: String?
    @ContentWrapped public var description: String?
    
    public var dates: Dates?
    public var owner: Person?
    public var tags: TagList?

    public struct Dates: Decodable {
        public let takenOn: Date
        
        enum CodingKeys: String, CodingKey {
            case takenOn = "taken"
        }
    }
    
    public struct TagList: Decodable {
        public let list: [Tag]
        
        enum CodingKeys: String, CodingKey {
            case list = "tag"
        }
    }
}

struct PhotosGetInfoResponse: Decodable {
    let photo: Photo
}
