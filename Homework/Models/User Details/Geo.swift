struct Geo: Codable {
    let lat: String
    let lng: String

    private enum CodingKeys: String, CodingKey {
        case lat
        case lng
    }
}
