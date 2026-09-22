import XCTest
@testable import ReactionDevelopment

final class QuestionRepositoryTests: XCTestCase {
    private let endpoint = "https://example.com/resource/question/list.json"

    override func tearDown() {
        MockURLProtocol.requestHandler = nil
        super.tearDown()
    }

    func testFetchQuestionsRequestsEndpointAndDecodes() async throws {
        var requestedURL: URL?
        MockURLProtocol.requestHandler = { request in
            requestedURL = request.url
            let body = Data("""
            {"questions": [{"id": "q1", "order": 1, "problemImageUrls": [], "solutionImageUrls": [], "references": []}]}
            """.utf8)
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, body)
        }

        let repository = QuestionRepository(session: MockURLProtocol.makeSession())
        let questions = try await repository.fetchQuestions(questionsEndpoint: endpoint)

        XCTAssertEqual(requestedURL?.absoluteString, endpoint)
        XCTAssertEqual(questions.map(\.id), ["q1"])
    }

    func testFetchQuestionsThrowsOnInvalidJSON() async {
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, Data("not json".utf8))
        }

        let repository = QuestionRepository(session: MockURLProtocol.makeSession())
        do {
            _ = try await repository.fetchQuestions(questionsEndpoint: endpoint)
            XCTFail("デコードエラーになるはず")
        } catch {
            XCTAssertTrue(error is DecodingError)
        }
    }

    func testFetchQuestionsThrowsOnNetworkError() async {
        MockURLProtocol.requestHandler = { _ in
            throw URLError(.notConnectedToInternet)
        }

        let repository = QuestionRepository(session: MockURLProtocol.makeSession())
        do {
            _ = try await repository.fetchQuestions(questionsEndpoint: endpoint)
            XCTFail("ネットワークエラーになるはず")
        } catch {
            XCTAssertEqual((error as? URLError)?.code, .notConnectedToInternet)
        }
    }

    func testFetchQuestionsThrowsBadURLForInvalidEndpoint() async {
        let repository = QuestionRepository(session: MockURLProtocol.makeSession())
        do {
            _ = try await repository.fetchQuestions(questionsEndpoint: "")
            XCTFail("URL 生成に失敗するはず")
        } catch {
            XCTAssertEqual((error as? URLError)?.code, .badURL)
        }
    }
}
