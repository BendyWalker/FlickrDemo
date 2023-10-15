import Foundation

public enum Photos {
    public enum Search {
        case text(String)
        case tags([String])
    }

    /// Returns a list of stub photos whose title, description or tags contain the provided query string.
    public static func search(_ searchType: Search) async throws -> [PhotoSearchResult] {
        let endpoint = API.Endpoint.Photos.search

        var components = URLComponents(for: endpoint)
        components.queryItems?.append(contentsOf: [
            .init(name: "safe_search", value: "1")
        ])
        
        switch searchType {
        case .text(let string):
            components.queryItems?.append(.init(name: "text", value: string))
        case .tags(let array):
            components.queryItems?.append(.init(name: "tags", value: array.joined(separator: ",")))
        }

        let decodedData: PhotoSearchResponse =
            try await URLSession.shared.decodedData(from: components.url!)
        return decodedData.photos.list
    }

    /// Returns a photo matching the given photo ID.
    public static func getInfo(forId id: String) async throws -> Photo {
        let endpoint = API.Endpoint.Photos.info

        var components = URLComponents(for: endpoint)
        components.queryItems?.append(contentsOf: [
            .init(name: "photo_id", value: id)
        ])

        let decodedData: PhotosGetInfoResponse =
            try await URLSession.shared.decodedData(from: components.url!)
        return decodedData.photo
    }
}
