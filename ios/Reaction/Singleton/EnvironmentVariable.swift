class EnvironmentVariable {
    static let shared = EnvironmentVariable()

    private init() {}
    
    private var reactionsEndpoint: String = ""
    
    var getReactionsEndpoint: String {
        return Self.shared.reactionsEndpoint
    }

    func setReactionsEndpoint(reactionsEndpoint: String) {
        Self.shared.reactionsEndpoint = reactionsEndpoint
    }
}
