import CoreData
import Foundation

class CoreDataController: ObservableObject {
    let container: NSPersistentContainer
    let moc: NSManagedObjectContext

    init() {
        container = NSPersistentContainer(name: "Homework")
        moc = container.viewContext
        loadPersistentStores()
    }

    private func loadPersistentStores() {
        container.loadPersistentStores { _, error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }

    func fetchPosts(completion: @escaping ([DBPostDetailsModel]) -> Void) {
        let fetchRequest = DBPostDetailsModel.fetchRequest()
        do {
            let dbPosts = try moc.fetch(fetchRequest)
            completion(dbPosts)
        } catch {
            print("Failed to fetch posts: \(error)")
            completion([])
        }
    }

    func saveToCoreData(_ postDetailsEntity: PostDetailsEntity) {
        moc.perform {
            let dbPost = DBPostDetailsModel(context: self.moc)
            dbPost.postTitle = postDetailsEntity.postTitle
            dbPost.userName = postDetailsEntity.userName

            do { try self.moc.save() }
            catch { print("Failed to save data to Core Data: \(error)") }
        }
    }

    func clearAllData() {
        let entityName = "DBPostDetailsModel"
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try moc.execute(batchDeleteRequest)
            try moc.save()
        } catch {
            print("Failed to clear data from Core Data: \(error)")
        }
    }
}
