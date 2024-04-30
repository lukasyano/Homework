import Alamofire
import Foundation

class ApiService: ObservableObject {
    let baseUrl = "https://jsonplaceholder.typicode.com"

    func fetchPosts(completion: @escaping (AFDataResponse<[ApiPostModel]>) -> Void) {
        let postsUrL = "\(baseUrl)/posts"

        AF.request(postsUrL).responseDecodable(of: [ApiPostModel].self) { completion($0) }
    }

    func fetchUserData(userId: Int, completion: @escaping (AFDataResponse<ApiUserModel>) -> Void) {
        let userDataUrl = "\(baseUrl)/users/\(userId)"

        AF.request(userDataUrl).responseDecodable(of: ApiUserModel.self) { completion($0) }
    }
}
