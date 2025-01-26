
import SwiftUI

struct Question: Identifiable, Decodable, Hashable {
    let id: Int
    let problemImageName: String
    let solutionImageName: String
    let references: [String]
}
