import CoreData
import SwiftUI

class PostsViewModel: ObservableObject {
    @Environment(\.managedObjectContext) var moc
    
    private let postRepository: PostRepository
    private let userRepository: UserRepository
    
    init(postRepository: PostRepository, userRepository: UserRepository) {
        self.postRepository = postRepository
        self.userRepository = userRepository
    }
    
}
