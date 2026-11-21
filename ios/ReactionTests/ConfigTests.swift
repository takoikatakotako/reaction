import XCTest
@testable import ReactionDevelopment

final class ConfigTests: XCTestCase {
    func testContactFormURLPrefillsDeviceAndAppVersion() throws {
        let url = try XCTUnwrap(Config.contactFormURL(device: "iPhone17,3 / iOS 26.1", appVersion: "6.3.0 (512)"))
        let components = try XCTUnwrap(URLComponents(url: url, resolvingAgainstBaseURL: false))
        let items = Dictionary(uniqueKeysWithValues: (components.queryItems ?? []).map { ($0.name, $0.value) })

        XCTAssertTrue(url.absoluteString.hasPrefix(Config.contactFormUrl + "?"))
        XCTAssertEqual(items["usp"], "pp_url")
        XCTAssertEqual(items["entry.26242826"], "iPhone17,3 / iOS 26.1")
        XCTAssertEqual(items["entry.1790724873"], "6.3.0 (512)")
    }
}
