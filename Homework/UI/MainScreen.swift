import SwiftUI

struct MainScreen: View {
    let postRepository: PostRepositoryProtocol
    
    init(postRepository: PostRepositoryProtocol) {
        self.postRepository = postRepository
    }
    
    var body: some View {
        PostsScreenView(postRepository: postRepository)
    }
}
