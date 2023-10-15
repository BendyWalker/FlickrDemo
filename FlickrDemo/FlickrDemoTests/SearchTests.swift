import XCTest

final class SearchTests: XCTestCase {
    func testNetworkResourceIsLoadingWhenFirstCreated() {
        let viewModel = SearchViewModel(photosProvider: MockPhotoProvider())
        XCTAssertEqual(viewModel.photos, .loading)
    }
    
    func testNetworkResourceIsLoadedWhenSearchQueryIsEmpty() {
        let viewModel = SearchViewModel(photosProvider: MockPhotoProvider())
        
        viewModel.search("")
        
        XCTAssertEqual(viewModel.photos, .loaded([]))
    }
    
    func testNetworkResourceIsLoadedWhenDataFetchSucceeds() {
        let successfulResponse: [Photo] = [.sample(id: "1"), .sample(id: "2"), .sample(id: "3")]
        let mockPhotoProvider = MockPhotoProvider(search: { successfulResponse })
        let viewModel = SearchViewModel(photosProvider: mockPhotoProvider)
        let expectation = XCTestExpectation(description: "Search completed.")
        
        viewModel.search("test")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            XCTAssertEqual(viewModel.photos, .loaded(successfulResponse))
            expectation.fulfill()
        }
        
        wait(for: [expectation])
    }
    
    func testNetworkResourceIsFailedWhenDataFetchFails() {
        let mockError = MockError.oops
        let mockPhotoProvider = MockPhotoProvider(search: { throw mockError })
        let viewModel = SearchViewModel(photosProvider: mockPhotoProvider)
        let expectation = XCTestExpectation(description: "Search completed.")
        
        viewModel.search("test")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            XCTAssertEqual(viewModel.photos, .failed(mockError))
            expectation.fulfill()
        }
        
        wait(for: [expectation])
    }
}
