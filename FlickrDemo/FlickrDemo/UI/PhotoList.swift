import SwiftUI

struct PhotoList: View {
    let photos: [Photo]

    var body: some View {
        List(photos) { photo in
            ZStack {
                NavigationLink(value: Path.photoDetails(photo: photo)) {
                    EmptyView()
                }
                SearchResultView(
                    photoUrl: photo.url,
                    ownerUsername: photo.owner?.username,
                    ownerBuddyIconUrl: photo.owner?.buddyIconUrl,
                    photoTags: photo.tags
                )
            }
            .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
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

#Preview("PhotoList") {
    PhotoList(photos: (0 ... 10).map { _ in .sample() })
}
