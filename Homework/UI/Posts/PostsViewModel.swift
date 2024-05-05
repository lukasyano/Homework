import Combine
import SwiftUI

class PostsViewModel: ObservableObject {
    private let repository: PostRepositoryProtocol

    @Published var posts = [PostEntity]()
    @Published var uiError: String = ""
    @Published var showErrorAlert: Bool = false
    @Published var isLoading: Bool = false

    private var cancellables = Set<AnyCancellable>()

    init(postRepository: PostRepositoryProtocol) {
        self.repository = postRepository
        setUpDatabase()
    }

    private func setUpDatabase() {
        fetchPostsFromDb()
        getNewPostsAndUpdateDatabase()
        observeDatabaseChanges()
    }

    private func fetchPostsFromDb() {
        repository.getPostsFromDatabase()
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

    private func getNewPostsAndUpdateDatabase() {
        isLoading = true
        repository.getPostsFromApi()
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
        repository.updateDatabase(with: posts)
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

        DispatchQueue.main.async { [weak self] in
            self?.isLoading = false
            self?.posts = Mapper.mapFromDB(dbModel: dbPosts)
        }
    }

    private func handleUiError(_ error: Error) {
        DispatchQueue.main.async { [weak self] in
            self?.isLoading = false
            self?.showErrorAlert = true
            self?.uiError = error.localizedDescription
        }
    }

    func refresh() {
        getNewPostsAndUpdateDatabase()
    }
}
