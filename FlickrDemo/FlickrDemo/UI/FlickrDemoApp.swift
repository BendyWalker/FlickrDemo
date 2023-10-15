import SwiftUI

enum Path: Hashable {
    case photoDetails(photo: Photo)
    case userPhotos(user: Person)
    case taggedPhotos(tag: String)
}

@main
struct FlickrDemoApp: App {
    @State private var path = [Path]()

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $path) {
                SearchView()
                    .navigationDestination(for: Path.self) { path in
                        switch path {
                        case .photoDetails(let photo):
                            PhotoDetailView(photo: photo)
                        case .userPhotos(let user):
                            UserPhotosView(user: user)
                        case .taggedPhotos(let tag):
                            TaggedPhotosView(tag: tag)
                        }
                    }
            }
        }
    }
}
