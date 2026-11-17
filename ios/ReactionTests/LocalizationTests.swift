import XCTest

/// コードで使っている文言キーが、翻訳ファイルに日本語・英語の両方で揃っているかを確かめる。
/// キーが無いとキー名がそのまま画面に出て、翻訳が片方だけだとその言語で英語などが混ざる。
final class LocalizationTests: XCTestCase {
    private var appDirectory: URL {
        URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent() // ReactionTests
            .deletingLastPathComponent() // ios
            .appendingPathComponent("Reaction")
    }

    private func catalog() throws -> [String: Any] {
        let data = try Data(contentsOf: appDirectory.appendingPathComponent("Localizable.xcstrings"))
        let json = try XCTUnwrap(JSONSerialization.jsonObject(with: data) as? [String: Any])
        return try XCTUnwrap(json["strings"] as? [String: Any])
    }

    private func usedKeys() throws -> [String: String] {
        let regex = try NSRegularExpression(pattern: #"String\(localized:\s*"([^"]+)""#)
        var keys: [String: String] = [:]
        let enumerator = try XCTUnwrap(FileManager.default.enumerator(at: appDirectory, includingPropertiesForKeys: nil))
        for case let file as URL in enumerator where file.pathExtension == "swift" {
            let source = try String(contentsOf: file, encoding: .utf8)
            let range = NSRange(source.startIndex..., in: source)
            for match in regex.matches(in: source, range: range) {
                if let keyRange = Range(match.range(at: 1), in: source) {
                    keys[String(source[keyRange])] = file.lastPathComponent
                }
            }
        }
        return keys
    }

    func testAllUsedKeysAreTranslated() throws {
        let strings = try catalog()
        let keys = try usedKeys()
        XCTAssertFalse(keys.isEmpty, "文言キーを読み取れていない")

        for (key, file) in keys.sorted(by: { $0.key < $1.key }) {
            guard let entry = strings[key] as? [String: Any] else {
                XCTFail("翻訳ファイルに無いキー: \(key) (\(file))")
                continue
            }
            let localizations = entry["localizations"] as? [String: Any] ?? [:]
            for language in ["ja", "en"] {
                let unit = (localizations[language] as? [String: Any])?["stringUnit"] as? [String: Any]
                let value = unit?["value"] as? String ?? ""
                XCTAssertFalse(value.isEmpty, "\(language) の翻訳が無いキー: \(key) (\(file))")
            }
        }
    }
}
