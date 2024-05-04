import Foundation

struct PostEntity: Identifiable {
    let id : UUID
    let title: String
    let author: String
    let email: String
    let website: String
    let street: String
    let city: String
    let companyName: String
}
