import CoreData
import Foundation

class DataController: ObservableObject {
    @Published var error: String = ""
    let container: NSPersistentContainer

    init() {
        container = NSPersistentContainer(name: "Homework")
        loadPersistentStores()
    }

    private func loadPersistentStores() {
        container.loadPersistentStores { description, error in
            if let error = error {
                self.error = error.localizedDescription
            }
        }
    }
}
