import Combine

protocol ApiServiceProtocol {
    func fetchPosts() -> AnyPublisher<[ApiPostModel], Error>
    func fetchUserData(userId: Int) -> AnyPublisher<ApiUserModel, Error>
}
