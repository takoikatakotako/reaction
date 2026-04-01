import Foundation

enum QuestionDetailViewSheet: Identifiable {
    var id: Int {
        switch self {
        case .imageViewer(imageUrlString: let imageUrlString):
            return imageUrlString.hashValue
        }
    }

    case imageViewer(imageUrlString: String)
}
