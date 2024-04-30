import SwiftUI

struct PostsScreenView: View {
    @EnvironmentObject private var postRepository : PostRepository
    var body: some View {
        NavigationStack {
            ZStack {
                Color.red.ignoresSafeArea().grayscale(0.7)
            }
            .onAppear{
                postRepository.getPosts { postEntity, error in
                    if let postEntity = postEntity{
                        print(postEntity)
                        print("Count: \(postEntity.count)")
                    }
                }
            }
            .navigationTitle("Posts")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    PostsScreenView()
}
