import SwiftUI

struct PostsScreenView: View {
    @StateObject private var viewModel: PostsViewModel

    init(postRepository: PostRepositoryProtocol) {
        _viewModel = StateObject(wrappedValue: PostsViewModel(postRepository: postRepository))
    }

    var body: some View {
        NavigationStack {
            List(viewModel.posts) { post in
                NavigationLink(destination: AboutUserView(postEntity: post)) {
                    postItem(item: post)
                }
            }
            .navigationTitle(String.postNavigationTitle)
            .listStyle(.plain)
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
                .font(.title3)
                .lineLimit(1)
            HStack(alignment: .bottom) {
                Text(item.author).font(.headline)
            }
        }
    }
}

#Preview {
    PostsScreenView(postRepository: PostRepository(postDao: PostDao(), api: ApiService()))
}
