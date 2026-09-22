import XCTest
@testable import ReactionDevelopment

final class UserDefaultRepositoryTests: XCTestCase {
    private let repository = UserDefaultRepository()

    private func clearKeys() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: repository.KEY_REACTION_MECHANISM_LANGUAGE)
        defaults.removeObject(forKey: repository.KEY_SHOW_THUMBNAIL)
        defaults.removeObject(forKey: repository.KEY_ENABLE_DETAILE_ABILITY)
    }

    override func setUp() {
        super.setUp()
        clearKeys()
    }

    override func tearDown() {
        clearKeys()
        super.tearDown()
    }

    func testDefaultValues() {
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
