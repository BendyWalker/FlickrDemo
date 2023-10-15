import SwiftUI

enum SearchScope: String, CaseIterable {
    case freeText = "Free Text"
    case tags = "Tags"
}

struct SearchTag: Identifiable {
    let id = UUID()
    let name: String
}

@Observable class SearchViewModel {
    var photos = NetworkResource<[Photo]>.loading
    var query = "Yorkshire"
    var scope = SearchScope.freeText
    var tags = [SearchTag]()

    private let photosProvider: PhotosProviding

    private var searchTask: Task<Void, Error>?

    init(photosProvider: PhotosProviding = PhotosProvider()) {
        self.photosProvider = photosProvider
    }

    func search() {
        searchTask?.cancel()
        if scope == .freeText && query.isEmpty || scope == .tags && tags.isEmpty {
            photos = .loaded([])
        } else {
            photos = .loading
            searchTask = Task {
                try await Task.sleep(for: .seconds(0.5))
                do {
                    switch scope {
                    case .freeText:
                        let response = try await photosProvider.freeTextSearch(query)
                        photos = .loaded(response)
                    case .tags:
                        let response = try await photosProvider.tagSearch(tags.map { $0.name })
                        photos = .loaded(response)
                    }
                } catch {
                    photos = .failed(error)
                }
            }
        }
    }

    func tokenise() {
        if query.last == "," {
            if !query.dropLast().trimmingCharacters(in: .whitespaces).isEmpty {
                tags.append(SearchTag(name: String(query.dropLast())))
            }
            query.removeAll()
        }
    }
}
