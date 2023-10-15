import FlickrAPI
import Foundation

protocol PhotosProviding {
    func search(_ query: String) async throws -> [Photo]
    func forUserId(_ id: String) async throws -> [Photo]
}

struct PhotosProvider: PhotosProviding {
    func search(_ query: String) async throws -> [Photo] {
        let stubs = try await FlickrAPI.Photos.search(query)
        return try await inflateStubs(stubs)
    }
    
    func forUserId(_ id: String) async throws -> [Photo] {
        let stubs = try await FlickrAPI.People.publicPhotos(forUserId: id)
        return try await inflateStubs(stubs)
    }
    
    private func inflateStubs(_ stubs: [PhotoSearchResult]) async throws -> [Photo] {
        try await withThrowingTaskGroup(of: FlickrAPI.Photo.self) { group in
            for stub in stubs {
                group.addTask {
                    try await FlickrAPI.Photos.getInfo(forId: stub.id)
                }
            }
            return try await group
                .reduce(into: []) { $0.append($1) }
                .map { Photo(from: $0) }
        }
    }
}
