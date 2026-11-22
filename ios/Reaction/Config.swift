import Foundation

enum Config {
    static let githubRepositoryUrl = "https://github.com/takoikatakotako/reaction"
    static let termsUrl = "https://chemist.swiswiswift.com/terms.html"
    static let privacyPolicyUrl = "https://chemist.swiswiswift.com/privacy.html"
    // 利用規約・プライバシーポリシー（lp/）と同じお問い合わせフォーム
    static let contactFormUrl = "https://docs.google.com/forms/d/e/1FAIpQLSckMT89daG9mXLGJJ7DAMWqsql2opnOo25Amm5kuCR4ZuwOvg/viewform"

    /// 端末・OS とアプリのバージョンを事前入力したお問い合わせフォームの URL。
    /// entry の ID は Google フォームの各質問に振られたもの。質問を作り直したら変わる。
    static func contactFormURL(device: String, appVersion: String) -> URL? {
        var components = URLComponents(string: contactFormUrl)
        components?.queryItems = [
            URLQueryItem(name: "usp", value: "pp_url"),
            URLQueryItem(name: "entry.26242826", value: device),
            URLQueryItem(name: "entry.1790724873", value: appVersion)
        ]
        return components?.url
    }
}
