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
        api.fetchPosts()
            .flatMap { posts in

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

    func fetchPostsFromDb(completion: @escaping ([DBPostModel]) -> Void) {
        dataController.fetchFromDB { posts in
            completion(posts)
        }
    }

    func saveToCoreData(_ posts: [PostEntity]) {        
        for post in posts {
            dataController.saveToCoreData(post)
        }
    }

    func clearAllData() {
        dataController.clearAllData()
    }
}
