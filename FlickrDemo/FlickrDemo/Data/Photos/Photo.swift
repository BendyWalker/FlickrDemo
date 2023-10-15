import FlickrAPI
import Foundation

struct Photo: Identifiable, Equatable, Hashable {
    let id: String
    let url: URL
    let title: String?
    let description: String?
    let takenOn: Date?
    let owner: Person?
    let tags: [String]?

    static func sample(id: String = UUID().uuidString) -> Photo {
        Photo(
            id: id,
            url: URL(string: "https://picsum.photos/200/300")!,
            title: "Example Photo",
            description: "An example photo with all fields filled.",
            takenOn: .now,
            owner: .sample(),
            tags: (1 ... 15).map { "tag\($0)" }
        )
    }
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

struct Person: Identifiable, Equatable, Hashable {
    let id: String
    let username: String
    let buddyIconUrl: URL

    static func sample(id: String = UUID().uuidString) -> Person {
        Person(
            id: id,
            username: "testuser",
            buddyIconUrl: URL(string: "https://picsum.photos/200/300)")!
        )
    }
}

extension Person {
    init?(from networkPerson: FlickrAPI.Person?) {
        guard let networkPerson else { return nil }
        id = networkPerson.id
        username = networkPerson.username
        buddyIconUrl = networkPerson.buddyIconUrl
    }
}
