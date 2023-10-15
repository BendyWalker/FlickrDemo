import SwiftUI

@Observable class SearchViewModel {
    public var photos = NetworkResource<[Photo]>.loading

    private let photosProvider: PhotosProviding
    
    private var searchTask: Task<Void, Error>?

    init(photosProvider: PhotosProviding = PhotosProvider()) {
        self.photosProvider = photosProvider
    }
    
    public func search(_ query: String) {
        searchTask?.cancel()
        if query.isEmpty {
            photos = .loaded([])
        } else {
            photos = .loading
            searchTask = Task {
                try await Task.sleep(for: .seconds(0.5))
                do {
                    let response = try await photosProvider.search(query)
                    photos = .loaded(response)
                } catch {
                    photos = .failed(error)
                }
            }
        }
    }
}
