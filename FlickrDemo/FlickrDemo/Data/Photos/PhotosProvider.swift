import FlickrAPI
import Foundation

protocol PhotosProviding {
    func search(_ query: String) async throws -> [Photo]
}

struct PhotosProvider: PhotosProviding {
    func search(_ query: String) async throws -> [Photo] {
        try await withThrowingTaskGroup(of: FlickrAPI.Photo.self) { group in
            let results = try await FlickrAPI.Photos.search(query)
            for result in results {
                group.addTask {
                    try await FlickrAPI.Photos.getInfo(forId: result.id)
                }
            }
            return try await group
                .reduce(into: []) { $0.append($1) }
                .map { Photo(from: $0) }
        }
    }
}
