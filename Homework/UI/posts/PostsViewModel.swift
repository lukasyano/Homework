import CoreData
import SwiftUI

class PostsViewModel: ObservableObject {
    private let postRepository: PostRepository
    private let userRepository: UserRepository
    private let moc: NSManagedObjectContext

    init(postRepository: PostRepository, userRepository: UserRepository, moc: NSManagedObjectContext) {
        self.postRepository = postRepository
        self.userRepository = userRepository
        self.moc = moc
        fetchPostsFromDb()
    }

    @Published var posts = [PostDetailsEntity]()

    func fetchPostsFromDb() {
        let fetchRequest: NSFetchRequest<DBPostDetailsModel> = DBPostDetailsModel.fetchRequest()
        do {
            let dbPosts = try moc.fetch(fetchRequest)
            posts = Mapper.mapFromDBToPostUserEntity(dbModel: dbPosts)
            
        } catch {
            print("Failed to fetch posts: \(error)")
        }
    }

    func updateDb() {
        postRepository.getPosts { [weak self] postEntity, _ in
            guard let self = self, let postEntity = postEntity else { return }

            for post in postEntity {
                userRepository.getUser(post.userId) { userEntity, _ in
                    guard let userEntity = userEntity else { return }

                    let postDetailsEntity = PostDetailsEntity(postTitle: post.title, userName: userEntity.name)
                    self.saveToCoreData(postDetailsEntity)
                }
            }
        }
    }

    func saveToCoreData(_ postDetailsEntity: PostDetailsEntity) {
        let dbPost = DBPostDetailsModel(context: moc)
        dbPost.postTitle = postDetailsEntity.postTitle
        dbPost.userName = postDetailsEntity.userName

        do { try moc.save() } catch {
            print("Failed to save data to Core Data: \(error)")
        }
        fetchPostsFromDb()
    }

    func clearAllData() {
        let entityName = "DBPostDetailsModel"
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: entityName)
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try moc.execute(batchDeleteRequest)
            try moc.save()
        } catch {
            print("Failed to clear data from Core Data: \(error)")
        }
        fetchPostsFromDb()
    }
}
