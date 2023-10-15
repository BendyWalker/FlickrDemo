import XCTest
import SwiftUI

final class SearchTests: XCTestCase {
    func testNetworkResourceIsLoadingWhenFirstCreated() {
        let viewModel = SearchViewModel(photosProvider: MockPhotoProvider())
        XCTAssertEqual(viewModel.photos, .loading)
    }
    
    func testScopeIsFreeTextWhenFirstCreated() {
        let viewModel = SearchViewModel(photosProvider: MockPhotoProvider())
        XCTAssertEqual(viewModel.scope, .freeText)
    }
    
    func testNetworkResourceIsLoadedWhenFreeTextSearchQueryIsEmpty() {
        let viewModel = SearchViewModel(photosProvider: MockPhotoProvider())
        
        viewModel.scope = .freeText
        viewModel.query = ""
        viewModel.search()
        
        XCTAssertEqual(viewModel.photos, .loaded([]))
    }
    
    func testNetworkResourceIsLoadedWhenTagsIsEmpty() {
        let viewModel = SearchViewModel(photosProvider: MockPhotoProvider())
        
        viewModel.scope = .tags
        viewModel.tags = [SearchTag]()
        viewModel.search()
        
        XCTAssertEqual(viewModel.photos, .loaded([]))
    }
    
    func testNetworkResourceIsLoadedWhenFreeTextSearchSucceeds() {
        let successfulResponse: [Photo] = [.sample(id: "1"), .sample(id: "2"), .sample(id: "3")]
        let mockPhotoProvider = MockPhotoProvider(freeTextSearch: { successfulResponse })
        let viewModel = SearchViewModel(photosProvider: mockPhotoProvider)
        let expectation = XCTestExpectation(description: "Search completed.")
        
        viewModel.scope = .freeText
        viewModel.query = "test"
        viewModel.search()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            XCTAssertEqual(viewModel.photos, .loaded(successfulResponse))
            expectation.fulfill()
        }
        
        wait(for: [expectation])
    }
    
    func testNetworkResourceIsFailedWhenFreeTextSearchFails() {
        let mockError = MockError.oops
        let mockPhotoProvider = MockPhotoProvider(freeTextSearch: { throw mockError })
        let viewModel = SearchViewModel(photosProvider: mockPhotoProvider)
        let expectation = XCTestExpectation(description: "Search completed.")
        
        viewModel.scope = .freeText
        viewModel.query = "test"
        viewModel.search()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            XCTAssertEqual(viewModel.photos, .failed(mockError))
            expectation.fulfill()
        }
        
        wait(for: [expectation])
    }
    
    func testNetworkResourceIsLoadedWhenTagsSearchSucceeds() {
        let successfulResponse: [Photo] = [.sample(id: "1"), .sample(id: "2"), .sample(id: "3")]
        let mockPhotoProvider = MockPhotoProvider(tagSearch: { successfulResponse })
        let viewModel = SearchViewModel(photosProvider: mockPhotoProvider)
        let expectation = XCTestExpectation(description: "Search completed.")
        
        viewModel.scope = .tags
        viewModel.tags = [SearchTag(name: "test")]
        viewModel.search()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            XCTAssertEqual(viewModel.photos, .loaded(successfulResponse))
            expectation.fulfill()
        }
        
        wait(for: [expectation])
    }
    
    func testNetworkResourceIsFailedWhenTagsSearchFails() {
        let mockError = MockError.oops
        let mockPhotoProvider = MockPhotoProvider(tagSearch: { throw mockError })
        let viewModel = SearchViewModel(photosProvider: mockPhotoProvider)
        let expectation = XCTestExpectation(description: "Search completed.")
        
        viewModel.scope = .tags
        viewModel.tags = [SearchTag(name: "test")]
        viewModel.search()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            XCTAssertEqual(viewModel.photos, .failed(mockError))
            expectation.fulfill()
        }
        
        wait(for: [expectation])
    }
    
    func testTokeniseCreatesSearchTagWhenCommaIsEntered() {
        let viewModel = SearchViewModel(photosProvider: MockPhotoProvider())
        
        viewModel.query = "test"
        viewModel.tokenise()
        
        XCTAssertEqual(viewModel.query, "test")
        XCTAssertTrue(viewModel.tags.isEmpty)
        
        viewModel.query = "test,"
        viewModel.tokenise()
        
        XCTAssertEqual(viewModel.query, "")
        XCTAssertEqual(viewModel.tags.first?.name, "test")
    }
    
    func testTokeniseDiscardsEmptyStringCommaIsEntered() {
        let viewModel = SearchViewModel(photosProvider: MockPhotoProvider())
        
        viewModel.query = " "
        viewModel.tokenise()
        
        XCTAssertEqual(viewModel.query, " ")
        XCTAssertTrue(viewModel.tags.isEmpty)
        
        viewModel.query = " ,"
        viewModel.tokenise()
        
        XCTAssertEqual(viewModel.query, "")
        XCTAssertTrue(viewModel.tags.isEmpty)
    }
}
