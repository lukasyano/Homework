struct ApiUserModel: Decodable {
    let id: Int?
    let name: String?
    let email: String?
    let address: Address?
    let website: String?
    let company: Company?
}

struct Address: Decodable {
    let street: String?
    let city: String?
}

struct Company: Decodable{
    let name: String?
}

