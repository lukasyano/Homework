import SwiftUI

struct PostsScreenView: View {
    @ObservedObject var viewModel: PostsViewModel

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

struct PostsScreenView_Previews: PreviewProvider {
    static var previews: some View {
        let mockedViewModel = PostsViewModel(postRepository: PostRepository(postDao: PostDao(), api: ApiService()))
        PostsScreenView(viewModel: mockedViewModel)
    }
}
