extension String {
    static let loading = "Loading..."
    static let postNavigationTitle = "Posts"
    static let error = "Error"
    static let retry = "Retry"

    func capitalizedFirstLetter() -> String {
        guard let firstLetter = first else { return "" }
        return String(firstLetter).uppercased() + dropFirst()
    }
}
