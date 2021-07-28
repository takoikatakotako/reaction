import Foundation

struct FirstCategory: Identifiable {
    var id: String {
        return name
    }
    let name: String
    let tag: String
    var check: Bool
    var secondCategories: [SecondCategory]
}
