import Combine

class PostRepository: PostRepositoryProtocol, ObservableObject {
    private let dao: PostDaoProtocol
    private let api: ApiServiceProtocol

    init(postDao: PostDaoProtocol, api: ApiServiceProtocol) {
        self.dao = postDao
        self.api = api
    }

    func getPostsFromApi() -> AnyPublisher<[PostEntity], Error> {
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

    func getPostsFromDatabase() -> AnyPublisher<[DBPostModel], Error> {
        return dao.fetch()
    }

    func updateDatabase(with posts: [PostEntity]) -> AnyPublisher<Void, Error> {
        return dao.update(with: posts)
    }
}
