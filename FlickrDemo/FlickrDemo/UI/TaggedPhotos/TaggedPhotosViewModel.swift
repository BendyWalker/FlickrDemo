import Foundation

@Observable class TaggedPhotosViewModel {
    public var photos: NetworkResource<[Photo]> = .loading
    
    private let photosProvider: PhotosProviding
    
    init(photosProvider: PhotosProviding = PhotosProvider()) {
        self.photosProvider = photosProvider
    }
    
    public func search(_ tag: String) async {
        do {
            let response = try await photosProvider.tagSearch([tag])
            photos = .loaded(response)
        } catch {
            photos = .failed(error)
        }
    }
}
