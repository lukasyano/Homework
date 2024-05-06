import Combine
@testable import Homework
import XCTest

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
    
    func test_apiService_fetchPosts_shouldFetchNotEmpty() {
        let expectation = XCTestExpectation(description: "Fetch posts")
        
        let cancellable = apiService.fetchPosts()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    expectation.fulfill()
                case .failure(let error):
                    XCTFail(error.localizedDescription)
                }
            }, receiveValue: { posts in
                XCTAssertFalse(posts.isEmpty)
            })
        
        wait(for: [expectation], timeout: 5.0)
        cancellable.cancel()
    }
    
    func test_apiService_fetchUserData_shouldFetchUserWithSameIdWhichRequested() {
        let expectation = XCTestExpectation(description: "Fetch user data")
        
        let userId = 1
        let cancellable = apiService.fetchUserData(userId: userId)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    expectation.fulfill()
                case .failure(let error):
                    XCTFail(error.localizedDescription)
                }
            }, receiveValue: { user in
                XCTAssertEqual(user.id, userId)
            })
        
        wait(for: [expectation], timeout: 5.0)
        cancellable.cancel()
    }
}
