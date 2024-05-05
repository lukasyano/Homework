import SwiftUI

struct AboutUserView: View {
    let postEntity: PostEntity

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(postEntity.title)
                .font(.title)
                .fontWeight(.bold)
            Divider()

            Text(String.email + (postEntity.email))
            Text(String.website + (postEntity.website))
            Text(String.address)
                .fontWeight(.bold)
            Text("\(postEntity.street), \(postEntity.city)")
                .padding(.leading, 20)
            Divider()

            Text(String.company)
                .fontWeight(.bold)
            Text(postEntity.companyName)

            Spacer()
        }
        .padding(20)
        .navigationTitle(postEntity.author)
        .navigationBarTitleDisplayMode(.inline)
    }
}
