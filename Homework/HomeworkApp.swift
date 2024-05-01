import SwiftUI

@main
struct HomeworkApp: App {
    @StateObject private var dataController = DataController()
    private let apiService = ApiService()
    var body: some Scene {
        WindowGroup {
            let postRepository = PostRepository(api: apiService)
            let userRepository = UserRepository(api: apiService)
            let postsViewModel = PostsViewModel(
                postRepository: postRepository,
                userRepository: userRepository,
                moc: dataController.container.viewContext
            )

            MainScreen()
                .environmentObject(postRepository)
                .environmentObject(userRepository)
                .environmentObject(postsViewModel)
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
