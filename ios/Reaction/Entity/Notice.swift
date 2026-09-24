import Foundation

struct NoticesResponse: Decodable, Hashable {
    let notices: [Notice]
}

struct Notice: Identifiable, Decodable, Hashable {
    let id: String
    // 旧 JSON でもデコードが落ちないよう Optional にする
    let englishTitle: String?
    let japaneseTitle: String?
    let englishBody: String?
    let japaneseBody: String?
    let publishedAt: String?

    // 反応機構名と同じ言語設定に準拠する
    func getDisplayTitle(identifier: String) -> String {
        if identifier.starts(with: "ja") {
            return japaneseTitle ?? ""
        }
        return englishTitle ?? ""
    }

    func getDisplayBody(identifier: String) -> String {
        if identifier.starts(with: "ja") {
            return japaneseBody ?? ""
        }
        return englishBody ?? ""
    }

    /// publishedAt は RFC3339。表示用に年月日だけを取り出す。
    var displayDate: String {
        guard let publishedAt else {
            return ""
        }
        let formatter = ISO8601DateFormatter()
        guard let date = formatter.date(from: publishedAt) else {
            return ""
        }
        let display = DateFormatter()
        display.dateStyle = .medium
        display.timeStyle = .none
        return display.string(from: date)
    }
}
