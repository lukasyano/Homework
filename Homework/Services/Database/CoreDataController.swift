import CoreData
import Foundation

class CoreDataController: ObservableObject {
    let container: NSPersistentContainer
    let moc: NSManagedObjectContext

    let containerName = "Homework"
    let entityName = "DBPostModel"

    init() {
        container = NSPersistentContainer(name: containerName)
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

    func fetchPosts(completion: @escaping ([DBPostModel]) -> Void) {
        let fetchRequest = DBPostModel.fetchRequest()
        do {
            let dbPosts = try moc.fetch(fetchRequest)
            completion(dbPosts)
        } catch {
            print("Failed to fetch posts: \(error)")
            completion([])
        }
    }

    func saveToCoreData(_ postEntity: PostEntity) {
        moc.perform {
            let dbPost = DBPostModel(context: self.moc)

            dbPost.title = postEntity.title
            dbPost.author = postEntity.author
            dbPost.email = postEntity.email
            dbPost.website = postEntity.website
            dbPost.street = postEntity.street
            dbPost.city = postEntity.city
            dbPost.companyName = postEntity.companyName

            do { try self.moc.save() }
            catch { print("Failed to save data to Core Data: \(error)") }
        }
    }

    func clearAllData() {
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
