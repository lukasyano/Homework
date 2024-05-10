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
