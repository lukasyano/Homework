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
        //Important! Rename this also if renaming CoreData entity name
        let entityName = "DBPostModel"
        
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
