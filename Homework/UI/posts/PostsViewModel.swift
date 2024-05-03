import Combine
import SwiftUI

class PostsViewModel: ObservableObject {
    private let postRepository: PostRepository

    @Published var posts = [PostEntity]()
    @Published var uiError: String = ""

    private var cancellables = Set<AnyCancellable>()

    init(postRepository: PostRepository) {
        self.postRepository = postRepository
        setUpDb()
    }

    private func setUpDb() {
        fetchPostsFromDb()
        observeDbChanges()
    }

    private func observeDbChanges() {
        NotificationCenter.default
            .publisher(for: .NSManagedObjectContextDidSave)
            .sink { [weak self] _ in
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
                    self?.fetchPostsFromDb()
                }
            }
            .store(in: &cancellables)
    }

    func updateUiPosts(dbPosts: [DBPostModel]) {
        posts = Mapper.mapFromDB(dbModel: dbPosts)
    }

    func fetchPostsFromDb() {
        postRepository.fetchPostsFromDb()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished: break
                case .failure(let error):
                    self.uiError = error.localizedDescription
                }
            }, receiveValue: { dbPosts in

                if !dbPosts.isEmpty {
                    self.updateUiPosts(dbPosts: dbPosts)
                } else {
                    self.refreshDb()
                }
            })
            .store(in: &cancellables)
    }

    func refreshDb() {
        postRepository.getPosts()
            .receive(on: DispatchQueue.main)
            .flatMap { [weak self] posts -> AnyPublisher<Void, Error> in
                guard let self = self else { return Empty().eraseToAnyPublisher() }

                return postRepository.updateDB(with: posts)
                    .eraseToAnyPublisher()
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
}
