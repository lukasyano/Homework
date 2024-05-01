enum Mapper {
    static func mapPostsFromApi(posts: [ApiPostModel]) -> [PostEntity] {
        return posts.map { PostEntity(title: $0.title, userId: $0.userId) }
    }
    
    static func mapUserFromApi(user: ApiUserModel) -> UserEntity {
        return UserEntity(id: user.id, name: user.name)
    }
    
    static func mapFromDBToPostUserEntity(dbModel: [DBPostDetailsModel]) -> [PostDetailsEntity] {
        return dbModel.map { PostDetailsEntity(postTitle: $0.postTitle ?? "", userName: $0.userName ?? "") }
    }
}
