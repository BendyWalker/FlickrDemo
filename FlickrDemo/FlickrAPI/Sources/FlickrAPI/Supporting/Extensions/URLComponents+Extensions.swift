import Foundation

extension URLComponents {
    init<E>(for endpoint: E) where E: EndpointCategory, E: RawRepresentable, E.RawValue == String {
        self.init(string: API.baseUrl)!
        queryItems = [
            .init(name: "format", value: "json"),
            .init(name: "nojsoncallback", value: "1"),
            .init(name: "method", value: endpoint.method),
            .init(name: "api_key", value: API.key)
        ]
    }
}
