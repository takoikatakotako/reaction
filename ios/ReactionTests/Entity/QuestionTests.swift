import XCTest
@testable import ReactionDevelopment

final class QuestionTests: XCTestCase {
    func testDecodeFullJSON() throws {
        let json = Data("""
        {
          "questions": [{
            "id": "q1",
            "order": 3,
            "englishTitle": "Provide reasonable mechanism.",
            "japaneseTitle": "反応機構を示せ",
            "category": "今週の反応機構",
            "number": 12,
            "difficulty": 4,
            "problemImageUrls": ["https://cdn.example.com/p.png"],
            "solutionImageUrls": ["https://cdn.example.com/s.png"],
            "references": ["https://example.com/ref"]
          }]
        }
        """.utf8)

        let response = try JSONDecoder().decode(QuestionsResponse.self, from: json)
        let question = try XCTUnwrap(response.questions.first)
        XCTAssertEqual(question.id, "q1")
        XCTAssertEqual(question.order, 3)
        XCTAssertEqual(question.englishTitle, "Provide reasonable mechanism.")
        XCTAssertEqual(question.category, "今週の反応機構")
        XCTAssertEqual(question.number, 12)
        XCTAssertEqual(question.difficulty, 4)
        XCTAssertEqual(question.references, ["https://example.com/ref"])
    }

    // 再エクスポート前の旧 JSON（タイトル等のフィールドが無い）でもデコードできること
    func testDecodeLegacyJSONWithoutNewFields() throws {
        let json = Data("""
        {
          "questions": [{
            "id": "q1",
            "order": 1,
            "problemImageUrls": [],
            "solutionImageUrls": [],
            "references": []
          }]
        }
        """.utf8)

        let response = try JSONDecoder().decode(QuestionsResponse.self, from: json)
        let question = try XCTUnwrap(response.questions.first)
        XCTAssertNil(question.englishTitle)
        XCTAssertNil(question.category)
        XCTAssertNil(question.difficulty)
    }

    func testGetDisplayTitleFollowsLanguageIdentifier() {
        let question = Fixtures.question()
        XCTAssertEqual(question.getDisplayTitle(identifier: "ja"), "反応機構を示せ")
        XCTAssertEqual(question.getDisplayTitle(identifier: "ja-JP"), "反応機構を示せ")
        XCTAssertEqual(question.getDisplayTitle(identifier: "en"), "Provide reasonable mechanism.")
        // 不明な言語は英語にフォールバック
        XCTAssertEqual(question.getDisplayTitle(identifier: "fr"), "Provide reasonable mechanism.")
    }

    func testGetDisplayTitleReturnsEmptyWhenMissing() {
        let question = Fixtures.question(englishTitle: nil, japaneseTitle: nil)
        XCTAssertEqual(question.getDisplayTitle(identifier: "ja"), "")
        XCTAssertEqual(question.getDisplayTitle(identifier: "en"), "")
    }

    func testDisplayNumberUsesCategoryAndZeroPaddedNumber() {
        XCTAssertEqual(Fixtures.question(category: "今週の反応機構", number: 7).displayNumber, "今週の反応機構007")
        XCTAssertEqual(Fixtures.question(category: "Q", number: 123).displayNumber, "Q123")
        XCTAssertEqual(Fixtures.question(category: "Q", number: nil).displayNumber, "Q000")
    }

    func testDisplayNumberFallsBackToOrderWithoutCategory() {
        XCTAssertEqual(Fixtures.question(order: 42, category: nil).displayNumber, "#42")
        XCTAssertEqual(Fixtures.question(order: 42, category: "").displayNumber, "#42")
    }
}
