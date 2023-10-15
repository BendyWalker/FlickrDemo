import SwiftUI

struct SearchView: View {
    @State var viewModel = SearchViewModel()

    @State private var shouldInitiallyFetch = true
    @State private var searchQuery = "Yorkshire"

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
        .searchable(text: $searchQuery)
        .onChange(of: searchQuery, initial: shouldInitiallyFetch) {
            shouldInitiallyFetch = false
            viewModel.search(searchQuery)
        }
    }
}

#Preview("Data") {
    NavigationStack {
        SearchView(viewModel: SearchViewModel(
            photosProvider: MockPhotoProvider(search: {
                (0 ... 50).map { _ in Photo.sample() }
            })))
    }
}

#Preview("No Data") {
    NavigationStack {
        SearchView(viewModel: SearchViewModel(
            photosProvider: MockPhotoProvider(search: {
                [Photo]()
            })))
    }
}

#Preview("Error") {
    NavigationStack {
        SearchView(viewModel: SearchViewModel(
            photosProvider: MockPhotoProvider(search: {
                throw MockError.oops
            })))
    }
}
