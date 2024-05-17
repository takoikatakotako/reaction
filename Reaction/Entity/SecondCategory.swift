import Foundation

struct SecondCategory: Identifiable {
    var id: String {
        return name
    }
    let name: String
    let tag: String
    var check: Bool
    var thirdCategories: [ThirdCategory]
}
