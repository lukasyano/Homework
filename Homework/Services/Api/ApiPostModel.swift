struct ApiPostModel: Decodable {
    let title: String
    let userId: Int

    private enum CodingKeys: String, CodingKey {
        case title
        case userId
    }
}
