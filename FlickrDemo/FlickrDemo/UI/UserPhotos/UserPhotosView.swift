import SwiftUI

struct UserPhotosView: View {
    @State var viewModel = UserPhotosViewModel()

    var user: Person

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
        .navigationTitle(user.username)
        .task {  await viewModel.fetch(forUserId: user.id) }
    }
}

#Preview("Data") {
    NavigationStack {
        UserPhotosView(
            viewModel: UserPhotosViewModel(
                photosProvider: MockPhotoProvider(forUserId: {
                    (0 ... 50).map { _ in Photo.sample() }
                })),
            user: .sample()
        )
    }
}

#Preview("No Data") {
    NavigationStack {
        UserPhotosView(
            viewModel: UserPhotosViewModel(
                photosProvider: MockPhotoProvider(forUserId: {
                    [Photo]()
                })),
            user: .sample()
        )
    }
}

#Preview("Error") {
    NavigationStack {
        UserPhotosView(
            viewModel: UserPhotosViewModel(
                photosProvider: MockPhotoProvider(forUserId: {
                    throw MockError.oops
                })),
            user: .sample()
        )
    }
}
