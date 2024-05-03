import Combine

protocol DataControllerProtocol {
    func fetchFromDB() -> AnyPublisher<[DBPostModel], Error>
    func updateDB(with postEntities: [PostEntity]) -> AnyPublisher<Void, Error>
}
