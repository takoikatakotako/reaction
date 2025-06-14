import SwiftUI

struct ReactionsResponse: Decodable, Hashable {
    let reactions: [ReactionMechanism]
}

struct ReactionMechanism: Identifiable, Decodable, Hashable {
    let id: String
    
    let englishName: String
    let japaneseName: String
    let thumbnailImageUrl: String
    
    let generalFormulaImageUrls: [String]
    let mechanismsImageUrls: [String]
    let exampleImageUrls: [String]
    let supplementsImageUrls: [String]
    
    let suggestions: [String]
    let reactants: [String]
    let products: [String]
    let youtubeUrls: [String]
    
    func getDisplayTitle(identifier: String) -> String {
        if identifier.starts(with: "en") {
            return englishName
        } else if identifier.starts(with: "ja") {
            return japaneseName
        } else {
            return englishName
        }
    }
}
