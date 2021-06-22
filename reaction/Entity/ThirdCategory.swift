import Foundation

struct ThirdCategory: Identifiable {
    var id: String {
        return name
    }
    let name: String
    var check: Bool
}
