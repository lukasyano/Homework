struct Mapper {
    static func mapPostsFromApi(posts: [ApiPostModel]) -> [PostEntity] {
        return posts.map { apiPost in
            PostEntity(title: apiPost.title, userId: apiPost.userId)
        }
    }
    
    static func mapUserFromApi(user: ApiUserModel) -> UserEntity {
        return UserEntity(id: user.id, name: user.name)
    }
}
