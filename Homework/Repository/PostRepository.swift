import SwiftUI

class PostRepository: ObservableObject {
    private let api: ApiService 
    
    init(api: ApiService) {
        self.api = api
    }

    func getPosts(completion: @escaping ([PostEntity]?, Error?) -> Void) {
        api.fetchPosts { apiPostResponse in

            switch apiPostResponse.result {
            case .success(let data):
                let listPostsEntity = Mapper.mapPostsFromApi(posts: data)
                completion(listPostsEntity, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
}
