import XCTest
@testable import ReactionDevelopment

@MainActor
final class ReactionListViewStateTests: XCTestCase {
    private func makeViewState() -> ReactionListViewState {
        let viewState = ReactionListViewState(showingThumbnail: true)
        viewState.reactionMechanisms = [
            Fixtures.reactionMechanism(id: "1", englishName: "Aldol Reaction", suggestions: ["Aldol", "Enolate"]),
            Fixtures.reactionMechanism(id: "2", englishName: "Diels-Alder Reaction", suggestions: ["Diels-Alder", "Cycloaddition"]),
            Fixtures.reactionMechanism(id: "3", englishName: "Wittig Reaction", suggestions: ["Wittig", "Ylide"])
        ]
        return viewState
    }

    func testShowingReactionsReturnsAllWhenSearchTextIsEmpty() {
        let viewState = makeViewState()
        XCTAssertEqual(viewState.showingReactions.map(\.id), ["1", "2", "3"])
    }

    func testShowingReactionsFiltersBySuggestionIgnoringCase() {
        let viewState = makeViewState()
        viewState.searchText = "aldol"
        XCTAssertEqual(viewState.showingReactions.map(\.id), ["1"])

        viewState.searchText = "CYCLO"
        XCTAssertEqual(viewState.showingReactions.map(\.id), ["2"])
    }

    func testShowingReactionsMatchesPartialText() {
        let viewState = makeViewState()
        viewState.searchText = "els"
        // "Diels-Alder" のみ部分一致する
        XCTAssertEqual(viewState.showingReactions.map(\.id), ["2"])
    }

    func testShowingReactionsReturnsEmptyWhenNothingMatches() {
        let viewState = makeViewState()
        viewState.searchText = "zzz"
        XCTAssertTrue(viewState.showingReactions.isEmpty)
    }

    func testClearSearchText() {
        let viewState = makeViewState()
        viewState.searchText = "aldol"
        viewState.clearSearchText()
        XCTAssertEqual(viewState.searchText, "")
        XCTAssertEqual(viewState.showingReactions.count, 3)
    }
}
