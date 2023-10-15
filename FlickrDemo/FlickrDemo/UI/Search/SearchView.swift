import SwiftUI

struct SearchView: View {
    @State var viewModel = SearchViewModel()

    @State private var searchQuery = "Yorkshire"

    var body: some View {
        NavigationStack {
            ZStack {
                switch viewModel.photos {
                case .loading:
                    ProgressView()
                case .loaded(let photos):
                    if photos.isEmpty {
                        ContentUnavailableView(
                            "Start Typing",
                            systemImage: "magnifyingglass",
                            description: Text("Start typing to search for cool photos!")
                        )
                    } else {
                        List(photos) {
                            SearchResultView(
                                photoUrl: $0.url,
                                ownerUsername: $0.owner?.username,
                                ownerBuddyIconUrl: $0.owner?.buddyIconUrl,
                                photoTags: $0.tags
                            )
                            .listRowSeparator(.hidden)
                        }
                        .listStyle(.plain)
                    }
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
                viewModel.search(searchQuery)
            }
        }
    }
}

private struct SearchResultView: View {
    let photoUrl: URL
    let ownerUsername: String?
    let ownerBuddyIconUrl: URL?
    let photoTags: [String]?

    var body: some View {
        AsyncImage(url: photoUrl) {
            $0.resizable()
        } placeholder: {
            Color.secondary.overlay {
                Image(systemName: "photo")
            }
        }
        .cropped(aspectRatio: 4.0 / 3.0)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .shadow(radius: 4)
        .overlay(alignment: .topLeading) {
            if let ownerUsername {
                OwnerView(
                    username: ownerUsername,
                    buddyIconUrl: ownerBuddyIconUrl
                )
                .padding(8)
            }
        }
        .overlay(alignment: .bottomTrailing) {
            if let photoTags, !photoTags.isEmpty {
                TagView(tags: photoTags)
                    .padding(8)
            }
        }
    }
}

private struct OwnerView: View {
    let username: String
    let buddyIconUrl: URL?

    var body: some View {
        HStack(spacing: 6) {
            AsyncImage(url: buddyIconUrl) {
                $0.resizable()
            } placeholder: {
                Color.white.overlay {
                    Image(systemName: "person.crop.circle.fill")
                }
            }
            .cropped()
            .frame(width: 20)
            .clipShape(Circle())
            Text(username)
                .lineLimit(1)
        }
        .padding(4)
        .padding(.trailing, 2)
        .fontWeight(.semibold)
        .modifier(ChipViewModifier())
    }
}

private struct TagView: View {
    let tags: [String]

    var body: some View {
        Text(tagString)
            .italic()
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .modifier(ChipViewModifier())
    }

    var tagString: String {
        let toDisplayCount = 3
        var string = tags.prefix(toDisplayCount).joined(separator: ", ")
        if tags.count > toDisplayCount {
            string.append(" + \(tags.count - toDisplayCount) more")
        }
        return string
    }
}

private struct ChipViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(.regularMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 6))
            .shadow(radius: 2)
    }
}

#Preview("Data") {
    let mockViewModel = SearchViewModel(photosProvider: MockPhotoProvider {
        (0 ... 50).map { _ in Photo.sample() }
    })
    return SearchView(viewModel: mockViewModel)
}

#Preview("No Data") {
    let mockViewModel = SearchViewModel(photosProvider: MockPhotoProvider {
        [Photo]()
    })
    return SearchView(viewModel: mockViewModel)
}

#Preview("Error") {
    let mockViewModel = SearchViewModel(photosProvider: MockPhotoProvider {
        throw MockError.oops
    })
    return SearchView(viewModel: mockViewModel)
}
