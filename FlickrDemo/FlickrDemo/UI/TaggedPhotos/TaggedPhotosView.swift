import SwiftUI

struct TaggedPhotosView: View {
    @State var viewModel = TaggedPhotosViewModel()

    var tag: String

    var body: some View {
        ZStack {
            switch viewModel.photos {
            case .loading:
                ProgressView()
            case .loaded(let photos):
                PhotoList(photos: photos)
            case .failed:
                ContentUnavailableView(
                    "No Images Found",
                    systemImage: "camera.on.rectangle.fill",
                    description: Text("Something must have gone wrong; sorry about that!"))
            }
        }
        .navigationTitle(tag)
        .task {  await viewModel.search(tag) }
    }
}

#Preview("Data") {
    NavigationStack {
        TaggedPhotosView(
            viewModel: TaggedPhotosViewModel(
                photosProvider: MockPhotoProvider(tagSearch: {
                    (0 ... 50).map { _ in Photo.sample() }
                })),
            tag: "tag"
        )
    }
}

#Preview("No Data") {
    NavigationStack {
        TaggedPhotosView(
            viewModel: TaggedPhotosViewModel(
                photosProvider: MockPhotoProvider(tagSearch: {
                    [Photo]()
                })),
            tag: "tag"
        )
    }
}

#Preview("Error") {
    NavigationStack {
        TaggedPhotosView(
            viewModel: TaggedPhotosViewModel(
                photosProvider: MockPhotoProvider(tagSearch: {
                    throw MockError.oops
                })),
            tag: "tag"
        )
    }
}
