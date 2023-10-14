import Foundation
import FlickrAPI

struct Photo: Identifiable {
    let id: String
    let url: URL
    let title: String?
    let description: String?
    let takenOn: Date?
    let owner: Person?
    let tags: [String]?
    
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

struct Person: Identifiable {
    let id: String
    let username: String
    let buddyIconUrl: URL
    
    init?(from networkPerson: FlickrAPI.Person?) {
        guard let networkPerson else { return nil }
        id = networkPerson.id
        username = networkPerson.username
        buddyIconUrl = networkPerson.buddyIconUrl
    }
}
