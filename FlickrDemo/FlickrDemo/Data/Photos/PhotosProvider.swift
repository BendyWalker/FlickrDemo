import FlickrAPI
import SwiftUI

enum PhotosProvider {
    
    static func search(_ query: String) async throws -> [Photo] {
        var photos = [FlickrAPI.Photo]()
        for result in try await FlickrAPI.Photos.search(query) {
            photos.append(try await FlickrAPI.Photos.getInfo(forId: result.id))
        }
        return photos.map { Photo(from: $0) }
    }
}
