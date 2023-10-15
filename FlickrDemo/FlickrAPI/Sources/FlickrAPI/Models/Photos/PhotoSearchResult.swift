import Foundation

/// Abbrieviated set of photo data fields sent down when searching.
public struct PhotoSearchResult: Decodable, Identifiable, PhotoUrlConstructable {
    public let id: String
    public let server: String
    public let secret: String
    public let owner: String
}

struct PhotoSearchResponse: Decodable {
    let photos: PhotoSearchResultList
    
    enum CodingKeys: String, CodingKey {
        case photos = "photos"
    }
    
    struct PhotoSearchResultList: Decodable {
        let list: [PhotoSearchResult]
        
        enum CodingKeys: String, CodingKey {
            case list = "photo"
        }
    }
}
