import XCTest

final class TaggedPhotosTests: XCTestCase {
    func testNetworkResourceIsLoadingWhenFirstCreated() {
        let viewModel = TaggedPhotosViewModel(photosProvider: MockPhotoProvider())
        XCTAssertEqual(viewModel.photos, .loading)
    }
    
    func testNetworkResourceIsLoadedWhenDataFetchSucceeds() async {
        let successfulResponse: [Photo] = [.sample(id: "1"), .sample(id: "2"), .sample(id: "3")]
        let mockPhotoProvider = MockPhotoProvider(tagSearch: { successfulResponse })
        let viewModel = TaggedPhotosViewModel(photosProvider: mockPhotoProvider)
        
        await viewModel.search("tag")
        
        XCTAssertEqual(viewModel.photos, .loaded(successfulResponse))
    }
    
    func testNetworkResourceIsFailedWhenDataFetchFails() async {
        let mockError = MockError.oops
        let mockPhotoProvider = MockPhotoProvider(tagSearch: { throw mockError })
        let viewModel = TaggedPhotosViewModel(photosProvider: mockPhotoProvider)
        
        await viewModel.search("tag")

        XCTAssertEqual(viewModel.photos, .failed(mockError))
    }
}
