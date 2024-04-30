struct ApiUserModel: Decodable {
    let id: Int
    let name: String

    private enum CodingKeys: String, CodingKey {
        case id
        case name
    }
}
