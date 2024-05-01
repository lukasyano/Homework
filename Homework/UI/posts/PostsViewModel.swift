import CoreData
import SwiftUI

class PostsViewModel: ObservableObject {
    private let postRepository: PostRepository
    private let userRepository: UserRepository
    private let managedObjectContext: NSManagedObjectContext

    init(postRepository: PostRepository, userRepository: UserRepository, managedObjectContext: NSManagedObjectContext) {
        self.postRepository = postRepository
        self.userRepository = userRepository
        self.managedObjectContext = managedObjectContext
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
        let dbPost = DBPostModel(context: managedObjectContext)
        dbPost.postTitle = postDetailsEntity.postTitle
        dbPost.userName = postDetailsEntity.userName

        do {
            try managedObjectContext.save()
        } catch {
            print("Failed to save data to Core Data: \(error)")
        }
    }
    
    func clearAllData() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "DBPostModel")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try managedObjectContext.execute(batchDeleteRequest)
            try managedObjectContext.save()
        } catch {
            print("Failed to clear data from Core Data: \(error)")
        }
    }

}
