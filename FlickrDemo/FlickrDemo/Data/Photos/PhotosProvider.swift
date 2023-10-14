import FlickrAPI
import Foundation

struct PhotosProvider: PhotosProviding {
    func search(_ query: String) async throws -> [Photo] {
        var photos = [FlickrAPI.Photo]()
        for result in try await FlickrAPI.Photos.search(query) {
            try photos.append(await FlickrAPI.Photos.getInfo(forId: result.id))
        }
        return photos.map { Photo(from: $0) }
    }
}
