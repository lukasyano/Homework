import Combine
import CoreData
@testable import Homework
import XCTest

class PostDaoTests: XCTestCase {
    var postDao: PostDao!
    var persistentContainer: NSPersistentContainer!

    override func setUp() {
        super.setUp()
        postDao = PostDao()
    }

    override func tearDown() {
        postDao = nil
        super.tearDown()
    }

    func test_PostDao_fetch_shouldFetchNotNilData() {
        let expectation = XCTestExpectation(description: "Fetch posts from CoreData")

        let cancellable = postDao.fetch()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    expectation.fulfill()
                case .failure(let error):
                    XCTFail(error.localizedDescription)
                }
            }, receiveValue: { dbPosts in
                XCTAssertNotNil(dbPosts)
            })

        wait(for: [expectation], timeout: 5.0)
        cancellable.cancel()
    }

    func test_PostDao_update_shouldDeleteExistingDataAndInsertNewProvided() {
        let expectation = XCTestExpectation(description: "Update posts in CoreData")

        let postEntity = PostEntity(
            id: UUID(),
            title: "Title",
            author: "",
            email: "",
            website: "",
            street: "",
            city: "",
            companyName: ""
        )

        let cancellable = postDao.update(with: [postEntity])
            .flatMap { _ in
                self.postDao.fetch()
            }
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    expectation.fulfill()
                case .failure(let error):
                    XCTFail(error.localizedDescription)
                }
            }, receiveValue: { dbPosts in
                XCTAssertEqual(dbPosts.count, 1)
                let updatedPost = dbPosts[0]
                XCTAssertNotNil(updatedPost)
                XCTAssertEqual(updatedPost.title, postEntity.title)
            })

        wait(for: [expectation], timeout: 5.0)
        cancellable.cancel()
    }
}
