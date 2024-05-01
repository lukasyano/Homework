import Combine
import CoreData
import SwiftUI

struct PostsScreenView: View {
    @EnvironmentObject var viewModel: PostsViewModel

    var body: some View {
        NavigationStack {
            ZStack {
                List(viewModel.posts, id: \.self) { item in
                    VStack(alignment: .leading, spacing: 10) {
                        Text(item.postTitle)
                        HStack {
                            Spacer()
                            Text(item.userName)
                        }
                    }
                }
            }
            .navigationTitle("Posts")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: viewModel.clearAllData) {
                        Text("ClearDB")
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: viewModel.updateDb) {
                        Text("UpdateDb")
                    }
                }
            }
        }
    }
}
