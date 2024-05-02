import Combine
import SwiftUI

class PostsViewModel: ObservableObject {
    private let postRepository: PostRepository

    @Published var posts = [PostEntity]()

    private var cancellables = Set<AnyCancellable>()

    init(postRepository: PostRepository) {
        self.postRepository = postRepository
        fetchPostsFromDb()
        observeDbChanges()
    }

    private func observeDbChanges() {
        NotificationCenter.default
            .publisher(for: .NSManagedObjectContextDidSave)
            .sink { [weak self] _ in
                self?.fetchPostsFromDb()
            }
            .store(in: &cancellables)
    }

    func fetchPostsFromDb() {
        postRepository.fetchPostsFromDb { [weak self] dbPosts in
            if dbPosts.isEmpty {
                self?.updateDb()
            }
            else {
                self?.posts = Mapper.mapFromDB(dbModel: dbPosts)
            }
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
            }, receiveValue: { posts in
                self.postRepository.saveToCoreData(posts)
            })
            .store(in: &cancellables)
    }
    
    func refreshDb(){
        postRepository.clearAllData()
    }

}
