import XCTest
import Combine
@testable import Homework

class ApiServiceTests: XCTestCase {
    
    var apiService: ApiService!
    
    override func setUp() {
        super.setUp()
        apiService = ApiService()
    }
    
    override func tearDown() {
        apiService = nil
        super.tearDown()
    }
    
    func testFetchPosts() {
        let expectation = XCTestExpectation(description: "Fetch posts")
        
        let cancellable = apiService.fetchPosts()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    expectation.fulfill()
                case .failure(let error):
                    XCTFail("Failed to fetch posts with error: \(error.localizedDescription)")
                }
            }, receiveValue: { posts in
                XCTAssertFalse(posts.isEmpty, "Posts should not be empty")
            })
        
        wait(for: [expectation], timeout: 5.0)
        cancellable.cancel()
    }
    
    func testFetchUserData() {
        let expectation = XCTestExpectation(description: "Fetch user data")
        
        let userId = 1
        let cancellable = apiService.fetchUserData(userId: userId)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    expectation.fulfill()
                case .failure(let error):
                    XCTFail("Failed to fetch user data with error: \(error.localizedDescription)")
                }
            }, receiveValue: { user in
                XCTAssertEqual(user.id, userId, "User ID should match the requested")
            })
        
        wait(for: [expectation], timeout: 5.0)
        cancellable.cancel()
    }
}
