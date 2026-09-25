import Foundation
@testable import ReactionDevelopment

enum Fixtures {
    static func question(
        id: String = "q1",
        order: Int = 1,
        englishTitle: String? = "Provide reasonable mechanism.",
        japaneseTitle: String? = "反応機構を示せ",
        category: String? = "今週の反応機構",
        number: Int? = 7,
        difficulty: Int? = 3
    ) -> Question {
        Question(
            id: id,
            order: order,
            englishTitle: englishTitle,
            japaneseTitle: japaneseTitle,
            category: category,
            number: number,
            difficulty: difficulty,
            problemImageUrls: ["https://cdn.example.com/p.png"],
            solutionImageUrls: ["https://cdn.example.com/s.png"],
            references: []
        )
    }

    static func reactionMechanism(
        id: String = "r1",
        englishName: String = "Aldol Reaction",
        japaneseName: String = "アルドール反応",
        suggestions: [String] = ["Aldol", "Enolate"]
    ) -> ReactionMechanism {
        ReactionMechanism(
            id: id,
            englishName: englishName,
            japaneseName: japaneseName,
            thumbnailImageUrl: "https://cdn.example.com/t.png",
            generalFormulaImageUrls: [],
            mechanismsImageUrls: [],
            exampleImageUrls: [],
            supplementsImageUrls: [],
            suggestions: suggestions,
            reactants: [],
            products: [],
            youtubeUrls: []
        )
    }

    static func notice(
        id: String = "n1",
        englishTitle: String? = "Maintenance",
        japaneseTitle: String? = "メンテナンスのお知らせ",
        englishBody: String? = "We will perform maintenance.",
        japaneseBody: String? = "メンテナンスを行います。",
        publishedAt: String? = "2026-09-24T00:00:00Z"
    ) -> Notice {
        Notice(
            id: id,
            englishTitle: englishTitle,
            japaneseTitle: japaneseTitle,
            englishBody: englishBody,
            japaneseBody: japaneseBody,
            publishedAt: publishedAt
        )
    }
}
