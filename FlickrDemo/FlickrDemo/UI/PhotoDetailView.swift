import SwiftUI

struct PhotoDetailView: View {
    let photo: Photo

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                AsyncImage(url: photo.url) {
                    $0.resizable()
                } placeholder: {
                    Color.secondary.overlay {
                        Image(systemName: "photo")
                    }
                }
                .aspectRatio(contentMode: .fit)
                VStack(alignment: .leading) {
                    if let title = photo.title {
                        Text(title)
                            .font(.largeTitle)
                            .fontWeight(.bold
                            )
                    }
                    if let description = photo.description {
                        Text(description)
                            .font(.title2)
                    }
                    if let takenOn = photo.takenOn {
                        Text(takenOn.formatted(.dateTime.day().month().year().hour().minute()))
                    }
                    if let owner = photo.owner {
                        Button(action: {}, label: {
                            HStack {
                                (Text("See more by ") + Text(owner.username).fontWeight(.semibold))
                                    .multilineTextAlignment(.leading)
                                Spacer()
                                Image(systemName: "chevron.right")
                            }
                            .frame(maxWidth: .infinity, minHeight: 44)
                        })
                        .buttonStyle(.borderedProminent)
                    }
                }
                .padding(.horizontal)

                if let tags = photo.tags {
                    ScrollView(.horizontal) {
                        LazyHStack {
                            ForEach(tags, id: \.self) { tag in
                                Button(action: {}, label: {
                                    Text(tag)
                                        .italic()
                                })
                                .buttonStyle(.bordered)
                            }
                        }
                    }
                    .safeAreaPadding()
                }
            }
            Spacer()
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview("Preview") {
    NavigationStack {
        PhotoDetailView(photo: .sample())
    }
}
