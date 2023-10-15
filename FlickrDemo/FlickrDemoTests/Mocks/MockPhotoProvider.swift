import Foundation

struct MockPhotoProvider: PhotosProviding {
    private let search: (() throws -> [Photo])?
    private let forUserId: (() throws -> [Photo])?
    
    init(
        search: (() throws -> [Photo])? = nil,
        forUserId: (() throws -> [Photo])? = nil
    ) {
        self.search = search
        self.forUserId = forUserId
    }
    
    func search(_ query: String) async throws -> [Photo] {
        guard let search else { return [] }
        return try search()
    }
    
    func forUserId(_ id: String) async throws -> [Photo] {
        guard let forUserId else { return [] }
        return try forUserId()
    }
}
