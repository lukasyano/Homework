struct ApiPostModel: Decodable {
    let userId: Int
    let id: Int
    let title: String

    private enum CodingKeys: String, CodingKey {
        case userId
        case id
        case title
    }
}
