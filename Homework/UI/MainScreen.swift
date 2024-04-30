import SwiftUI

struct MainScreen: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Color.red.ignoresSafeArea().grayscale(0.7)
                
            }
            .navigationTitle("Posts")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    MainScreen()
}
