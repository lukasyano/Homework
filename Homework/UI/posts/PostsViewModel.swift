import Combine
import CoreData
import SwiftUI

class PostsViewModel: ObservableObject {
    private let postRepository: PostRepository
    private let coreDataController: CoreDataController

    private var cancellables = Set<AnyCancellable>()

    init(postRepository: PostRepository, coreDataController: CoreDataController) {
        self.postRepository = postRepository
        self.coreDataController = coreDataController
        fetchPostsFromDb()
        observeDbChanges()
    }

    @Published var posts = [PostEntity]()

    private func observeDbChanges() {
        NotificationCenter.default.publisher(for: .NSManagedObjectContextDidSave, object: coreDataController.moc)
            .sink { [weak self] _ in
                self?.fetchPostsFromDb()
            }
            .store(in: &cancellables)
    }


    func fetchPostsFromDb() {
        coreDataController.fetchPosts { dbPosts in
            self.posts = Mapper.mapFromDB(dbModel: dbPosts)
        }
    }

    func updateDb() {
        postRepository.getPosts()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Finished fetching posts.")
                case .failure(let error):
                    print("Error fetching posts: \(error)")
                }
            }, receiveValue: { postDetails in

                for post in postDetails {
                    self.coreDataController.saveToCoreData(post)
                }

            }).store(in: &cancellables)
    }

    func clearAllData() {
        coreDataController.clearAllData()
    }

}
