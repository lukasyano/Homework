import CoreData
import Foundation

class DataController: ObservableObject {
    let container: NSPersistentContainer

    init() {
        container = NSPersistentContainer(name: "Homework")
        loadPersistentStores()
    }

    private func loadPersistentStores() {
        container.loadPersistentStores { _, error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
}
