import XCTest
@testable import ReactionDevelopment

final class NoticeRepositoryTests: XCTestCase {
    private let endpoint = "https://example.com/resource/notice/list.json"

    override func tearDown() {
        MockURLProtocol.requestHandler = nil
        super.tearDown()
    }

    func testFetchNoticesRequestsEndpointAndDecodes() async throws {
        var requestedURL: URL?
        MockURLProtocol.requestHandler = { request in
            requestedURL = request.url
            let body = Data("""
            {"notices": [
              {"id": "n1", "japaneseTitle": "お知らせ1", "publishedAt": "2026-09-24T00:00:00Z"},
              {"id": "n2", "japaneseTitle": "お知らせ2", "publishedAt": "2026-09-20T00:00:00Z"}
            ]}
            """.utf8)
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, body)
        }

        let repository = NoticeRepository(session: MockURLProtocol.makeSession())
        let notices = try await repository.fetchNotices(noticesEndpoint: endpoint)

        XCTAssertEqual(requestedURL?.absoluteString, endpoint)
        XCTAssertEqual(notices.map(\.id), ["n1", "n2"])
    }

    func testFetchNoticesThrowsOnInvalidJSON() async {
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, Data("not json".utf8))
        }

        let repository = NoticeRepository(session: MockURLProtocol.makeSession())
        do {
            _ = try await repository.fetchNotices(noticesEndpoint: endpoint)
            XCTFail("デコードエラーになるはず")
        } catch {
            XCTAssertTrue(error is DecodingError)
        }
    }

    func testFetchNoticesThrowsBadURLForInvalidEndpoint() async {
        let repository = NoticeRepository(session: MockURLProtocol.makeSession())
        do {
            _ = try await repository.fetchNotices(noticesEndpoint: "")
            XCTFail("URL 生成に失敗するはず")
        } catch {
            XCTAssertEqual((error as? URLError)?.code, .badURL)
        }
    }
}
