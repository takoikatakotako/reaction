import XCTest
@testable import ReactionDevelopment

final class ReactionMechanismRepositoryTests: XCTestCase {
    private let endpoint = "https://example.com/resource/reaction/list.json"

    override func tearDown() {
        MockURLProtocol.requestHandler = nil
        super.tearDown()
    }

    func testFetchMechanismsRequestsEndpointAndDecodes() async throws {
        var requestedURL: URL?
        MockURLProtocol.requestHandler = { request in
            requestedURL = request.url
            let body = Data("""
            {"reactions": [{
              "id": "r1", "englishName": "Aldol Reaction", "japaneseName": "アルドール反応",
              "thumbnailImageUrl": "", "generalFormulaImageUrls": [], "mechanismsImageUrls": [],
              "exampleImageUrls": [], "supplementsImageUrls": [], "suggestions": [],
              "reactants": [], "products": [], "youtubeUrls": []
            }]}
            """.utf8)
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, body)
        }

        let repository = ReactionMechanismRepository(session: MockURLProtocol.makeSession())
        let reactions = try await repository.fetchMechanisms(reactionsEndpoint: endpoint)

        XCTAssertEqual(requestedURL?.absoluteString, endpoint)
        XCTAssertEqual(reactions.map(\.englishName), ["Aldol Reaction"])
    }

    func testFetchMechanismsThrowsOnInvalidJSON() async {
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, Data("{}".utf8))
        }

        let repository = ReactionMechanismRepository(session: MockURLProtocol.makeSession())
        do {
            _ = try await repository.fetchMechanisms(reactionsEndpoint: endpoint)
            XCTFail("デコードエラーになるはず")
        } catch {
            XCTAssertTrue(error is DecodingError)
        }
    }
}
