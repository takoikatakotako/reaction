import SwiftUI

struct ReactionMechanism: Identifiable, Decodable, Hashable {
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
    let reactants: [String]
    let products: [String]
    let youtubeLinks: [String]

    var thmbnailUrl: URL {
        let string = "\(appEnvironment.baseUrlString)/resource/images/\(directoryName)/\(thmbnailName)"
        return URL(string: string)!
    }

    var reactionUrlString: String {
        let string = "\(appEnvironment.baseUrlString)/resource/images/\(directoryName)/"
        return string
    }

    func getDisplayTitle(identifier: String) -> String {
        if identifier.starts(with: "en") {
            return english
        } else if identifier.starts(with: "ja") {
            return japanese
        } else {
            return english
        }
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
            suggestions: [],
            reactants: [],
            products: [],
            youtubeLinks: [])
    }
}
