import SwiftUI

@main
struct HomeworkApp: App {
    @StateObject private var dataController = DataController()
    @StateObject private var api = ApiService()
    var body: some Scene {
        WindowGroup {
            MainScreen()
                .environmentObject(api)
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
