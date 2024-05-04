import Combine

protocol PostDaoProtocol {
    func fetch() -> AnyPublisher<[DBPostModel], Error>
    func update(with postEntities: [PostEntity]) -> AnyPublisher<Void, Error>
}
