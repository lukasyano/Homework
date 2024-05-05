import SwiftUI

struct PostsScreenView: View {
    @StateObject private var viewModel: PostsViewModel

    init(postRepository: PostRepositoryProtocol) {
        _viewModel = StateObject(wrappedValue: PostsViewModel(postRepository: postRepository))
    }

    var body: some View {
        NavigationStack {
            List(viewModel.posts) { postItem(item: $0) }
                .navigationTitle(String.postNavigationTitle)
                .refreshable { viewModel.refresh() }
                .alert(isPresented: $viewModel.showErrorAlert) { errorAlert }
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        if viewModel.isLoading { progressView }
                    }
                }
        }
    }

    fileprivate var progressView: some View {
        HStack(spacing: 8) {
            ProgressView()
            Text(String.loading)
        }
    }

    fileprivate var errorAlert: Alert {
        Alert(
            title: Text(String.error),
            message: Text(viewModel.uiError),
            primaryButton: .default(Text(String.retry)) {
                viewModel.refresh()
            },
            secondaryButton: .cancel()
        )
    }

    fileprivate func postItem(item: PostEntity) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(item.title)
            HStack(alignment: .bottom) {
                Text(item.author)
            }
        }
    }
}

#Preview {
    PostsScreenView(postRepository: PostRepository(postDao: PostDao(), api: ApiService()))
}
