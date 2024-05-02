import Combine
import SwiftUI

class PostsViewModel: ObservableObject {
    private let postRepository: PostRepository

    @Published var posts = [PostEntity]()
    @Published var uiError: String = ""

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
        postRepository.fetchPostsFromDb()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished: break
                case .failure(let error):
                    print("Error fetching posts from DB: \(error)")
                }
            }, receiveValue: { dbPosts in
                self.posts = Mapper.mapFromDB(dbModel: dbPosts)
            })
            .store(in: &cancellables)
    }

    func refreshDb() {
        postRepository.getPosts()
            .flatMap { [weak self] posts -> AnyPublisher<Void, Error> in
                guard let self = self else { return Empty().eraseToAnyPublisher() }

                return self.postRepository.clearAllData()
                    .flatMap { _ in
                        self.postRepository.saveToCoreData(posts)
                    }.eraseToAnyPublisher()
            }
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished: break
                case .failure(let error):
                    self.uiError = error.localizedDescription
                }
            }, receiveValue: { _ in })
            .store(in: &cancellables)
    }

//    func refreshDb(){
//        postRepository.clearAllData()
//    }
}
