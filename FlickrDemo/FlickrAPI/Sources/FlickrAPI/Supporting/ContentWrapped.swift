import Foundation

struct ContentWrapper<T: Decodable>: Decodable {
    let content: T?
    
    enum CodingKeys: String, CodingKey {
        case content = "_content"
    }
}

/// Parses the underlying value for JSON fields wrapped in unnecessary `content` objects.
@propertyWrapper
public struct ContentWrapped<T: Decodable>: Decodable {
    public let wrappedValue: T?
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.wrappedValue = try container.decode(ContentWrapper<T>.self).content
    }
}
