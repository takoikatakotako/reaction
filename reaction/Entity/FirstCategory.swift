import Foundation

struct FirstCategory: Identifiable {
    var id: String {
        return name
    }
    let name: String
    var check: Bool
    var secondCategories: [SecondCategory]
}
