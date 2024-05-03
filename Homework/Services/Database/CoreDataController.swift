import Combine
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

    func fetchFromDB() -> AnyPublisher<[DBPostModel], Error> {
        let fetchRequest = DBPostModel.fetchRequest()
        return Future<[DBPostModel], Error> { promise in
            do {
                let dbPosts = try self.moc.fetch(fetchRequest)
                promise(.success(dbPosts))
            } catch {
                promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }

    func saveToCoreData(_ postEntities: [PostEntity]) -> AnyPublisher<Void, Error> {
        return Future<Void, Error> { promise in
            self.moc.perform {
                postEntities.forEach { postEntity in
                    let dbPost = DBPostModel(context: self.moc)
                    dbPost.title = postEntity.title
                    dbPost.author = postEntity.author
                    dbPost.email = postEntity.email
                    dbPost.website = postEntity.website
                    dbPost.street = postEntity.street
                    dbPost.city = postEntity.city
                    dbPost.companyName = postEntity.companyName
                }

                do {
                    try self.moc.save()
                    promise(.success(()))
                } catch {
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }

    func clearAllData() -> AnyPublisher<Void, Error> {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        return Future<Void, Error> { promise in
            do {
                try self.moc.execute(batchDeleteRequest)
                try self.moc.save()
                promise(.success(()))
            } catch {
                promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }
}
