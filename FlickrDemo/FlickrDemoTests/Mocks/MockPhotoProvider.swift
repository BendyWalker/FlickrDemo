import Foundation

struct MockPhotoProvider: PhotosProviding {
    private let search: () throws -> [Photo]
    
    init(search: @escaping () throws -> [Photo]) {
        self.search = search
    }
    
    func search(_ query: String) async throws -> [Photo] {
        try search()
    }
}
