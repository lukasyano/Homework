import SwiftUI

struct MainScreen: View {
    private let postRepository: PostRepositoryProtocol
    @StateObject var postsViewModel: PostsViewModel

    init(postRepository: PostRepositoryProtocol) {
        self.postRepository = postRepository
        self._postsViewModel = StateObject(wrappedValue: PostsViewModel(postRepository: postRepository))
    }

    var body: some View {
        PostsScreenView(viewModel: postsViewModel)
    }
}
