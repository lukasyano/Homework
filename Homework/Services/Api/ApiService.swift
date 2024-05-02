import Alamofire
import Combine
import Foundation

protocol ApiServiceProtocol {
    func fetchPosts() -> AnyPublisher<[ApiPostModel], Error>
    func fetchUserData(userId: Int) -> AnyPublisher<ApiUserModel, Error>
}

class ApiService: ApiServiceProtocol {
    let baseUrl = "https://jsonplaceholder.typicode.com"

    func fetchPosts() -> AnyPublisher<[ApiPostModel], Error> {
        let postsUrl = "\(baseUrl)/posts"

        return AF.request(postsUrl)
            .publishDecodable(type: [ApiPostModel].self)
            .value()
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }

    func fetchUserData(userId: Int) -> AnyPublisher<ApiUserModel, Error> {
        let userDataUrl = "\(baseUrl)/users/\(userId)"

        return AF.request(userDataUrl)
            .publishDecodable(type: ApiUserModel.self)
            .value()
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
}
