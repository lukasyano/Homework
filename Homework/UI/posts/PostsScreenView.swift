import SwiftUI

struct PostsScreenView: View {
//    @EnvironmentObject private var vm: PostsViewModel
//    @FetchRequest(sortDescriptors: []) var data: FetchedResults<DBPostModel>

    var body: some View {
        NavigationStack {
            ZStack {
                Color.red.ignoresSafeArea().grayscale(0.7)

//                List(data, id: \.self) { entity in
//                    Text("\(String(describing: entity.postTitle)) \(String(describing: entity.userName))")
//                }
            }
        }

        .navigationTitle("Posts")
        .navigationBarTitleDisplayMode(.inline)
    }
}
