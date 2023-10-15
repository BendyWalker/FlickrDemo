import Foundation

enum API {
    static let key = "456d20aa22305cb89039cf73a528c40d"
    static let secret = "5d0b3cedbb5862dd"
    static let baseUrl = "https://api.flickr.com/services/rest"
    
    enum Endpoint {
        enum Photos: String, EndpointCategory {
            case search
            case info = "getInfo"
            
            var category: String { "photos" }
        }
        
        enum People: String, EndpointCategory {
            case publicPhotos = "getPublicPhotos"
            
            var category: String { "people" }
        }
    }
}
