extension String {
    // PostsScreenView
    static let loading = "Loading..."
    static let postNavigationTitle = "Posts"
    static let error = "Error"
    static let retry = "Retry"
    // AboutUserView
    static let email = "Email: "
    static let website = "Website: "
    static let address = "Address:"
    static let company = "Company:"

    func capitalizedFirstLetter() -> String {
        guard let firstLetter = first else { return "" }
        return String(firstLetter).uppercased() + dropFirst()
    }
}
