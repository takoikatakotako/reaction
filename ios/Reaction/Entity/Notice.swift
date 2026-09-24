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
    ///
    /// 管理画面は選択された日付を 00:00:00Z として保存するため、これは時刻ではなく
    /// 日付そのものを表す値。端末のタイムゾーンで解釈すると UTC より西の地域で
    /// 前日になってしまうので、表示用フォーマッターは UTC に固定する。
    var displayDate: String {
        guard let publishedAt else {
            return ""
        }
        let parser = ISO8601DateFormatter()
        parser.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        guard let date = parser.date(from: publishedAt)
                ?? ISO8601DateFormatter().date(from: publishedAt) else {
            return ""
        }
        let display = DateFormatter()
        display.dateStyle = .medium
        display.timeStyle = .none
        display.timeZone = TimeZone(identifier: "UTC")
        return display.string(from: date)
    }
}
