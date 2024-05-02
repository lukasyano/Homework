import Alamofire
import Combine
import SwiftUI

class PostRepository: ObservableObject {
    private let api: ApiService

    init(api: ApiService) {
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
}
