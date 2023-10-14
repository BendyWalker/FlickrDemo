import FlickrAPI
import Foundation

struct Photo: Identifiable, Equatable {
    let id: String
    let url: URL
    let title: String?
    let description: String?
    let takenOn: Date?
    let owner: Person?
    let tags: [String]?

    static let sample = Photo(
        id: "1",
        url: URL(string: "https://picsum.photos/200/300")!,
        title: "Example Photo",
        description: "An example photo with all fields filled.",
        takenOn: .now,
        owner: .sample,
        tags: ["tag1", "tag2"]
    )
}

extension Photo {
    init(from networkPhoto: FlickrAPI.Photo) {
        id = networkPhoto.id
        url = networkPhoto.url()
        title = networkPhoto.title
        description = networkPhoto.description
        takenOn = networkPhoto.dates?.takenOn
        owner = Person(from: networkPhoto.owner)
        tags = networkPhoto.tags?.list.map { $0.name }
    }
}

struct Person: Identifiable, Equatable {
    let id: String
    let username: String
    let buddyIconUrl: URL

    static let sample = Person(
        id: "1",
        username: "testuser",
        buddyIconUrl: URL(string: "https://picsum.photos/200/300)")!
    )
}

extension Person {
    init?(from networkPerson: FlickrAPI.Person?) {
        guard let networkPerson else { return nil }
        id = networkPerson.id
        username = networkPerson.username
        buddyIconUrl = networkPerson.buddyIconUrl
    }
}
