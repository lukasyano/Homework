import Combine
import SwiftUI

@main
struct HomeworkApp: App {
    private var postDao: PostDaoProtocol = PostDao()
    private let api: ApiServiceProtocol = ApiService()

    var body: some Scene {
        let postRepository: PostRepositoryProtocol = PostRepository(postDao: postDao, api: api)

        WindowGroup {
            MainScreen(postRepository: postRepository)
        }
    }
}
