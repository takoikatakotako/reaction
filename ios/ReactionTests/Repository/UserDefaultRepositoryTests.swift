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
        XCTAssertTrue(repository.showThmbnail)
        XCTAssertFalse(repository.enableDetaileAbility)
    }

    func testInitilizeRegistersDefaults() {
        repository.initilize()
        XCTAssertEqual(repository.reactionMechanismLanguage, "en")
        XCTAssertTrue(repository.showThmbnail)
        XCTAssertFalse(repository.enableDetaileAbility)
    }

    func testSetAndGetValues() {
        repository.setReactionMechanismLanguage("ja")
        repository.setShowThmbnail(false)
        repository.setEnableDetaileAbility(true)

        XCTAssertEqual(repository.reactionMechanismLanguage, "ja")
        XCTAssertFalse(repository.showThmbnail)
        XCTAssertTrue(repository.enableDetaileAbility)
    }
}
