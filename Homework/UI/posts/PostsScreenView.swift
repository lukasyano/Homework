import SwiftUI

struct PostsScreenView: View {
    @EnvironmentObject var viewModel: PostsViewModel

    var body: some View {
        NavigationStack {
            VStack {
                List(viewModel.posts, id: \.self) { item in
                    postItem(item: item)
                }.overlay {
                    if viewModel.isLoading {
                        ProgressView()
                    }
                }
            }
            .navigationTitle("Posts")
            .refreshable { viewModel.refresh() }
            .alert(isPresented: $viewModel.showErrorAlert) {
                errorAlert
            }
        }
    }

    private var errorAlert: Alert {
        Alert(
            title: Text("Error"),
            message: Text(viewModel.uiError),
            primaryButton: .default(Text("Retry")) {
                viewModel.refresh()
            },
            secondaryButton: .cancel()
        )
    }

    fileprivate func postItem(item: PostEntity) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(item.title)
            HStack {
                Spacer()
                Text(item.author)
            }
        }
    }
}
