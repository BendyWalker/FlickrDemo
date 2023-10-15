import Foundation

struct MockPhotoProvider: PhotosProviding {
    private let freeTextSearch: (() throws -> [Photo])?
    private let tagSearch: (() throws -> [Photo])?
    private let forUserId: (() throws -> [Photo])?
    
    init(
        freeTextSearch: (() throws -> [Photo])? = nil,
        tagSearch: (() throws -> [Photo])? = nil,
        forUserId: (() throws -> [Photo])? = nil
    ) {
        self.freeTextSearch = freeTextSearch
        self.tagSearch = tagSearch
        self.forUserId = forUserId
    }
    
    func freeTextSearch(_ query: String) async throws -> [Photo] {
        guard let freeTextSearch else { return [] }
        return try freeTextSearch()
    }
    
    func tagSearch(_ tags: [String]) async throws -> [Photo] {
        guard let tagSearch else { return [] }
        return try tagSearch()
    }
    
    func forUserId(_ id: String) async throws -> [Photo] {
        guard let forUserId else { return [] }
        return try forUserId()
    }
}
