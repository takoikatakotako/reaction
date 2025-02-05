
import SwiftUI

struct Question: Identifiable, Decodable, Hashable {
    let id: Int
    let problemImageNames: [String]
    let solutionImageNames: [String]
    let references: [String]
}
