import Combine

class PostRepository: PostRepositoryProtocol, ObservableObject {
    private let dao: PostDao
    private let api: ApiService

    init(dataController: PostDao, api: ApiService) {
        self.dao = dataController
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
