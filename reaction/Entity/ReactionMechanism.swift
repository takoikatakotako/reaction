import SwiftUI

struct ReactionMechanism: Identifiable, Decodable {
    var id: String {
        directoryName
    }
    let directoryName: String
    let english: String
    let japanese: String
    let thmbnailName: String
    let generalFormulas: [GeneralFormula]
    let mechanisms: [Mechanism]
    let examples: [Example]
    let supplements: [Supplement]
    let suggestions: [String]
    
    var thmbnailUrl: URL {
        return URL(string: "\(appEnvironment.baseUrlString)/\(directoryName)/\(thmbnailName)")!
    }
    
    var reactionUrlString: String {
        return "\(appEnvironment.baseUrlString)/\(directoryName)/"
    }
}

struct GeneralFormula: Decodable, Hashable {
    let imageName: String
}

struct Mechanism: Decodable, Hashable {
    let imageName: String
}

struct Example: Decodable, Hashable {
    let imageName: String
}

struct Supplement: Decodable, Hashable {
    let imageName: String
}

extension ReactionMechanism: Mockable {
    static func mock() -> Self {
        return ReactionMechanism(
            directoryName: "barton-reaction",
            english: "BartonReaction",
            japanese: "Barton反応",
            thmbnailName: "barton-reaction-general-expression.png",
            generalFormulas: [GeneralFormula(imageName: "barton-reaction-general-expression.png")],
            mechanisms: [Mechanism(imageName: "barton-reaction-mechanism.png")],
            examples: [Example(imageName: "barton-reaction-example.png")],
            supplements: [Supplement(imageName: "barton-reaction-example.png")],
            suggestions: [])
    }
}
