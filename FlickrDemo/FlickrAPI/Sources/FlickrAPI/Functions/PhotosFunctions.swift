import Foundation

public enum Photos {
    /// Returns a list of stub photos whose title, description or tags contain the provided query string.
    public static func search(_ query: String) async throws -> [PhotoSearchResult] {
        let endpoint = API.Endpoint.Photos.search

        var components = URLComponents(for: endpoint)
        components.queryItems?.append(contentsOf: [
            .init(name: "text", value: query),
            .init(name: "safe_search", value: "1")
        ])

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
