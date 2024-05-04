extension DBPostModel {
    func populate(from postEntity: PostEntity) {
        title = postEntity.title
        author = postEntity.author
        email = postEntity.email
        website = postEntity.website
        street = postEntity.street
        city = postEntity.city
        companyName = postEntity.companyName
    }
}
