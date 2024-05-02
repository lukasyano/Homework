import SwiftUI

@main
struct HomeworkApp: App {
    @StateObject private var coreDataController = CoreDataController()
    private let apiService = ApiService()

    var body: some Scene {
        WindowGroup {
            let postRepository = PostRepository(api: apiService)
//            let userRepository = UserRepository(api: apiService)
            let postsViewModel = PostsViewModel(
                postRepository: postRepository,
//                userRepository: userRepository,
                coreDataController: coreDataController
            )

            MainScreen()
                .environmentObject(postRepository)
//                .environmentObject(userRepository)
                .environmentObject(postsViewModel)
                .environment(\.managedObjectContext, coreDataController.container.viewContext)
        }
    }
}
