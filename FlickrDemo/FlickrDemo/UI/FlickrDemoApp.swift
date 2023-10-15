import SwiftUI

enum Path: Hashable {
    case photoDetails(photo: Photo)
}

@main
struct FlickrDemoApp: App {
    @State private var path = [Path]()

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $path) {
                SearchView()
            }
        }
    }
}
