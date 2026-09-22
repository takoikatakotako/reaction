import XCTest
@testable import ReactionDevelopment

final class ReactionMechanismTests: XCTestCase {
    func testDecodeJSON() throws {
        let json = Data("""
        {
          "reactions": [{
            "id": "r1",
            "englishName": "Aldol Reaction",
            "japaneseName": "アルドール反応",
            "thumbnailImageUrl": "https://cdn.example.com/t.png",
            "generalFormulaImageUrls": ["https://cdn.example.com/g.png"],
            "mechanismsImageUrls": [],
            "exampleImageUrls": [],
            "supplementsImageUrls": [],
            "suggestions": ["Aldol"],
            "reactants": ["Aldehyde"],
            "products": ["Alcohol"],
            "youtubeUrls": []
          }]
        }
        """.utf8)

        let response = try JSONDecoder().decode(ReactionsResponse.self, from: json)
        let reaction = try XCTUnwrap(response.reactions.first)
        XCTAssertEqual(reaction.id, "r1")
        XCTAssertEqual(reaction.englishName, "Aldol Reaction")
        XCTAssertEqual(reaction.generalFormulaImageUrls, ["https://cdn.example.com/g.png"])
        XCTAssertEqual(reaction.reactants, ["Aldehyde"])
    }

    func testGetDisplayTitleFollowsLanguageIdentifier() {
        let reaction = Fixtures.reactionMechanism()
        XCTAssertEqual(reaction.getDisplayTitle(identifier: "en"), "Aldol Reaction")
        XCTAssertEqual(reaction.getDisplayTitle(identifier: "en-US"), "Aldol Reaction")
        XCTAssertEqual(reaction.getDisplayTitle(identifier: "ja"), "アルドール反応")
        // 不明な言語は英語にフォールバック
        XCTAssertEqual(reaction.getDisplayTitle(identifier: "de"), "Aldol Reaction")
    }
}
