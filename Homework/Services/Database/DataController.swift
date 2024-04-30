import CoreData
import Foundation

class DataController: ObservableObject {
    @Published var errorMessage: String = ""
    let container: NSPersistentContainer

    init() {
        container = NSPersistentContainer(name: "Homework")
        loadPersistentStores()
    }

    private func loadPersistentStores() {
        container.loadPersistentStores { _, error in
            if let error = error {
                self.errorMessage = error.localizedDescription
            }
        }
    }
}
