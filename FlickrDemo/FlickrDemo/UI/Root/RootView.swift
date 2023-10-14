import SwiftUI

struct RootView: View {
    @State private var viewModel = RootViewModel()

    @State private var searchQuery = "Yorkshire"
    @State private var searchTask: Task<Void, Error>?

    var body: some View {
        NavigationStack {
            ZStack {
                switch viewModel.photos {
                case .loading:
                    ProgressView()
                case .loaded(let photos):
                    List(photos) {
                        AsyncImage(url: $0.url)
                    }
                    .listStyle(.plain)
                case .failed:
                    ContentUnavailableView(
                        "No Images Found",
                        systemImage: "camera.on.rectangle.fill",
                        description: Text("Check the spelling in your search term or try something else.")
                    )
                }
            }
            .navigationTitle("FlickrDemo")
            .searchable(text: $searchQuery)
            .onChange(of: searchQuery, initial: true) {
                searchTask?.cancel()
                searchTask = Task {
                    viewModel.photos = .loading
                    try await Task.sleep(for: .seconds(0.5))
                    await viewModel.search(searchQuery)
                }
            }
        }
    }
}

#Preview {
    RootView()
}
