import SwiftUI

@Observable class RootViewModel {
    public var photos = NetworkResource<[Photo]>.loading

    private let photosProvider: PhotosProviding

    init(photosProvider: PhotosProviding = PhotosProvider()) {
        self.photosProvider = photosProvider
    }

    public func search(_ query: String = "Yorkshire") async {
        photos = .loading
        do {
            photos = try .loaded(await photosProvider.search(query))
        } catch {
            photos = .failed(error)
        }
    }
}
