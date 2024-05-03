import SwiftUI

@main
struct HomeworkApp: App {
    @StateObject private var dbController = CoreDataController()
    private let apiService = ApiService()

    var body: some Scene {
        WindowGroup {
            let postRepository = PostRepository(dataController: dbController, api: apiService)
            let postsViewModel = PostsViewModel(postRepository: postRepository)

            MainScreen()
                .environmentObject(postRepository)
                .environmentObject(postsViewModel)
        }
    }
}
