import XCTest
@testable import ReactionDevelopment

final class UserDefaultRepositoryTests: XCTestCase {
    private var repository: UserDefaultRepository!

    override func setUp() {
        super.setUp()
        repository = UserDefaultRepository(userDefaults: TestUserDefaults.make())
    }

    func testDefaultValues() {
        XCTAssertEqual(repository.reactionMechanismLanguage, "en")
        XCTAssertTrue(repository.showThumbnail)
        XCTAssertFalse(repository.enableDetailAbility)
    }

    func testInitilizeRegistersDefaults() {
        repository.initialize()
        XCTAssertEqual(repository.reactionMechanismLanguage, "en")
        XCTAssertTrue(repository.showThumbnail)
        XCTAssertFalse(repository.enableDetailAbility)
    }

    func testSetAndGetValues() {
        repository.setReactionMechanismLanguage("ja")
        repository.setShowThumbnail(false)
        repository.setEnableDetailAbility(true)

        XCTAssertEqual(repository.reactionMechanismLanguage, "ja")
        XCTAssertFalse(repository.showThumbnail)
        XCTAssertTrue(repository.enableDetailAbility)
    }
}
