import XCTest
@testable import ReactionDevelopment

@MainActor
final class QuestionDetailViewStateTests: XCTestCase {
    private var userDefaultRepository: UserDefaultRepository!

    override func setUp() {
        super.setUp()
        userDefaultRepository = UserDefaultRepository(userDefaults: TestUserDefaults.make())
    }

    private func makeViewState(question: Question = Fixtures.question()) -> QuestionDetailViewState {
        QuestionDetailViewState(question: question, userDefaultRepository: userDefaultRepository)
    }

    func testDisplayTitleFollowsReactionMechanismLanguage() {
        userDefaultRepository.setReactionMechanismLanguage("ja")
        XCTAssertEqual(makeViewState().displayTitle, "反応機構を示せ")

        userDefaultRepository.setReactionMechanismLanguage("en")
        XCTAssertEqual(makeViewState().displayTitle, "Provide reasonable mechanism.")
    }

    func testDifficultyDefaultsToZeroWhenMissing() {
        XCTAssertEqual(makeViewState(question: Fixtures.question(difficulty: nil)).difficulty, 0)
        XCTAssertEqual(makeViewState(question: Fixtures.question(difficulty: 5)).difficulty, 5)
    }

    func testShowSolutionTapped() {
        let viewState = makeViewState()
        XCTAssertFalse(viewState.showSolution)
        viewState.showSolutionTapped()
        XCTAssertTrue(viewState.showSolution)
    }
}
