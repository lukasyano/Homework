struct Company: Codable {
    let name: String
    let catchPhrase: String
    let bs: String

    private enum CodingKeys: String, CodingKey {
        case name
        case catchPhrase
        case bs
    }
}
