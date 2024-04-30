import SwiftUI

struct MainScreen: View {
//    @EnvironmentObject var api: ApiService
    var body: some View {
        NavigationStack {
            VStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                Text("Hello, world!")
            }
        }
    }
}

#Preview {
    MainScreen()
}
