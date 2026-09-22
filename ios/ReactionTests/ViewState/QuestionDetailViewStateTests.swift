import XCTest
@testable import ReactionDevelopment

final class QuestionDetailViewStateTests: XCTestCase {
    private let userDefaultRepository = UserDefaultRepository()

    override func tearDown() {
        UserDefaults.standard.removeObject(forKey: userDefaultRepository.KEY_REACTION_MECHANISM_LANGUAGE)
        super.tearDown()
    }

    func testDisplayTitleFollowsReactionMechanismLanguage() {
        userDefaultRepository.setReactionMechanismLanguage("ja")
        let viewState = QuestionDetailViewState(question: Fixtures.question())
        XCTAssertEqual(viewState.displayTitle, "反応機構を示せ")

        userDefaultRepository.setReactionMechanismLanguage("en")
        let englishViewState = QuestionDetailViewState(question: Fixtures.question())
        XCTAssertEqual(englishViewState.displayTitle, "Provide reasonable mechanism.")
    }

    func testDifficultyDefaultsToZeroWhenMissing() {
        XCTAssertEqual(QuestionDetailViewState(question: Fixtures.question(difficulty: nil)).difficulty, 0)
        XCTAssertEqual(QuestionDetailViewState(question: Fixtures.question(difficulty: 5)).difficulty, 5)
    }

    func testShowSolutionTapped() {
        let viewState = QuestionDetailViewState(question: Fixtures.question())
        XCTAssertFalse(viewState.showSolution)
        viewState.showSolutionTapped()
        XCTAssertTrue(viewState.showSolution)
    }
}
