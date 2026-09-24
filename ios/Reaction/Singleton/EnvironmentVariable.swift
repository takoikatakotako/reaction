import Foundation

/// Info.plist から読み込んだエンドポイントを保持する。
/// AppDelegate の起動時に一度だけ設定される。
final class EnvironmentVariable {
    static let shared = EnvironmentVariable()

    private init() {}

    private(set) var reactionsEndpoint: String = ""
    private(set) var questionsEndpoint: String = ""

    func setReactionsEndpoint(_ endpoint: String) {
        reactionsEndpoint = endpoint
    }

    func setQuestionsEndpoint(_ endpoint: String) {
        questionsEndpoint = endpoint
    }
}
