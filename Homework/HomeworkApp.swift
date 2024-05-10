import SwiftUI

@main
struct HomeworkApp: App {
    var body: some Scene {
        WindowGroup {
            MainScreen()
                .environmentObject(DependencyContainer())
        }
    }
}

class DependencyContainer: ObservableObject {
    private let api: ApiServiceProtocol = ApiService()
    private let dao: PostDaoProtocol = PostDao()
    private let postRepository: PostRepositoryProtocol

    init() {
        self.postRepository = PostRepository(postDao: dao, api: api)
    }
}

protocol ViewModelProvider {
    func makePostsViewModel() -> PostsViewModel
}

extension DependencyContainer: ViewModelProvider {
    func makePostsViewModel() -> PostsViewModel {
        return PostsViewModel(postRepository: postRepository)
    }
}
