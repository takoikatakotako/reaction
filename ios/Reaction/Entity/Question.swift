import SwiftUI

struct QuestionsResponse: Decodable, Hashable {
    let questions: [Question]
}

struct Question: Identifiable, Decodable, Hashable {
    let id: String
    let problemImageUrls: [String]
    let solutionImageUrls: [String]
    let references: [String]
}
