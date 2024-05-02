enum Mapper {
    static func mapFromApi(post: ApiPostModel, user: ApiUserModel) -> PostEntity {
        return PostEntity(
            title: post.title ?? "",
            author: user.name ?? "",
            email: user.email ?? "",
            website: user.website ?? "",
            street: user.address?.street ?? "",
            city: user.address?.city ?? "",
            companyName: user.company?.name ?? ""
        )
    }

    static func mapFromDB(dbModel: [DBPostModel]) -> [PostEntity] {
        return dbModel.map {
            PostEntity(
                title: $0.title ?? "",
                author: $0.author ?? "",
                email: $0.email ?? "",
                website: $0.website ?? "",
                street: $0.street ?? "",
                city: $0.city ?? "",
                companyName: $0.companyName ?? ""
            )
        }
    }
}
