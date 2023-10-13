import XCTest
@testable import FlickrAPI

func convertMock(named name: String) -> Data {
    guard let fileUrl = Bundle.module.url(forResource: name, withExtension: "json") else {
        fatalError()
    }
    
    do {
        return try Data(contentsOf: fileUrl)
    } catch {
        fatalError()
    }
}

final class DataToDecodableTests: XCTestCase {
    func testPhotosSearch() throws {
        let data = convertMock(named: "photosSearch")
        let decodedData = try JSONDecoder.FlickrAPI.decode(PhotoSearchResponse.self, from: data)
        let photos = decodedData.photos.list
        
        XCTAssertEqual(photos.count, 100)
        XCTAssertEqual(photos.first?.id, "53254719161")
    }
    
    func testPhotosGetInfo() throws {
        let data = convertMock(named: "photosGetInfo")
        let decodedData = try JSONDecoder.FlickrAPI.decode(PhotosGetInfoResponse.self, from: data)
        let photo = decodedData.photo
        
        XCTAssertEqual(photo.id, "53254719161")
    }
}
