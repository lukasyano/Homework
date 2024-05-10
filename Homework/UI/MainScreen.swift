import SwiftUI

struct MainScreen: View {
    @EnvironmentObject var dependencyContainer: DependencyContainer

    var body: some View {
        PostsScreenView(viewModel: dependencyContainer.makePostsViewModel())
    }
}
