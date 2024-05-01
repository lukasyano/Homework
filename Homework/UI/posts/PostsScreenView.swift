import SwiftUI

struct PostsScreenView: View {
    @EnvironmentObject var viewModel: PostsViewModel
    @FetchRequest(sortDescriptors: []) var posts: FetchedResults<DBPostModel>

    var body: some View {
        NavigationStack {
            ZStack {
                List(posts, id: \.self) { item in
                    VStack(alignment: .leading, spacing: 10) {
                        Text(item.postTitle ?? "Unknown")
                        HStack {
                            Spacer()
                            Text(item.userName ?? "Unknown")
                        }
                    }
                }
            }
            .navigationTitle("Posts")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        viewModel.clearAllData()
                        DispatchQueue.main.async {
                            self.viewModel.objectWillChange.send()
                        }
                    } label: {
                        Text("ClearDB")
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        viewModel.updateDb()
                    } label: {
                        Text("UpdateDb")
                    }
                }
            }
        }
    }
}

//                    Text("\(item.userName) + \(item.postTitle)")
