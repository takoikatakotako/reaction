import Foundation

struct ThirdCategory: Identifiable {
    var id: String {
        return name
    }
    let name: String
    let englishName: String
    let japaneseName: String
    let tag: String
    var check: Bool

    func getDisplayName(laungageIdentifier: String) -> String {
        if laungageIdentifier.starts(with: "en") {
            return englishName
        } else if laungageIdentifier.starts(with: "ja") {
            return japaneseName
        }
        return ""
    }
}
