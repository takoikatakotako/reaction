import XCTest
@testable import ReactionDevelopment

final class NoticeTests: XCTestCase {
    func testDecodeJSON() throws {
        let json = Data("""
        {
          "notices": [{
            "id": "n1",
            "englishTitle": "Maintenance",
            "japaneseTitle": "メンテナンスのお知らせ",
            "englishBody": "We will perform maintenance.",
            "japaneseBody": "メンテナンスを行います。",
            "publishedAt": "2026-09-24T00:00:00Z"
          }]
        }
        """.utf8)

        let response = try JSONDecoder().decode(NoticesResponse.self, from: json)
        let notice = try XCTUnwrap(response.notices.first)
        XCTAssertEqual(notice.id, "n1")
        XCTAssertEqual(notice.japaneseTitle, "メンテナンスのお知らせ")
        XCTAssertEqual(notice.publishedAt, "2026-09-24T00:00:00Z")
    }

    // フィールドが欠けた JSON でもデコードできること
    func testDecodeJSONWithMissingFields() throws {
        let json = Data("""
        {"notices": [{"id": "n1"}]}
        """.utf8)

        let response = try JSONDecoder().decode(NoticesResponse.self, from: json)
        let notice = try XCTUnwrap(response.notices.first)
        XCTAssertNil(notice.japaneseTitle)
        XCTAssertNil(notice.publishedAt)
    }

    func testGetDisplayTitleFollowsLanguageIdentifier() {
        let notice = Fixtures.notice()
        XCTAssertEqual(notice.getDisplayTitle(identifier: "ja"), "メンテナンスのお知らせ")
        XCTAssertEqual(notice.getDisplayTitle(identifier: "ja-JP"), "メンテナンスのお知らせ")
        XCTAssertEqual(notice.getDisplayTitle(identifier: "en"), "Maintenance")
        // 不明な言語は英語にフォールバック
        XCTAssertEqual(notice.getDisplayTitle(identifier: "fr"), "Maintenance")
    }

    func testGetDisplayBodyFollowsLanguageIdentifier() {
        let notice = Fixtures.notice()
        XCTAssertEqual(notice.getDisplayBody(identifier: "ja"), "メンテナンスを行います。")
        XCTAssertEqual(notice.getDisplayBody(identifier: "en"), "We will perform maintenance.")
    }

    func testGetDisplayTextReturnsEmptyWhenMissing() {
        let notice = Fixtures.notice(englishTitle: nil, japaneseTitle: nil, englishBody: nil, japaneseBody: nil)
        XCTAssertEqual(notice.getDisplayTitle(identifier: "ja"), "")
        XCTAssertEqual(notice.getDisplayBody(identifier: "en"), "")
    }

    func testDisplayDateIsEmptyForInvalidValues() {
        XCTAssertEqual(Fixtures.notice(publishedAt: nil).displayDate, "")
        XCTAssertEqual(Fixtures.notice(publishedAt: "2026/09/24").displayDate, "")
    }

    func testDisplayDateFormatsRFC3339() {
        let displayDate = Fixtures.notice(publishedAt: "2026-09-24T00:00:00Z").displayDate
        // ロケール依存なので書式そのものではなく、日付が取れていることを確認する
        XCTAssertFalse(displayDate.isEmpty)
        XCTAssertTrue(displayDate.contains("2026"))
    }
}
