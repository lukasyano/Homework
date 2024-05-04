import Combine

protocol PostRepositoryProtocol {
    func getPostsFromApi() -> AnyPublisher<[PostEntity], Error>
    func getPostsFromDatabase() -> AnyPublisher<[DBPostModel], Error>
    func updateDatabase(with posts: [PostEntity]) -> AnyPublisher<Void, Error>
}
