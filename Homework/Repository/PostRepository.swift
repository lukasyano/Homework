import Combine
import SwiftUI

class PostRepository: ObservableObject {
    private let dataController: CoreDataController
    private let api: ApiService

    init(dataController: CoreDataController, api: ApiService) {
        self.dataController = dataController
        self.api = api
    }

    func getPosts() -> AnyPublisher<[PostEntity], Error> {
        return api.fetchPosts()
            .flatMap { posts -> AnyPublisher<[PostEntity], Error> in
                let postDetailsPublishers = posts.map { post in
                    self.api.fetchUserData(userId: post.userId)
                        .map { userData in
                            Mapper.mapFromApi(post: post, user: userData)
                        }
                        .eraseToAnyPublisher()
                }
                return Publishers.MergeMany(postDetailsPublishers).collect().eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }

    func fetchPostsFromDb() -> AnyPublisher<[DBPostModel], Error> {
        return dataController.fetchFromDB()
    }

    func saveToCoreData(_ posts: [PostEntity]) -> AnyPublisher<Void, Error> {
        return Publishers.MergeMany(dataController.saveToCoreData(posts))
            .collect()
            .map { _ in }
            .eraseToAnyPublisher()
    }

    func clearAllData() -> AnyPublisher<Void, Error> {
        return dataController.clearAllData()
    }
}
