import Foundation

struct ThirdCategory: Identifiable {
    var id: String {
        return name
    }
    let name: String
    let tag: String
    var check: Bool
}
