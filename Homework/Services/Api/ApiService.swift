import Combine
import Foundation

class ApiService: ApiServiceProtocol {
    let baseUrl = "https://jsonplaceholder.typicode.com"

    func fetchPosts() -> AnyPublisher<[ApiPostModel], Error> {
        guard let postsUrl = URL(string: "\(baseUrl)/posts") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: postsUrl)
            .mapError { $0 as Error }
            .map { $0.data }
            .decode(type: [ApiPostModel].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }

    func fetchUserData(userId: Int) -> AnyPublisher<ApiUserModel, Error> {
        guard let userDataUrl = URL(string: "\(baseUrl)/users/\(userId)") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: userDataUrl)
            .mapError { $0 as Error }
            .map { $0.data }
            .decode(type: ApiUserModel.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
