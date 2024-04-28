struct Post: Codable {
    let userId: Int
    let id: Int
    let title: String
    let body: String

    private enum CodingKeys: String, CodingKey {
        case userId
        case id
        case title
        case body
    }
}
