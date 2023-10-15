import Foundation

public enum People {
    /// Returns a list of public stub photos taken by the user ID.
    public static func publicPhotos(forUserId id: String) async throws -> [PhotoSearchResult] {
        let endpoint = API.Endpoint.People.publicPhotos

        var components = URLComponents(for: endpoint)
        components.queryItems?.append(contentsOf: [
            .init(name: "user_id", value: id),
            .init(name: "safe_search", value: "1")
        ])

        let decodedData: PhotoSearchResponse =
            try await URLSession.shared.decodedData(from: components.url!)
        return decodedData.photos.list
    }
}
