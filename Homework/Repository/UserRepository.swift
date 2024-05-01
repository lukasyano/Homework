import SwiftUI

class UserRepository: ObservableObject {
    private let api: ApiService 
    
    init(api: ApiService) {
        self.api = api
    }

    func getUser(_ userId: Int, completion: @escaping (UserEntity?, Error?) -> Void) {
        api.fetchUserData(userId: userId) { apiUserModel in

            switch apiUserModel.result {
            case .success(let data):
                let userEntity = Mapper.mapUserFromApi(user: data)
                completion(userEntity, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
}
