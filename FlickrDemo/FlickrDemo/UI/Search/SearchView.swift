import SwiftUI

struct SearchView: View {
    @State var viewModel = SearchViewModel()

    @State private var hasInitiallyFetched = false

    var body: some View {
        ZStack {
            switch viewModel.photos {
            case .loading:
                ProgressView()
            case .loaded(let photos):
                if photos.isEmpty {
                    ContentUnavailableView(
                        "Start Typing",
                        systemImage: "magnifyingglass",
                        description: Text("Start typing to search for cool photos!"))
                } else {
                    PhotoList(photos: photos)
                }
            case .failed:
                ContentUnavailableView(
                    "No Images Found",
                    systemImage: "camera.on.rectangle.fill",
                    description: Text("Check the spelling in your search term or try something else."))
            }
        }
        .navigationTitle("FlickrDemo")
        .searchable(text: $viewModel.query, editableTokens: $viewModel.tags) { token in
            Text(token.wrappedValue.name)
        }
        .searchScopes($viewModel.scope, activation: .onSearchPresentation, {
            ForEach(SearchScope.allCases, id: \.self) {
                Text($0.rawValue).tag($0)
            }
        })
        .onSubmit(of: .search) {
            viewModel.search()
        }
        .onChange(of: viewModel.query) {
            if viewModel.scope == .tags {
                viewModel.tokenise()
            }
        }
        .onChange(of: viewModel.scope) {
            viewModel.query.removeAll()
            viewModel.tags.removeAll()
        }
        .task {
            if !hasInitiallyFetched {
                viewModel.search()
                hasInitiallyFetched = true
            }
        }
    }
}

#Preview("Data") {
    NavigationStack {
        SearchView(viewModel: SearchViewModel(
            photosProvider: MockPhotoProvider(freeTextSearch: {
                (0 ... 50).map { _ in Photo.sample() }
            })))
    }
}

#Preview("No Data") {
    NavigationStack {
        SearchView(viewModel: SearchViewModel(
            photosProvider: MockPhotoProvider(freeTextSearch: {
                [Photo]()
            })))
    }
}

#Preview("Error") {
    NavigationStack {
        SearchView(viewModel: SearchViewModel(
            photosProvider: MockPhotoProvider(freeTextSearch: {
                throw MockError.oops
            })))
    }
}
