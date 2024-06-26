import Combine
import CoreData

class PostDao: ObservableObject, PostDaoProtocol {
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

    func fetch() -> AnyPublisher<[DBPostModel], Error> {
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

    func update(with postEntities: [PostEntity]) -> AnyPublisher<Void, Error> {
        return Future<Void, Error> { promise in
            self.moc.perform {
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: self.entityName)
                let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

                do {
                    try self.moc.execute(batchDeleteRequest)

                    postEntities.forEach { postEntity in
                        let dbPost = DBPostModel(context: self.moc)
                        dbPost.populate(from: postEntity)
                    }

                    try self.moc.save()
                    promise(.success(()))
                } catch {
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
}
