import SwiftUI

@main
struct HomeworkApp: App {
    @StateObject private var dataController = DataController()
    private let apiService = ApiService()
    var body: some Scene {
        WindowGroup {
            MainScreen()
                .environmentObject(PostRepository(api: apiService))
                .environmentObject(UserRepository(api: apiService))
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
