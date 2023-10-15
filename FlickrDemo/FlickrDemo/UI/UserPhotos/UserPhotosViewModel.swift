import SwiftUI

@Observable class UserPhotosViewModel {
    public var photos: NetworkResource<[Photo]> = .loading
    
    private let photosProvider: PhotosProviding
    
    init(photosProvider: PhotosProviding = PhotosProvider()) {
        self.photosProvider = photosProvider
    }
    
    public func fetch(forUserId id: String) async {
        do {
            let response = try await photosProvider.forUserId(id)
            photos = .loaded(response)
        } catch {
            photos = .failed(error)
        }
    }
}
