import SwiftUI

class PostsViewModel: ObservableObject {
    private let postRepository: PostRepository
    private let userRepository: UserRepository
    private let coreDataController: CoreDataController

    init(postRepository: PostRepository, userRepository: UserRepository, coreDataController: CoreDataController) {
        self.postRepository = postRepository
        self.userRepository = userRepository
        self.coreDataController = coreDataController
        fetchPostsFromDb()
    }

    @Published var posts = [PostDetailsEntity]()

    func fetchPostsFromDb() {
        coreDataController.fetchPosts { dbPosts in
            self.posts = Mapper.mapFromDBToPostUserEntity(dbModel: dbPosts)
        }
    }

    func updateDb() {
        postRepository.getPosts { [weak self] postEntity, _ in
            guard let self = self, let postEntity = postEntity else { return }

            for post in postEntity {
                self.userRepository.getUser(post.userId) { userEntity, _ in
                    guard let userEntity = userEntity else { return }

                    let postDetailsEntity = PostDetailsEntity(postTitle: post.title, userName: userEntity.name)
                    self.coreDataController.saveToCoreData(postDetailsEntity)
                    self.fetchPostsFromDb()

                }
            }
        }
    }

    func clearAllData() {
        coreDataController.clearAllData()
        fetchPostsFromDb()
    }
}
