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
        getPostsAndUpdateDatabase()
        observeDatabaseChanges()
    }

    private func fetchPostsFromDb() {
        postRepository.fetchPostsFromDb()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished: break
                case let .failure(error):
                    self?.handleUiError(error)
                }
            }, receiveValue: { [weak self] dbPosts in
                self?.updateUiPosts(dbPosts: dbPosts)
            })
            .store(in: &cancellables)
    }

    func refresh(){
        getPostsAndUpdateDatabase()
    }
    
    private func getPostsAndUpdateDatabase() {
        postRepository.getPosts()
            .flatMap { [weak self] posts -> AnyPublisher<Void, Error> in
                guard let self = self else { return Empty().eraseToAnyPublisher() }

                return self.updateDatabase(with: posts)
            }
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished: break
                case let .failure(error):
                    self?.handleUiError(error)
                }
            }, receiveValue: { _ in })
            .store(in: &cancellables)
    }

    private func updateDatabase(with posts: [PostEntity]) -> AnyPublisher<Void, Error> {
        postRepository.updateDB(with: posts)
            .eraseToAnyPublisher()
    }

    private func observeDatabaseChanges() {
        NotificationCenter.default
            .publisher(for: .NSManagedObjectContextDidSave)
            .debounce(for: .milliseconds(600), scheduler: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.fetchPostsFromDb()
            }
            .store(in: &cancellables)
    }

    private func updateUiPosts(dbPosts: [DBPostModel]) {
        guard !dbPosts.isEmpty else { return }
        posts = Mapper.mapFromDB(dbModel: dbPosts)
    }

    private func handleUiError(_ error: Error) {
        uiError = error.localizedDescription
    }
}
