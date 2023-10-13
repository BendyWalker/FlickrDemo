import Foundation

protocol EndpointCategory {
    /// The root category for the endpoint definition, e.g. `photos`.
    var category: String { get }
}

extension EndpointCategory where Self: RawRepresentable, RawValue == String {
    /// Value to be supplied as a `method` query item to call a specific endpoint.
    var method: String {
        ["flickr", category, rawValue].joined(separator: ".")
    }
}
