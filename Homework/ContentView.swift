import SwiftUI

struct ContentView: View {
    @State var message = ""

    var body: some View {
        let webService = WebService()

        NavigationStack {
            VStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                Text("Hello, world!")

                Text(message)
            }
            .onAppear {
                
                webService.fetchPosts { posts, error in
                    if let error = error {
                        message = error.localizedDescription
                    }
                    if let posts = posts {
                        message = posts.debugDescription
                    }
                }
                
                webService.fetchUserData(userId: 1) { user, error in
                    if let user = user{
                        message = user.address
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
