class EnvironmentVariable {
    static let shared = EnvironmentVariable()

    private init() {}

    private var reactionsEndpoint: String = ""
    private var questionsEndpoint: String = ""

    var getReactionsEndpoint: String {
        return Self.shared.reactionsEndpoint
    }

    func setReactionsEndpoint(reactionsEndpoint: String) {
        Self.shared.reactionsEndpoint = reactionsEndpoint
    }

    var getQuestionsEndpoint: String {
        return Self.shared.questionsEndpoint
    }

    func setQuestionsEndpoint(questionsEndpoint: String) {
        Self.shared.questionsEndpoint = questionsEndpoint
    }
}
