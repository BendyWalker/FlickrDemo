import XCTest

final class RootTests: XCTestCase {
    func testNetworkResourceIsLoadingWhenFirstCreated() async {
        let viewModel = RootViewModel()
        XCTAssertEqual(viewModel.photos, .loading)
    }
    
    func testNetworkResourceIsLoadedWhenDataFetchSucceeds() async {
        let successfulResponse: [Photo] = [.sample, .sample, .sample]
        let mockPhotoProvider = MockPhotoProvider { successfulResponse }
        let viewModel = RootViewModel(photosProvider: mockPhotoProvider)
        
        await viewModel.search("")
        
        XCTAssertEqual(viewModel.photos, .loaded(successfulResponse))
    }
    
    func testNetworkResourceIsFailedWhenDataFetchFails() async {
        let mockError = MockError.oops
        let mockPhotoProvider = MockPhotoProvider { throw mockError }
        let viewModel = RootViewModel(photosProvider: mockPhotoProvider)
        
        await viewModel.search("")
        
        XCTAssertEqual(viewModel.photos, .failed(mockError))
    }
}
