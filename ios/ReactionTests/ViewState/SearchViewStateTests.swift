import XCTest
@testable import ReactionDevelopment

@MainActor
final class SearchViewStateTests: XCTestCase {
    /// 管理画面で反応物・生成物に選べるタグ。反応機構データのタグはここから入力される。
    /// 検索はタグの完全一致なので、アプリ側のタグが 1 文字でも違うとその項目では何も見つからない。
    private func adminTagOptions() throws -> Set<String> {
        let constants = URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent() // ViewState
            .deletingLastPathComponent() // ReactionTests
            .deletingLastPathComponent() // ios
            .deletingLastPathComponent() // リポジトリのルート
            .appendingPathComponent("admin/src/lib/constants.ts")
        let source = try String(contentsOf: constants, encoding: .utf8)
        let regex = try NSRegularExpression(pattern: "'([^']+)'")
        let range = NSRange(source.startIndex..., in: source)
        let options = regex.matches(in: source, range: range).compactMap { match -> String? in
            Range(match.range(at: 1), in: source).map { String(source[$0]) }
        }
        return Set(options)
    }

    private func allTags(_ viewState: SearchViewState) -> [String] {
        viewState.firstCategories.flatMap { first in
            [first.tag] + first.secondCategories.flatMap { second in
                [second.tag] + second.thirdCategories.map(\.tag)
            }
        }
    }

    func testAllCategoryTagsExistInAdminOptions() throws {
        let options = try adminTagOptions()
        XCTAssertTrue(options.contains("Carbonyl"), "管理画面の選択肢を読み取れていない")

        // 管理画面に選択肢が無く、どの反応機構にも付けられないカテゴリ。扱いが決まるまで除外する
        let knownMissing: Set<String> = ["Carbonyl-Carboxylic_Acid_Derivative-Acid_Derivative"]

        for tag in allTags(SearchViewState()) where !knownMissing.contains(tag) {
            XCTAssertTrue(options.contains(tag), "管理画面の選択肢に無いタグ: \(tag)")
        }
    }

    func testCategoryNamesHaveBothLanguages() {
        let viewState = SearchViewState()
        for first in viewState.firstCategories {
            XCTAssertFalse(first.getDisplayName(laungageIdentifier: "ja").isEmpty, first.name)
            XCTAssertFalse(first.getDisplayName(laungageIdentifier: "en").isEmpty, first.name)
            for second in first.secondCategories {
                XCTAssertFalse(second.getDisplayName(laungageIdentifier: "ja").isEmpty, second.name)
                XCTAssertFalse(second.getDisplayName(laungageIdentifier: "en").isEmpty, second.name)
                for third in second.thirdCategories {
                    XCTAssertFalse(third.getDisplayName(laungageIdentifier: "ja").isEmpty, third.name)
                    XCTAssertFalse(third.getDisplayName(laungageIdentifier: "en").isEmpty, third.name)
                }
            }
        }
    }
}
