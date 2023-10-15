import XCTest

final class UserPhotosTests: XCTestCase {
    func testNetworkResourceIsLoadingWhenFirstCreated() {
        let viewModel = UserPhotosViewModel(photosProvider: MockPhotoProvider())
        XCTAssertEqual(viewModel.photos, .loading)
    }
    
    func testNetworkResourceIsLoadedWhenDataFetchSucceeds() async {
        let successfulResponse: [Photo] = [.sample(id: "1"), .sample(id: "2"), .sample(id: "3")]
        let mockPhotoProvider = MockPhotoProvider(forUserId: { successfulResponse })
        let viewModel = UserPhotosViewModel(photosProvider: mockPhotoProvider)
        
        await viewModel.fetch(forUserId: "")
        
        XCTAssertEqual(viewModel.photos, .loaded(successfulResponse))
    }
    
    func testNetworkResourceIsFailedWhenDataFetchFails() async {
        let mockError = MockError.oops
        let mockPhotoProvider = MockPhotoProvider(forUserId: { throw mockError })
        let viewModel = UserPhotosViewModel(photosProvider: mockPhotoProvider)
        
        await viewModel.fetch(forUserId: "")

        XCTAssertEqual(viewModel.photos, .failed(mockError))
    }
}
