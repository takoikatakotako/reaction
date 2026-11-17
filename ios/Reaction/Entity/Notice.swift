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
    // 対象言語（"ja" / "en"）。項目追加前の JSON には無いので、nil や空はすべての言語が対象
    let languages: [String]?

    /// 表示言語の設定がこのお知らせの対象か。表示言語の判定は getDisplayTitle と同じく
    /// "ja" で始まれば日本語、それ以外は英語とみなす。
    func isTarget(identifier: String) -> Bool {
        guard let languages, !languages.isEmpty else {
            return true
        }
        let language = identifier.starts(with: "ja") ? "ja" : "en"
        return languages.contains(language)
    }

    // identifier はアプリの表示言語（"ja" で始まれば日本語、それ以外は英語）
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
