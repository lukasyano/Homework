import Combine
import SwiftUI

@main
struct HomeworkApp: App {
    private var postDao: PostDaoProtocol = PostDao()
    private let api: ApiServiceProtocol = ApiService()

    var body: some Scene {
        let postRepository = PostRepository(postDao: postDao, api: api)
        let postsViewModel = PostsViewModel(postRepository: postRepository)
        WindowGroup {
            MainScreen()
                .environmentObject(postRepository)
                .environmentObject(postsViewModel)
        }
    }
}
