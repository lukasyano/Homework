import SwiftUI

struct PostsScreenView: View {
    @EnvironmentObject var viewModel: PostsViewModel

    @State private var showAlert = false
    @State private var isRefresing = false

    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    List(viewModel.posts, id: \.self) { item in
                        NavigationLink {
                            Color.black
                        } label: {
                            VStack(alignment: .leading, spacing: 10) {
                                Text(item.title)
                                HStack {
                                    Spacer()
                                    Text(item.author)
                                }
                            }
                        }
                    }
                    .disabled(isRefresing)
                    .overlay(isRefresing ? ProgressView() : nil, alignment: .center)
                }
            }
            .navigationTitle("Posts")
            .refreshable {
                viewModel.refreshDb()
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Error"),
                    message: Text(viewModel.uiError),
                    primaryButton: .default(Text("Retry")) {
                        viewModel.refreshDb()
                    },
                    secondaryButton: .cancel()
                )
            }
        }
        .onReceive(viewModel.$posts, perform: { posts in
            print(posts.count)
        })
        .onReceive(viewModel.$uiError) { error in
            if !error.isEmpty {
                showAlert = true
            }
        }
    }
}
