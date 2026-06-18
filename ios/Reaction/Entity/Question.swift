import SwiftUI

struct QuestionsResponse: Decodable, Hashable {
    let questions: [Question]
}

struct Question: Identifiable, Decodable, Hashable {
    let id: String
    let order: Int
    // 旧JSON（再エクスポート前）でもデコードが落ちないよう Optional にする
    let englishTitle: String?
    let japaneseTitle: String?
    let category: String?
    let number: Int?
    let difficulty: Int?
    let problemImageUrls: [String]
    let solutionImageUrls: [String]
    let references: [String]

    func getDisplayTitle(identifier: String) -> String {
        if identifier.starts(with: "ja") {
            return japaneseTitle ?? ""
        } else {
            return englishTitle ?? ""
        }
    }

    // 管理画面と同じ「カテゴリ + 3桁番号」（例: 今週の反応機構001）
    var displayNumber: String {
        guard let category, !category.isEmpty else { return "" }
        return category + String(format: "%03d", number ?? 0)
    }
}
