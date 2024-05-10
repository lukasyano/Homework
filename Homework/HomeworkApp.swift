import Combine
import SwiftUI

@main
struct HomeworkApp: App {
    private let postDao: PostDaoProtocol = PostDao()
    private let api: ApiServiceProtocol = ApiService()
    private let postRepository: PostRepositoryProtocol

    init() {
        self.postRepository = PostRepository(postDao: postDao, api: api)
    }

    var body: some Scene {
        WindowGroup {
            MainScreen(postRepository: postRepository)
        }
    }
}
