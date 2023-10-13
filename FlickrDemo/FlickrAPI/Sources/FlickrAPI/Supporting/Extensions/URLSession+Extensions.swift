import Foundation

extension URLSession {
    func decodedData<T: Decodable>(from url: URL) async throws -> T {
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder.FlickrAPI.decode(T.self, from: data)
    }
}
