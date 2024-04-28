import Alamofire
import Foundation

class WebService {
    let baseUrl = "https://jsonplaceholder.typicode.com"

    func fetchPosts(completion: @escaping ([Post]?, Error?) -> Void) {
        let url = "\(baseUrl)/posts"

        AF.request(url).responseDecodable(of: [Post].self) { response in
            switch response.result {
            case .success(let posts):
                completion(posts, nil)
            case .failure(let error):
                completion(nil, error.underlyingError)
            }
        }
    }

    func fetchUserData(userId: Int, completion: @escaping (User?, Error?) -> Void) {
        let url = "\(baseUrl)/users/\(userId)"

        AF.request(url).responseDecodable(of: User.self) { response in
            switch response.result {
            case .success(let user):
                completion(user, nil)
            case .failure(let error):
                completion(nil, error.underlyingError)
            }
        }
    }
}
