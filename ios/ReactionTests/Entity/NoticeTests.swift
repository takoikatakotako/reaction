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

    func testDecodeJSONWithTargets() throws {
        let json = Data("""
        {"notices": [{"id": "n1", "platforms": ["ios"], "languages": ["ja"]}]}
        """.utf8)

        let response = try JSONDecoder().decode(NoticesResponse.self, from: json)
        let notice = try XCTUnwrap(response.notices.first)
        XCTAssertEqual(notice.languages, ["ja"])
    }

    func testIsTargetForAllLanguages() {
        let notice = Fixtures.notice(languages: ["ja", "en"])
        XCTAssertTrue(notice.isTarget(identifier: "ja"))
        XCTAssertTrue(notice.isTarget(identifier: "en"))
    }

    func testIsTargetForJapaneseOnly() {
        let notice = Fixtures.notice(languages: ["ja"])
        XCTAssertTrue(notice.isTarget(identifier: "ja"))
        XCTAssertTrue(notice.isTarget(identifier: "ja-JP"))
        XCTAssertFalse(notice.isTarget(identifier: "en"))
        // 不明な言語は英語として扱う
        XCTAssertFalse(notice.isTarget(identifier: "fr"))
    }

    func testIsTargetForEnglishOnly() {
        let notice = Fixtures.notice(languages: ["en"])
        XCTAssertFalse(notice.isTarget(identifier: "ja"))
        XCTAssertTrue(notice.isTarget(identifier: "en"))
        XCTAssertTrue(notice.isTarget(identifier: "fr"))
    }

    // 項目追加前の JSON（languages 無し）はすべての言語が対象
    func testIsTargetWhenLanguagesMissing() {
        XCTAssertTrue(Fixtures.notice(languages: nil).isTarget(identifier: "en"))
        XCTAssertTrue(Fixtures.notice(languages: []).isTarget(identifier: "ja"))
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

    // 管理画面は日付を 00:00:00Z として保存するため、端末のタイムゾーンで
    // 解釈すると UTC より西の地域で前日になる。UTC 固定で表示されること。
    func testDisplayDateIsStableAcrossTimeZones() {
        let notice = Fixtures.notice(publishedAt: "2026-09-24T00:00:00Z")

        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.timeZone = TimeZone(identifier: "UTC")
        let expected = formatter.string(from: Date(timeIntervalSince1970: 1_790_208_000))

        XCTAssertEqual(notice.displayDate, expected)
    }

    func testDisplayDateAcceptsFractionalSeconds() {
        let notice = Fixtures.notice(publishedAt: "2026-09-24T00:00:00.500Z")
        XCTAssertFalse(notice.displayDate.isEmpty)
        XCTAssertTrue(notice.displayDate.contains("2026"))
    }
}
